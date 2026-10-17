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
}


def get_theme():
    """Return the active palette based on ~/.config/awesome/theme_mode."""
    mode_file = os.path.expanduser("~/.config/awesome/theme_mode")
    try:
        with open(mode_file, "r", encoding="utf-8") as f:
            if f.read().strip() == "lab":
                return LAB_THEME
    except OSError:
        pass
    return SLIME_THEME
