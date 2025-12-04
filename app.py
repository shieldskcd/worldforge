"""
World Forge - A Natural Language World Builder
Streamlit-based text world generator with optional LLM integration
"""

import streamlit as st
import json
import os
from datetime import datetime
from world_generator import WorldGenerator
from pathlib import Path

# Page config
st.set_page_config(
    page_title="World Forge",
    page_icon="🔨",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS for better styling
st.markdown("""
<style>
    .world-box {
        background-color: #1e1e2e;
        border: 1px solid #45475a;
        border-radius: 10px;
        padding: 20px;
        margin: 10px 0;
        font-family: 'Courier New', monospace;
    }
    .world-title {
        color: #89b4fa;
        font-size: 1.5em;
        font-weight: bold;
        border-bottom: 1px solid #45475a;
        padding-bottom: 10px;
        margin-bottom: 15px;
    }
    .npc-card {
        background-color: #313244;
        border-radius: 8px;
        padding: 15px;
        margin: 10px 0;
    }
    .prop-list {
        color: #a6adc8;
    }
    .mood-tag {
        display: inline-block;
        background-color: #45475a;
        padding: 3px 10px;
        border-radius: 15px;
        margin: 2px;
        font-size: 0.9em;
    }
    .stTextInput > div > div > input {
        font-size: 1.1em;
    }
</style>
""", unsafe_allow_html=True)

# Initialize session state
if 'worlds' not in st.session_state:
    st.session_state.worlds = []
if 'generator' not in st.session_state:
    st.session_state.generator = WorldGenerator()

def render_world(world: dict):
    """Render a generated world in a nice format"""
    
    st.markdown(f"""
    <div class="world-box">
        <div class="world-title">🏰 {world['name']}</div>
        <p><em>{world['description']}</em></p>
    </div>
    """, unsafe_allow_html=True)
    
    # Layout columns
    col1, col2 = st.columns([2, 1])
    
    with col1:
        # Atmosphere
        st.markdown("### 🌫️ Atmosphere")
        st.write(world.get('atmosphere', 'No atmosphere defined.'))
        
        # NPCs
        if world.get('npcs'):
            st.markdown("### 👥 Characters")
            for npc in world['npcs']:
                with st.container():
                    st.markdown(f"**{npc['name']}** — *{npc['type']}*")
                    st.write(f"_{npc['description']}_")
                    if npc.get('behavior'):
                        st.write(f"**Behavior:** {npc['behavior']}")
                    if npc.get('dialogue'):
                        with st.expander("💬 Sample Dialogue"):
                            for line in npc['dialogue'][:3]:
                                st.write(f'"{line}"')
                    st.divider()
    
    with col2:
        # Quick Stats
        st.markdown("### 📊 Details")
        st.write(f"**Size:** {world.get('size', 'Medium').title()}")
        st.write(f"**Stability:** {world.get('stability', 'Normal').title()}")
        st.write(f"**Lighting:** {world.get('lighting', 'Normal')}")
        
        # Props
        if world.get('props'):
            st.markdown("### 🪑 Props")
            for prop in world['props']:
                st.write(f"• {prop['name']} ({prop['type']})")
        
        # Mood Tags
        if world.get('mood_tags'):
            st.markdown("### 🎭 Mood")
            tags_html = " ".join([f'<span class="mood-tag">{tag}</span>' for tag in world['mood_tags']])
            st.markdown(tags_html, unsafe_allow_html=True)
        
        # Exits
        if world.get('exits'):
            st.markdown("### 🚪 Exits")
            for exit_dir, exit_desc in world['exits'].items():
                st.write(f"**{exit_dir.title()}:** {exit_desc}")

def export_world(world: dict) -> str:
    """Export world to JSON string"""
    return json.dumps(world, indent=2, default=str)

# Sidebar
with st.sidebar:
    st.title("⚒️ World Forge")
    st.markdown("*Describe worlds, bring them to life*")
    
    st.divider()
    
    # API Key configuration
    st.markdown("### 🔑 LLM Configuration")
    
    # Check for API key in environment or secrets first
    env_api_key = os.environ.get("ANTHROPIC_API_KEY", "")
    secrets_api_key = ""
    try:
        secrets_api_key = st.secrets.get("ANTHROPIC_API_KEY", "")
    except:
        pass
    
    default_key = env_api_key or secrets_api_key
    
    if default_key:
        st.success("✓ API key configured (from environment)")
        st.session_state.generator.set_api_key(default_key)
        api_key = default_key
    else:
        api_key = st.text_input(
            "Anthropic API Key (optional)",
            type="password",
            help="Add your API key for richer, more creative world generation. Leave blank to use template-based generation."
        )
        
        if api_key:
            st.session_state.generator.set_api_key(api_key)
            st.success("✓ Claude API enabled")
        else:
            st.info("Using template-based generation")
    
    st.divider()
    
    # Generation settings
    st.markdown("### ⚙️ Settings")
    
    creativity = st.slider(
        "Creativity",
        min_value=0.0,
        max_value=1.0,
        value=0.7,
        help="Higher = more creative/unexpected, Lower = more predictable"
    )
    st.session_state.generator.creativity = creativity
    
    include_npcs = st.checkbox("Generate NPCs", value=True)
    include_props = st.checkbox("Generate Props", value=True)
    include_exits = st.checkbox("Generate Exits", value=True)
    
    st.session_state.generator.include_npcs = include_npcs
    st.session_state.generator.include_props = include_props
    st.session_state.generator.include_exits = include_exits
    
    st.divider()
    
    # World history
    if st.session_state.worlds:
        st.markdown("### 📜 History")
        for i, world in enumerate(reversed(st.session_state.worlds[-5:])):
            if st.button(f"🔹 {world['name'][:20]}...", key=f"history_{i}"):
                st.session_state.selected_world = world
    
    st.divider()
    
    # Examples
    st.markdown("### 💡 Try These")
    examples = [
        "A throne room with a jester who tells dad jokes",
        "Dark dungeon, held together by hope, explosive barrels",
        "Cozy tavern with a grumpy bartender and three goblins",
        "Cyberpunk alley with neon signs and a shady merchant",
        "Peaceful library with a sleeping wizard",
        "Convergence Zero control room with malfunctioning robots"
    ]
    for example in examples:
        if st.button(f"_{example[:35]}..._", key=f"ex_{hash(example)}"):
            st.session_state.prompt_input = example

# Main content
st.title("🔨 World Forge")
st.markdown("*Describe a world and watch it come to life*")

# Input area
prompt = st.text_input(
    "What would you like to create?",
    value=st.session_state.get('prompt_input', ''),
    placeholder="e.g., A throne room with a jester who tells bad dad jokes...",
    key="main_prompt"
)

col1, col2, col3 = st.columns([1, 1, 4])
with col1:
    generate_btn = st.button("⚒️ Forge World", type="primary", use_container_width=True)
with col2:
    if st.session_state.worlds:
        clear_btn = st.button("🗑️ Clear All", use_container_width=True)
        if clear_btn:
            st.session_state.worlds = []
            st.rerun()

# Generate world
if generate_btn and prompt:
    with st.spinner("Forging your world..."):
        try:
            world = st.session_state.generator.generate(prompt)
            st.session_state.worlds.append(world)
            st.session_state.prompt_input = ""  # Clear input
            st.success(f"✨ Created: {world['name']}")
        except Exception as e:
            st.error(f"Generation failed: {str(e)}")

# Display worlds
if st.session_state.worlds:
    st.divider()
    
    # Tabs for multiple worlds
    if len(st.session_state.worlds) > 1:
        tabs = st.tabs([f"🏰 {w['name'][:20]}" for w in st.session_state.worlds[-5:]])
        for i, tab in enumerate(tabs):
            with tab:
                world = st.session_state.worlds[-(5-i)] if len(st.session_state.worlds) > i else st.session_state.worlds[i]
                render_world(world)
                
                # Export options
                with st.expander("📤 Export"):
                    st.code(export_world(world), language="json")
                    st.download_button(
                        "Download JSON",
                        export_world(world),
                        file_name=f"{world['name'].lower().replace(' ', '_')}.json",
                        mime="application/json"
                    )
    else:
        render_world(st.session_state.worlds[-1])
        with st.expander("📤 Export"):
            st.code(export_world(st.session_state.worlds[-1]), language="json")
            st.download_button(
                "Download JSON",
                export_world(st.session_state.worlds[-1]),
                file_name=f"{st.session_state.worlds[-1]['name'].lower().replace(' ', '_')}.json",
                mime="application/json"
            )

else:
    # Empty state
    st.markdown("""
    ---
    ### 🌟 Welcome to World Forge!
    
    Describe any world, room, or location and I'll bring it to life with:
    
    - 📝 **Rich descriptions** of the environment
    - 👥 **NPCs** with personalities and dialogue
    - 🪑 **Props** that fill the space
    - 🎭 **Mood and atmosphere**
    - 🚪 **Exits** to other areas
    
    **Try it:** Type something like *"a spooky dungeon with a skeleton guard"* above!
    
    ---
    
    *Tip: Add an Anthropic API key in the sidebar for richer, AI-powered generation!*
    """)

# Footer
st.markdown("---")
st.markdown(
    "<center><small>World Forge v1.0 | Built for creative minds</small></center>",
    unsafe_allow_html=True
)
