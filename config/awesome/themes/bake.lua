-- ==============================================================================
-- Wake & Bake Theme: 420 Special (All the Weeds, All the Times)
-- ==============================================================================
-- Cozy stoner den aesthetics: sloth & rabbit on the couch with gaming controllers,
-- bong smoke swirling, deep midnight couchlock charcoal noir (#111618),
-- vibrant cannabis leaf emerald (#48b852), TV/bong glow cyan (#4ee2ec),
-- munchies potato chips/soda crimson (#e63946), cheesy doritos amber (#f4a226),
-- and rolling paper parchment cream (#e5dfd5).
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/bake.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/bake.png"
end

local theme = {
    -- 1. Metadata
    name                 = "bake",
    display_name         = "Wake & Bake (420 Special)",
    act                  = "420 Special",
    narrative_title      = "WAKE & BAKE: 420 SPECIAL [ALL THE WEEDS//ALL THE TIMES]",
    narrative_body       = "Controller in hand, couchlock engaged. Passing the bong to the sloth. (Super+o to cycle)",
    is_light             = false,
    has_bake_mascot      = true,
    has_bake_prompt      = true,

    -- 2. Typography
    font_family          = "ComicShannsMono Nerd Font",
    font_size            = "10",

    -- 3. Window Borders & Gaps (Emerald Kush Glowing Focus Border)
    border_width         = dpi(2),
    border_normal        = "#1a2622",
    border_focus         = "#48b852",
    border_marked        = "#e63946",
    useless_gap          = dpi(6),

    -- 4. Core Window & Widget Palette (Couchlock Midnight Noir & Herbal Tones)
    bg_normal            = "#111618f5",
    bg_focus             = "#16201e",
    bg_urgent            = "#e63946",
    bg_minimize          = "#0a0e0f",
    bg_systray           = "#111618",

    fg_normal            = "#e5dfd5",
    fg_focus             = "#ffffff",
    fg_urgent            = "#ffffff",
    fg_minimize          = "#70857b",

    -- Taglist Theming (Cannabis Green Focus Pill, Bong Glow Cyan Occupied)
    taglist_bg_focus     = "#48b852",
    taglist_fg_focus     = "#0d1411",
    taglist_bg_urgent    = "#e63946",
    taglist_fg_urgent    = "#ffffff",
    taglist_bg_occupied  = "#182220",
    taglist_fg_occupied  = "#4ee2ec",
    taglist_bg_empty     = "#111618",
    taglist_fg_empty     = "#384d45",

    -- Tasklist Theming
    tasklist_bg_normal   = "#141c1add",
    tasklist_fg_normal   = "#b5c4bd",
    tasklist_bg_focus    = "#1b2623",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#e63946",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0a0e0f",
    tasklist_fg_minimize = "#485e54",

    -- Context Menu Theming
    menu_bg_normal     = "#141c1af8",
    menu_bg_focus      = "#48b852",
    menu_fg_normal     = "#e5dfd5",
    menu_fg_focus      = "#0d1411",
    menu_border_color  = "#48b852",
    menu_border_width  = dpi(2),
    menu_height        = dpi(26),
    menu_width         = dpi(160),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#141c1a",
    hotkeys_fg           = "#e5dfd5",
    hotkeys_border_color = "#48b852",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#f4a226",
    hotkeys_label_bg     = "#48b852",
    hotkeys_label_fg     = "#0d1411",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#111618",
    titlebar_bg_focus  = "#16201e",
    titlebar_fg_normal = "#70857b",
    titlebar_fg_focus  = "#48b852",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#48b852",

    -- 5. Top Bar Telemetry Palette (Vivid Herbal & Munchies Tones)
    palette = {
        cpu        = "#e63946", -- Snack Bag / Soda Red
        temp_ok    = "#f4a226", -- Cheesy Doritos Amber Gold
        temp_hot   = "#e63946",
        gpu        = "#48b852", -- Trichome Herb Green
        sys        = "#e5dfd5", -- Rolling Paper Cream
        net_ok     = "#4ee2ec", -- TV / Bong Water Glow Cyan
        net_off    = "#e63946",
        vol_ok     = "#f4a226",
        vol_mute   = "#e63946",
        bat_ok     = "#48b852",
        bat_chg    = "#4ee2ec",
        bat_warn   = "#f4a226",
        bat_crit   = "#e63946",
        bat_badge  = "#48b852",
        pill_bg1   = "#16201e",
        pill_bg2   = "#1c2825",
        pill_fg    = "#ffffff",
        pill_bdr   = "#48b852", -- Cannabis green rim
        pill_bw    = 1,
    },

    -- 6. Top Bar Styling with Custom 420 Cairo Renderer
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_bake_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 1,
    task_border_col = "#48b852",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#141c1a",
            fg           = "#e5dfd5",
            border_color = "#48b852",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2b0d10",
            fg           = "#e63946",
            border_color = "#e63946",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#111618",
            fg           = "#f4a226",
            border_color = "#f4a226",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
