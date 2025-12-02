extends CharacterBody2D
## Player - The user's avatar in the World Forge
class_name Player

@export var move_speed: float = 200.0

var can_interact: bool = false
var nearby_interactable: Node = null

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	# Get input
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")
	
	velocity = input_dir.normalized() * move_speed
	
	move_and_slide()
	
	# Check for interactions
	if Input.is_action_just_pressed("interact"):
		_try_interact()
	
	# Destruction controls
	if Input.is_action_just_pressed("smite"):
		GameManager.trigger_smite()
	
	if Input.is_action_just_pressed("destroy"):
		_throw_object()

func _try_interact() -> void:
	if nearby_interactable and nearby_interactable.has_method("interact"):
		nearby_interactable.interact()

func _throw_object() -> void:
	## Spawn a physics object and throw it in facing direction
	var projectile = RigidBody2D.new()
	projectile.position = global_position + Vector2(30, 0)
	projectile.add_to_group("destructible")
	
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 10
	collision.shape = shape
	projectile.add_child(collision)
	
	var visual = ColorRect.new()
	visual.size = Vector2(20, 20)
	visual.position = Vector2(-10, -10)
	visual.color = Color(0.8, 0.3, 0.3)
	projectile.add_child(visual)
	
	projectile.set_script(preload("res://core/destructible_object.gd"))
	
	get_tree().current_scene.add_child(projectile)
	
	# Throw it!
	var throw_dir = Vector2(1, -0.3).normalized()
	if velocity.x < 0:
		throw_dir.x = -1
	projectile.apply_central_impulse(throw_dir * 500)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("interact"):
		can_interact = true
		nearby_interactable = area.get_parent()

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() == nearby_interactable:
		can_interact = false
		nearby_interactable = null
