-- Act IV: Orbital Containment / Deep Space Vessel (Flight Deck)
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "space",
    display_name    = "Orbital Containment",
    act             = "Act IV",
    narrative_title = "Act IV: ORBITAL CONTAINMENT [ORB//DECK]",
    narrative_body  = "Deep Space Vessel & Cryo-Stasis active (Super+o to cycle)",
    is_light        = true,

    -- Typography
    font_family     = "SpaceMono Nerd Font",
    font_size       = "9",

    -- Core Window Borders (Outer border drawn by 4-sided Double-Pencil HUD perimeter bars) & Gaps
    border_width    = dpi(0),
    border_normal   = "#e1e4ea",
    border_focus    = "#e59500",
    border_marked   = "#d32f2f",
    useless_gap     = dpi(6),

    -- Core Color Palette
    bg_normal       = "#f5f6f9f5",
    bg_focus        = "#e1e4ea",
    bg_urgent       = "#d32f2f",
    bg_minimize     = "#e1e4ea",
    bg_systray      = "#f5f6f9",

    fg_normal       = "#1b2028",
    fg_focus        = "#0088cc",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#5a6578",

    -- Taglist Theming
    taglist_bg_focus    = "#1b2028",
    taglist_fg_focus    = "#e59500",
    taglist_bg_urgent   = "#d32f2f",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#e1e4ea",
    taglist_fg_occupied = "#0088cc",
    taglist_bg_empty    = "#f5f6f9",
    taglist_fg_empty    = "#8c96a8",

    -- Tasklist Theming
    tasklist_bg_normal   = "#f5f6f9",
    tasklist_fg_normal   = "#1b2028",
    tasklist_bg_focus    = "#e1e4ea",
    tasklist_fg_focus    = "#0088cc",
    tasklist_bg_urgent   = "#d32f2f",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#e1e4ea",
    tasklist_fg_minimize = "#5a6578",

    -- Context Menu Theming
    menu_bg_normal    = "#f5f6f9f8",
    menu_bg_focus     = "#e1e4ea",
    menu_fg_normal    = "#1b2028",
    menu_fg_focus     = "#0088cc",
    menu_border_color = "#e59500",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#f5f6f9f8",
    hotkeys_fg           = "#1b2028",
    hotkeys_border_color = "#e59500",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#0088cc",
    hotkeys_label_bg     = "#1b2028",
    hotkeys_label_fg     = "#e59500",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#e1e4ea",
    titlebar_bg_focus  = "#f5f6f9",
    titlebar_fg_normal = "#5a6578",
    titlebar_fg_focus  = "#1b2028",

    -- Wallpaper & Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/space.jpg",
    layout_color = "#0088cc",

    -- Telemetry Palette
    palette = {
        cpu        = "#1b2028",
        temp_ok    = "#0088cc",
        temp_hot   = "#d32f2f",
        gpu        = "#0088cc",
        sys        = "#1b2028",
        net_ok     = "#0088cc",
        net_off    = "#d32f2f",
        vol_ok     = "#1b2028",
        vol_mute   = "#d32f2f",
        bat_ok     = "#0d8a52",
        bat_chg    = "#e59500",
        bat_warn   = "#c25d00",
        bat_crit   = "#d32f2f",
        bat_badge  = "#0088cc",
        pill_bg1   = "#f5f6f9",
        pill_bg2   = "#e1e4ea",
        pill_fg    = "#1b2028",
        pill_bdr   = "#e59500",
        pill_bw    = 1,
    },

    -- Top Bar Styling
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_space_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_border_w   = 1,
    task_border_col = "#e59500",

    -- Window Styling & Signals
    window_style    = "space_perimeter",
    window_shape_fn = nil, -- Uses 4-sided titlebars with edge renderer
    perimeter_titlebars = true,
    window_edge_fn  = function(c, side) return slime_shapes.render_space_window_edge(c, side) end,

    -- Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    notification_presets = {
        normal = {
            bg           = "#f5f6f9f8",
            fg           = "#1b2028",
            border_color = "#e59500",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#fbe9e9",
            fg           = "#1b2028",
            border_color = "#d32f2f",
            border_width = 3,
            timeout      = 0,
        },
        low = {
            bg           = "#e1e4ea",
            fg           = "#0088cc",
            border_color = "#0088cc",
            border_width = 2,
            timeout      = 4,
        },
    },
}

return theme
