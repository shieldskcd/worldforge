extends Node2D
## Main - The primary game scene containing landing pad and world container

@onready var player: CharacterBody2D = $Player
@onready var world_container: Node2D = $WorldContainer
@onready var forge_terminal: Control = $CanvasLayer/ForgeTerminal
@onready var camera: Camera2D = $Player/Camera2D

var terminal_visible: bool = true

func _ready() -> void:
	# Register world container with game manager
	GameManager.register_world_container(world_container)
	
	# Connect forge terminal signals
	forge_terminal.world_requested.connect(_on_world_requested)
	
	# Set up camera limits (will be adjusted based on world size)
	_setup_camera()
	
	print("[WorldForge] Main scene ready!")
	print("[WorldForge] Press TAB to toggle terminal")
	print("[WorldForge] Press Q to SMITE everything")
	print("[WorldForge] Press SPACE to throw objects")

func _setup_camera() -> void:
	camera.limit_left = -100
	camera.limit_top = -100
	camera.limit_right = 1400
	camera.limit_bottom = 800

func _input(event: InputEvent) -> void:
	# Toggle terminal visibility
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB:
		terminal_visible = !terminal_visible
		forge_terminal.visible = terminal_visible
		
		if terminal_visible:
			# Focus the input field
			var input_field = forge_terminal.get_node("PanelContainer/VBoxContainer/InputContainer/PromptInput")
			if input_field:
				input_field.grab_focus()

func _on_world_requested(prompt: String) -> void:
	GameManager.create_world_from_prompt(prompt)
	
	# Optionally hide terminal after creation
	# terminal_visible = false
	# forge_terminal.visible = false
