"""
Templates for World Forge
Room descriptions, NPC data, props, and dialogue
"""

# Room templates with descriptions and default props
ROOM_TEMPLATES = {
    'throne_room': {
        'description': "A {mood} grand hall stretches before you, dominated by an imposing throne at the far end. Tall windows cast long shadows across the polished stone floor.",
        'lighting': "Daylight streams through tall stained-glass windows, painting the floor in fragments of color.",
        'default_props': ['throne', 'banner', 'torch'],
    },
    'dungeon': {
        'description': "Cold stone walls drip with moisture in this {mood} underground chamber. Iron bars and chains speak to the room's grim purpose.",
        'lighting': "Flickering torchlight barely penetrates the oppressive darkness.",
        'default_props': ['torch', 'chains', 'barrel'],
    },
    'cave': {
        'description': "A {mood} natural cavern opens up, its ceiling lost in shadow. Stalactites hang like ancient teeth above.",
        'lighting': "Bioluminescent moss provides an eerie pale glow.",
        'default_props': ['rock', 'mushroom'],
    },
    'tavern': {
        'description': "The {mood} common room is filled with the smell of ale and wood smoke. Worn tables and chairs crowd the space.",
        'lighting': "Warm firelight flickers from a large hearth, supplemented by candles on each table.",
        'default_props': ['table', 'chair', 'barrel', 'fireplace'],
    },
    'library': {
        'description': "Towering bookshelves line every wall of this {mood} repository of knowledge. Dust motes dance in the light.",
        'lighting': "Soft light filters through high windows, supplemented by reading lamps.",
        'default_props': ['bookshelf', 'table', 'chair', 'candle'],
    },
    'laboratory': {
        'description': "A {mood} workspace cluttered with bubbling beakers, strange apparatus, and scattered notes. Something hums with power.",
        'lighting': "Harsh alchemical lights cast everything in sharp relief.",
        'default_props': ['table', 'cauldron', 'bookshelf'],
    },
    'temple': {
        'description': "Sacred geometry and ancient symbols adorn this {mood} place of worship. An altar stands at the center.",
        'lighting': "Candles and braziers create pools of warm light amid the shadows.",
        'default_props': ['altar', 'candle', 'statue'],
    },
    'forest': {
        'description': "Ancient trees tower overhead in this {mood} woodland clearing. Dappled light filters through the canopy.",
        'lighting': "Sunlight breaks through the leaves in golden shafts.",
        'default_props': ['tree', 'rock', 'mushroom'],
    },
    'city': {
        'description': "A {mood} urban scene unfolds with cobblestone streets and crowded buildings pressing close.",
        'lighting': "The sun hangs over the rooftops, casting long shadows between buildings.",
        'default_props': ['crate', 'barrel', 'cart'],
    },
    'alley': {
        'description': "A narrow {mood} passage between buildings, littered with refuse and forgotten things.",
        'lighting': "Dim light barely reaches this forgotten corner of the city.",
        'default_props': ['crate', 'barrel'],
    },
    'cyberpunk': {
        'description': "Neon signs flicker above this {mood} street, casting everything in electric blues and pinks. Steam rises from grates.",
        'lighting': "Holographic advertisements and neon tubes provide garish, ever-changing illumination.",
        'default_props': ['terminal', 'crate', 'neon_sign'],
    },
    'space_station': {
        'description': "Sleek metal panels and blinking consoles fill this {mood} corridor. The hum of life support is ever-present.",
        'lighting': "Harsh fluorescent panels line the ceiling, occasionally flickering.",
        'default_props': ['terminal', 'crate', 'control_panel'],
    },
    'convergence_zero': {
        'description': "A {mood} chamber of advanced technology and mysterious purpose. Screens display incomprehensible data streams.",
        'lighting': "Cool blue LEDs and holographic displays cast an otherworldly glow.",
        'default_props': ['terminal', 'control_panel', 'server_rack'],
    },
    'void': {
        'description': "Reality seems thin here in this {mood} space between spaces. The ground is uncertain, the sky unknowable.",
        'lighting': "Light comes from everywhere and nowhere, casting no shadows.",
        'default_props': [],
    },
    'generic': {
        'description': "A {mood} space opens before you, its purpose unclear but its atmosphere undeniable.",
        'lighting': "Ambient light from unknown sources illuminates the area.",
        'default_props': ['crate'],
    },
}

# NPC templates
NPC_TEMPLATES = {
    'jester': {
        'description': "A colorful figure in motley, bells jingling with every movement.",
        'behavior': "Capers about, telling jokes and performing tricks for anyone who will watch.",
    },
    'guard': {
        'description': "A stern figure in armor, eyes constantly scanning for threats.",
        'behavior': "Stands at attention, occasionally pacing a patrol route.",
    },
    'wizard': {
        'description': "Robes covered in arcane symbols, a knowing glint in ancient eyes.",
        'behavior': "Studies mysterious tomes and mutters incantations under their breath.",
    },
    'bartender': {
        'description': "Weathered hands polish an endless supply of glasses, missing nothing.",
        'behavior': "Serves drinks, listens to troubles, and occasionally shares local gossip.",
    },
    'merchant': {
        'description': "Shrewd eyes assess everything and everyone as potential profit.",
        'behavior': "Hawks wares with practiced enthusiasm, always ready to make a deal.",
    },
    'goblin': {
        'description': "Small, green-skinned, with pointed ears and sharp teeth.",
        'behavior': "Skulks about, looking for trouble or treasure.",
    },
    'skeleton': {
        'description': "Bones held together by dark magic, eye sockets glowing faintly.",
        'behavior': "Patrols mindlessly, attacking the living on sight.",
    },
    'robot': {
        'description': "Chrome and circuitry, moving with mechanical precision.",
        'behavior': "Executes programmed routines, occasionally glitching.",
    },
    'king': {
        'description': "Regal bearing, crown slightly askew, the weight of rule evident.",
        'behavior': "Holds court, making proclamations and receiving petitioners.",
    },
    'queen': {
        'description': "Elegant and composed, radiating authority and grace.",
        'behavior': "Observes all with keen intelligence, speaking rarely but meaningfully.",
    },
    'dragon': {
        'description': "Scales glinting, smoke curling from nostrils, ancient and terrible.",
        'behavior': "Guards its hoard jealously, demanding tribute or combat.",
    },
    'cat': {
        'description': "Sleek fur and knowing eyes, moving with feline grace.",
        'behavior': "Naps in inconvenient places, demands attention on its own terms.",
    },
    'dog': {
        'description': "Loyal eyes and wagging tail, eager for companionship.",
        'behavior': "Follows interesting people, hoping for treats or adventure.",
    },
    'potato_person': {
        'description': "A sentient potato with stubby limbs and a surprisingly expressive face.",
        'behavior': "Waddles about, occasionally philosophizing about existence.",
    },
    'generic': {
        'description': "A mysterious figure whose purpose remains unclear.",
        'behavior': "Watches and waits.",
    },
}

# Prop templates
PROP_TEMPLATES = {
    'throne': {
        'name': 'Ornate Throne',
        'type': 'furniture',
        'description': 'A grand seat of power, carved from dark wood and gilded with gold.',
    },
    'banner': {
        'name': 'Heraldic Banner',
        'type': 'decoration',
        'description': 'A faded tapestry bearing an ancient crest.',
    },
    'torch': {
        'name': 'Wall Torch',
        'type': 'light',
        'description': 'A flickering torch mounted in an iron sconce.',
    },
    'chains': {
        'name': 'Rusty Chains',
        'type': 'restraint',
        'description': 'Heavy iron chains bolted to the wall, stained with rust.',
    },
    'barrel': {
        'name': 'Wooden Barrel',
        'type': 'container',
        'description': 'A sturdy barrel, contents unknown.',
    },
    'explosive_barrel': {
        'name': 'Explosive Barrel',
        'type': 'hazard',
        'description': 'A red barrel marked with warning symbols. Handle with extreme caution.',
    },
    'crate': {
        'name': 'Wooden Crate',
        'type': 'container',
        'description': 'A simple shipping crate, nailed shut.',
    },
    'chest': {
        'name': 'Treasure Chest',
        'type': 'container',
        'description': 'An iron-bound chest, locked and mysterious.',
    },
    'table': {
        'name': 'Wooden Table',
        'type': 'furniture',
        'description': 'A sturdy table, scarred by years of use.',
    },
    'chair': {
        'name': 'Simple Chair',
        'type': 'furniture',
        'description': 'A basic wooden chair.',
    },
    'bookshelf': {
        'name': 'Tall Bookshelf',
        'type': 'furniture',
        'description': 'Shelves packed with dusty tomes and scrolls.',
    },
    'bed': {
        'name': 'Simple Bed',
        'type': 'furniture',
        'description': 'A straw mattress on a wooden frame.',
    },
    'candle': {
        'name': 'Wax Candle',
        'type': 'light',
        'description': 'A half-melted candle, flame dancing.',
    },
    'cauldron': {
        'name': 'Iron Cauldron',
        'type': 'container',
        'description': 'A large pot bubbling with unknown substances.',
    },
    'altar': {
        'name': 'Stone Altar',
        'type': 'furniture',
        'description': 'A sacred altar, stained with offerings.',
    },
    'statue': {
        'name': 'Stone Statue',
        'type': 'decoration',
        'description': 'A weathered statue of some forgotten figure.',
    },
    'fireplace': {
        'name': 'Stone Hearth',
        'type': 'furniture',
        'description': 'A large fireplace crackling with warmth.',
    },
    'rock': {
        'name': 'Large Boulder',
        'type': 'natural',
        'description': 'A moss-covered stone, ancient and unmoved.',
    },
    'mushroom': {
        'name': 'Glowing Mushroom',
        'type': 'natural',
        'description': 'A bioluminescent fungus pulsing with soft light.',
    },
    'tree': {
        'name': 'Ancient Tree',
        'type': 'natural',
        'description': 'A gnarled tree, roots deep in forgotten soil.',
    },
    'cart': {
        'name': 'Merchant Cart',
        'type': 'vehicle',
        'description': 'A wheeled cart for hauling goods.',
    },
    'terminal': {
        'name': 'Computer Terminal',
        'type': 'tech',
        'description': 'A screen displays scrolling data and command prompts.',
    },
    'control_panel': {
        'name': 'Control Panel',
        'type': 'tech',
        'description': 'Buttons and switches control unknown systems.',
    },
    'server_rack': {
        'name': 'Server Rack',
        'type': 'tech',
        'description': 'Blinking lights indicate constant data processing.',
    },
    'neon_sign': {
        'name': 'Neon Sign',
        'type': 'decoration',
        'description': 'Flickering neon tubes spell out an advertisement.',
    },
}

# Dialogue templates
DIALOGUE_TEMPLATES = {
    'dad_jokes': [
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
        "What did the grape say when it got stepped on? Nothing, it just let out a little wine!",
        "Why did the bicycle fall over? Because it was two-tired!",
    ],
    'jokes': [
        "A skeleton walks into a tavern and orders a drink... and a mop.",
        "Why did the dungeon master bring a ladder? To get to the next level!",
        "What's a dragon's favorite snack? Firecrackers!",
    ],
    'jester': [
        "A jest for you, good traveler!",
        "Why so serious? Life is but a stage!",
        "Did you hear the one about the knight and the dragon?",
    ],
    'guard': [
        "Halt! State your business.",
        "Move along, nothing to see here.",
        "Keep your hands where I can see them.",
    ],
    'wizard': [
        "The arcane secrets are not for the uninitiated...",
        "I sense great potential in you. Or perhaps it's just indigestion.",
        "Reality is merely a suggestion to those who understand the weave.",
    ],
    'bartender': [
        "What'll it be?",
        "We don't get many strangers around here.",
        "Word of advice? Don't ask about the stew.",
    ],
    'merchant': [
        "I have just the thing you're looking for!",
        "For you, my friend, a special price.",
        "Finest goods in all the realm!",
    ],
    'goblin': [
        "Shiny things! Give us the shiny things!",
        "We takes what we wants!",
        "*incomprehensible cackling*",
    ],
    'skeleton': [
        "*bone rattling intensifies*",
        "...",
        "*hollow stare*",
    ],
    'robot': [
        "GREETINGS. HUMAN. HOW. MAY. I. ASSIST.",
        "ERROR: HUMOR MODULE NOT FOUND.",
        "PROCESSING... PROCESSING...",
    ],
    'potato_person': [
        "Have you ever considered the philosophical implications of being a root vegetable?",
        "I yam what I yam.",
        "Life is strange when you're a sentient tuber.",
    ],
    'generic': [
        "Hmm.",
        "...",
        "Interesting.",
    ],
}

# Atmosphere phrases by room type
ATMOSPHERE_PHRASES = {
    'throne_room': [
        "The weight of authority hangs heavy in the air, centuries of power and politics soaked into the very stones.",
        "Echoes of proclamations past seem to linger, ghostly voices debating matters of state.",
        "Every footstep reverberates with importance in this seat of power.",
    ],
    'dungeon': [
        "The air is thick with damp and despair, the walls holding memories of countless prisoners.",
        "Distant dripping water marks the passing seconds in this forgotten pit.",
        "Scratches on the walls tell stories better left unread.",
    ],
    'cave': [
        "The earth breathes slowly here, ancient and patient, indifferent to the concerns of surface dwellers.",
        "Mineral deposits glitter like stars in the darkness, a hidden cosmos underground.",
        "The silence is broken only by the occasional drop of water from unseen heights.",
    ],
    'tavern': [
        "The warmth of companionship fills the room, strangers becoming friends over shared drinks.",
        "Stories and lies intermingle freely, each tale taller than the last.",
        "The fire crackles a welcome to weary travelers.",
    ],
    'library': [
        "Knowledge accumulated over generations fills every shelf, waiting to be rediscovered.",
        "The musty smell of old books carries the weight of countless thoughts and dreams.",
        "Silence reigns, broken only by the whisper of turning pages.",
    ],
    'cyberpunk': [
        "The hum of technology is ever-present, a digital heartbeat beneath the neon glow.",
        "Data flows like blood through the veins of the city, everything connected, nothing private.",
        "The rain-slicked streets reflect a thousand advertisements, each promising escape.",
    ],
    'convergence_zero': [
        "Reality feels thin here, as if the boundary between possible and impossible is merely a suggestion.",
        "Technology beyond current understanding hums with purpose, its goals inscrutable.",
        "Something significant happened here, or will happen, or is happening in a timeline adjacent to now.",
    ],
    'generic': [
        "The atmosphere here is difficult to define but impossible to ignore.",
        "Something about this place demands attention, invites exploration.",
        "The air itself seems to hold its breath, waiting.",
    ],
    'mood_dark': [
        "Shadows seem to move of their own accord, dancing at the edge of vision.",
        "A chill seeps into the bones, not entirely physical in nature.",
    ],
    'mood_cheerful': [
        "There's an inexplicable lightness here, as if joy itself has soaked into the surroundings.",
        "Even the dust motes seem to dance with contentment.",
    ],
    'mood_mysterious': [
        "Questions multiply faster than answers in this enigmatic space.",
        "Every corner holds potential secrets, every shadow a hidden truth.",
    ],
    'mood_cozy': [
        "Comfort wraps around you like a warm blanket, inviting you to stay.",
        "This is a place for rest and reflection, sheltered from the world's demands.",
    ],
}

# Name generation parts
NAME_PARTS = {
    'prefixes': {
        'dark': ['The Shadowed', 'The Dark', 'The Gloomy', 'The Forsaken'],
        'cheerful': ['The Bright', 'The Merry', 'The Golden', 'The Sunny'],
        'mysterious': ['The Enigmatic', 'The Veiled', 'The Hidden', 'The Secret'],
        'ancient': ['The Ancient', 'The Forgotten', 'The Timeless', 'The Eternal'],
        'cozy': ['The Warm', 'The Cozy', 'The Welcoming', 'The Homey'],
        'spooky': ['The Haunted', 'The Cursed', 'The Spectral', 'The Eerie'],
        'neutral': ['The', 'The Grand', 'The Central', 'The Main'],
        'ruined': ['The Ruined', 'The Crumbling', 'The Abandoned', 'The Desolate'],
        'elegant': ['The Royal', 'The Grand', 'The Magnificent', 'The Resplendent'],
    },
    'cores': {
        'throne_room': ['Throne Room', 'Hall of Kings', 'Seat of Power', 'Royal Chamber'],
        'dungeon': ['Dungeon', 'Oubliette', 'Prison Pit', 'Dark Cells'],
        'cave': ['Cavern', 'Grotto', 'Underground Hollow', 'Stone Womb'],
        'tavern': ['Tavern', 'Inn', 'Alehouse', 'Public House', 'Watering Hole'],
        'library': ['Library', 'Archive', 'Repository', 'Hall of Tomes'],
        'laboratory': ['Laboratory', 'Workshop', 'Sanctum', 'Experimatorium'],
        'temple': ['Temple', 'Shrine', 'Sanctuary', 'Holy Ground'],
        'forest': ['Clearing', 'Grove', 'Glade', 'Woodland Heart'],
        'city': ['Square', 'Plaza', 'Street', 'District'],
        'alley': ['Alley', 'Passage', 'Backstreet', 'Lane'],
        'cyberpunk': ['Sector', 'Block', 'Node', 'District'],
        'space_station': ['Deck', 'Module', 'Bay', 'Corridor'],
        'convergence_zero': ['Nexus', 'Core', 'Hub', 'Convergence Point'],
        'void': ['Void', 'Nothing', 'Emptiness', 'Absence'],
        'generic': ['Chamber', 'Room', 'Space', 'Area'],
    },
    'suffixes': [
        'of Echoes',
        'of Shadows',
        'of Whispers',
        'of Forgotten Things',
        'of Lost Souls',
        'of Ancient Days',
        '',
        '',
        '',  # Empty strings make suffixes optional
    ],
}

# Stability descriptions
STABILITY_DESCRIPTIONS = {
    'solid': "The structure is sound and dependable, built to last centuries.",
    'normal': "",
    'fragile': "Cracks run through the walls and ceiling, threatening collapse at any moment.",
    'hope': "Everything here seems held together by nothing more than desperate hope and defiance of physics. One wrong move and it all comes down.",
}

# Mood words for descriptions
MOOD_WORDS = {
    'dark': ['shadowy', 'gloomy', 'dim', 'murky'],
    'cheerful': ['bright', 'lively', 'warm', 'inviting'],
    'spooky': ['eerie', 'unsettling', 'haunted', 'creepy'],
    'mysterious': ['enigmatic', 'puzzling', 'cryptic', 'arcane'],
    'peaceful': ['serene', 'tranquil', 'calm', 'restful'],
    'cozy': ['comfortable', 'snug', 'homey', 'welcoming'],
    'ancient': ['timeworn', 'aged', 'venerable', 'primordial'],
    'ruined': ['crumbling', 'decayed', 'dilapidated', 'ravaged'],
    'busy': ['bustling', 'crowded', 'active', 'lively'],
    'elegant': ['refined', 'sophisticated', 'grand', 'majestic'],
    'gritty': ['rough', 'grimy', 'seedy', 'hardscrabble'],
    'neutral': ['atmospheric', 'distinct', 'notable', 'remarkable'],
}
