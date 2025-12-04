"""
World Generator - Interprets natural language and generates world descriptions
Supports both template-based and LLM-powered generation
"""

import random
import re
from typing import Optional
from dataclasses import dataclass, field
from templates import (
    ROOM_TEMPLATES, NPC_TEMPLATES, PROP_TEMPLATES,
    ATMOSPHERE_PHRASES, NAME_PARTS, DIALOGUE_TEMPLATES,
    STABILITY_DESCRIPTIONS, MOOD_WORDS
)

@dataclass
class WorldGenerator:
    """Generates world descriptions from natural language prompts"""
    
    api_key: Optional[str] = None
    creativity: float = 0.7
    include_npcs: bool = True
    include_props: bool = True
    include_exits: bool = True
    
    def set_api_key(self, key: str):
        """Set the Anthropic API key for LLM generation"""
        self.api_key = key if key.strip() else None
    
    def generate(self, prompt: str) -> dict:
        """Generate a world from a natural language prompt"""
        if self.api_key:
            return self._generate_with_llm(prompt)
        else:
            return self._generate_with_templates(prompt)
    
    def _generate_with_llm(self, prompt: str) -> dict:
        """Use Claude API for rich generation"""
        try:
            import anthropic
            
            client = anthropic.Anthropic(api_key=self.api_key)
            
            system_prompt = """You are a creative world builder for games and storytelling. 
            Given a description, generate a detailed world/room/location.
            
            Respond with ONLY valid JSON in this exact format:
            {
                "name": "Creative name for this location",
                "description": "2-3 sentence vivid description",
                "atmosphere": "Detailed paragraph about the feel, sounds, smells",
                "size": "tiny/small/medium/large/vast",
                "stability": "solid/normal/fragile/hope",
                "lighting": "Description of lighting",
                "mood_tags": ["tag1", "tag2", "tag3"],
                "npcs": [
                    {
                        "name": "Character name",
                        "type": "What they are",
                        "description": "Brief description",
                        "behavior": "What they do",
                        "dialogue": ["Line 1", "Line 2", "Line 3"]
                    }
                ],
                "props": [
                    {"name": "Prop name", "type": "category", "description": "brief desc"}
                ],
                "exits": {
                    "north": "Where it leads",
                    "south": "Where it leads"
                }
            }
            
            Be creative! If they mention jokes, include funny dialogue. Match the mood they describe.
            For "held together by hope" stability, describe things barely holding together."""
            
            message = client.messages.create(
                model="claude-sonnet-4-20250514",
                max_tokens=1500,
                messages=[
                    {"role": "user", "content": f"Create a world based on: {prompt}"}
                ],
                system=system_prompt
            )
            
            # Parse the response
            response_text = message.content[0].text
            
            # Try to extract JSON from the response
            import json
            
            # Handle potential markdown code blocks
            if "```json" in response_text:
                response_text = response_text.split("```json")[1].split("```")[0]
            elif "```" in response_text:
                response_text = response_text.split("```")[1].split("```")[0]
            
            world = json.loads(response_text.strip())
            world['source'] = 'llm'
            world['original_prompt'] = prompt
            
            return world
            
        except ImportError:
            # anthropic package not installed, fall back to templates
            return self._generate_with_templates(prompt)
        except Exception as e:
            # Any other error, fall back to templates
            print(f"LLM generation failed: {e}, falling back to templates")
            return self._generate_with_templates(prompt)
    
    def _generate_with_templates(self, prompt: str) -> dict:
        """Generate using smart templates and parsing"""
        lower_prompt = prompt.lower()
        
        # Parse the prompt
        room_type = self._detect_room_type(lower_prompt)
        size = self._detect_size(lower_prompt)
        stability = self._detect_stability(lower_prompt)
        mood = self._detect_mood(lower_prompt)
        
        # Get base template
        template = ROOM_TEMPLATES.get(room_type, ROOM_TEMPLATES['generic'])
        
        # Generate world
        world = {
            'name': self._generate_name(room_type, mood),
            'description': self._fill_template(template['description'], mood, stability),
            'atmosphere': self._generate_atmosphere(room_type, mood, stability),
            'size': size,
            'stability': stability,
            'lighting': template.get('lighting', 'Ambient light from unknown sources'),
            'mood_tags': self._generate_mood_tags(mood, room_type),
            'npcs': [],
            'props': [],
            'exits': {},
            'source': 'template',
            'original_prompt': prompt
        }
        
        # Add NPCs if requested
        if self.include_npcs:
            world['npcs'] = self._generate_npcs(lower_prompt, room_type)
        
        # Add props if requested
        if self.include_props:
            world['props'] = self._generate_props(lower_prompt, room_type, template)
        
        # Add exits if requested
        if self.include_exits:
            world['exits'] = self._generate_exits(room_type)
        
        return world
    
    def _detect_room_type(self, prompt: str) -> str:
        """Detect the type of room/location from the prompt"""
        type_keywords = {
            'throne': 'throne_room',
            'throne room': 'throne_room',
            'castle': 'throne_room',
            'dungeon': 'dungeon',
            'cell': 'dungeon',
            'prison': 'dungeon',
            'cave': 'cave',
            'cavern': 'cave',
            'tavern': 'tavern',
            'inn': 'tavern',
            'bar': 'tavern',
            'pub': 'tavern',
            'library': 'library',
            'study': 'library',
            'laboratory': 'laboratory',
            'lab': 'laboratory',
            'forest': 'forest',
            'woods': 'forest',
            'grove': 'forest',
            'temple': 'temple',
            'shrine': 'temple',
            'church': 'temple',
            'city': 'city',
            'street': 'city',
            'alley': 'alley',
            'cyberpunk': 'cyberpunk',
            'neon': 'cyberpunk',
            'space': 'space_station',
            'station': 'space_station',
            'spaceship': 'space_station',
            'ship': 'space_station',
            'convergence': 'convergence_zero',
            'convergence zero': 'convergence_zero',
            'void': 'void',
            'abstract': 'void',
            'chaos': 'void',
        }
        
        for keyword, room_type in type_keywords.items():
            if keyword in prompt:
                return room_type
        
        return 'generic'
    
    def _detect_size(self, prompt: str) -> str:
        """Detect size from prompt"""
        size_keywords = {
            'tiny': 'tiny',
            'small': 'small',
            'cozy': 'small',
            'medium': 'medium',
            'large': 'large',
            'huge': 'vast',
            'vast': 'vast',
            'massive': 'vast',
            'sprawling': 'vast',
            'enormous': 'vast',
        }
        
        for keyword, size in size_keywords.items():
            if keyword in prompt:
                return size
        
        return 'medium'
    
    def _detect_stability(self, prompt: str) -> str:
        """Detect structural stability from prompt"""
        if 'held together by hope' in prompt or 'hope' in prompt:
            return 'hope'
        if 'crumbling' in prompt or 'unstable' in prompt or 'rickety' in prompt:
            return 'fragile'
        if 'fragile' in prompt or 'weak' in prompt:
            return 'fragile'
        if 'solid' in prompt or 'sturdy' in prompt or 'strong' in prompt:
            return 'solid'
        return 'normal'
    
    def _detect_mood(self, prompt: str) -> str:
        """Detect mood/atmosphere from prompt"""
        mood_keywords = {
            'dark': 'dark',
            'gloomy': 'dark',
            'spooky': 'spooky',
            'haunted': 'spooky',
            'creepy': 'spooky',
            'bright': 'bright',
            'cheerful': 'cheerful',
            'happy': 'cheerful',
            'cozy': 'cozy',
            'warm': 'cozy',
            'peaceful': 'peaceful',
            'calm': 'peaceful',
            'serene': 'peaceful',
            'mysterious': 'mysterious',
            'eerie': 'mysterious',
            'ancient': 'ancient',
            'old': 'ancient',
            'ruined': 'ruined',
            'abandoned': 'ruined',
            'busy': 'busy',
            'crowded': 'busy',
            'elegant': 'elegant',
            'grand': 'elegant',
            'dirty': 'gritty',
            'grimy': 'gritty',
            'gritty': 'gritty',
        }
        
        for keyword, mood in mood_keywords.items():
            if keyword in prompt:
                return mood
        
        return 'neutral'
    
    def _generate_name(self, room_type: str, mood: str) -> str:
        """Generate a creative name for the location"""
        prefixes = NAME_PARTS.get('prefixes', {}).get(mood, ['The'])
        cores = NAME_PARTS.get('cores', {}).get(room_type, ['Chamber'])
        suffixes = NAME_PARTS.get('suffixes', [''])
        
        prefix = random.choice(prefixes)
        core = random.choice(cores)
        suffix = random.choice(suffixes) if random.random() > 0.5 else ''
        
        name = f"{prefix} {core}"
        if suffix:
            name += f" {suffix}"
        
        return name
    
    def _fill_template(self, template: str, mood: str, stability: str) -> str:
        """Fill in template placeholders"""
        mood_adj = MOOD_WORDS.get(mood, ['atmospheric'])[0]
        stability_desc = STABILITY_DESCRIPTIONS.get(stability, '')
        
        result = template.replace('{mood}', mood_adj)
        if stability == 'hope' or stability == 'fragile':
            result += f" {stability_desc}"
        
        return result
    
    def _generate_atmosphere(self, room_type: str, mood: str, stability: str) -> str:
        """Generate atmospheric description"""
        phrases = ATMOSPHERE_PHRASES.get(room_type, ATMOSPHERE_PHRASES['generic'])
        mood_phrases = ATMOSPHERE_PHRASES.get(f"mood_{mood}", [])
        
        base = random.choice(phrases)
        
        if mood_phrases:
            base += " " + random.choice(mood_phrases)
        
        if stability == 'hope':
            base += " Everything seems to be barely holding together, as if one wrong move could bring it all down."
        elif stability == 'fragile':
            base += " Cracks spider across the surfaces, and dust falls with every vibration."
        
        return base
    
    def _generate_mood_tags(self, mood: str, room_type: str) -> list:
        """Generate mood tags for the location"""
        tags = [mood] if mood != 'neutral' else []
        tags.append(room_type.replace('_', ' '))
        
        extra_tags = ['atmospheric', 'immersive', 'detailed']
        tags.append(random.choice(extra_tags))
        
        return tags[:4]
    
    def _generate_npcs(self, prompt: str, room_type: str) -> list:
        """Generate NPCs based on prompt"""
        npcs = []
        
        # NPC patterns to look for
        npc_patterns = [
            (r'(\w+)?\s*jester', 'jester'),
            (r'(\w+)?\s*guard', 'guard'),
            (r'(\w+)?\s*wizard', 'wizard'),
            (r'(\w+)?\s*bartender', 'bartender'),
            (r'(\w+)?\s*merchant', 'merchant'),
            (r'(\w+)?\s*goblin', 'goblin'),
            (r'(\w+)?\s*skeleton', 'skeleton'),
            (r'(\w+)?\s*robot', 'robot'),
            (r'(\w+)?\s*king', 'king'),
            (r'(\w+)?\s*queen', 'queen'),
            (r'(\w+)?\s*dragon', 'dragon'),
            (r'(\w+)?\s*cat', 'cat'),
            (r'(\w+)?\s*dog', 'dog'),
            (r'potato\s*person|potato\s*people', 'potato_person'),
        ]
        
        # Check for quantity words
        quantity_words = {
            'a': 1, 'an': 1, 'one': 1,
            'two': 2, 'couple': 2,
            'three': 3, 'few': 3,
            'four': 4,
            'five': 5, 'several': 5,
            'six': 6,
            'many': 4,
            'some': 3,
        }
        
        for pattern, npc_type in npc_patterns:
            if re.search(pattern, prompt):
                # Try to find quantity
                count = 1
                for word, num in quantity_words.items():
                    if re.search(rf'\b{word}\b.*{npc_type}', prompt):
                        count = num
                        break
                
                template = NPC_TEMPLATES.get(npc_type, NPC_TEMPLATES['generic'])
                
                for i in range(count):
                    npc = {
                        'name': self._generate_npc_name(npc_type, i),
                        'type': npc_type.replace('_', ' ').title(),
                        'description': template['description'],
                        'behavior': template['behavior'],
                        'dialogue': self._generate_dialogue(npc_type, prompt)
                    }
                    npcs.append(npc)
        
        return npcs
    
    def _generate_npc_name(self, npc_type: str, index: int = 0) -> str:
        """Generate a name for an NPC"""
        name_lists = {
            'jester': ['Finnick the Foolish', 'Motley Pete', 'Jingles', 'Bells McGee', 'Chuckles'],
            'guard': ['Ser Marcus', 'Grim Gerald', 'Stone-faced Stan', 'Watchful Wendy', 'Iron Ivan'],
            'wizard': ['Mysticus the Grey', 'Eldwin Sparkle', 'Nox the Unknowable', 'Sage Whisperwind'],
            'bartender': ['Old Gus', 'Molly Stoutarm', 'Gruff McGruffin', 'Barrel Betty'],
            'merchant': ['Silvertongue Sam', 'Honest Abe', 'Shady Sadie', 'Coins McGraw'],
            'goblin': ['Snarl', 'Grubnik', 'Pointy Pete', 'Wort', 'Skritch', 'Nob'],
            'skeleton': ['Bones', 'Rattles', 'Sir Calcium', 'Dusty', 'Clacksworth'],
            'robot': ['Unit-7', 'RX-42', 'Chrome', 'Servo', 'Rusty'],
            'king': ['King Aldric', 'His Majesty Thornwell', 'King Barron III'],
            'queen': ['Queen Seraphina', 'Her Majesty Elowen', 'Queen Margot'],
            'potato_person': ['Spud', 'Tater', 'Russet Ron', 'Yukon Yolanda', 'Mash'],
        }
        
        names = name_lists.get(npc_type, ['Stranger', 'Unknown Figure', 'Mysterious Entity'])
        return names[index % len(names)]
    
    def _generate_dialogue(self, npc_type: str, prompt: str) -> list:
        """Generate dialogue for an NPC"""
        # Check for joke-related keywords
        if 'joke' in prompt or 'jokes' in prompt:
            if 'dad' in prompt or 'bad' in prompt:
                return DIALOGUE_TEMPLATES['dad_jokes'][:5]
            return DIALOGUE_TEMPLATES.get('jokes', DIALOGUE_TEMPLATES['generic'])[:3]
        
        return DIALOGUE_TEMPLATES.get(npc_type, DIALOGUE_TEMPLATES['generic'])[:3]
    
    def _generate_props(self, prompt: str, room_type: str, template: dict) -> list:
        """Generate props for the room"""
        props = []
        
        # Get default props for room type
        default_props = template.get('default_props', [])
        for prop_type in default_props:
            if prop_type in PROP_TEMPLATES:
                prop_data = PROP_TEMPLATES[prop_type]
                props.append({
                    'name': prop_data['name'],
                    'type': prop_data['type'],
                    'description': prop_data['description']
                })
        
        # Check for explicitly mentioned props
        prop_keywords = {
            'barrel': 'barrel',
            'explosive': 'explosive_barrel',
            'crate': 'crate',
            'chest': 'chest',
            'table': 'table',
            'chair': 'chair',
            'throne': 'throne',
            'torch': 'torch',
            'bookshelf': 'bookshelf',
            'bed': 'bed',
            'cauldron': 'cauldron',
            'computer': 'computer',
            'terminal': 'terminal',
        }
        
        for keyword, prop_type in prop_keywords.items():
            if keyword in prompt and prop_type in PROP_TEMPLATES:
                # Avoid duplicates
                if not any(p['name'] == PROP_TEMPLATES[prop_type]['name'] for p in props):
                    prop_data = PROP_TEMPLATES[prop_type]
                    props.append({
                        'name': prop_data['name'],
                        'type': prop_data['type'],
                        'description': prop_data['description']
                    })
        
        return props
    
    def _generate_exits(self, room_type: str) -> dict:
        """Generate exits for the room"""
        exit_templates = {
            'throne_room': {
                'north': 'Royal Chambers',
                'south': 'Grand Entrance Hall',
                'east': 'War Room',
            },
            'dungeon': {
                'north': 'Deeper into the dungeon',
                'south': 'Stairs leading up',
                'east': 'Another cell block',
            },
            'tavern': {
                'south': 'The main street',
                'up': 'Rooms for rent',
            },
            'library': {
                'north': 'Restricted Section',
                'south': 'Main Hall',
            },
            'cave': {
                'north': 'Deeper into darkness',
                'south': 'Towards daylight',
            },
            'cyberpunk': {
                'north': 'Neon District',
                'south': 'Underground Market',
                'up': 'Rooftops',
            },
            'convergence_zero': {
                'north': 'Command Center',
                'south': 'Docking Bay',
                'down': 'Maintenance Tunnels',
            },
        }
        
        return exit_templates.get(room_type, {
            'north': 'Unknown passage',
            'south': 'The way back',
        })
