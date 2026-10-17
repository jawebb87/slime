local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Start from default theme
local theme = dofile(themes_path .. "default/theme.lua")

-- Read current theme mode ("origin", "lab", "slime", "cyber", or "space")
local mode_file = os.getenv("HOME") .. "/.config/awesome/theme_mode"
local mode = "slime"
do
    local f = io.open(mode_file, "r")
    if f then
        local content = f:read("*all")
        f:close()
        if content then
            content = content:gsub("%s+", "")
            if content == "origin" or content == "lab" or content == "slime" or content == "cyber" or content == "space" or content == "shred" or content == "larry" or content == "chomp" then
                mode = content
            end
        end
    end
end

theme.mode = mode

-- Per-Theme Typography
local origin_font_family = "MonaspiceRn Nerd Font"
local origin_font_size   = "9"
local slime_font_family  = "OpenDyslexic Nerd Font"
local slime_font_size    = "10"
local lab_font_family    = "ShureTechMono Nerd Font"
local lab_font_size      = "10"
local cyber_font_family  = "ZedMono Nerd Font"
local cyber_font_size    = "10"
local space_font_family  = "SpaceMono Nerd Font"
local space_font_size    = "9"
local shred_font_family  = "JetBrainsMono Nerd Font"
local shred_font_size    = "10"
local chomp_font_family  = "IosevkaTerm Nerd Font"
local chomp_font_size    = "10"

local active_font_family = slime_font_family
local active_font_size   = slime_font_size
if mode == "origin" then
    active_font_family = origin_font_family
    active_font_size   = origin_font_size
elseif mode == "lab" then
    active_font_family = lab_font_family
    active_font_size   = lab_font_size
elseif mode == "cyber" then
    active_font_family = cyber_font_family
    active_font_size   = cyber_font_size
elseif mode == "space" then
    active_font_family = space_font_family
    active_font_size   = space_font_size
elseif mode == "shred" then
    active_font_family = shred_font_family
    active_font_size   = shred_font_size
elseif mode == "chomp" or mode == "larry" then
    active_font_family = chomp_font_family
    active_font_size   = chomp_font_size
end
theme.font                     = active_font_family .. " " .. active_font_size
theme.hotkeys_font             = active_font_family .. " Bold " .. active_font_size
theme.hotkeys_description_font = active_font_family .. " " .. active_font_size

-- Window Gaps
theme.useless_gap = dpi(6)

if mode == "origin" then
    -- ==========================================================
    -- Act 0: The Specimen Origin / Deep Wood (Forest & Mycelium)
    -- ==========================================================
    theme.border_width  = dpi(2)
    theme.border_normal = "#241e17aa"
    theme.border_focus  = "#9ece6a88"
    theme.border_marked = "#d08770aa"

    -- Core Color Palette (Deep Forest Soil #141712 & Bark Timber #241e17)
    theme.bg_normal   = "#141712f5"
    theme.bg_focus    = "#241e17"
    theme.bg_urgent   = "#d08770"
    theme.bg_minimize = "#1c1914"
    theme.bg_systray  = "#141712"

    theme.fg_normal   = "#d8dee9"
    theme.fg_focus    = "#9ece6a"
    theme.fg_urgent   = "#141712"
    theme.fg_minimize = "#5a784d"

    -- Taglist Theming
    theme.taglist_bg_focus    = "#241e17"
    theme.taglist_fg_focus    = "#9ece6a"
    theme.taglist_bg_urgent   = "#d08770"
    theme.taglist_fg_urgent   = "#141712"
    theme.taglist_bg_occupied = "#1c1914"
    theme.taglist_fg_occupied = "#d8dee9"
    theme.taglist_bg_empty    = "#141712"
    theme.taglist_fg_empty    = "#5a784d"

    -- Tasklist Theming
    theme.tasklist_bg_normal   = "#1c1914"
    theme.tasklist_fg_normal   = "#d8dee9"
    theme.tasklist_bg_focus    = "#241e17"
    theme.tasklist_fg_focus    = "#9ece6a"
    theme.tasklist_bg_urgent   = "#d08770"
    theme.tasklist_fg_urgent   = "#141712"
    theme.tasklist_bg_minimize = "#141712"
    theme.tasklist_fg_minimize = "#5a784d"

    -- Context Menu Theming
    theme.menu_bg_normal    = "#141712f8"
    theme.menu_bg_focus     = "#241e17"
    theme.menu_fg_normal    = "#d8dee9"
    theme.menu_fg_focus     = "#9ece6a"
    theme.menu_border_color = "#5a784d"
    theme.menu_border_width = dpi(2)
    theme.menu_height       = dpi(26)
    theme.menu_width        = dpi(140)

    -- Hotkeys Popup / Help Modal
    theme.hotkeys_bg              = "#141712f8"
    theme.hotkeys_fg              = "#d8dee9"
    theme.hotkeys_border_color    = "#9ece6a"
    theme.hotkeys_border_width    = dpi(2)
    theme.hotkeys_modifiers_fg    = "#d08770"
    theme.hotkeys_label_bg        = "#241e17"
    theme.hotkeys_label_fg        = "#9ece6a"
    theme.hotkeys_group_margin    = dpi(16)

    -- Titlebars
    theme.titlebar_bg_normal = "#141712"
    theme.titlebar_bg_focus  = "#241e17"
    theme.titlebar_fg_normal = "#5a784d"
    theme.titlebar_fg_focus  = "#9ece6a"

    -- Wibar Height
    theme.wibar_height = dpi(28)

    -- Wallpaper
    theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/origin.jpg"
elseif mode == "lab" then
    -- ==========================================
    -- Laboratory White Theme (Pre-Contamination)
    -- ==========================================
    theme.border_width  = dpi(3)
    theme.border_normal = "#475569"
    theme.border_focus  = "#000000"
    theme.border_marked = "#dc2626"

    -- Core Color Palette (Sterile white & stark jet-black)
    theme.bg_normal   = "#f4f6f8f5"
    theme.bg_focus    = "#0a0c0e"
    theme.bg_urgent   = "#dc2626"
    theme.bg_minimize = "#e2e8f0"
    theme.bg_systray  = "#f4f6f8"

    theme.fg_normal   = "#0a0c0e"
    theme.fg_focus    = "#ffffff"
    theme.fg_urgent   = "#ffffff"
    theme.fg_minimize = "#64748b"

    -- Taglist Theming
    theme.taglist_bg_focus    = "#0a0c0e"
    theme.taglist_fg_focus    = "#ffffff"
    theme.taglist_bg_urgent   = "#dc2626"
    theme.taglist_fg_urgent   = "#ffffff"
    theme.taglist_bg_occupied = "#dde4ec"
    theme.taglist_fg_occupied = "#0a0c0e"
    theme.taglist_bg_empty    = "#ffffff"
    theme.taglist_fg_empty    = "#94a3b8"

    -- Tasklist Theming
    theme.tasklist_bg_normal   = "#ffffff"
    theme.tasklist_fg_normal   = "#334155"
    theme.tasklist_bg_focus    = "#0a0c0e"
    theme.tasklist_fg_focus    = "#ffffff"
    theme.tasklist_bg_urgent   = "#dc2626"
    theme.tasklist_fg_urgent   = "#ffffff"
    theme.tasklist_bg_minimize = "#e2e8f0"
    theme.tasklist_fg_minimize = "#64748b"

    -- Context Menu Theming
    theme.menu_bg_normal    = "#ffffff"
    theme.menu_bg_focus     = "#0a0c0e"
    theme.menu_fg_normal    = "#0a0c0e"
    theme.menu_fg_focus     = "#ffffff"
    theme.menu_border_color = "#000000"
    theme.menu_border_width = dpi(2)
    theme.menu_height       = dpi(26)
    theme.menu_width        = dpi(140)

    -- Hotkeys Popup / Help Modal
    theme.hotkeys_bg              = "#ffffff"
    theme.hotkeys_fg              = "#0a0c0e"
    theme.hotkeys_border_color    = "#000000"
    theme.hotkeys_border_width    = dpi(3)
    theme.hotkeys_modifiers_fg    = "#0284c7"
    theme.hotkeys_label_bg        = "#0a0c0e"
    theme.hotkeys_label_fg        = "#ffffff"
    theme.hotkeys_group_margin    = dpi(16)

    -- Titlebars
    theme.titlebar_bg_normal = "#e2e8f0"
    theme.titlebar_bg_focus  = "#ffffff"
    theme.titlebar_fg_normal = "#475569"
    theme.titlebar_fg_focus  = "#0a0c0e"

    -- Wibar Height
    theme.wibar_height = dpi(34)

    -- Wallpaper
    theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/lab.jpg"
elseif mode == "cyber" then
    -- =====================================================
    -- Cyberpunk Future Theme (Bio-Grid Cyberdeck / Act III)
    -- =====================================================
    -- Outer border drawn by 4-sided perimeter titlebars with circling green bio-pulse
    theme.border_width  = dpi(0)
    theme.border_normal = "#7928ca"
    theme.border_focus  = "#a855f7"
    theme.border_marked = "#ff007f"

    -- Core Color Palette (Obsidian #090812, Raised Panel #161326, Deep Indigo #120f24)
    theme.bg_normal   = "#090812f5"
    theme.bg_focus    = "#161326"
    theme.bg_urgent   = "#ff007f"
    theme.bg_minimize = "#120f24"
    theme.bg_systray  = "#090812"

    theme.fg_normal   = "#e0d8f6"
    theme.fg_focus    = "#00f0ff"
    theme.fg_urgent   = "#ffffff"
    theme.fg_minimize = "#7928ca"

    -- Taglist Theming (Toxic Slime #55f736 active power node, Acid Cyan #00f0ff occupied, Neon Violet #7928ca muted)
    theme.taglist_bg_focus    = "#161326"
    theme.taglist_fg_focus    = "#55f736"
    theme.taglist_bg_urgent   = "#ff007f"
    theme.taglist_fg_urgent   = "#ffffff"
    theme.taglist_bg_occupied = "#120f24"
    theme.taglist_fg_occupied = "#00f0ff"
    theme.taglist_bg_empty    = "#090812"
    theme.taglist_fg_empty    = "#7928ca"

    -- Tasklist Theming
    theme.tasklist_bg_normal   = "#120f24"
    theme.tasklist_fg_normal   = "#e0d8f6"
    theme.tasklist_bg_focus    = "#161326"
    theme.tasklist_fg_focus    = "#00f0ff"
    theme.tasklist_bg_urgent   = "#ff007f"
    theme.tasklist_fg_urgent   = "#ffffff"
    theme.tasklist_bg_minimize = "#090812"
    theme.tasklist_fg_minimize = "#7928ca"

    -- Context Menu Theming
    theme.menu_bg_normal    = "#090812f8"
    theme.menu_bg_focus     = "#161326"
    theme.menu_fg_normal    = "#e0d8f6"
    theme.menu_fg_focus     = "#00f0ff"
    theme.menu_border_color = "#a855f7"
    theme.menu_border_width = dpi(1)
    theme.menu_height       = dpi(26)
    theme.menu_width        = dpi(140)

    -- Hotkeys Popup / Help Modal
    theme.hotkeys_bg              = "#090812f8"
    theme.hotkeys_fg              = "#e0d8f6"
    theme.hotkeys_border_color    = "#a855f7"
    theme.hotkeys_border_width    = dpi(1)
    theme.hotkeys_modifiers_fg    = "#00f0ff"
    theme.hotkeys_label_bg        = "#161326"
    theme.hotkeys_label_fg        = "#55f736"
    theme.hotkeys_group_margin    = dpi(16)

    -- Titlebars
    theme.titlebar_bg_normal = "#120f24"
    theme.titlebar_bg_focus  = "#161326"
    theme.titlebar_fg_normal = "#7928ca"
    theme.titlebar_fg_focus  = "#00f0ff"

    -- Wibar Height
    theme.wibar_height = dpi(34)

    -- Wallpaper
    theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/cyber.jpg"
elseif mode == "space" then
    -- ==========================================================
    -- Act IV: Orbital Containment / Deep Space Vessel (Flight Deck)
    -- ==========================================================
    -- Outer border drawn by 4-sided Double-Pencil HUD perimeter bars & corner brackets
    theme.border_width  = dpi(0)
    theme.border_normal = "#e1e4ea"
    theme.border_focus  = "#e59500"
    theme.border_marked = "#d32f2f"

    -- Core Color Palette (Hull White #f5f6f9, Airframe Grey #e1e4ea, Deep Nav Slate #1b2028)
    theme.bg_normal   = "#f5f6f9f5"
    theme.bg_focus    = "#e1e4ea"
    theme.bg_urgent   = "#d32f2f"
    theme.bg_minimize = "#e1e4ea"
    theme.bg_systray  = "#f5f6f9"

    theme.fg_normal   = "#1b2028"
    theme.fg_focus    = "#0088cc"
    theme.fg_urgent   = "#ffffff"
    theme.fg_minimize = "#5a6578"

    -- Taglist Theming (Solar Flare Gold #e59500 active, Thruster Cyan #0088cc occupied)
    theme.taglist_bg_focus    = "#1b2028"
    theme.taglist_fg_focus    = "#e59500"
    theme.taglist_bg_urgent   = "#d32f2f"
    theme.taglist_fg_urgent   = "#ffffff"
    theme.taglist_bg_occupied = "#e1e4ea"
    theme.taglist_fg_occupied = "#0088cc"
    theme.taglist_bg_empty    = "#f5f6f9"
    theme.taglist_fg_empty    = "#8c96a8"

    -- Tasklist Theming
    theme.tasklist_bg_normal   = "#f5f6f9"
    theme.tasklist_fg_normal   = "#1b2028"
    theme.tasklist_bg_focus    = "#e1e4ea"
    theme.tasklist_fg_focus    = "#0088cc"
    theme.tasklist_bg_urgent   = "#d32f2f"
    theme.tasklist_fg_urgent   = "#ffffff"
    theme.tasklist_bg_minimize = "#e1e4ea"
    theme.tasklist_fg_minimize = "#5a6578"

    -- Context Menu Theming
    theme.menu_bg_normal    = "#f5f6f9f8"
    theme.menu_bg_focus     = "#e1e4ea"
    theme.menu_fg_normal    = "#1b2028"
    theme.menu_fg_focus     = "#0088cc"
    theme.menu_border_color = "#e59500"
    theme.menu_border_width = dpi(2)
    theme.menu_height       = dpi(26)
    theme.menu_width        = dpi(140)

    -- Hotkeys Popup / Help Modal
    theme.hotkeys_bg              = "#f5f6f9f8"
    theme.hotkeys_fg              = "#1b2028"
    theme.hotkeys_border_color    = "#e59500"
    theme.hotkeys_border_width    = dpi(2)
    theme.hotkeys_modifiers_fg    = "#0088cc"
    theme.hotkeys_label_bg        = "#1b2028"
    theme.hotkeys_label_fg        = "#e59500"
    theme.hotkeys_group_margin    = dpi(16)

    -- Titlebars
    theme.titlebar_bg_normal = "#e1e4ea"
    theme.titlebar_bg_focus  = "#f5f6f9"
    theme.titlebar_fg_normal = "#5a6578"
    theme.titlebar_fg_focus  = "#1b2028"

    -- Wibar Height
    theme.wibar_height = dpi(34)

    -- Wallpaper
    theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/space.jpg"
elseif mode == "shred" then
    -- ===============================================================
    -- Standalone: The Shredder (Gunmetal, Razor Angles & Ripper Teeth)
    -- ===============================================================
    theme.border_width  = dpi(2)
    theme.border_normal = "#242a34aa"
    theme.border_focus  = "#c8d0dccc"
    theme.border_marked = "#ff2a2acc"

    -- Core Color Palette (Abyssal Chute #0b0c0e, Machined Gunmetal #14171c, Honed Razor Steel #e2e8f0)
    theme.bg_normal   = "#0b0c0ef5"
    theme.bg_focus    = "#1c2129"
    theme.bg_urgent   = "#ff2a2a"
    theme.bg_minimize = "#111318"
    theme.bg_systray  = "#0b0c0e"

    theme.fg_normal   = "#c8d0dc"
    theme.fg_focus    = "#ffffff"
    theme.fg_urgent   = "#ffffff"
    theme.fg_minimize = "#525b69"

    -- Taglist Theming
    theme.taglist_bg_focus    = "#242a34"
    theme.taglist_fg_focus    = "#ff2a2a"
    theme.taglist_bg_urgent   = "#ff2a2a"
    theme.taglist_fg_urgent   = "#ffffff"
    theme.taglist_bg_occupied = "#14171c"
    theme.taglist_fg_occupied = "#e2e8f0"
    theme.taglist_bg_empty    = "#0b0c0e"
    theme.taglist_fg_empty    = "#4a5260"

    -- Tasklist Theming
    theme.tasklist_bg_normal   = "#14171c"
    theme.tasklist_fg_normal   = "#8b95a5"
    theme.tasklist_bg_focus    = "#242a34"
    theme.tasklist_fg_focus    = "#ffffff"
    theme.tasklist_bg_urgent   = "#ff2a2a"
    theme.tasklist_fg_urgent   = "#ffffff"
    theme.tasklist_bg_minimize = "#0b0c0e"
    theme.tasklist_fg_minimize = "#4a5260"

    -- Context Menu Theming
    theme.menu_bg_normal    = "#0b0c0ef8"
    theme.menu_bg_focus     = "#242a34"
    theme.menu_fg_normal    = "#c8d0dc"
    theme.menu_fg_focus     = "#ffffff"
    theme.menu_border_color = "#c8d0dc"
    theme.menu_border_width = dpi(2)
    theme.menu_height       = dpi(26)
    theme.menu_width        = dpi(140)

    -- Hotkeys Popup / Help Modal
    theme.hotkeys_bg              = "#0b0c0ef8"
    theme.hotkeys_fg              = "#d8dee9"
    theme.hotkeys_border_color    = "#c8d0dc"
    theme.hotkeys_border_width    = dpi(2)
    theme.hotkeys_modifiers_fg    = "#ff5500"
    theme.hotkeys_label_bg        = "#242a34"
    theme.hotkeys_label_fg        = "#ff2a2a"
    theme.hotkeys_group_margin    = dpi(16)

    -- Titlebars
    theme.titlebar_bg_normal = "#0b0c0e"
    theme.titlebar_bg_focus  = "#1c2129"
    theme.titlebar_fg_normal = "#525b69"
    theme.titlebar_fg_focus  = "#e2e8f0"

    -- Wibar Height
    theme.wibar_height = dpi(28)

    -- Wallpaper
    theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/shred.jpg"
elseif mode == "chomp" or mode == "larry" then
    -- ==============================================================================
    -- Standalone: "Chomp the Haxor" / CHOMP_0x Cyber-Swamp Brutalist Theme
    -- High-Readability Monolithic Industrial Aesthetics
    -- ==============================================================================
    theme.border_width       = dpi(2)
    theme.border_width_focus = dpi(3)
    theme.border_normal      = "#16382f" -- Distinct deep emerald slate
    theme.border_focus       = "#39ff14" -- High-voltage toxic green laser
    theme.border_marked      = "#ffb000" -- Alert amber

    -- Core Color Palette (Matte Chassis, Marsh Teal, Toxic Green & Phosphor White)
    theme.bg_normal   = "#111415"
    theme.bg_focus    = "#0d2822"
    theme.bg_urgent   = "#ffb000"
    theme.bg_minimize = "#090c0c"
    theme.bg_systray  = "#111415"

    theme.fg_normal   = "#e2f5ec" -- Crisp, high-contrast phosphor white-mint
    theme.fg_focus    = "#39ff14" -- Toxic laser green
    theme.fg_urgent   = "#000000"
    theme.fg_minimize = "#6f8a7e" -- Clearly readable tactical slate

    -- Taglist Theming (SYS, DEV, SWAMP, ROOT, LOGS)
    theme.taglist_bg_focus    = "#39ff14"
    theme.taglist_fg_focus    = "#0a140f"
    theme.taglist_bg_urgent   = "#ffb000"
    theme.taglist_fg_urgent   = "#000000"
    theme.taglist_bg_occupied = "#182622"
    theme.taglist_fg_occupied = "#e2f5ec"
    theme.taglist_bg_empty    = "#111415"
    theme.taglist_fg_empty    = "#6f8a7e"

    -- Tasklist Theming
    theme.tasklist_bg_normal   = "#111415"
    theme.tasklist_fg_normal   = "#e2f5ec"
    theme.tasklist_bg_focus    = "#0d2822"
    theme.tasklist_fg_focus    = "#39ff14"
    theme.tasklist_bg_urgent   = "#ffb000"
    theme.tasklist_fg_urgent   = "#000000"
    theme.tasklist_bg_minimize = "#090c0c"
    theme.tasklist_fg_minimize = "#6f8a7e"

    -- Context Menu Theming
    theme.menu_bg_normal    = "#111415f8"
    theme.menu_bg_focus     = "#0d2822"
    theme.menu_fg_normal    = "#e2f5ec"
    theme.menu_fg_focus     = "#39ff14"
    theme.menu_border_color = "#39ff14"
    theme.menu_border_width = dpi(1)
    theme.menu_height       = dpi(26)
    theme.menu_width        = dpi(140)

    -- Hotkeys Popup / Help Modal
    theme.hotkeys_bg              = "#111415f8"
    theme.hotkeys_fg              = "#e2f5ec"
    theme.hotkeys_border_color    = "#39ff14"
    theme.hotkeys_border_width    = dpi(2)
    theme.hotkeys_modifiers_fg    = "#ffb000"
    theme.hotkeys_label_bg        = "#0d2822"
    theme.hotkeys_label_fg        = "#39ff14"
    theme.hotkeys_group_margin    = dpi(16)

    -- Titlebars
    theme.titlebar_bg_normal = "#111415"
    theme.titlebar_bg_focus  = "#0d2822"
    theme.titlebar_fg_normal = "#6f8a7e"
    theme.titlebar_fg_focus  = "#39ff14"

    -- Wibar Height
    theme.wibar_height = dpi(36)

    -- Wallpaper
    theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/chomp.jpg"
else
    -- ==========================================
    -- Slime Theme Aesthetics (Post-Contamination)
    -- ==========================================
    theme.border_width  = dpi(2)
    theme.border_normal = "#15241777"
    theme.border_focus  = "#55f73677"
    theme.border_marked = "#ff434399"

    -- Core Color Palette (Semi-transparent murky dark slime & vibrant neon accents)
    theme.bg_normal   = "#0c140df0"
    theme.bg_focus    = "#1b351e"
    theme.bg_urgent   = "#ff4343"
    theme.bg_minimize = "#101d12"
    theme.bg_systray  = theme.bg_normal

    theme.fg_normal   = "#b9e69c"
    theme.fg_focus    = "#f0ffcd"
    theme.fg_urgent   = "#ffffff"
    theme.fg_minimize = "#476b4e"

    -- Taglist Theming
    theme.taglist_bg_focus    = "#1f3d23"
    theme.taglist_fg_focus    = "#74ff2e"
    theme.taglist_bg_urgent   = "#ff4343"
    theme.taglist_fg_urgent   = "#ffffff"
    theme.taglist_bg_occupied = "#101d12"
    theme.taglist_fg_occupied = "#c6f582"
    theme.taglist_bg_empty    = "#0c140df0"
    theme.taglist_fg_empty    = "#3a563f"

    -- Tasklist Theming
    theme.tasklist_bg_normal   = "#0c140df0"
    theme.tasklist_fg_normal   = "#98c481"
    theme.tasklist_bg_focus    = "#1c3820"
    theme.tasklist_fg_focus    = "#64f830"
    theme.tasklist_bg_urgent   = "#ff4343"
    theme.tasklist_fg_urgent   = "#ffffff"
    theme.tasklist_bg_minimize = "#101a11"
    theme.tasklist_fg_minimize = "#476b4e"

    -- Context Menu Theming
    theme.menu_bg_normal    = "#0c140df6"
    theme.menu_bg_focus     = "#1f3f24"
    theme.menu_fg_normal    = "#c6f582"
    theme.menu_fg_focus     = "#f0ffcd"
    theme.menu_border_color = "#396b3f"
    theme.menu_border_width = dpi(2)
    theme.menu_height       = dpi(26)
    theme.menu_width        = dpi(140)

    -- Hotkeys Popup / Help Modal
    theme.hotkeys_bg              = "#0c140df6"
    theme.hotkeys_fg              = "#c6f582"
    theme.hotkeys_border_color    = "#55f736"
    theme.hotkeys_border_width    = dpi(2)
    theme.hotkeys_modifiers_fg    = "#d8eb34"
    theme.hotkeys_label_bg        = "#1b351e"
    theme.hotkeys_label_fg        = "#f0ffcd"
    theme.hotkeys_group_margin    = dpi(16)

    -- Titlebars
    theme.titlebar_bg_normal = "#0c140d"
    theme.titlebar_bg_focus  = "#152618"
    theme.titlebar_fg_normal = "#6d9c74"
    theme.titlebar_fg_focus  = "#c6f582"

    -- Wibar Height
    theme.wibar_height = dpi(28)

    -- Wallpaper
    theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/slime.jpg"
end

-- Recolor layout icons to match the active theme
local gcolor = require("gears.color")
local layout_color = "#55f736"
if mode == "origin" then
    layout_color = "#9ece6a"
elseif mode == "lab" then
    layout_color = "#0a0c0e"
elseif mode == "cyber" then
    layout_color = "#00f0ff"
elseif mode == "space" then
    layout_color = "#0088cc"
elseif mode == "shred" then
    layout_color = "#c8d0dc"
elseif mode == "chomp" or mode == "larry" then
    layout_color = "#39ff14"
end
for _, l in ipairs({
    "fairh", "fairv", "floating", "magnifier", "max", "fullscreen",
    "tilebottom", "tileleft", "tile", "tiletop", "spiral", "dwindle",
    "cornernw", "cornerne", "cornersw", "cornerse"
}) do
    local key = "layout_" .. l
    if theme[key] then
        theme[key] = gcolor.recolor_image(theme[key], layout_color)
    end
end

return theme

