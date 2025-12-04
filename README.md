# ⚒️ World Forge

A natural language world builder. Describe any location and watch it come to life with rich descriptions, NPCs, props, and atmosphere.

## Quick Start

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Run the app
streamlit run app.py
```

Then open http://localhost:8501 in your browser.

## Features

### Natural Language Input
Just describe what you want:
- "A throne room with a jester who tells dad jokes"
- "Dark dungeon held together by hope with explosive barrels"
- "Cozy tavern with a grumpy bartender and three goblins"
- "Convergence Zero control room with malfunctioning robots"

### Smart Parsing
The generator understands:

**Room Types:** throne room, dungeon, cave, tavern, library, laboratory, temple, forest, city, alley, cyberpunk, space station, convergence zero, void

**Sizes:** tiny, small, medium, large, vast, sprawling

**Stability:**
- solid (built to last)
- normal 
- fragile (crumbling)
- "held together by hope" (one bump and it all collapses)

**Moods:** dark, cheerful, spooky, mysterious, peaceful, cozy, ancient, ruined, elegant, gritty

**NPCs:** jester, guard, wizard, bartender, merchant, goblin, skeleton, robot, king, queen, dragon, cat, dog, potato person

**Behaviors:** Add "tells jokes" or "dad jokes" for joke-telling NPCs

### Output
Each generated world includes:
- 📝 Name and description
- 🌫️ Detailed atmosphere
- 👥 NPCs with dialogue
- 🪑 Props and objects
- 🎭 Mood tags
- 🚪 Exits to other areas
- 📤 JSON export

## LLM Enhancement (Optional)

Add your Anthropic API key in the sidebar for richer, more creative generation powered by Claude. Without an API key, the app uses smart template-based generation.

## File Structure

```
world_forge/
├── app.py              # Streamlit web interface
├── world_generator.py  # Generation logic
├── templates.py        # Room/NPC/prop templates
├── requirements.txt    # Dependencies
└── README.md
```

## Extending

### Add New Room Types

In `templates.py`, add to `ROOM_TEMPLATES`:
```python
'my_room': {
    'description': "A {mood} description here...",
    'lighting': "How it's lit",
    'default_props': ['prop1', 'prop2'],
},
```

Then add detection keyword in `world_generator.py`:
```python
'my keyword': 'my_room',
```

### Add New NPCs

In `templates.py`, add to `NPC_TEMPLATES`:
```python
'my_npc': {
    'description': "What they look like",
    'behavior': "What they do",
},
```

Add dialogue in `DIALOGUE_TEMPLATES`:
```python
'my_npc': [
    "Line one",
    "Line two",
],
```

### Add New Props

In `templates.py`, add to `PROP_TEMPLATES`:
```python
'my_prop': {
    'name': 'Display Name',
    'type': 'category',
    'description': 'What it is',
},
```

## Future Ideas

- [ ] Save/load world collections
- [ ] Connect rooms into dungeons/maps
- [ ] Export to other formats (Markdown, HTML)
- [ ] Integration with game engines
- [ ] Collaborative world building
- [ ] AI image generation for locations
- [ ] Text-to-speech for NPC dialogue

## Use Cases

- **Game Development:** Quickly visualize locations for Convergence Zero or other projects
- **Tabletop RPG:** Generate rooms on the fly during sessions
- **Writing:** Create detailed settings for stories
- **Brainstorming:** Rapid location prototyping
- **Fun:** Just make weird stuff and see what happens

---

Built with Streamlit and optional Claude API integration.
