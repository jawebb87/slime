#!/usr/bin/env python3
"""Theme palettes shared by the desktop GUI dropdown pads."""

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
    "font": "HeavyData Nerd Font",
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


CHOMP_THEME = {
    "bg": "#111415",             # Cyber-Swamp Brutalist Console background
    "bg_surface": "#0d2822",     # Dark emerald shadow surface frame
    "bg_card": "#161b1c",        # Monolithic chamfer panel card
    "bg_hover": "#1c2522",       # Hover state
    "bg_active": "#22382e",      # Active selection
    "bg_selected": "#1c2522",    # Selected card surface
    "border": "#39ff14",         # High-voltage neon green border
    "border_focus": "#39ff14",   # Neon green active border
    "border_today": "#ffb000",   # Amber highlight
    "fg": "#e2f5ec",             # High contrast phosphor mint text
    "fg_dim": "#6ee7b7",         # Muted emerald text
    "fg_header": "#39ff14",      # Pure neon green header
    "key_bg": "#0d2822",         # High-contrast badge background
    "key_fg": "#39ff14",         # Neon green badge text
    "status_running": "#39ff14", # Phosphor green running state
    "status_stopped": "#ff3b5c", # Neon crimson stop
    "status_paused": "#ffb000",  # Amber warning
    "accent_blue": "#6ee7b7",    # Mint
    "accent_aqua": "#39ff14",    # High-voltage green
    "accent_green": "#39ff14",   # High-voltage green
    "accent_yellow": "#ffb000",  # Amber
    "accent_orange": "#ffb000",  # Amber
    "accent_purple": "#2dd4bf",  # Teal accent
    "accent_red": "#ff3b5c",     # Neon crimson
    "font": "IosevkaTerm Nerd Font",
}


RED_THEME = {
    "bg": "#0e0708",             # Scorched obsidian background
    "bg_surface": "#1c090c",     # Infernal shadow surface frame
    "bg_card": "#240b0f",        # Crucible chamber panel card
    "bg_hover": "#360e14",       # Hover state
    "bg_active": "#4a141b",      # Active selection
    "bg_selected": "#360e14",    # Selected card surface
    "border": "#8a2430",         # High-contrast brimstone border
    "border_focus": "#ff1a2a",   # Searing crucible red active border
    "border_today": "#ffaa00",   # Crucible flame amber
    "fg": "#faebe8",             # Bone white text
    "fg_dim": "#ba6874",         # Muted ember text
    "fg_header": "#ffffff",      # Blinding white header
    "key_bg": "#1c090c",         # Badge background
    "key_fg": "#ffaa00",         # Crucible amber badge text
    "status_running": "#39ff14", # Acid green active state
    "status_stopped": "#ff1a2a", # Searing red alert
    "status_paused": "#ffaa00",  # Crucible amber
    "accent_blue": "#38bdf8",    # Plasma blue
    "accent_aqua": "#00e5ff",    # BFG cyan
    "accent_green": "#39ff14",   # Acid green
    "accent_yellow": "#ffaa00",  # Crucible amber
    "accent_orange": "#ff5500",  # Molten slag
    "accent_purple": "#e040fb",  # Demonic violet
    "accent_red": "#ff1a2a",     # Infernal blood red
    "font": "GohuFont 11 Nerd Font",
}


WINDBREAKER_THEME = {
    "bg": "#f4f6fa",             # Crisp light athletic nylon fabric background
    "bg_surface": "#ffffff",     # Pure white elevated surface frame
    "bg_card": "#edf1f8",        # Clean nylon container card
    "bg_hover": "#ffd6ea",       # Soft neon pink hover state
    "bg_active": "#ff007f",      # High-voltage neon hot pink active selection
    "bg_selected": "#e0f7fa",    # Electric cyan tint selected card surface
    "border": "#00d2ff",         # Electric cyan architectural border
    "border_focus": "#ff007f",   # Hot neon pink active border
    "border_today": "#ffe600",   # Cyber solar yellow
    "fg": "#151324",             # Crisp deep indigo readable text
    "fg_dim": "#625c7e",         # Muted dusk slate text
    "fg_header": "#ff007f",      # Hot neon pink header
    "key_bg": "#ff007f",         # Neon pink key badge
    "key_fg": "#ffffff",         # Crisp white key badge text
    "status_running": "#05b34c", # Vivid 90s neon green
    "status_stopped": "#ff2a5f", # Neon coral/red alert!
    "status_paused": "#ffe600",  # Cyber solar yellow
    "accent_blue": "#0077cc",    # Electric blue
    "accent_aqua": "#00d2ff",    # Electric cyan / turquoise
    "accent_green": "#10e862",   # High-voltage neon lime green
    "accent_yellow": "#ffe600",  # Cyber neon yellow
    "accent_orange": "#ff8c00",  # 90s neon tangerine
    "accent_purple": "#7000ff",  # Retro royal purple
    "accent_red": "#ff007f",     # Sizzling hot magenta
    "font": "ComicShannsMono Nerd Font",
}

GILL_THEME = {
    "bg": "#080e15",             # Deep subterranean cavern trench
    "bg_surface": "#0c1520",     # Subterranean grotto surface
    "bg_card": "#13202e",        # Elevated wet stone container card
    "bg_hover": "#1e354d",       # Aquatic cavern hover state
    "bg_active": "#00f5d4",      # High-voltage bioluminescent cyan selection
    "bg_selected": "#162d42",    # Deep pool selected card surface
    "border": "#1a2e42",         # Wet basalt architectural border
    "border_focus": "#00f5d4",   # Electric bioluminescent cyan border
    "border_today": "#fbbf24",   # Baron's gold monocle accent
    "fg": "#cbd5e1",             # Crisp cave mist readable text
    "fg_dim": "#475569",         # Muted cave shadow text
    "fg_header": "#00f5d4",      # Bioluminescent cyan header
    "key_bg": "#00f5d4",         # Bioluminescent badge background
    "key_fg": "#080e15",         # High-contrast trench dark badge text
    "status_running": "#34d399", # Bioluminescent moss emerald
    "status_stopped": "#fb7185", # Baron's feathery coral gill alert!
    "status_paused": "#fbbf24",  # Antique monocle gold
    "accent_blue": "#38bdf8",    # Bioluminescent pool azure
    "accent_aqua": "#00f5d4",    # Electric bioluminescent cyan
    "accent_green": "#34d399",   # Subterranean emerald moss
    "accent_yellow": "#fbbf24",  # Monocle gold / cane knob
    "accent_orange": "#f59e0b",  # Antique brass
    "accent_purple": "#c084fc",  # Cave spore violet
    "accent_red": "#fb7185",     # Feathery external gill coral
    "font": "JetBrainsMono Nerd Font",
}

MOTHGOMERY_THEME = {
    "bg": "#0d1c21",             # Deep lamplit cavern trench
    "bg_surface": "#142a30",     # Workshop grotto surface
    "bg_card": "#254148",        # Elevated wet stone container card
    "bg_hover": "#35575b",       # Aquatic cavern hover state
    "bg_active": "#e8bb76",      # High-voltage bioluminescent cyan selection
    "bg_selected": "#354d48",    # Deep pool selected card surface
    "border": "#395257",         # Wet basalt architectural border
    "border_focus": "#e8bb76",   # Electric bioluminescent cyan border
    "border_today": "#f3d395",   # Baron's gold monocle accent
    "fg": "#efdfbf",             # Crisp cave mist readable text
    "fg_dim": "#9b9e8c",         # Muted cave shadow text
    "fg_header": "#e8bb76",      # Bioluminescent cyan header
    "key_bg": "#e8bb76",         # Bioluminescent badge background
    "key_fg": "#0d1c21",         # High-contrast trench dark badge text
    "status_running": "#a9c593", # Bioluminescent moss emerald
    "status_stopped": "#df9774", # Baron's feathery coral mothgomery alert!
    "status_paused": "#f3d395",  # Antique monocle gold
    "accent_blue": "#75c9c7",    # Bioluminescent pool azure
    "accent_aqua": "#e8bb76",    # Electric bioluminescent cyan
    "accent_green": "#a9c593",   # Workshop emerald moss
    "accent_yellow": "#f3d395",  # Monocle gold / cane knob
    "accent_orange": "#c99b5c",  # Antique brass
    "accent_purple": "#b49aaf",  # Cave spore violet
    "accent_red": "#df9774",     # Feathery external mothgomery coral
    "font": "JetBrainsMono Nerd Font",
}

RABLE_THEME = {
    "bg": "#0a0812",             # Midnight wet alleyway background
    "bg_surface": "#12101b",     # Leather jacket shadow surface
    "bg_card": "#1a1628",        # Urban alley panel card
    "bg_hover": "#281e3a",       # Dark violet hover state
    "bg_active": "#ff2a85",      # Searing hot neon magenta active selection
    "bg_selected": "#2a1638",    # Selected card surface
    "border": "#241c38",         # Urban brick shadow border
    "border_focus": "#ff2a85",   # Hot neon magenta active border
    "border_today": "#00f0ff",   # Electric neon cyan accent
    "fg": "#cbd5e1",             # Distressed poster readable text
    "fg_dim": "#5a5261",         # Muted shadow slate text
    "fg_header": "#ff2a85",      # Hot neon magenta header
    "key_bg": "#ff2a85",         # Neon magenta badge background
    "key_fg": "#ffffff",         # Crisp white badge text
    "status_running": "#39ff14", # Toxic neon tag lime
    "status_stopped": "#ff0055", # Hot alert magenta
    "status_paused": "#ffb000",  # Streetlamp amber
    "accent_blue": "#00f0ff",    # Electric neon cyan
    "accent_aqua": "#00f0ff",    # Electric neon cyan
    "accent_green": "#39ff14",   # Toxic tag lime
    "accent_yellow": "#ffb000",  # Streetlamp amber
    "accent_orange": "#f59e0b",  # Punk amber
    "accent_purple": "#c026d3",  # Deep punk violet
    "accent_red": "#ff2a85",     # Hot neon magenta
    "font": "JetBrainsMono Nerd Font",
}

TOV_THEME = {
    "bg": "#0f0d0e",             # Abyssal Asphalt
    "bg_surface": "#1e1a1c",     # Smoky Grime
    "bg_card": "#2d272a",        # Urban Slate
    "bg_hover": "#3a3236",       # Molotov ember hover
    "bg_active": "#f77f00",      # Molotov Amber active selection
    "bg_selected": "#2d272a",    # Urban Slate selected
    "border": "#2d272a",         # Urban Slate divider border
    "border_focus": "#f77f00",   # Molotov Amber active border
    "border_today": "#fcbf49",   # Blaze Orange accent
    "fg": "#f1faee",             # Ash White readable text
    "fg_dim": "#a8dadc",         # Concrete Gray muted text
    "fg_header": "#f77f00",      # Molotov Amber header
    "key_bg": "#f77f00",         # Molotov Amber badge background
    "key_fg": "#0f0d0e",         # Abyssal Asphalt badge text
    "status_running": "#70e000", # Acid Neon Green active state
    "status_stopped": "#e63946", # Anarchist Red alert
    "status_paused": "#fcbf49",  # Blaze Orange warning
    "accent_blue": "#457b9d",    # Faded Denim
    "accent_aqua": "#a8dadc",    # Concrete Gray
    "accent_green": "#70e000",   # Acid Neon Green
    "accent_yellow": "#eae2b7",  # Incandescent Yellow
    "accent_orange": "#f77f00",  # Molotov Amber
    "accent_purple": "#e63946",  # Anarchist Red
    "accent_red": "#e63946",     # Anarchist Red
    "font": "JetBrainsMono Nerd Font",
}

DINO_THEME = {
    "bg": "#0c0c0e",             # Night Wet Asphalt
    "bg_surface": "#16161a",     # Smoked Studded Leather
    "bg_card": "#222228",        # Wet Alley Basalt
    "bg_hover": "#2e2d36",       # Mortar hover
    "bg_active": "#76ff03",      # Radioactive Toxic Lime
    "bg_selected": "#222228",    # Basalt card selected
    "border": "#2e2d36",         # Mortar Slate divider
    "border_focus": "#76ff03",   # Radioactive Toxic Lime
    "border_today": "#ff6d00",   # Spraypaint Neon Orange
    "fg": "#f4f4f5",             # Clean Specular Silver
    "fg_dim": "#a1a1aa",         # Rain Mist Slate
    "fg_header": "#76ff03",      # Radioactive Toxic Lime header
    "key_bg": "#76ff03",         # Toxic lime key badge
    "key_fg": "#0c0c0e",         # Asphalt dark badge text
    "status_running": "#76ff03", # Radioactive green active
    "status_stopped": "#ff1744", # Police siren red alert
    "status_paused": "#ff6d00",  # Spraypaint orange warning
    "accent_blue": "#00b0ff",    # Police Siren Blue
    "accent_aqua": "#1de9b6",    # Teal Mist
    "accent_green": "#76ff03",   # Radioactive Lime
    "accent_yellow": "#ffab00",  # Warm Sparks
    "accent_orange": "#ff6d00",  # Spraypaint Orange
    "accent_purple": "#d500f9",  # Riot Violet
    "accent_red": "#ff1744",     # Police Siren Red
    "font": "JetBrainsMono Nerd Font",
}

CRUST_THEME = {
    "bg": "#0f0e0f",             # Abyssal Puddle Asphalt
    "bg_surface": "#1a1716",     # Smoked Rust Brick
    "bg_card": "#27221f",        # Alley Basalt
    "bg_hover": "#3a322c",       # Rusted steel hover
    "bg_active": "#f4d06f",      # Weathered Stencil Bone
    "bg_selected": "#27221f",    # Alley Basalt selected
    "border": "#3a322c",         # Rusted Steel divider
    "border_focus": "#f4d06f",   # Weathered Stencil Bone
    "border_today": "#d97706",   # Dumpster Rust Amber
    "fg": "#f5f5f4",             # Parchment White
    "fg_dim": "#a8a29e",         # Alley Dust
    "fg_header": "#f4d06f",      # Weathered Stencil Bone header
    "key_bg": "#f4d06f",         # Weathered bone key badge
    "key_fg": "#0f0e0f",         # Asphalt dark badge text
    "status_running": "#65a30d", # Dumpster Moss Green
    "status_stopped": "#991b1b", # Dirty Brick Crimson
    "status_paused": "#d97706",  # Dumpster Rust Amber
    "accent_blue": "#38bdf8",    # Puddle Reflection Cyan
    "accent_aqua": "#a8a29e",    # Alley Dust
    "accent_green": "#65a30d",   # Dumpster Moss Green
    "accent_yellow": "#f4d06f",  # Weathered Stencil Bone
    "accent_orange": "#d97706",  # Dumpster Rust Amber
    "accent_purple": "#c084fc",  # Distant Alley Neon
    "accent_red": "#991b1b",     # Dirty Brick Crimson
    "font": "JetBrainsMono Nerd Font",
}

TUNES_THEME = {
    "bg": "#faf5eb",             # Warm vintage cartoon parchment cel
    "bg_surface": "#ffffff",     # Clean elevated surface
    "bg_card": "#f5edd8",        # Warm cartoon cel card
    "bg_hover": "#fed7aa",       # Warm peach hover state
    "bg_active": "#d91424",      # Acme Dynamite Red active selection
    "bg_selected": "#fed7aa",    # Warm cartoon peach selected
    "border": "#dcd3c5",         # Parchment border
    "border_focus": "#d91424",   # Acme Dynamite Red focus border
    "border_today": "#ff6b00",   # Carrot orange
    "fg": "#1c1612",             # Deep cartoon ink
    "fg_dim": "#786c62",         # Muted graphite ink
    "fg_header": "#d91424",      # Acme red header
    "key_bg": "#d91424",         # Acme red key badge
    "key_fg": "#ffffff",         # Crisp white text
    "status_running": "#0c7a36", # Toon clover green
    "status_stopped": "#d91424", # Dynamite red alert
    "status_paused": "#b85d00",  # Daffy amber gold
    "accent_blue": "#005bbb",    # Warner azure blue
    "accent_aqua": "#007788",    # Cartoon whistle teal
    "accent_green": "#0c7a36",   # Marvin green
    "accent_yellow": "#b85d00",  # Tweety marigold gold
    "accent_orange": "#ff6b00",  # Carrot orange
    "accent_purple": "#86198f",  # Cartoon mallet purple
    "accent_red": "#d91424",     # Acme dynamite red
    "font": "ComicShannsMono Nerd Font",
}

MYSTERY_THEME = {
    "bg": "#10151d",             # Deep spooky midnight teal-black
    "bg_surface": "#17232e",     # Smoked midnight container
    "bg_card": "#1d2c3a",        # Mystery Machine body panel
    "bg_hover": "#26394c",       # Hover state
    "bg_active": "#1cd1be",      # Mystery Machine turquoise selection
    "bg_selected": "#1d2c3a",    # Selected card surface
    "border": "#1d2c3a",         # Deep midnight border
    "border_focus": "#1cd1be",   # Mystery Machine turquoise focus border
    "border_today": "#88e22c",   # Groovy Lime Green
    "fg": "#d4e5ea",             # Pale spectral cream-cyan
    "fg_dim": "#6b8594",         # Muted midnight slate
    "fg_header": "#ffffff",      # Crisp white header
    "key_bg": "#1cd1be",         # Turquoise key badge
    "key_fg": "#10151d",         # Dark badge text
    "status_running": "#88e22c", # Groovy lime green
    "status_stopped": "#ff3864", # Alert red
    "status_paused": "#ffd000",  # Scooby snack gold
    "accent_blue": "#1cd1be",    # Mystery Machine turquoise
    "accent_aqua": "#38e1d0",    # Electric cyan
    "accent_green": "#88e22c",   # Groovy lime green
    "accent_yellow": "#ffd000",  # Scooby snack gold
    "accent_orange": "#ff7700",  # Flower power tangerine
    "accent_purple": "#b062ff",  # Spooky night violet
    "accent_red": "#ff3864",     # Spooky alert red
    "font": "ComicShannsMono Nerd Font",
}

DARKWING_THEME = {
    "bg": "#120c1f",             # Deep midnight purple canvas
    "bg_surface": "#1c1330",     # Smoked cape violet container
    "bg_card": "#22183b",        # Elevated darkroom violet card
    "bg_hover": "#2f1e52",       # Hover state
    "bg_active": "#00e5ff",      # Electric Cyan selection
    "bg_selected": "#22183b",    # Selected card surface
    "border": "#261a40",         # Deep midnight border
    "border_focus": "#00e5ff",   # Electric Cyan focus border
    "border_today": "#ffd700",   # Cape Button Gold
    "fg": "#e2daf0",             # Pale spectral lavender-white
    "fg_dim": "#7c6a99",         # Muted shadow violet
    "fg_header": "#ffffff",      # Crisp white header
    "key_bg": "#00e5ff",         # Cyan key badge
    "key_fg": "#120c1f",         # Dark badge text
    "status_running": "#1de9b6", # Gas mist teal
    "status_stopped": "#ff2a6d", # Alert red
    "status_paused": "#ffd700",  # Cape button gold
    "accent_blue": "#00e5ff",    # Electric cyan
    "accent_aqua": "#1de9b6",    # Teal gas mist
    "accent_green": "#1de9b6",   # Gas mist teal
    "accent_yellow": "#ffd700",  # Cape button gold
    "accent_orange": "#ff6b00",  # Comic action orange
    "accent_purple": "#9d4edd",  # Fedora / cape purple
    "accent_red": "#ff2a6d",     # Alert red
    "font": "ComicShannsMono Nerd Font",
}

TMNT_THEME = {
    "bg": "#0e1510",             # Deep sewer slate / moss canvas
    "bg_surface": "#152218",     # Smoked sewer brick container
    "bg_card": "#1b2b1f",        # Elevated turtle shell card
    "bg_hover": "#253b2a",       # Hover state
    "bg_active": "#39ff14",      # Mutagen Ooze selection
    "bg_selected": "#1b2b1f",    # Selected card surface
    "border": "#1e3022",         # Deep sewer border
    "border_focus": "#39ff14",   # Toxic Mutagen Ooze focus border
    "border_today": "#ffd700",   # Pepperoni Pizza Gold
    "fg": "#d8ebd8",             # Pale cel mint text
    "fg_dim": "#5a7d5f",         # Muted sewer shadow green
    "fg_header": "#ffffff",      # Crisp white header
    "key_bg": "#39ff14",         # Mutagen green key badge
    "key_fg": "#0e1510",         # Dark badge text
    "status_running": "#39ff14", # Mutagen green active
    "status_stopped": "#ff2a4b", # Raphael Sais Red
    "status_paused": "#ffd700",  # Pizza gold
    "accent_blue": "#00aaff",    # Leonardo Katana Blue
    "accent_aqua": "#39ff14",    # Mutagen slime green
    "accent_green": "#4caf50",   # Turtle shell green
    "accent_yellow": "#ffd700",  # Pepperoni pizza gold
    "accent_orange": "#ff8800",  # Michelangelo Pizza Orange
    "accent_purple": "#9d4edd",  # Donatello Bo Staff Purple
    "accent_red": "#ff2a4b",     # Raphael Sais Red
    "font": "ComicShannsMono Nerd Font",
}

MUPPET_THEME = {
    "bg": "#1a1528",             # Deep twilight nursery violet
    "bg_surface": "#241c38",     # Smoked nursery container
    "bg_card": "#2d2345",        # Elevated dream playroom card
    "bg_hover": "#3a2d59",       # Hover state
    "bg_active": "#ff70a6",      # Baby Piggy Bubblegum Pink selection
    "bg_selected": "#2d2345",    # Selected card surface
    "border": "#2e2346",         # Deep twilight border
    "border_focus": "#ff70a6",   # Baby Piggy Pink focus border
    "border_today": "#ffd166",   # Baby Fozzie Warm Peach Gold
    "fg": "#f0e6f6",             # Pastel dream white
    "fg_dim": "#8b7a9e",         # Muted shadow lavender
    "fg_header": "#ffffff",      # Crisp white header
    "key_bg": "#ff70a6",         # Bubblegum pink key badge
    "key_fg": "#1a1528",         # Dark badge text
    "status_running": "#80ed99", # Baby Kermit Mint Green
    "status_stopped": "#ff4d6d", # Baby Animal Coral Pink
    "status_paused": "#ffd166",  # Baby Fozzie Peach Gold
    "accent_blue": "#70d6ff",    # Baby Gonzo Periwinkle Cyan
    "accent_aqua": "#80ed99",    # Kermit Mint Green
    "accent_green": "#80ed99",   # Kermit Mint Green
    "accent_yellow": "#ffd166",  # Fozzie Peach Gold
    "accent_orange": "#ffd166",  # Fozzie Peach
    "accent_purple": "#b388ff",  # Lilac Dream Purple
    "accent_red": "#ff4d6d",     # Animal Coral Pink
    "font": "ComicShannsMono Nerd Font",
}

JON_THEME = {
    "bg": "#0f0c0b",             # Abyssal kitchen noir
    "bg_surface": "#181211",     # Shadowed kitchen container
    "bg_card": "#211715",        # Elevated lasagna parchment card
    "bg_hover": "#2c1e1c",       # Hover state
    "bg_active": "#e0562e",      # Burnt Lasagna glowing orange selection
    "bg_selected": "#211715",    # Selected card surface
    "border": "#2c1e1c",         # Abyssal shadow border
    "border_focus": "#e0562e",   # Burnt lasagna orange focus border
    "border_today": "#e5a93c",   # Hanging lamp amber gold
    "fg": "#e8dcc4",             # Sepia kitchen parchment cream
    "fg_dim": "#8a7b6d",         # Kitchen shadow charcoal
    "fg_header": "#ffffff",      # Bleached bones white header
    "key_bg": "#e0562e",         # Burnt orange key badge
    "key_fg": "#0f0c0b",         # Dark badge text
    "status_running": "#5c7f87", # Jon's Slate Teal
    "status_stopped": "#d13824", # Monday Crimson Red
    "status_paused": "#e5a93c",  # Lamp Amber Gold
    "accent_blue": "#5c7f87",    # Jon's Slate Teal
    "accent_aqua": "#5c7f87",    # Jon Teal
    "accent_green": "#5c7f87",   # Slate Teal
    "accent_yellow": "#e5a93c",  # Lamp Amber Gold
    "accent_orange": "#e0562e",  # Burnt Lasagna Orange
    "accent_purple": "#8b4f58",  # Eldritch Flesh
    "accent_red": "#d13824",     # Monday Crimson
    "font": "ComicShannsMono Nerd Font",
}


SPEEDSTER_THEME = {
    "bg": "#140d0d",             # Clubhouse espresso noir
    "bg_surface": "#241513",     # Warm chestnut container
    "bg_card": "#2d1a17",        # Elevated clubhouse card
    "bg_hover": "#3a211a",       # Hover state
    "bg_active": "#cb6d25",      # Radiant Speedster glowing amber selection
    "bg_selected": "#2d1a17",    # Selected card surface
    "border": "#3a211a",         # Warm shadow border
    "border_focus": "#cb6d25",   # Radiant Speedster amber focus border
    "border_today": "#dd9868",   # Honey apricot
    "fg": "#f9cda7",             # Warm vanilla cream
    "fg_dim": "#8a6d5f",         # Dusty cocoa shadow
    "fg_header": "#ffffff",      # Bright white header
    "key_bg": "#cb6d25",         # Radiant amber key badge
    "key_fg": "#140d0d",         # Dark badge text
    "status_running": "#605526", # Retro olive moss
    "status_stopped": "#d93829", # Hearth fire red
    "status_paused": "#dd9868",  # Honey apricot
    "accent_blue": "#cb6d25",    # Speedster orange
    "accent_aqua": "#dd9868",    # Honey apricot
    "accent_green": "#605526",   # Retro olive moss
    "accent_yellow": "#dd9868",  # Honey apricot
    "accent_orange": "#cb6d25",  # Speedster amber orange
    "accent_purple": "#8330b7",  # Twilight skyline violet
    "accent_red": "#d93829",     # Hearth fire red
    "font": "ComicShannsMono Nerd Font",
}


CLAY_THEME = {
    "bg": "#585153",
    "bg_surface": "#a39990",
    "bg_card": "#665e59",
    "bg_hover": "#a39990",
    "bg_active": "#d1c4af",
    "bg_selected": "#a39990",
    "border": "#413a3b",
    "border_focus": "#d1c4af",
    "border_today": "#d49b52",
    "fg": "#d1c4af",
    "fg_dim": "#786f69",
    "fg_header": "#2b2526",
    "key_bg": "#d1c4af",
    "key_fg": "#2b2526",
    "status_running": "#889c6d",
    "status_stopped": "#c26d55",
    "status_paused": "#d49b52",
    "accent_blue": "#d1c4af",
    "accent_aqua": "#889c6d",
    "accent_green": "#889c6d",
    "accent_yellow": "#d49b52",
    "accent_orange": "#d49b52",
    "accent_purple": "#cfa15d",
    "accent_red": "#c26d55",
    "font": "IosevkaTermSlab Nerd Font",
}

VOID_THEME = {
    "bg": "#05060b",
    "bg_surface": "#0e1428",
    "bg_card": "#080c16",
    "bg_hover": "#121b36",
    "bg_active": "#00e5ff",
    "bg_selected": "#0e1428",
    "border": "#0c101c",
    "border_focus": "#00e5ff",
    "border_today": "#f59e0b",
    "fg": "#c8d6e5",
    "fg_dim": "#475569",
    "fg_header": "#ffffff",
    "key_bg": "#00e5ff",
    "key_fg": "#05060b",
    "status_running": "#06d6a0",
    "status_stopped": "#ff0055",
    "status_paused": "#f59e0b",
    "accent_blue": "#3b82f6",
    "accent_aqua": "#00e5ff",
    "accent_green": "#06d6a0",
    "accent_yellow": "#f59e0b",
    "accent_orange": "#ff007f",
    "accent_purple": "#a855f7",
    "accent_red": "#ff0055",
    "font": "JetBrainsMono Nerd Font",
}

BAKE_THEME = {
    "bg": "#111618",
    "bg_surface": "#16201e",
    "bg_card": "#141c1a",
    "bg_hover": "#48b852",
    "bg_active": "#48b852",
    "bg_selected": "#16201e",
    "border": "#1a2622",
    "border_focus": "#48b852",
    "border_today": "#f4a226",
    "fg": "#e5dfd5",
    "fg_dim": "#70857b",
    "fg_header": "#ffffff",
    "key_bg": "#48b852",
    "key_fg": "#0d1411",
    "status_running": "#48b852",
    "status_stopped": "#e63946",
    "status_paused": "#f4a226",
    "accent_blue": "#f4a226",
    "accent_aqua": "#4ee2ec",
    "accent_green": "#48b852",
    "accent_yellow": "#f4a226",
    "accent_orange": "#e63946",
    "accent_purple": "#48b852",
    "accent_red": "#e63946",
    "font": "ComicShannsMono Nerd Font",
}


FOUNDRY_THEME = {
    "bg": "#171b1b",
    "bg_surface": "#30362f",
    "bg_card": "#232927",
    "bg_hover": "#30362f",
    "bg_active": "#30362f",
    "bg_selected": "#30362f",
    "border": "#4a4437",
    "border_focus": "#d3b77c",
    "border_today": "#c38b59",
    "fg": "#dfd4b9",
    "fg_dim": "#8f9382",
    "fg_header": "#dfd4b9",
    "key_bg": "#30362f",
    "key_fg": "#d3b77c",
    "status_running": "#91ae83",
    "status_stopped": "#d57659",
    "status_paused": "#c38b59",
    "accent_blue": "#91b6a2",
    "accent_aqua": "#91ae83",
    "accent_green": "#91ae83",
    "accent_yellow": "#c38b59",
    "accent_orange": "#d3b77c",
    "accent_purple": "#b38d78",
    "accent_red": "#d57659",
    "font": "IosevkaTermSlab Nerd Font",
}


SKETCHBOOK_THEME = {
    "bg": "#faf4e7",             # Deep lamplit cavern trench
    "bg_surface": "#f6efdf",     # Workshop grotto surface
    "bg_card": "#e2e8dc",        # Elevated wet stone container card
    "bg_hover": "#35575b",       # Aquatic cavern hover state
    "bg_active": "#276c67",      # High-voltage bioluminescent cyan selection
    "bg_selected": "#d2e6de",    # Deep pool selected card surface
    "border": "#395257",         # Wet basalt architectural border
    "border_focus": "#276c67",   # Electric bioluminescent cyan border
    "border_today": "#86591f",   # Baron's gold monocle accent
    "fg": "#343b39",             # Crisp cave mist readable text
    "fg_dim": "#686b60",         # Muted cave shadow text
    "fg_header": "#276c67",      # Bioluminescent cyan header
    "key_bg": "#276c67",         # Bioluminescent badge background
    "key_fg": "#faf4e7",         # High-contrast trench dark badge text
    "status_running": "#486d45", # Bioluminescent moss emerald
    "status_stopped": "#945b29", # Baron's feathery coral sketchbook alert!
    "status_paused": "#86591f",  # Antique monocle gold
    "accent_blue": "#2b666f",    # Bioluminescent pool azure
    "accent_aqua": "#276c67",    # Electric bioluminescent cyan
    "accent_green": "#486d45",   # Workshop emerald moss
    "accent_yellow": "#86591f",  # Monocle gold / cane knob
    "accent_orange": "#86591f",  # Antique brass
    "accent_purple": "#79506f",  # Cave spore violet
    "accent_red": "#945b29",     # Feathery external sketchbook coral
    "font": "JetBrainsMono Nerd Font",
}

JAWS_THEME = {
    "bg": "#0b151b",
    "bg_surface": "#14252d",
    "bg_card": "#2a4149",
    "bg_hover": "#36505a",
    "bg_active": "#e8bd4e",
    "bg_selected": "#354a50",
    "border": "#49616a",
    "border_focus": "#e8bd4e",
    "border_today": "#f5d675",
    "fg": "#ecdfbf",
    "fg_dim": "#a4aaa3",
    "fg_header": "#e8bd4e",
    "key_bg": "#e8bd4e",
    "key_fg": "#0b151b",
    "status_running": "#aab987",
    "status_stopped": "#ef7160",
    "status_paused": "#f5d675",
    "accent_blue": "#7db4ba",
    "accent_aqua": "#e8bd4e",
    "accent_green": "#aab987",
    "accent_yellow": "#f5d675",
    "accent_orange": "#d89850",
    "accent_purple": "#ae929e",
    "accent_red": "#ef7160",
    "font": "JetBrainsMono Nerd Font",
}

BAMBOO_CORSAIR_THEME = {
    "bg": "#100c20",
    "bg_surface": "#211531",
    "bg_card": "#39264e",
    "bg_hover": "#4b3562",
    "bg_active": "#91e66d",
    "bg_selected": "#44335a",
    "border": "#59436d",
    "border_focus": "#91e66d",
    "border_today": "#cbe889",
    "fg": "#d9efcf",
    "fg_dim": "#9a9cac",
    "fg_header": "#91e66d",
    "key_bg": "#91e66d",
    "key_fg": "#100c20",
    "status_running": "#73c983",
    "status_stopped": "#ef8198",
    "status_paused": "#cbe889",
    "accent_blue": "#76cda8",
    "accent_aqua": "#91e66d",
    "accent_green": "#73c983",
    "accent_yellow": "#cbe889",
    "accent_orange": "#c9b56e",
    "accent_purple": "#a57ace",
    "accent_red": "#ef8198",
    "font": "JetBrainsMono Nerd Font",
}

EEYORE_THEME = {
    "bg": "#f3f6f3",
    "bg_surface": "#e7efee",
    "bg_card": "#dce7e5",
    "bg_hover": "#cadde4",
    "bg_active": "#326d8b",
    "bg_selected": "#d0e3ea",
    "border": "#a6babf",
    "border_focus": "#326d8b",
    "border_today": "#866a2e",
    "fg": "#34444e",
    "fg_dim": "#697d85",
    "fg_header": "#326d8b",
    "key_bg": "#326d8b",
    "key_fg": "#f3f6f3",
    "status_running": "#59784b",
    "status_stopped": "#a34f69",
    "status_paused": "#866a2e",
    "accent_blue": "#477666",
    "accent_aqua": "#326d8b",
    "accent_green": "#59784b",
    "accent_yellow": "#866a2e",
    "accent_orange": "#947139",
    "accent_purple": "#775c83",
    "accent_red": "#a34f69",
    "font": "JetBrainsMono Nerd Font",
}

HALFPIPE_THEME = {
    "bg": "#171e1c",
    "bg_surface": "#27322e",
    "bg_card": "#37473d",
    "bg_hover": "#4c6052",
    "bg_active": "#9cdb45",
    "bg_selected": "#415545",
    "border": "#617568",
    "border_focus": "#9cdb45",
    "border_today": "#e6c56a",
    "fg": "#e5e6d6",
    "fg_dim": "#9eada1",
    "fg_header": "#9cdb45",
    "key_bg": "#9cdb45",
    "key_fg": "#171e1c",
    "status_running": "#9fbd88",
    "status_stopped": "#df6094",
    "status_paused": "#e6c56a",
    "accent_blue": "#7fc1b0",
    "accent_aqua": "#9cdb45",
    "accent_green": "#9fbd88",
    "accent_yellow": "#e6c56a",
    "accent_orange": "#d7b958",
    "accent_purple": "#b6a0c2",
    "accent_red": "#df6094",
    "font": "JetBrainsMono Nerd Font",
}


PUNK_SHOW_THEME = {
    "bg": "#161815",
    "bg_surface": "#272a24",
    "bg_card": "#363b30",
    "bg_hover": "#505444",
    "bg_active": "#ef4148",
    "bg_selected": "#424936",
    "border": "#686d59",
    "border_focus": "#ef4148",
    "border_today": "#d1ac63",
    "fg": "#ddd7c0",
    "fg_dim": "#9c9e8b",
    "fg_header": "#ef4148",
    "key_bg": "#ef4148",
    "key_fg": "#161815",
    "status_running": "#91ad6e",
    "status_stopped": "#f46b66",
    "status_paused": "#d1ac63",
    "accent_blue": "#91ad6e",
    "accent_aqua": "#ef4148",
    "accent_green": "#91ad6e",
    "accent_yellow": "#d1ac63",
    "accent_orange": "#d1ac63",
    "accent_purple": "#b09a9b",
    "accent_red": "#f46b66",
    "font": "JetBrainsMono Nerd Font",
}

SATANIC_PANIC_THEME = {
    "bg": "#171311",
    "bg_surface": "#29211e",
    "bg_card": "#363b30",
    "bg_hover": "#505444",
    "bg_active": "#b63d30",
    "bg_selected": "#49332a",
    "border": "#686d59",
    "border_focus": "#b63d30",
    "border_today": "#c38d52",
    "fg": "#dbc3a0",
    "fg_dim": "#a68b73",
    "fg_header": "#b63d30",
    "key_bg": "#b63d30",
    "key_fg": "#171311",
    "status_running": "#b29a70",
    "status_stopped": "#d65a3d",
    "status_paused": "#c38d52",
    "accent_blue": "#b29a70",
    "accent_aqua": "#b63d30",
    "accent_green": "#b29a70",
    "accent_yellow": "#c38d52",
    "accent_orange": "#c38d52",
    "accent_purple": "#b09a9b",
    "accent_red": "#d65a3d",
    "font": "JetBrainsMono Nerd Font",
}

VAPORWAVE_SCHIZOID_THEME = {
    "bg": "#110c27",
    "bg_surface": "#21163f",
    "bg_card": "#2c2050",
    "bg_hover": "#493166",
    "bg_active": "#ff55c8",
    "bg_selected": "#4a276a",
    "border": "#68518e",
    "border_focus": "#ff55c8",
    "border_today": "#ffba8c",
    "fg": "#f0ddff",
    "fg_dim": "#a99bcc",
    "fg_header": "#ff55c8",
    "key_bg": "#ff55c8",
    "key_fg": "#110c27",
    "status_running": "#61e5f5",
    "status_stopped": "#ff719f",
    "status_paused": "#ffba8c",
    "accent_blue": "#61e5f5",
    "accent_aqua": "#ff55c8",
    "accent_green": "#61e5f5",
    "accent_yellow": "#ffba8c",
    "accent_orange": "#ffba8c",
    "accent_purple": "#bc87ff",
    "accent_red": "#ff719f",
    "font": "JetBrainsMono Nerd Font",
}

MOONLIT_WELL_THEME = {
    "bg": "#080f13",
    "bg_surface": "#142229",
    "bg_card": "#22343b",
    "bg_hover": "#354c54",
    "bg_active": "#79c9c3",
    "bg_selected": "#28454c",
    "border": "#4c6871",
    "border_focus": "#79c9c3",
    "border_today": "#c4b788",
    "fg": "#d9e7ec",
    "fg_dim": "#92a6ae",
    "fg_header": "#79c9c3",
    "key_bg": "#79c9c3",
    "key_fg": "#080f13",
    "status_running": "#9bb9cb",
    "status_stopped": "#cd8792",
    "status_paused": "#c4b788",
    "accent_blue": "#9bb9cb",
    "accent_aqua": "#79c9c3",
    "accent_green": "#9bb9cb",
    "accent_yellow": "#c4b788",
    "accent_orange": "#c4b788",
    "accent_purple": "#aa95b1",
    "accent_red": "#cd8792",
    "font": "JetBrainsMono Nerd Font",
}

SCP_FACILITY_THEME = {
    "bg": "#0b0f12",
    "bg_surface": "#1a2228",
    "bg_card": "#26333b",
    "bg_hover": "#3b4b55",
    "bg_active": "#d6584d",
    "bg_selected": "#34454f",
    "border": "#526570",
    "border_focus": "#d6584d",
    "border_today": "#d5af58",
    "fg": "#d8e1e5",
    "fg_dim": "#93a3ad",
    "fg_header": "#d6584d",
    "key_bg": "#d6584d",
    "key_fg": "#0b0f12",
    "status_running": "#8dbdc9",
    "status_stopped": "#ff7564",
    "status_paused": "#d5af58",
    "accent_blue": "#8dbdc9",
    "accent_aqua": "#d6584d",
    "accent_green": "#8dbdc9",
    "accent_yellow": "#d5af58",
    "accent_orange": "#d5af58",
    "accent_purple": "#a5a1b8",
    "accent_red": "#ff7564",
    "font": "JetBrainsMono Nerd Font",
}


SUGAR_RUSH_THEME = {
    "bg": "#fff1fb",
    "bg_surface": "#f4e3fa",
    "bg_card": "#e3dcef",
    "bg_hover": "#dcc9e8",
    "bg_active": "#a33c83",
    "bg_selected": "#e4d5ef",
    "border": "#ae8dbd",
    "border_focus": "#a33c83",
    "border_today": "#916b26",
    "fg": "#603575",
    "fg_dim": "#8b7197",
    "fg_header": "#a33c83",
    "key_bg": "#a33c83",
    "key_fg": "#fff1fb",
    "status_running": "#45836b",
    "status_stopped": "#b74c85",
    "status_paused": "#916b26",
    "accent_blue": "#45836b",
    "accent_aqua": "#a33c83",
    "accent_green": "#45836b",
    "accent_yellow": "#916b26",
    "accent_orange": "#916b26",
    "accent_purple": "#9160a6",
    "accent_red": "#b74c85",
    "font": "JetBrainsMono Nerd Font",
}

CRAYON_CHOMP_THEME = {
    "bg": "#fffbed",
    "bg_surface": "#f5efd9",
    "bg_card": "#d8e8ce",
    "bg_hover": "#c4dbc1",
    "bg_active": "#246d9b",
    "bg_selected": "#d4e6ef",
    "border": "#ae8dbd",
    "border_focus": "#246d9b",
    "border_today": "#a16c18",
    "fg": "#39382f",
    "fg_dim": "#8a806a",
    "fg_header": "#246d9b",
    "key_bg": "#246d9b",
    "key_fg": "#fffbed",
    "status_running": "#43812e",
    "status_stopped": "#b84435",
    "status_paused": "#a16c18",
    "accent_blue": "#43812e",
    "accent_aqua": "#246d9b",
    "accent_green": "#43812e",
    "accent_yellow": "#a16c18",
    "accent_orange": "#a16c18",
    "accent_purple": "#9160a6",
    "accent_red": "#b84435",
    "font": "JetBrainsMono Nerd Font",
}


def get_theme():
    """Return the active palette based on ~/.config/awesome/theme_mode."""
    mode_file = os.path.expanduser("~/.config/awesome/theme_mode")
    try:
        with open(mode_file, "r", encoding="utf-8") as f:
            mode = f.read().strip()
            if mode == "scp-facility":
                return SCP_FACILITY_THEME
            if mode == "moonlit-well":
                return MOONLIT_WELL_THEME
            if mode == "vaporwave-schizoid":
                return VAPORWAVE_SCHIZOID_THEME
            if mode == "satanic-panic":
                return SATANIC_PANIC_THEME
            if mode in ("speedster", "speedster-crew", "crew", "hangout"):
                return SPEEDSTER_THEME
            if mode == "crayon-chomp":
                return CRAYON_CHOMP_THEME
            if mode == "sugar-rush":
                return SUGAR_RUSH_THEME
            if mode == "punk-show":
                return PUNK_SHOW_THEME
            if mode == "halfpipe":
                return HALFPIPE_THEME
            if mode == "eeyore":
                return EEYORE_THEME
            if mode == "bamboo-corsair":
                return BAMBOO_CORSAIR_THEME
            if mode == "jaws":
                return JAWS_THEME
            if mode == "sketchbook":
                return SKETCHBOOK_THEME
            if mode == "foundry":
                return FOUNDRY_THEME
            if mode == "clay":
                return CLAY_THEME
            if mode == "void":
                return VOID_THEME
            if mode == "bake":
                return BAKE_THEME
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
            if mode in ("chomp", "larry"):
                return CHOMP_THEME
            if mode in ("red", "doom"):
                return RED_THEME
            if mode in ("windbreaker", "90s", "neon90s", "fresh", "rad"):
                return WINDBREAKER_THEME
            if mode in ("gill", "baron", "von_gill", "baronvongill", "axolotl", "grotto"):
                return GILL_THEME
            if mode in ("mothgomery", "moth", "workshop", "lamplight"):
                return MOTHGOMERY_THEME
            if mode in ("rable", "missrable", "miss_rable", "punk", "riot"):
                return RABLE_THEME
            if mode in ("tov", "molly", "mollytov", "molly_tov", "anarchy", "molotov", "fire"):
                return TOV_THEME
            if mode in ("dino", "might", "dinomight", "dino_might", "riot_dino", "heavy"):
                return DINO_THEME
            if mode in ("crust", "crustpunk", "crusty", "dumpster", "alley", "drifter"):
                return CRUST_THEME
            if mode in ("tunes", "looney", "cartoon", "acme", "bugs", "thatsallfolks"):
                return TUNES_THEME
            if mode in ("mystery", "scooby", "mysterymachine", "van", "shaggy", "doo", "spooky"):
                return MYSTERY_THEME
            if mode in ("darkwing", "duck", "drake", "dangerous", "terror", "dw"):
                return DARKWING_THEME
            if mode in ("tmnt", "turtles", "turtle", "cowabunga", "ooze", "mutant", "pizza"):
                return TMNT_THEME
            if mode in ("muppet", "babies", "muppetbabies", "muppets", "kermit", "nursery", "dreams"):
                return MUPPET_THEME
            if mode in ("jon", "garfield", "imsorryjon", "im_sorry_jon", "gorefield", "lasagna", "mondays", "horror", "eldritch"):
                return JON_THEME
    except OSError:
        pass
    return SLIME_THEME


