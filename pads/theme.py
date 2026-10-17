#!/usr/bin/env python3
"""
Dual Theme Provider for Desktop GUI Dropdown Pads
=================================================
Supplies either the Biohazard Slime (Post-Contamination) palette or the
Laboratory White (Pre-Contamination) palette to all Python Tkinter scratchpads.
"""

import os

SLIME_THEME = {
    "bg": "#0c140d",             # Deep swamp dark green background
    "bg_surface": "#122015",     # Dark green surface frame
    "bg_card": "#16281a",        # Elevated container card
    "bg_hover": "#1f3a24",       # Hover state
    "bg_active": "#25482b",      # Active selection
    "bg_selected": "#1f3a24",    # Selected card surface
    "border": "#27482d",         # Subtle green border
    "border_focus": "#55f736",   # Radioactive slime green border
    "border_today": "#d8eb34",   # Toxic acid yellow
    "fg": "#c6f582",             # Pale lichen text
    "fg_dim": "#6f9976",         # Muted green text
    "fg_header": "#f0ffcd",      # High contrast bright text
    "key_bg": "#122015",         # Badge background
    "key_fg": "#d8eb34",         # Toxic yellow badge text
    "status_running": "#4ee24e", # Vibrant slime green
    "status_stopped": "#ff4343", # Vivid hazard red!
    "status_paused": "#d8eb34",  # Toxic yellow
    "accent_blue": "#36e385",    # Algae / cyan-green
    "accent_aqua": "#55ffaa",    # Mint slime
    "accent_green": "#4ee24e",   # Slime green
    "accent_yellow": "#d8eb34",  # Acid yellow
    "accent_orange": "#e5ff4d",  # Electric chartreuse
    "accent_purple": "#7cb324",  # Olive green
    "accent_red": "#ff4343",     # Stand-out alert red
    "font": "OpenDyslexic Nerd Font",
}

LAB_THEME = {
    "bg": "#f4f6f8",             # Sterile laboratory white background
    "bg_surface": "#ffffff",     # Pure ceramic white surface frame
    "bg_card": "#e8edf2",        # Brushed clinical panel card
    "bg_hover": "#dde4ec",       # Hover state
    "bg_active": "#cbd5e1",      # Active selection
    "bg_selected": "#dbe4ee",    # Selected card surface
    "border": "#000000",         # Stark jet-black architectural border
    "border_focus": "#000000",   # Stark jet-black active border
    "border_today": "#0284c7",   # Clinical blueprint blue
    "fg": "#0a0c0e",             # Stark jet-black readable text
    "fg_dim": "#475569",         # Surgical slate grey text
    "fg_header": "#000000",      # Pure black header text
    "key_bg": "#0a0c0e",         # High-contrast black key badge
    "key_fg": "#ffffff",         # Pure white key badge text
    "status_running": "#0f766e", # Clinical teal-green
    "status_stopped": "#dc2626", # Hazard red
    "status_paused": "#b45309",  # Caution amber
    "accent_blue": "#0284c7",    # Cryo / clinical blue
    "accent_aqua": "#0f766e",    # Sterile teal
    "accent_green": "#047857",   # Cleanroom emerald
    "accent_yellow": "#b45309",  # Caution amber
    "accent_orange": "#c2410c",  # Industrial orange
    "accent_purple": "#334155",  # Surgical steel
    "accent_red": "#dc2626",     # Stand-out hazard red
    "font": "ShureTechMono Nerd Font",
}

CYBER_THEME = {
    "bg": "#090812",             # Obsidian ink-violet background
    "bg_surface": "#120f24",     # Deep indigo surface frame
    "bg_card": "#161326",        # Raised cyberdeck panel card
    "bg_hover": "#1f1a36",       # Hover state
    "bg_active": "#2d234e",      # Active selection
    "bg_selected": "#1f1a36",    # Selected card surface
    "border": "#7928ca",         # Deep UV neon violet border
    "border_focus": "#a855f7",   # Core electric purple active border
    "border_today": "#00f0ff",   # High-voltage acid cyan
    "fg": "#e0d8f6",             # Bioluminescent off-white text
    "fg_dim": "#7928ca",         # Muted neon violet text
    "fg_header": "#00f0ff",      # High-voltage acid cyan header
    "key_bg": "#120f24",         # Badge background
    "key_fg": "#55f736",         # Toxic slime bio-reactor badge text
    "status_running": "#55f736", # Toxic slime power active
    "status_stopped": "#ff007f", # Hot magenta alert!
    "status_paused": "#00f0ff",  # Acid cyan
    "accent_blue": "#00f0ff",    # Acid cyan
    "accent_aqua": "#00f0ff",    # Acid cyan
    "accent_green": "#55f736",   # Toxic slime green
    "accent_yellow": "#55f736",  # Toxic slime green
    "accent_orange": "#a855f7",  # Core electric purple
    "accent_purple": "#a855f7",  # Core electric purple
    "accent_red": "#ff007f",     # Hot magenta
    "font": "ZedMono Nerd Font",
}


ORIGIN_THEME = {
    "bg": "#141712",             # Deep Forest Soil background
    "bg_surface": "#1c1914",     # Peat / root shadow surface frame
    "bg_card": "#241e17",        # Bark & Timber panel card
    "bg_hover": "#2e261d",       # Hover state
    "bg_active": "#382f24",      # Active selection
    "bg_selected": "#2e261d",    # Selected card surface
    "border": "#5a784d",         # Lichen / Damp Moss border
    "border_focus": "#9ece6a",   # Bioluminescent Spore active border
    "border_today": "#d08770",   # Weathered Amber
    "fg": "#d8dee9",             # Spore White text
    "fg_dim": "#7c8574",         # Muted lichen text
    "fg_header": "#9ece6a",      # Bioluminescent Spore header
    "key_bg": "#1c1914",         # Badge background
    "key_fg": "#9ece6a",         # Bioluminescent Spore badge text
    "status_running": "#9ece6a", # Bioluminescent Spore active
    "status_stopped": "#d08770", # Weathered Amber alert
    "status_paused": "#ebcb8b",  # Golden Mycelium
    "accent_blue": "#8fbcbb",    # Morning Dew
    "accent_aqua": "#9ece6a",    # Bioluminescent Spore
    "accent_green": "#5a784d",   # Lichen / Damp Moss
    "accent_yellow": "#ebcb8b",  # Golden Mycelium
    "accent_orange": "#d08770",  # Weathered Amber
    "accent_purple": "#b48ead",  # Wild Forest Orchid
    "accent_red": "#bf616a",     # Rust Berry
    "font": "MonaspiceRn Nerd Font",
}


SPACE_THEME = {
    "bg": "#f5f6f9",             # Hull White background
    "bg_surface": "#ffffff",     # Pressurized cabin surface frame
    "bg_card": "#e1e4ea",        # Airframe Grey panel card
    "bg_hover": "#d2d7e0",       # Hover state
    "bg_active": "#c2c9d6",      # Active selection
    "bg_selected": "#d2d7e0",    # Selected card surface
    "border": "#0088cc",         # Thruster Cyan border
    "border_focus": "#e59500",   # Solar Flare Gold active border
    "border_today": "#0088cc",   # Thruster Cyan
    "fg": "#1b2028",             # Deep Nav Slate text
    "fg_dim": "#5a6578",         # Muted cabin slate text
    "fg_header": "#1b2028",      # Deep Nav Slate header
    "key_bg": "#1b2028",         # High-contrast slate badge
    "key_fg": "#e59500",         # Solar Flare Gold badge text
    "status_running": "#0d8a52", # Cryo-Stasis Emerald
    "status_stopped": "#d32f2f", # Airlock Red alert!
    "status_paused": "#c25d00",  # Hull Seal Amber
    "accent_blue": "#0088cc",    # Thruster Cyan
    "accent_aqua": "#0088cc",    # Thruster Cyan
    "accent_green": "#0d8a52",   # Cryo-Stasis Emerald
    "accent_yellow": "#e59500",  # Solar Flare Gold
    "accent_orange": "#c25d00",  # Hull Seal Amber
    "accent_purple": "#6b46c1",  # Starlight Relay Violet
    "accent_red": "#d32f2f",     # Airlock Red
    "font": "SpaceMono Nerd Font",
}


SHRED_THEME = {
    "bg": "#0b0c0e",             # Abyssal Chute background
    "bg_surface": "#14171c",     # Machined gunmetal surface frame
    "bg_card": "#1c2026",        # Hardened steel panel card
    "bg_hover": "#262c36",       # Hover state
    "bg_active": "#323842",      # Active selection
    "bg_selected": "#262c36",    # Selected card surface
    "border": "#4a5260",         # Brushed tungsten border
    "border_focus": "#c8d0dc",   # Honed razor blade active border
    "border_today": "#ff2a2a",   # Friction spark red
    "fg": "#d8dee9",             # Cold brushed steel text
    "fg_dim": "#6e7785",         # Muted gunmetal slate text
    "fg_header": "#ffffff",      # Blinding specular razor header
    "key_bg": "#14171c",         # Machined gunmetal badge
    "key_fg": "#ff2a2a",         # Friction spark red badge text
    "status_running": "#c8d0dc", # Honed steel running state
    "status_stopped": "#ff2a2a", # Friction spark red stop
    "status_paused": "#ff5500",  # Grinding spark orange
    "accent_blue": "#5c6e84",    # Blued gunmetal
    "accent_aqua": "#8b95a5",    # Titanium
    "accent_green": "#7a889b",   # Steel patina
    "accent_yellow": "#ff5500",  # Grinding spark orange
    "accent_orange": "#ff8800",  # Molten slag
    "accent_purple": "#9e6b78",  # Heat-treated titanium
    "accent_red": "#ff2a2a",     # Friction spark red
    "font": "JetBrainsMono Nerd Font",
}


def get_theme():
    """Return the active palette based on ~/.config/awesome/theme_mode."""
    mode_file = os.path.expanduser("~/.config/awesome/theme_mode")
    try:
        with open(mode_file, "r", encoding="utf-8") as f:
            mode = f.read().strip()
            if mode == "origin":
                return ORIGIN_THEME
            if mode == "lab":
                return LAB_THEME
            if mode == "cyber":
                return CYBER_THEME
            if mode == "space":
                return SPACE_THEME
            if mode == "shred":
                return SHRED_THEME
    except OSError:
        pass
    return SLIME_THEME
