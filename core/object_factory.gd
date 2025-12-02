extends Node
## ObjectFactory - Creates game objects from definitions
## Autoloaded as "ObjectFactory"

# Stability multipliers for joint strength
const STABILITY_MULTIPLIERS = {
	"solid": 10000.0,
	"normal": 500.0,
	"fragile": 100.0,
	"hope": 15.0,  # Held together by hope - breaks if you look at it wrong
}

# Color palettes for different room types
const ROOM_PALETTES = {
	"throne_room": {
		"floor": Color(0.4, 0.35, 0.3),
		"wall": Color(0.5, 0.45, 0.4),
		"accent": Color(0.8, 0.7, 0.2),
	},
	"dungeon": {
		"floor": Color(0.25, 0.25, 0.28),
		"wall": Color(0.35, 0.35, 0.38),
		"accent": Color(0.6, 0.4, 0.2),
	},
	"tavern": {
		"floor": Color(0.45, 0.3, 0.2),
		"wall": Color(0.5, 0.35, 0.25),
		"accent": Color(0.7, 0.5, 0.2),
	},
	"laboratory": {
		"floor": Color(0.7, 0.7, 0.75),
		"wall": Color(0.8, 0.8, 0.85),
		"accent": Color(0.2, 0.8, 0.4),
	},
	"cyberpunk_city": {
		"floor": Color(0.15, 0.15, 0.2),
		"wall": Color(0.2, 0.2, 0.25),
		"accent": Color(1.0, 0.2, 0.8),
	},
	"convergence_zero": {
		"floor": Color(0.1, 0.12, 0.15),
		"wall": Color(0.15, 0.18, 0.22),
		"accent": Color(0.0, 0.9, 1.0),
	},
	"void": {
		"floor": Color(0.05, 0.05, 0.08),
		"wall": Color(0.1, 0.1, 0.15),
		"accent": Color(0.5, 0.0, 1.0),
	},
	"generic": {
		"floor": Color(0.4, 0.4, 0.4),
		"wall": Color(0.5, 0.5, 0.5),
		"accent": Color(0.6, 0.6, 0.6),
	},
}

# Object colors by type
const OBJECT_COLORS = {
	"throne": Color(0.6, 0.5, 0.1),
	"chair": Color(0.5, 0.35, 0.2),
	"table": Color(0.45, 0.3, 0.15),
	"barrel": Color(0.5, 0.35, 0.2),
	"crate": Color(0.55, 0.4, 0.2),
	"chest": Color(0.5, 0.4, 0.1),
	"pillar": Color(0.6, 0.58, 0.55),
	"torch": Color(0.9, 0.6, 0.1),
	"candle": Color(0.9, 0.85, 0.7),
	"lantern": Color(0.7, 0.5, 0.2),
	"bed": Color(0.6, 0.4, 0.4),
	"bookshelf": Color(0.4, 0.28, 0.15),
	"statue": Color(0.65, 0.65, 0.6),
	"banner": Color(0.7, 0.2, 0.2),
	"rug": Color(0.6, 0.3, 0.3),
	"robot": Color(0.5, 0.5, 0.55),
	"computer": Color(0.3, 0.3, 0.35),
	"terminal": Color(0.2, 0.25, 0.3),
	"explosive_barrel": Color(0.8, 0.2, 0.1),
	"bomb": Color(0.2, 0.2, 0.2),
	"tnt": Color(0.9, 0.3, 0.2),
}

# NPC colors
const NPC_COLORS = {
	"jester": Color(0.8, 0.2, 0.8),
	"king": Color(0.7, 0.5, 0.1),
	"queen": Color(0.5, 0.2, 0.6),
	"guard": Color(0.4, 0.4, 0.5),
	"wizard": Color(0.3, 0.3, 0.7),
	"merchant": Color(0.5, 0.4, 0.3),
	"bartender": Color(0.5, 0.35, 0.25),
	"robot": Color(0.6, 0.6, 0.65),
	"goblin": Color(0.3, 0.5, 0.2),
	"skeleton": Color(0.9, 0.9, 0.85),
	"zombie": Color(0.4, 0.5, 0.35),
	"dragon": Color(0.7, 0.2, 0.1),
	"cat": Color(0.6, 0.4, 0.2),
	"dog": Color(0.5, 0.35, 0.2),
	"potato_person": Color(0.7, 0.6, 0.3),
	"generic_person": Color(0.6, 0.5, 0.4),
}

func _ready() -> void:
	print("[WorldForge] ObjectFactory initialized")

func create_floor(dimensions: Vector2, room_type: String, stability: String) -> StaticBody2D:
	var floor_body = StaticBody2D.new()
	floor_body.name = "Floor"
	floor_body.position = Vector2(dimensions.x / 2, dimensions.y - 20)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(dimensions.x, 40)
	collision.shape = shape
	floor_body.add_child(collision)
	
	var visual = ColorRect.new()
	visual.size = Vector2(dimensions.x, 40)
	visual.position = Vector2(-dimensions.x / 2, -20)
	visual.color = _get_palette(room_type)["floor"]
	floor_body.add_child(visual)
	
	return floor_body

func create_walls(dimensions: Vector2, room_type: String, stability: String) -> Array:
	var walls = []
	var palette = _get_palette(room_type)
	var break_force = STABILITY_MULTIPLIERS.get(stability, 500.0)
	
	# Left wall
	var left_wall = _create_wall_segment(
		Vector2(20, dimensions.y),
		Vector2(10, dimensions.y / 2),
		palette["wall"],
		stability
	)
	left_wall.name = "LeftWall"
	walls.append(left_wall)
	
	# Right wall
	var right_wall = _create_wall_segment(
		Vector2(20, dimensions.y),
		Vector2(dimensions.x - 10, dimensions.y / 2),
		palette["wall"],
		stability
	)
	right_wall.name = "RightWall"
	walls.append(right_wall)
	
	return walls

func _create_wall_segment(size: Vector2, pos: Vector2, color: Color, stability: String) -> Node2D:
	## Create a wall that can potentially break apart
	if stability == "hope" or stability == "fragile":
		# Create breakable wall segments
		return _create_breakable_wall(size, pos, color, stability)
	else:
		# Solid static wall
		var wall = StaticBody2D.new()
		wall.position = pos
		
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = size
		collision.shape = shape
		wall.add_child(collision)
		
		var visual = ColorRect.new()
		visual.size = size
		visual.position = Vector2(-size.x / 2, -size.y / 2)
		visual.color = color
		wall.add_child(visual)
		
		return wall

func _create_breakable_wall(size: Vector2, pos: Vector2, color: Color, stability: String) -> Node2D:
	## Create a wall made of physics blocks that can fall apart
	var wall_container = Node2D.new()
	wall_container.position = pos
	
	var block_size = Vector2(20, 30)
	var cols = int(size.x / block_size.x)
	var rows = int(size.y / block_size.y)
	
	var blocks = []
	
	for row in range(rows):
		for col in range(cols):
			var block = _create_physics_block(
				block_size,
				Vector2(
					col * block_size.x - size.x / 2 + block_size.x / 2,
					row * block_size.y - size.y / 2 + block_size.y / 2
				),
				color.darkened(randf_range(0, 0.2)),
				stability
			)
			wall_container.add_child(block)
			blocks.append(block)
	
	# Add joints between adjacent blocks
	_add_block_joints(blocks, block_size, stability, wall_container)
	
	return wall_container

func _create_physics_block(size: Vector2, pos: Vector2, color: Color, stability: String) -> RigidBody2D:
	var block = RigidBody2D.new()
	block.position = pos
	block.mass = 5.0
	block.add_to_group("destructible")
	
	# For "hope" stability, blocks start frozen but wake on any disturbance
	if stability == "hope":
		block.freeze = true
		block.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = size * 0.95  # Slight gap for visual separation
	collision.shape = shape
	block.add_child(collision)
	
	var visual = ColorRect.new()
	visual.size = size * 0.95
	visual.position = Vector2(-size.x * 0.95 / 2, -size.y * 0.95 / 2)
	visual.color = color
	block.add_child(visual)
	
	# Add explosion response
	block.set_script(preload("res://core/destructible_object.gd"))
	
	return block

func _add_block_joints(blocks: Array, block_size: Vector2, stability: String, parent: Node2D) -> void:
	## Connect blocks with breakable joints
	var break_force = STABILITY_MULTIPLIERS.get(stability, 500.0)
	
	for i in range(blocks.size()):
		var block = blocks[i]
		# Try to connect to neighbors
		for j in range(i + 1, blocks.size()):
			var other = blocks[j]
			var dist = block.position.distance_to(other.position)
			
			# If adjacent (within 1.5 block widths)
			if dist < block_size.x * 1.5 or dist < block_size.y * 1.5:
				var pin = PinJoint2D.new()
				pin.node_a = block.get_path()
				pin.node_b = other.get_path()
				pin.softness = 0.1 if stability == "hope" else 0.5
				pin.add_to_group("breakable_joint")
				
				# Breakable joints via custom script
				pin.set_meta("break_force", break_force)
				
				parent.add_child(pin)

func create_ceiling(dimensions: Vector2, room_type: String, stability: String) -> Node2D:
	var palette = _get_palette(room_type)
	
	if stability == "hope" or stability == "fragile":
		# Breakable ceiling
		return _create_breakable_wall(
			Vector2(dimensions.x, 30),
			Vector2(dimensions.x / 2, 15),
			palette["wall"],
			stability
		)
	else:
		var ceiling = StaticBody2D.new()
		ceiling.name = "Ceiling"
		ceiling.position = Vector2(dimensions.x / 2, 15)
		
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(dimensions.x, 30)
		collision.shape = shape
		ceiling.add_child(collision)
		
		var visual = ColorRect.new()
		visual.size = Vector2(dimensions.x, 30)
		visual.position = Vector2(-dimensions.x / 2, -15)
		visual.color = palette["wall"]
		ceiling.add_child(visual)
		
		return ceiling

func create_object(data: Dictionary) -> RigidBody2D:
	## Create a prop/object from parsed data
	var obj = RigidBody2D.new()
	obj.add_to_group("destructible")
	
	var subtype = data.get("subtype", "crate")
	var pos = data.get("position", Vector2(400, 300))
	
	obj.position = pos
	obj.name = subtype.capitalize()
	
	var size = _get_object_size(subtype)
	obj.mass = size.x * size.y * 0.01  # Mass based on size
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	obj.add_child(collision)
	
	var visual = ColorRect.new()
	visual.size = size
	visual.position = -size / 2
	visual.color = OBJECT_COLORS.get(subtype, Color(0.5, 0.5, 0.5))
	obj.add_child(visual)
	
	# Add a label so you know what it is
	var label = Label.new()
	label.text = subtype
	label.position = Vector2(-size.x / 2, -size.y / 2 - 20)
	label.add_theme_font_size_override("font_size", 10)
	obj.add_child(label)
	
	# Make explosives actually explosive
	if data.get("type") == "explosive":
		obj.set_meta("explosive", true)
		obj.set_meta("explosion_force", 2000.0)
		obj.set_meta("explosion_radius", 200.0)
	
	obj.set_script(preload("res://core/destructible_object.gd"))
	
	return obj

func _get_object_size(subtype: String) -> Vector2:
	match subtype:
		"throne": return Vector2(60, 80)
		"chair": return Vector2(30, 40)
		"table": return Vector2(80, 40)
		"barrel": return Vector2(35, 45)
		"crate": return Vector2(40, 40)
		"chest": return Vector2(50, 35)
		"pillar": return Vector2(30, 120)
		"torch": return Vector2(10, 30)
		"candle": return Vector2(8, 20)
		"lantern": return Vector2(20, 25)
		"bed": return Vector2(70, 35)
		"bookshelf": return Vector2(60, 100)
		"statue": return Vector2(40, 90)
		"banner": return Vector2(30, 60)
		"rug": return Vector2(100, 15)
		"robot": return Vector2(35, 50)
		"computer": return Vector2(40, 35)
		"terminal": return Vector2(50, 70)
		_: return Vector2(40, 40)

func create_npc(data: Dictionary) -> CharacterBody2D:
	## Create an NPC with behavior
	var npc = CharacterBody2D.new()
	npc.add_to_group("npc")
	npc.add_to_group("destructible")
	
	var npc_type = data.get("type", "generic_person")
	var pos = data.get("position", Vector2(400, 300))
	var behavior = data.get("behavior", "idle")
	var dialogue = data.get("dialogue", [])
	
	npc.position = pos
	npc.name = npc_type.capitalize() + "_NPC"
	
	var size = Vector2(30, 50)
	
	var collision = CollisionShape2D.new()
	var shape = CapsuleShape2D.new()
	shape.radius = 15
	shape.height = 50
	collision.shape = shape
	npc.add_child(collision)
	
	var visual = ColorRect.new()
	visual.size = size
	visual.position = -size / 2
	visual.color = NPC_COLORS.get(npc_type, Color(0.5, 0.5, 0.5))
	npc.add_child(visual)
	
	# Head (circle on top)
	var head = ColorRect.new()
	head.size = Vector2(20, 20)
	head.position = Vector2(-10, -size.y / 2 - 15)
	head.color = visual.color.lightened(0.2)
	npc.add_child(head)
	
	# Label
	var label = Label.new()
	label.text = npc_type.replace("_", " ").capitalize()
	label.position = Vector2(-40, -size.y / 2 - 35)
	label.add_theme_font_size_override("font_size", 11)
	npc.add_child(label)
	
	# Store behavior data
	npc.set_meta("behavior", behavior)
	npc.set_meta("dialogue", dialogue)
	npc.set_meta("npc_type", npc_type)
	
	# Attach NPC script
	npc.set_script(preload("res://core/npc_controller.gd"))
	
	return npc

func _get_palette(room_type: String) -> Dictionary:
	return ROOM_PALETTES.get(room_type, ROOM_PALETTES["generic"])
