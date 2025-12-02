extends Node
## GameManager - Global game state and coordination
## Autoloaded as "GameManager"

signal world_created(world_data: Dictionary)
signal world_destroyed()
signal forge_activated()

enum GameState { LANDING_PAD, FORGING, EXPLORING, DESTROYING }

var current_state: GameState = GameState.LANDING_PAD
var current_world: Node2D = null
var current_world_data: Dictionary = {}

# Reference to the world container where generated worlds spawn
var world_container: Node2D = null

func _ready() -> void:
	print("[WorldForge] GameManager initialized")

func set_state(new_state: GameState) -> void:
	current_state = new_state
	print("[WorldForge] State changed to: ", GameState.keys()[new_state])

func register_world_container(container: Node2D) -> void:
	world_container = container

func create_world_from_prompt(prompt: String) -> void:
	print("[WorldForge] Processing prompt: ", prompt)
	set_state(GameState.FORGING)
	
	# Parse the natural language prompt
	var parsed = WorldParser.parse_prompt(prompt)
	current_world_data = parsed
	
	# Clear any existing world
	if current_world:
		destroy_current_world()
	
	# Build the new world
	current_world = _build_world(parsed)
	if world_container:
		world_container.add_child(current_world)
	
	set_state(GameState.EXPLORING)
	world_created.emit(parsed)

func _build_world(data: Dictionary) -> Node2D:
	var world = Node2D.new()
	world.name = "GeneratedWorld"
	
	# Create the room structure
	var room = _create_room(data)
	world.add_child(room)
	
	# Add props/objects
	for prop in data.get("props", []):
		var obj = ObjectFactory.create_object(prop)
		if obj:
			world.add_child(obj)
	
	# Add NPCs
	for npc_data in data.get("npcs", []):
		var npc = ObjectFactory.create_npc(npc_data)
		if npc:
			world.add_child(npc)
	
	return world

func _create_room(data: Dictionary) -> Node2D:
	var room = Node2D.new()
	room.name = "Room"
	
	var room_type = data.get("room_type", "generic")
	var size = data.get("size", "medium")
	var stability = data.get("stability", "normal")
	
	# Calculate room dimensions
	var dimensions = _get_room_dimensions(size)
	
	# Create floor
	var floor_obj = ObjectFactory.create_floor(dimensions, room_type, stability)
	room.add_child(floor_obj)
	
	# Create walls
	var walls = ObjectFactory.create_walls(dimensions, room_type, stability)
	for wall in walls:
		room.add_child(wall)
	
	# Create ceiling if indoor
	if data.get("indoor", true):
		var ceiling = ObjectFactory.create_ceiling(dimensions, room_type, stability)
		room.add_child(ceiling)
	
	return room

func _get_room_dimensions(size: String) -> Vector2:
	match size:
		"tiny": return Vector2(400, 300)
		"small": return Vector2(600, 400)
		"medium": return Vector2(900, 500)
		"large": return Vector2(1200, 600)
		"vast": return Vector2(1600, 800)
		_: return Vector2(900, 500)

func destroy_current_world() -> void:
	if current_world:
		current_world.queue_free()
		current_world = null
		current_world_data = {}
		world_destroyed.emit()
		print("[WorldForge] World destroyed")

func trigger_smite() -> void:
	## The big red button - applies explosive force to everything
	if current_world:
		set_state(GameState.DESTROYING)
		var objects = get_tree().get_nodes_in_group("destructible")
		for obj in objects:
			if obj.has_method("apply_explosion"):
				var random_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				obj.apply_explosion(random_dir * randf_range(500, 1500))
		print("[WorldForge] SMITE ACTIVATED!")

func trigger_chaos() -> void:
	## Even more chaos - breaks all joints
	if current_world:
		var joints = get_tree().get_nodes_in_group("breakable_joint")
		for joint in joints:
			if joint is Joint2D:
				joint.queue_free()
		print("[WorldForge] CHAOS UNLEASHED - All joints broken!")
