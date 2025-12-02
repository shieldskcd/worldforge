extends Control
## ForgeTerminal - Natural language world creation interface
class_name ForgeTerminal

signal world_requested(prompt: String)
signal terminal_closed()

@onready var input_field: LineEdit = $PanelContainer/VBoxContainer/InputContainer/PromptInput
@onready var output_label: RichTextLabel = $PanelContainer/VBoxContainer/OutputScroll/OutputLabel
@onready var create_button: Button = $PanelContainer/VBoxContainer/InputContainer/CreateButton
@onready var smite_button: Button = $PanelContainer/VBoxContainer/ButtonContainer/SmiteButton
@onready var chaos_button: Button = $PanelContainer/VBoxContainer/ButtonContainer/ChaosButton
@onready var clear_button: Button = $PanelContainer/VBoxContainer/ButtonContainer/ClearButton

var command_history: Array = []
var history_index: int = -1

func _ready() -> void:
	# Connect signals
	create_button.pressed.connect(_on_create_pressed)
	smite_button.pressed.connect(_on_smite_pressed)
	chaos_button.pressed.connect(_on_chaos_pressed)
	clear_button.pressed.connect(_on_clear_pressed)
	input_field.text_submitted.connect(_on_text_submitted)
	
	# Welcome message
	_add_output("[color=cyan]╔══════════════════════════════════════╗[/color]")
	_add_output("[color=cyan]║       WORLD FORGE TERMINAL v1.0      ║[/color]")
	_add_output("[color=cyan]╚══════════════════════════════════════╝[/color]")
	_add_output("")
	_add_output("[color=gray]Describe what you want to create...[/color]")
	_add_output("")
	_add_output("[color=yellow]Examples:[/color]")
	_add_output("  • Create a throne room with a jester who tells bad dad jokes")
	_add_output("  • Build a dark dungeon with explosive barrels")
	_add_output("  • Make a tavern with three drunk goblins")
	_add_output("  • Convergence Zero cityscape, held together by hope")
	_add_output("")
	_add_output("[color=gray]Controls: [Q] Smite All | [Space] Throw Object | [E] Interact[/color]")
	_add_output("")
	
	# Focus input
	input_field.grab_focus()

func _on_create_pressed() -> void:
	_process_input(input_field.text)

func _on_text_submitted(text: String) -> void:
	_process_input(text)

func _process_input(text: String) -> void:
	if text.strip_edges().is_empty():
		return
	
	# Add to history
	command_history.append(text)
	history_index = command_history.size()
	
	# Echo input
	_add_output("[color=green]> " + text + "[/color]")
	
	# Process command
	var lower_text = text.to_lower()
	
	if lower_text == "help":
		_show_help()
	elif lower_text == "clear":
		_clear_output()
	elif lower_text == "smite":
		_on_smite_pressed()
	elif lower_text == "chaos":
		_on_chaos_pressed()
	elif lower_text.begins_with("create") or lower_text.begins_with("build") or lower_text.begins_with("make") or lower_text.begins_with("generate"):
		_create_world(text)
	else:
		# Assume it's a creation command
		_create_world(text)
	
	# Clear input
	input_field.text = ""

func _create_world(prompt: String) -> void:
	_add_output("")
	_add_output("[color=cyan]Forging world...[/color]")
	_add_output("[color=gray]Parsing: \"" + prompt + "\"[/color]")
	
	# Request world creation
	world_requested.emit(prompt)
	
	# Show what was parsed (after a brief delay to let parsing complete)
	await get_tree().create_timer(0.1).timeout
	
	var data = GameManager.current_world_data
	if data:
		_add_output("")
		_add_output("[color=yellow]World created:[/color]")
		_add_output("  Room type: " + str(data.get("room_type", "unknown")))
		_add_output("  Size: " + str(data.get("size", "medium")))
		_add_output("  Stability: " + str(data.get("stability", "normal")))
		_add_output("  Props: " + str(data.get("props", []).size()))
		_add_output("  NPCs: " + str(data.get("npcs", []).size()))
		_add_output("")
		_add_output("[color=green]World ready! Go explore and destroy![/color]")

func _on_smite_pressed() -> void:
	_add_output("")
	_add_output("[color=red]☠ SMITE ACTIVATED ☠[/color]")
	_add_output("[color=orange]Applying explosive force to all objects...[/color]")
	GameManager.trigger_smite()

func _on_chaos_pressed() -> void:
	_add_output("")
	_add_output("[color=magenta]⚡ CHAOS UNLEASHED ⚡[/color]")
	_add_output("[color=orange]Breaking all structural joints...[/color]")
	GameManager.trigger_chaos()

func _on_clear_pressed() -> void:
	_add_output("")
	_add_output("[color=yellow]Clearing current world...[/color]")
	GameManager.destroy_current_world()
	_add_output("[color=green]World cleared. Ready for new creation.[/color]")

func _show_help() -> void:
	_add_output("")
	_add_output("[color=cyan]═══ HELP ═══[/color]")
	_add_output("")
	_add_output("[color=yellow]Creating worlds:[/color]")
	_add_output("  Just describe what you want! The forge understands:")
	_add_output("  • Room types: throne room, dungeon, tavern, lab, space station...")
	_add_output("  • Sizes: tiny, small, medium, large, vast")
	_add_output("  • Stability: solid, fragile, 'held together by hope'")
	_add_output("  • Props: barrels, crates, thrones, torches, explosives...")
	_add_output("  • NPCs: jesters, guards, goblins, robots, potato people...")
	_add_output("  • Behaviors: tells jokes, wandering, guarding, hostile...")
	_add_output("")
	_add_output("[color=yellow]Destruction:[/color]")
	_add_output("  • SMITE - Apply explosive force to everything")
	_add_output("  • CHAOS - Break all joints (things fall apart)")
	_add_output("  • Press [Space] to throw objects")
	_add_output("  • Press [Q] for quick smite")
	_add_output("")
	_add_output("[color=yellow]Commands:[/color]")
	_add_output("  • help - Show this message")
	_add_output("  • clear - Destroy current world")
	_add_output("  • smite - Trigger smite")
	_add_output("  • chaos - Trigger chaos")
	_add_output("")

func _clear_output() -> void:
	output_label.text = ""

func _add_output(text: String) -> void:
	output_label.append_text(text + "\n")

func _input(event: InputEvent) -> void:
	# Command history navigation
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			if history_index > 0:
				history_index -= 1
				input_field.text = command_history[history_index]
				input_field.caret_column = input_field.text.length()
		elif event.keycode == KEY_DOWN:
			if history_index < command_history.size() - 1:
				history_index += 1
				input_field.text = command_history[history_index]
			else:
				history_index = command_history.size()
				input_field.text = ""
		elif event.keycode == KEY_ESCAPE:
			terminal_closed.emit()
