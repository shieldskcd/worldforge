extends RigidBody2D
## DestructibleObject - Any object that can be destroyed/exploded
class_name DestructibleObject

@export var is_explosive: bool = false
@export var explosion_force: float = 2000.0
@export var explosion_radius: float = 200.0

var has_exploded: bool = false

func _ready() -> void:
	# Load metadata if set
	if has_meta("explosive"):
		is_explosive = get_meta("explosive")
	if has_meta("explosion_force"):
		explosion_force = get_meta("explosion_force")
	if has_meta("explosion_radius"):
		explosion_radius = get_meta("explosion_radius")
	
	# Connect to body entered for collision-based explosions
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# If we're explosive and hit hard enough, explode
	if is_explosive and not has_exploded:
		if linear_velocity.length() > 100:
			explode()

func apply_explosion(force: Vector2) -> void:
	## Apply explosive force to this object
	# Unfreeze if frozen
	if freeze:
		freeze = false
	
	apply_central_impulse(force)
	
	# Add some spin for visual interest
	apply_torque_impulse(randf_range(-500, 500))
	
	# If this is explosive, trigger chain reaction
	if is_explosive and not has_exploded:
		# Delay slightly for chain reaction effect
		await get_tree().create_timer(0.1).timeout
		explode()

func explode() -> void:
	## Trigger explosion
	if has_exploded:
		return
	
	has_exploded = true
	
	# Find all nearby destructibles and apply force
	var nearby = get_tree().get_nodes_in_group("destructible")
	for obj in nearby:
		if obj == self:
			continue
		
		var dist = global_position.distance_to(obj.global_position)
		if dist < explosion_radius:
			var direction = (obj.global_position - global_position).normalized()
			var force_multiplier = 1.0 - (dist / explosion_radius)
			var force = direction * explosion_force * force_multiplier
			
			if obj.has_method("apply_explosion"):
				obj.apply_explosion(force)
	
	# Visual feedback - flash and disappear
	_explosion_effect()
	
	# Remove self after short delay
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _explosion_effect() -> void:
	## Simple visual explosion effect
	# Find our visual (ColorRect child)
	for child in get_children():
		if child is ColorRect:
			# Flash white then fade
			var tween = create_tween()
			tween.tween_property(child, "color", Color.WHITE, 0.05)
			tween.tween_property(child, "modulate:a", 0.0, 0.15)
	
	# TODO: Add particle effects here when we have assets

func wake_up() -> void:
	## Unfreeze the object (for "held together by hope" structures)
	if freeze:
		freeze = false
		# Small random impulse to start things moving
		apply_central_impulse(Vector2(randf_range(-50, 50), randf_range(-20, 0)))
