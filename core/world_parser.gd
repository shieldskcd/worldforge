extends Node
## WorldParser - Interprets natural language prompts into build recipes
## Autoloaded as "WorldParser"

# Room type keywords and their mappings
const ROOM_TYPES = {
	"throne": "throne_room",
	"throne room": "throne_room",
	"castle": "throne_room",
	"dungeon": "dungeon",
	"cell": "dungeon",
	"prison": "dungeon",
	"cave": "cave",
	"cavern": "cave",
	"forest": "forest",
	"woods": "forest",
	"city": "cityscape",
	"street": "cityscape",
	"urban": "cityscape",
	"cyberpunk": "cyberpunk_city",
	"neon": "cyberpunk_city",
	"space": "space_station",
	"station": "space_station",
	"spaceship": "space_station",
	"lab": "laboratory",
	"laboratory": "laboratory",
	"science": "laboratory",
	"tavern": "tavern",
	"inn": "tavern",
	"bar": "tavern",
	"library": "library",
	"study": "library",
	"temple": "temple",
	"shrine": "temple",
	"church": "temple",
	"void": "void",
	"abstract": "void",
	"chaos": "void",
	"convergence": "convergence_zero",
	"convergence zero": "convergence_zero",
}

# Size keywords
const SIZE_KEYWORDS = {
	"tiny": "tiny",
	"small": "small",
	"medium": "medium",
	"large": "large",
	"huge": "vast",
	"vast": "vast",
	"massive": "vast",
	"cozy": "small",
	"sprawling": "vast",
}

# Stability keywords (for "held together by hope")
const STABILITY_KEYWORDS = {
	"solid": "solid",
	"sturdy": "solid",
	"stable": "solid",
	"strong": "solid",
	"normal": "normal",
	"regular": "normal",
	"fragile": "fragile",
	"weak": "fragile",
	"crumbling": "fragile",
	"rickety": "hope",
	"hope": "hope",
	"barely": "hope",
	"unstable": "hope",
	"precarious": "hope",
}

# Known prop types
const PROP_KEYWORDS = {
	"throne": {"type": "furniture", "subtype": "throne"},
	"chair": {"type": "furniture", "subtype": "chair"},
	"table": {"type": "furniture", "subtype": "table"},
	"barrel": {"type": "container", "subtype": "barrel"},
	"crate": {"type": "container", "subtype": "crate"},
	"chest": {"type": "container", "subtype": "chest"},
	"pillar": {"type": "structure", "subtype": "pillar"},
	"column": {"type": "structure", "subtype": "pillar"},
	"torch": {"type": "light", "subtype": "torch"},
	"candle": {"type": "light", "subtype": "candle"},
	"lantern": {"type": "light", "subtype": "lantern"},
	"bed": {"type": "furniture", "subtype": "bed"},
	"bookshelf": {"type": "furniture", "subtype": "bookshelf"},
	"statue": {"type": "decoration", "subtype": "statue"},
	"banner": {"type": "decoration", "subtype": "banner"},
	"rug": {"type": "decoration", "subtype": "rug"},
	"carpet": {"type": "decoration", "subtype": "rug"},
	"robot": {"type": "tech", "subtype": "robot"},
	"computer": {"type": "tech", "subtype": "computer"},
	"terminal": {"type": "tech", "subtype": "terminal"},
	"explosive": {"type": "explosive", "subtype": "barrel"},
	"bomb": {"type": "explosive", "subtype": "bomb"},
	"tnt": {"type": "explosive", "subtype": "tnt"},
}

# NPC behavior keywords
const BEHAVIOR_KEYWORDS = {
	"angry": "aggressive",
	"hostile": "aggressive",
	"fighting": "aggressive",
	"friendly": "friendly",
	"nice": "friendly",
	"helpful": "friendly",
	"idle": "idle",
	"standing": "idle",
	"wandering": "wander",
	"walking": "wander",
	"pacing": "wander",
	"talking": "dialogue",
	"speaking": "dialogue",
	"tells": "dialogue",
	"says": "dialogue",
	"jokes": "joke_teller",
	"dad jokes": "dad_joke_teller",
	"bad jokes": "dad_joke_teller",
	"guard": "guard",
	"guarding": "guard",
	"patrol": "patrol",
	"patrolling": "patrol",
}

func _ready() -> void:
	print("[WorldForge] WorldParser initialized")

func parse_prompt(prompt: String) -> Dictionary:
	## Main parsing function - takes natural language, returns build recipe
	var lower_prompt = prompt.to_lower()
	
	var result = {
		"original_prompt": prompt,
		"room_type": _detect_room_type(lower_prompt),
		"size": _detect_size(lower_prompt),
		"stability": _detect_stability(lower_prompt),
		"indoor": _detect_indoor(lower_prompt),
		"props": _detect_props(lower_prompt),
		"npcs": _detect_npcs(lower_prompt),
		"mood": _detect_mood(lower_prompt),
		"colors": _detect_colors(lower_prompt),
	}
	
	# Add default props based on room type
	result["props"].append_array(_get_default_props(result["room_type"]))
	
	print("[WorldForge] Parsed result: ", result)
	return result

func _detect_room_type(prompt: String) -> String:
	for keyword in ROOM_TYPES:
		if keyword in prompt:
			return ROOM_TYPES[keyword]
	return "generic"

func _detect_size(prompt: String) -> String:
	for keyword in SIZE_KEYWORDS:
		if keyword in prompt:
			return SIZE_KEYWORDS[keyword]
	return "medium"

func _detect_stability(prompt: String) -> String:
	# Check for "held together by hope" phrase specifically
	if "held together by hope" in prompt or "together by hope" in prompt:
		return "hope"
	
	for keyword in STABILITY_KEYWORDS:
		if keyword in prompt:
			return STABILITY_KEYWORDS[keyword]
	return "normal"

func _detect_indoor(prompt: String) -> bool:
	var outdoor_keywords = ["outside", "outdoor", "open air", "forest", "street", "city"]
	for keyword in outdoor_keywords:
		if keyword in prompt:
			return false
	return true

func _detect_props(prompt: String) -> Array:
	var props = []
	var words = prompt.split(" ")
	
	# Look for quantity + prop patterns (e.g., "three barrels", "5 crates")
	for i in range(words.size() - 1):
		var quantity = _parse_quantity(words[i])
		var next_word = words[i + 1].trim_suffix("s").trim_suffix(",").trim_suffix(".")
		
		if quantity > 0 and next_word in PROP_KEYWORDS:
			for j in range(quantity):
				var prop = PROP_KEYWORDS[next_word].duplicate()
				prop["position"] = _random_position()
				props.append(prop)
	
	# Also look for standalone prop keywords
	for keyword in PROP_KEYWORDS:
		if keyword in prompt:
			# Check if we already added this via quantity parsing
			var already_added = false
			for prop in props:
				if prop.get("subtype") == PROP_KEYWORDS[keyword]["subtype"]:
					already_added = true
					break
			
			if not already_added:
				var prop = PROP_KEYWORDS[keyword].duplicate()
				prop["position"] = _random_position()
				props.append(prop)
	
	return props

func _detect_npcs(prompt: String) -> Array:
	var npcs = []
	
	# Common NPC patterns
	var npc_patterns = [
		{"pattern": "jester", "type": "jester", "default_behavior": "joke_teller"},
		{"pattern": "king", "type": "king", "default_behavior": "idle"},
		{"pattern": "queen", "type": "queen", "default_behavior": "idle"},
		{"pattern": "guard", "type": "guard", "default_behavior": "guard"},
		{"pattern": "wizard", "type": "wizard", "default_behavior": "idle"},
		{"pattern": "merchant", "type": "merchant", "default_behavior": "dialogue"},
		{"pattern": "bartender", "type": "bartender", "default_behavior": "dialogue"},
		{"pattern": "robot", "type": "robot", "default_behavior": "wander"},
		{"pattern": "goblin", "type": "goblin", "default_behavior": "aggressive"},
		{"pattern": "skeleton", "type": "skeleton", "default_behavior": "wander"},
		{"pattern": "zombie", "type": "zombie", "default_behavior": "wander"},
		{"pattern": "dragon", "type": "dragon", "default_behavior": "aggressive"},
		{"pattern": "cat", "type": "cat", "default_behavior": "wander"},
		{"pattern": "dog", "type": "dog", "default_behavior": "friendly"},
		{"pattern": "potato", "type": "potato_person", "default_behavior": "idle"},
		{"pattern": "person", "type": "generic_person", "default_behavior": "idle"},
		{"pattern": "people", "type": "generic_person", "default_behavior": "idle"},
		{"pattern": "npc", "type": "generic_person", "default_behavior": "idle"},
	]
	
	var words = prompt.split(" ")
	
	for pattern_data in npc_patterns:
		var pattern = pattern_data["pattern"]
		if pattern in prompt:
			# Try to find quantity
			var quantity = 1
			for i in range(words.size() - 1):
				var q = _parse_quantity(words[i])
				if q > 0:
					var next_words = " ".join(words.slice(i + 1, min(i + 3, words.size())))
					if pattern in next_words:
						quantity = q
						break
			
			# Detect behavior from context
			var behavior = pattern_data["default_behavior"]
			for bkeyword in BEHAVIOR_KEYWORDS:
				if bkeyword in prompt:
					behavior = BEHAVIOR_KEYWORDS[bkeyword]
					break
			
			# Check for dialogue content
			var dialogue = _extract_dialogue_content(prompt, pattern)
			
			for j in range(quantity):
				var npc = {
					"type": pattern_data["type"],
					"behavior": behavior,
					"position": _random_position(),
					"dialogue": dialogue,
				}
				npcs.append(npc)
	
	return npcs

func _extract_dialogue_content(prompt: String, npc_type: String) -> Array:
	## Extract what the NPC should say based on context
	var dialogues = []
	
	# Check for joke-related context
	if "joke" in prompt or "jokes" in prompt:
		if "dad" in prompt or "bad" in prompt:
			dialogues = _get_dad_jokes()
		else:
			dialogues = _get_generic_jokes()
	
	return dialogues

func _get_dad_jokes() -> Array:
	return [
		"Why did the king go to the dentist? To get his crown checked!",
		"I used to hate facial hair, but then it grew on me.",
		"What do you call a fake noodle? An impasta!",
		"Why don't eggs tell jokes? They'd crack each other up!",
		"I'm reading a book about anti-gravity. It's impossible to put down!",
		"What do you call a bear with no teeth? A gummy bear!",
		"Why did the scarecrow win an award? He was outstanding in his field!",
		"What do you call a fish without eyes? A fsh!",
		"I would tell you a construction joke, but I'm still working on it.",
		"Why don't scientists trust atoms? Because they make up everything!",
	]

func _get_generic_jokes() -> Array:
	return [
		"Welcome, traveler! Have you heard the one about the adventurer who walked into a bar?",
		"A skeleton walks into a tavern and orders a drink... and a mop.",
		"Why did the dungeon boss go to therapy? Too many unresolved issues with heroes!",
	]

func _detect_mood(prompt: String) -> String:
	var mood_keywords = {
		"dark": "dark",
		"gloomy": "dark",
		"spooky": "dark",
		"bright": "bright",
		"cheerful": "bright",
		"happy": "bright",
		"mysterious": "mysterious",
		"eerie": "mysterious",
		"peaceful": "peaceful",
		"calm": "peaceful",
		"chaotic": "chaotic",
		"wild": "chaotic",
	}
	
	for keyword in mood_keywords:
		if keyword in prompt:
			return mood_keywords[keyword]
	return "neutral"

func _detect_colors(prompt: String) -> Array:
	var colors = []
	var color_keywords = ["red", "blue", "green", "yellow", "purple", "orange", "pink", "black", "white", "gold", "silver", "neon"]
	
	for color in color_keywords:
		if color in prompt:
			colors.append(color)
	
	return colors

func _parse_quantity(word: String) -> int:
	## Parse number words or digits
	var number_words = {
		"one": 1, "a": 1, "an": 1,
		"two": 2, "couple": 2,
		"three": 3, "few": 3,
		"four": 4,
		"five": 5, "several": 5,
		"six": 6,
		"seven": 7,
		"eight": 8,
		"nine": 9,
		"ten": 10,
		"many": 7,
		"lots": 8,
		"dozen": 12,
	}
	
	word = word.to_lower().trim_suffix(",")
	
	if word in number_words:
		return number_words[word]
	
	if word.is_valid_int():
		return int(word)
	
	return 0

func _random_position() -> Vector2:
	## Generate a random position within typical room bounds
	return Vector2(randf_range(100, 800), randf_range(100, 400))

func _get_default_props(room_type: String) -> Array:
	## Add default props that make sense for the room type
	var defaults = []
	
	match room_type:
		"throne_room":
			defaults.append({"type": "furniture", "subtype": "throne", "position": Vector2(450, 200)})
			defaults.append({"type": "decoration", "subtype": "banner", "position": Vector2(200, 100)})
			defaults.append({"type": "decoration", "subtype": "banner", "position": Vector2(700, 100)})
		"dungeon":
			defaults.append({"type": "container", "subtype": "barrel", "position": Vector2(150, 350)})
			defaults.append({"type": "light", "subtype": "torch", "position": Vector2(100, 150)})
			defaults.append({"type": "light", "subtype": "torch", "position": Vector2(800, 150)})
		"tavern":
			defaults.append({"type": "furniture", "subtype": "table", "position": Vector2(300, 300)})
			defaults.append({"type": "furniture", "subtype": "table", "position": Vector2(600, 300)})
			defaults.append({"type": "furniture", "subtype": "chair", "position": Vector2(250, 320)})
			defaults.append({"type": "furniture", "subtype": "chair", "position": Vector2(350, 320)})
			defaults.append({"type": "container", "subtype": "barrel", "position": Vector2(100, 200)})
		"laboratory":
			defaults.append({"type": "furniture", "subtype": "table", "position": Vector2(400, 250)})
			defaults.append({"type": "tech", "subtype": "computer", "position": Vector2(420, 230)})
		"convergence_zero":
			defaults.append({"type": "tech", "subtype": "terminal", "position": Vector2(450, 200)})
			defaults.append({"type": "container", "subtype": "crate", "position": Vector2(200, 350)})
	
	return defaults
