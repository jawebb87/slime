-- ==============================================================================
-- Speedster and Crew Theme: Cozy Cartoon Hangout
-- ==============================================================================
-- Inspired by the warm, nostalgic Speedster and Crew clubhouse illustration:
-- Clubhouse espresso noir canvas (#140d0d), radiant Speedster amber orange (#cb6d25),
-- honey apricot midtones (#dd9868), twilight skyline violet (#8330b7),
-- retro olive moss (#605526), and warm vanilla cream foreground (#f9cda7).
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/speedster.png"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/speedster.jpg"
end

local theme = {
    -- 1. Metadata
    name                 = "speedster",
    display_name         = "Speedster and Crew",
    act                  = "Speedster and Crew",
    narrative_title      = "SPEEDSTER AND CREW: COZY CARTOON HANGOUT",
    narrative_body       = "Speedster and the crew chilling in the clubhouse. (Super+o to cycle)",
    is_light             = false,
    has_speedster_prompt = true,
    has_speedster_mascot = true,
    companion_label      = "SPEEDSTER",
    companion_icon       = "🏎️ ",
    companion_accent     = "#cb6d25",
    companion_bg         = "#241513",

    -- 2. Typography
    font_family          = "ComicShannsMono Nerd Font",
    font_size            = "10",

    -- 3. Window Borders & Gaps (Radiant Speedster Amber Orange Glowing Focus Border)
    border_width         = dpi(2),
    border_normal        = "#3a211a",
    border_focus         = "#cb6d25",
    border_marked        = "#dd9868",
    useless_gap          = dpi(6),

    -- 4. Core Window & Widget Palette (Clubhouse Espresso Noir & Cozy Accents)
    bg_normal            = "#140d0df5",
    bg_focus             = "#241513",
    bg_urgent            = "#d93829",
    bg_minimize          = "#0d0808",
    bg_systray           = "#140d0d",

    fg_normal            = "#f9cda7",
    fg_focus             = "#ffffff",
    fg_urgent            = "#ffffff",
    fg_minimize          = "#8a6d5f",

    -- Taglist Theming (Radiant Amber Focus Pill, Honey Apricot Occupied)
    taglist_bg_focus     = "#cb6d25",
    taglist_fg_focus     = "#140d0d",
    taglist_bg_urgent    = "#d93829",
    taglist_fg_urgent    = "#ffffff",
    taglist_bg_occupied  = "#241513",
    taglist_fg_occupied  = "#dd9868",
    taglist_bg_empty     = "#140d0d",
    taglist_fg_empty     = "#604336",

    -- Tasklist Theming
    tasklist_bg_normal   = "#1c1210dd",
    tasklist_fg_normal   = "#d49360",
    tasklist_bg_focus    = "#2d1a17",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#d93829",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0d0808",
    tasklist_fg_minimize = "#604336",

    -- Context Menu Theming
    menu_bg_normal     = "#1c1210f8",
    menu_bg_focus      = "#cb6d25",
    menu_fg_normal     = "#f9cda7",
    menu_fg_focus      = "#140d0d",
    menu_border_color  = "#cb6d25",
    menu_border_width  = dpi(2),
    menu_height        = dpi(26),
    menu_width         = dpi(160),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#1c1210",
    hotkeys_fg           = "#f9cda7",
    hotkeys_border_color = "#cb6d25",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#dd9868",
    hotkeys_label_bg     = "#cb6d25",
    hotkeys_label_fg     = "#140d0d",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#140d0d",
    titlebar_bg_focus  = "#241513",
    titlebar_fg_normal = "#8a6d5f",
    titlebar_fg_focus  = "#cb6d25",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#cb6d25",

    -- 5. Top Bar Telemetry Palette (Warm Hearth, Firelight & Clubhouse Tones)
    palette = {
        cpu        = "#d93829", -- Hearth Fire Crimson
        temp_ok    = "#dd9868", -- Honey Apricot
        temp_hot   = "#d93829",
        gpu        = "#cb6d25", -- Radiant Amber Orange
        sys        = "#f9cda7", -- Vanilla Cream
        net_ok     = "#605526", -- Retro Olive Moss
        net_off    = "#d93829",
        vol_ok     = "#dd9868",
        vol_mute   = "#d93829",
        bat_ok     = "#cb6d25",
        bat_chg    = "#dd9868",
        bat_warn   = "#e69138",
        bat_crit   = "#d93829",
        bat_badge  = "#cb6d25",
        pill_bg1   = "#241513",
        pill_bg2   = "#1c1210",
        pill_fg    = "#ffffff",
        pill_bdr   = "#cb6d25", -- Radiant Amber rim
        pill_bw    = 1,
    },

    -- 6. Top Bar Styling with Custom Speedster & Crew Cairo Renderer
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_speedster_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 1,
    task_border_col = "#cb6d25",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#1c1210",
            fg           = "#f9cda7",
            border_color = "#cb6d25",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2d0e0b",
            fg           = "#ff5747",
            border_color = "#d93829",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#140d0d",
            fg           = "#dd9868",
            border_color = "#dd9868",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
