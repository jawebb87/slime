-- ==============================================================================
-- Abyssal Void Theme: Psychedelic Glitch & Liquid Singularity
-- ==============================================================================
-- Floating neon glass capsules suspended over a pitch-black cosmic liquid void.
-- Features an invisible, transparent wibar where only the luminous telemetry
-- and workspace pills appear floating across the desktop.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/void.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/slime_dark_void.jpg"
end

local theme = {
    -- 1. Metadata
    name            = "void",
    display_name    = "Abyssal Void",
    narrative_title = "ABYSSAL VOID: LIQUID SINGULARITY [VOID//ZERO]",
    narrative_body  = "Liquid Void theme active - floating pills & invisible bar (Super+o to cycle)",
    is_light        = false,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Floating void aesthetic with generous 8px gap)
    border_width    = dpi(2),
    border_normal   = "#0c101c",
    border_focus    = "#00e5ff",
    border_marked   = "#ff007f",
    useless_gap     = dpi(8),

    -- 4. Core Window & Widget Palette (Pitch Obsidian & Bioluminescent Accents)
    bg_normal       = "#05060bee",
    bg_focus        = "#0e1428",
    bg_urgent       = "#ff007f",
    bg_minimize     = "#020305",
    bg_systray      = "#080c16",

    fg_normal       = "#c8d6e5",
    fg_focus        = "#ffffff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#475569",

    -- Taglist Theming (Luminous Floating Pills)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#00e5ff",
    taglist_fg_focus    = "#05060b",
    taglist_bg_urgent   = "#ff007f",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#101828",
    taglist_fg_occupied = "#38bdf8",
    taglist_bg_empty    = "#060810aa",
    taglist_fg_empty    = "#475569",
    taglist_template    = {
        {
            {
                id     = "text_role",
                widget = wibox.widget.textbox,
            },
            left   = 8,
            right  = 8,
            top    = 2,
            bottom = 2,
            widget = wibox.container.margin,
        },
        id                 = "background_role",
        widget             = wibox.container.background,
        shape              = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
        shape_border_width = 1,
        shape_border_color = "#00e5ff44",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Floating Smoked Obsidian Pods)
    tasklist_bg_normal   = "#080c16dd",
    tasklist_fg_normal   = "#94a3b8",
    tasklist_bg_focus    = "#0e152edd",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff007f",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#04060b",
    tasklist_fg_minimize = "#475569",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    task_border_w        = 1,
    task_border_col      = "#00e5ff88",

    -- Context Menu
    menu_bg_normal    = "#080c16f8",
    menu_bg_focus     = "#121b36",
    menu_fg_normal    = "#c8d6e5",
    menu_fg_focus     = "#00e5ff",
    menu_border_color = "#00e5ff",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#080c16f8",
    hotkeys_fg           = "#c8d6e5",
    hotkeys_border_color = "#00e5ff",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ff007f",
    hotkeys_label_bg     = "#0e152e",
    hotkeys_label_fg     = "#00e5ff",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#05060b",
    titlebar_bg_focus  = "#0e152e",
    titlebar_fg_normal = "#475569",
    titlebar_fg_focus  = "#00e5ff",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#00e5ff",

    -- 5. Top Bar Telemetry Palette (High-Voltage Bioluminescence)
    palette = {
        cpu        = "#ff007f", -- Neon Hot Pink
        temp_ok    = "#00e5ff", -- Electric Cyan
        temp_hot   = "#ff0055", -- Searing Crimson
        gpu        = "#a855f7", -- Electric Violet
        sys        = "#38bdf8", -- Sky Blue
        net_ok     = "#00e5ff", -- Electric Cyan
        net_off    = "#ff0055", -- Neon Warning
        vol_ok     = "#3b82f6", -- Cobalt Blue
        vol_mute   = "#576574", -- Muted Void
        bat_ok     = "#06d6a0", -- Bioluminescent Teal
        bat_chg    = "#00e5ff", -- Electric Cyan
        bat_warn   = "#f59e0b", -- Amber Glow
        bat_crit   = "#ff0055", -- Neon Red
        bat_badge  = "#101828",
        pill_bg1   = "#080c16dd", -- Smoked Obsidian Glass (transparent)
        pill_bg2   = "#090e1bdd", -- Deep Void Glass
        pill_fg    = "#e2e8f0",   -- Crisp Ice White
        pill_bdr   = "#00e5ff66", -- Electric Cyan Neon Rim (translucent glow)
        pill_bw    = 1,
    },

    -- 6. Top Bar Layout & Geometry: COMPLETELY INVISIBLE BAR
    -- Zero background plate, zero background image, floating neon capsules
    bar_invisible      = true,
    bar_height         = 40,
    bar_strut_top      = 40,
    bar_margin_top     = 4,
    bar_margin_bottom  = 4,
    bar_drip_height    = 0,
    is_flat            = true,
    bar_shape          = nil,
    bar_bgimage        = nil,
    clock_format       = "  %I:%M %p ",
    telemetry_style    = "icon",

    -- Smooth floating capsule shape for all telemetry pills
    pill_shape_fn = function(cr, w, h)
        gears.shape.rounded_pill(cr, w, h)
    end,

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#080c16f2",
            fg           = "#e2e8f0",
            border_color = "#00e5ff",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#1c040cf6",
            fg           = "#ffdddd",
            border_color = "#ff0055",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#04060af2",
            fg           = "#94a3b8",
            border_color = "#1e293b",
            border_width = 1,
            timeout      = 3,
        },
    },
}

return theme
