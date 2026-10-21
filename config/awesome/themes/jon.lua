-- ==============================================================================
-- I'm Sorry Jon Theme: The Flesh is Weak (Cosmic Horror & Eldritch Lasagna)
-- ==============================================================================
-- Inspired by the legendary 'I'm Sorry Jon' (Gorefield) cosmic horror aesthetic:
-- Abyssal kitchen shadow noir canvas (#0f0c0b), burnt lasagna glowing orange (#e0562e),
-- hanging pendant lamp amber (#e5a93c), Jon's slate teal (#5c7f87),
-- and sepia kitchen parchment cream (#e8dcc4). "Bullets don't work, Jon."
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/jon.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/jon.png"
end

local theme = {
    -- 1. Metadata
    name                 = "jon",
    display_name         = "I'm Sorry Jon",
    act                  = "I'm Sorry Jon",
    narrative_title      = "I'M SORRY JON: BULLETS DON'T WORK [ELDRITCH//LASAGNA]",
    narrative_body       = "I'm sorry Jon. I was so hungry. (Super+o to cycle)",
    is_light             = false,
    has_jon_mascot       = true,
    has_jon_prompt       = true,

    -- 2. Typography
    font_family          = "ComicShannsMono Nerd Font",
    font_size            = "10",

    -- 3. Window Borders & Gaps (Burnt Lasagna Orange Glowing Focus Border)
    border_width         = dpi(2),
    border_normal        = "#2c1e1c",
    border_focus         = "#e0562e",
    border_marked        = "#d13824",
    useless_gap          = dpi(6),

    -- 4. Core Window & Widget Palette (Abyssal Kitchen Noir & Eldritch Accents)
    bg_normal            = "#0f0c0bf5",
    bg_focus             = "#181211",
    bg_urgent            = "#d13824",
    bg_minimize          = "#080605",
    bg_systray           = "#0f0c0b",

    fg_normal            = "#e8dcc4",
    fg_focus             = "#ffffff",
    fg_urgent            = "#ffffff",
    fg_minimize          = "#7d695c",

    -- Taglist Theming (Burnt Orange Focus Pill, Hanging Lamp Amber Occupied)
    taglist_bg_focus     = "#e0562e",
    taglist_fg_focus     = "#0f0c0b",
    taglist_bg_urgent    = "#d13824",
    taglist_fg_urgent    = "#ffffff",
    taglist_bg_occupied  = "#1e1513",
    taglist_fg_occupied  = "#e5a93c",
    taglist_bg_empty     = "#0f0c0b",
    taglist_fg_empty     = "#4a3934",

    -- Tasklist Theming
    tasklist_bg_normal   = "#140f0edd",
    tasklist_fg_normal   = "#b3a294",
    tasklist_bg_focus    = "#211715",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#d13824",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#080605",
    tasklist_fg_minimize = "#4a3934",

    -- Context Menu Theming
    menu_bg_normal     = "#140f0ef8",
    menu_bg_focus      = "#e0562e",
    menu_fg_normal     = "#e8dcc4",
    menu_fg_focus      = "#0f0c0b",
    menu_border_color  = "#e0562e",
    menu_border_width  = dpi(2),
    menu_height        = dpi(26),
    menu_width         = dpi(160),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#140f0e",
    hotkeys_fg           = "#e8dcc4",
    hotkeys_border_color = "#e0562e",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#e5a93c",
    hotkeys_label_bg     = "#e0562e",
    hotkeys_label_fg     = "#0f0c0b",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#0f0c0b",
    titlebar_bg_focus  = "#181211",
    titlebar_fg_normal = "#7d695c",
    titlebar_fg_focus  = "#e0562e",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#e0562e",

    -- 5. Top Bar Telemetry Palette (Vivid Eldritch & Kitchen Tones)
    palette = {
        cpu        = "#d13824", -- Enemy / Mondays Red
        temp_ok    = "#e5a93c", -- Lamp Amber Gold
        temp_hot   = "#d13824",
        gpu        = "#e0562e", -- Burnt Lasagna Orange
        sys        = "#e8dcc4", -- Sepia Parchment
        net_ok     = "#5c7f87", -- Jon's Slate Teal
        net_off    = "#d13824",
        vol_ok     = "#e5a93c",
        vol_mute   = "#d13824",
        bat_ok     = "#e5a93c",
        bat_chg    = "#5c7f87",
        bat_warn   = "#e0562e",
        bat_crit   = "#d13824",
        bat_badge  = "#e5a93c",
        pill_bg1   = "#181211",
        pill_bg2   = "#211715",
        pill_fg    = "#ffffff",
        pill_bdr   = "#e0562e", -- Burnt orange rim
        pill_bw    = 1,
    },

    -- 6. Top Bar Styling with Custom I'm Sorry Jon Cairo Renderer
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_jon_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 1,
    task_border_col = "#e0562e",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#140f0e",
            fg           = "#e8dcc4",
            border_color = "#e0562e",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2b0a0a",
            fg           = "#d13824",
            border_color = "#d13824",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#0f0c0b",
            fg           = "#e5a93c",
            border_color = "#e5a93c",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
