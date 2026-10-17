#!/usr/bin/env python3
"""
Slime Theme Provider for Desktop GUI Dropdown Pads
==================================================
Supplies the Slime color palette to all Python Tkinter scratchpad dropdowns.
"""

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
}

def get_theme():
    """Return the active Slime palette for dropdown applications."""
    return SLIME_THEME
