extends CharacterBody2D
## NPCController - Controls NPC behavior and dialogue
class_name NPCController

enum Behavior { IDLE, WANDER, GUARD, PATROL, AGGRESSIVE, FRIENDLY, DIALOGUE, JOKE_TELLER, DAD_JOKE_TELLER }

@export var move_speed: float = 50.0
@export var wander_range: float = 100.0

var behavior: Behavior = Behavior.IDLE
var dialogue_lines: Array = []
var current_dialogue_index: int = 0
var home_position: Vector2
var wander_target: Vector2
var wander_timer: float = 0.0
var dialogue_cooldown: float = 0.0
var is_talking: bool = false

# UI elements
var speech_bubble: Label = null
var speech_timer: float = 0.0

func _ready() -> void:
	home_position = position
	wander_target = position
	
	# Load behavior from metadata
	var behavior_str = get_meta("behavior") if has_meta("behavior") else "idle"
	behavior = _string_to_behavior(behavior_str)
	
	if has_meta("dialogue"):
		dialogue_lines = get_meta("dialogue")
	
	# Create speech bubble
	_create_speech_bubble()
	
	# If joke teller, make sure we have jokes
	if behavior == Behavior.JOKE_TELLER or behavior == Behavior.DAD_JOKE_TELLER:
		if dialogue_lines.is_empty():
			dialogue_lines = _get_default_jokes()
		# Start telling jokes periodically
		_schedule_next_joke()

func _physics_process(delta: float) -> void:
	# Update dialogue cooldown
	if dialogue_cooldown > 0:
		dialogue_cooldown -= delta
	
	# Update speech bubble timer
	if speech_timer > 0:
		speech_timer -= delta
		if speech_timer <= 0:
			_hide_speech_bubble()
	
	# Update wander timer
	if wander_timer > 0:
		wander_timer -= delta
	
	# Process behavior
	match behavior:
		Behavior.IDLE:
			_process_idle(delta)
		Behavior.WANDER:
			_process_wander(delta)
		Behavior.GUARD:
			_process_guard(delta)
		Behavior.PATROL:
			_process_patrol(delta)
		Behavior.JOKE_TELLER, Behavior.DAD_JOKE_TELLER:
			_process_joke_teller(delta)
		_:
			_process_idle(delta)
	
	move_and_slide()

func _process_idle(_delta: float) -> void:
	velocity = Vector2.ZERO
	# Occasionally fidget
	if randf() < 0.001:
		velocity = Vector2(randf_range(-20, 20), 0)

func _process_wander(delta: float) -> void:
	if wander_timer <= 0:
		# Pick new target
		wander_target = home_position + Vector2(
			randf_range(-wander_range, wander_range),
			randf_range(-wander_range / 2, wander_range / 2)
		)
		wander_timer = randf_range(2.0, 5.0)
	
	# Move toward target
	var direction = (wander_target - position).normalized()
	var distance = position.distance_to(wander_target)
	
	if distance > 10:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO

func _process_guard(_delta: float) -> void:
	# Stay in place, face toward center of room
	velocity = Vector2.ZERO
	# Could add "look around" animation here

func _process_patrol(_delta: float) -> void:
	# Similar to wander but in a more regular pattern
	_process_wander(_delta)

func _process_joke_teller(_delta: float) -> void:
	velocity = Vector2.ZERO
	# Jokes are told via timer, handled in _schedule_next_joke

func _schedule_next_joke() -> void:
	if not is_inside_tree():
		return
	
	var delay = randf_range(5.0, 15.0)
	await get_tree().create_timer(delay).timeout
	
	if is_inside_tree():
		tell_joke()
		_schedule_next_joke()

func tell_joke() -> void:
	if dialogue_lines.is_empty():
		return
	
	var joke = dialogue_lines[current_dialogue_index]
	current_dialogue_index = (current_dialogue_index + 1) % dialogue_lines.size()
	
	say(joke, 5.0)

func say(text: String, duration: float = 3.0) -> void:
	if speech_bubble:
		speech_bubble.text = text
		speech_bubble.visible = true
		speech_timer = duration
		is_talking = true

func _hide_speech_bubble() -> void:
	if speech_bubble:
		speech_bubble.visible = false
		is_talking = false

func _create_speech_bubble() -> void:
	speech_bubble = Label.new()
	speech_bubble.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	speech_bubble.position = Vector2(-100, -80)
	speech_bubble.custom_minimum_size = Vector2(200, 0)
	speech_bubble.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	speech_bubble.add_theme_font_size_override("font_size", 12)
	speech_bubble.visible = false
	
	# Add background panel
	var panel = PanelContainer.new()
	panel.position = Vector2(-105, -85)
	panel.custom_minimum_size = Vector2(210, 40)
	
	add_child(panel)
	add_child(speech_bubble)

func _get_default_jokes() -> Array:
	return [
		"Why did the knight break up with the princess? She had too many towers of emotional baggage!",
		"What do you call a sleeping dinosaur? A dino-snore!",
		"Why don't skeletons fight each other? They don't have the guts!",
		"What did the grape say when it got stepped on? Nothing, it just let out a little wine!",
		"I told my wife she was drawing her eyebrows too high. She looked surprised!",
		"Why did the scarecrow win an award? He was outstanding in his field!",
		"What do you call a fake noodle? An impasta!",
		"Why don't eggs tell jokes? They'd crack each other up!",
		"What do you call a bear with no teeth? A gummy bear!",
		"I'm reading a book about anti-gravity. It's impossible to put down!",
	]

func _string_to_behavior(s: String) -> Behavior:
	match s.to_lower():
		"idle": return Behavior.IDLE
		"wander": return Behavior.WANDER
		"guard": return Behavior.GUARD
		"patrol": return Behavior.PATROL
		"aggressive": return Behavior.AGGRESSIVE
		"friendly": return Behavior.FRIENDLY
		"dialogue": return Behavior.DIALOGUE
		"joke_teller": return Behavior.JOKE_TELLER
		"dad_joke_teller": return Behavior.DAD_JOKE_TELLER
		_: return Behavior.IDLE

func interact() -> void:
	## Called when player interacts with this NPC
	if not dialogue_lines.is_empty():
		var line = dialogue_lines[current_dialogue_index]
		current_dialogue_index = (current_dialogue_index + 1) % dialogue_lines.size()
		say(line, 4.0)
	else:
		say("...", 1.0)

func apply_explosion(force: Vector2) -> void:
	## NPCs can be knocked around by explosions
	# Convert to physics briefly
	say("AAAH!", 1.0)
	# Apply knockback via velocity
	velocity = force * 0.5
