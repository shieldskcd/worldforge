# World Forge 🔨⚡

A natural language world builder and destruction sandbox. Describe what you want, watch it form, then blow it up.

## Quick Start

1. **Download Godot 4.2+** from [godotengine.org](https://godotengine.org/download)
2. Open Godot and click "Import"
3. Navigate to this folder and select `project.godot`
4. Press F5 or click the Play button

## How It Works

### The Forge Terminal

Type natural language descriptions and the World Forge interprets them:

```
Create a throne room with a jester who tells bad dad jokes
```

```
Build a dark dungeon with explosive barrels, held together by hope
```

```
Make a tavern with three drunk goblins and lots of tables
```

```
Convergence Zero cityscape with neon lights and robots
```

### What the Parser Understands

**Room Types:**
- throne room, dungeon, cave, tavern, laboratory
- space station, cyberpunk city, temple, library
- convergence zero (for your game!)
- void/abstract/chaos

**Sizes:**
- tiny, small, medium, large, vast, sprawling

**Stability:**
- solid, normal, fragile
- "held together by hope" (everything collapses if you look at it wrong)

**Props:**
- throne, chair, table, barrel, crate, chest
- pillar, torch, candle, bookshelf, statue, banner
- robot, computer, terminal
- explosive barrel, bomb, TNT

**NPCs:**
- jester, king, queen, guard, wizard, merchant
- goblin, skeleton, zombie, dragon
- robot, cat, dog
- potato person (yes, really)

**Behaviors:**
- tells jokes, dad jokes, wandering, guarding
- hostile, friendly, patrolling

## Controls

| Key | Action |
|-----|--------|
| Arrow Keys | Move |
| TAB | Toggle terminal |
| Q | SMITE (explode everything) |
| SPACE | Throw object |
| E | Interact with NPCs |

## Terminal Commands

- `help` - Show help
- `clear` - Destroy current world
- `smite` - Activate smite
- `chaos` - Break all structural joints

## Project Structure

```
WorldForge/
├── project.godot          # Godot project file
├── core/
│   ├── game_manager.gd    # Global state coordination
│   ├── world_parser.gd    # Natural language interpretation
│   ├── object_factory.gd  # Creates objects with physics
│   ├── destructible_object.gd
│   ├── npc_controller.gd
│   └── player.gd
├── scenes/
│   ├── main.tscn          # Main game scene
│   └── main.gd
├── ui/
│   ├── forge_terminal.tscn
│   └── forge_terminal.gd
└── icon.svg
```

## Adding New Content

### New Room Types

Edit `world_parser.gd` - add to `ROOM_TYPES` dictionary:
```gdscript
"my_room": "my_room_type",
```

Then add a palette in `object_factory.gd`:
```gdscript
"my_room_type": {
    "floor": Color(0.4, 0.4, 0.4),
    "wall": Color(0.5, 0.5, 0.5),
    "accent": Color(0.8, 0.2, 0.2),
},
```

### New Props

Add to `PROP_KEYWORDS` in `world_parser.gd`:
```gdscript
"my_prop": {"type": "furniture", "subtype": "my_prop"},
```

Add size in `object_factory.gd` `_get_object_size()`:
```gdscript
"my_prop": return Vector2(50, 50)
```

Add color in `OBJECT_COLORS`:
```gdscript
"my_prop": Color(0.5, 0.5, 0.5),
```

### New NPCs

Add to `npc_patterns` in `world_parser.gd`:
```gdscript
{"pattern": "my_npc", "type": "my_npc", "default_behavior": "idle"},
```

Add color in `object_factory.gd`:
```gdscript
"my_npc": Color(0.5, 0.5, 0.5),
```

## Asset Recommendations

Replace the placeholder ColorRects with real sprites:

- **Kenney.nl** - Free, consistent, huge variety
- **OpenGameArt.org** - Mixed quality but lots of options  
- **itch.io** - Search "free asset pack 2D"
- **Novel AI / Stable Diffusion** - For custom pieces

## Future Ideas

- [ ] Save/load worlds
- [ ] More destruction types (fire, acid, etc.)
- [ ] Sound effects for explosions
- [ ] Particle effects
- [ ] More NPC behaviors
- [ ] Procedural room layouts
- [ ] LLM integration for smarter parsing
- [ ] Multiple connected rooms
- [ ] Day/night cycles per biome

## Notes

This is a creative sandbox for visualization and stress relief. Build something, blow it up, repeat. Perfect for:

- Visualizing game ideas (Convergence Zero scenes!)
- Testing tabletop RPG room layouts
- Just destroying things after a long day

---

Built with Godot 4 and the power of natural language chaos.
