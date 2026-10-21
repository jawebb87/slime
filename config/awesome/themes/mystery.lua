-- ==============================================================================
-- Mystery Machine Theme: Spooky Nights & Groovy Flower Power (Dark Theme)
-- ==============================================================================
-- Inspired by Scooby-Doo's iconic Mystery Machine van: spooky misty midnight road,
-- haunted Victorian manor, full moon, glowing headlights, and signature
-- turquoise body, lime green floral accents, and flower power tangerine orange.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/mystery.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/mystery.png"
end

local theme = {
    -- 1. Metadata
    name                = "mystery",
    display_name        = "Mystery Machine",
    act                 = "Spooky Mystery",
    narrative_title     = "THE MYSTERY MACHINE: SPOOKY NIGHTS & FLOWER POWER [SCOOBY//MYSTERY]",
    narrative_body      = "Mystery Machine dark theme active - Ruh-roh! (Super+o to cycle)",
    is_light            = false,
    has_mystery_mascot  = true,
    has_mystery_prompt  = true,

    -- 2. Typography
    font_family         = "ComicShannsMono Nerd Font",
    font_size           = "10",

    -- 3. Window Borders & Gaps (Mystery Machine Turquoise Active Focus)
    border_width        = dpi(2),
    border_normal       = "#1d2c3a",
    border_focus        = "#1cd1be",
    border_marked       = "#ff7700",
    useless_gap         = dpi(6),

    -- 4. Core Window & Widget Palette (Midnight Fog & Psychedelic Accents)
    bg_normal           = "#10151df5",
    bg_focus            = "#17232e",
    bg_urgent           = "#ff3864",
    bg_minimize         = "#0a0e14",
    bg_systray          = "#10151d",

    fg_normal           = "#d4e5ea",
    fg_focus            = "#ffffff",
    fg_urgent           = "#ffffff",
    fg_minimize         = "#6b8594",

    -- Taglist Theming (Turquoise Focus Pill, Groovy Lime Green Occupied)
    taglist_bg_focus    = "#1cd1be",
    taglist_fg_focus    = "#10151d",
    taglist_bg_urgent   = "#ff3864",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#1f2e3d",
    taglist_fg_occupied = "#88e22c",
    taglist_bg_empty    = "#10151d",
    taglist_fg_empty    = "#506877",

    -- Tasklist Theming
    tasklist_bg_normal   = "#151d28dd",
    tasklist_fg_normal   = "#9fb5c2",
    tasklist_bg_focus    = "#1c2b3a",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff3864",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0a0e14",
    tasklist_fg_minimize = "#506877",

    -- Context Menu Theming
    menu_bg_normal    = "#151d28f8",
    menu_bg_focus     = "#1cd1be",
    menu_fg_normal    = "#d4e5ea",
    menu_fg_focus     = "#10151d",
    menu_border_color = "#88e22c",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(160),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#151d28",
    hotkeys_fg           = "#d4e5ea",
    hotkeys_border_color = "#1cd1be",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#88e22c",
    hotkeys_label_bg     = "#1cd1be",
    hotkeys_label_fg     = "#10151d",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#10151d",
    titlebar_bg_focus  = "#17232e",
    titlebar_fg_normal = "#6b8594",
    titlebar_fg_focus  = "#1cd1be",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#1cd1be",

    -- 5. Top Bar Telemetry Palette (Vivid Mystery Machine Colors)
    palette = {
        cpu        = "#ff7700", -- Flower Power Tangerine Orange
        temp_ok    = "#1cd1be", -- Mystery Machine Turquoise Aqua
        temp_hot   = "#ff3864", -- Spooky Alert Crimson
        gpu        = "#b062ff", -- Mystery Night Violet
        sys        = "#d4e5ea", -- Pale Cel White
        net_ok     = "#88e22c", -- Groovy Lime Green
        net_off    = "#ff3864", -- Alert
        vol_ok     = "#1cd1be", -- Turquoise
        vol_mute   = "#ff3864",
        bat_ok     = "#88e22c", -- Lime
        bat_chg    = "#1cd1be", -- Turquoise
        bat_warn   = "#ffd000", -- Scooby Snack Gold
        bat_crit   = "#ff3864",
        bat_badge  = "#ff7700",
        pill_bg1   = "#151d28",
        pill_bg2   = "#1c2b3a",
        pill_fg    = "#ffffff",
        pill_bdr   = "#1cd1be", -- Turquoise rim
        pill_bw    = 1,
    },

    -- 6. Top Bar Styling with Custom Flower Power Cairo Renderer
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_mystery_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 1,
    task_border_col = "#1cd1be",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#151d28",
            fg           = "#d4e5ea",
            border_color = "#1cd1be",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#201217",
            fg           = "#ff3864",
            border_color = "#ff3864",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#131b22",
            fg           = "#88e22c",
            border_color = "#88e22c",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
