-- Act 0: The Specimen Origin / Deep Wood (Forest & Mycelium)
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "origin",
    display_name    = "The Specimen Origin",
    act             = "Act 0",
    narrative_title = "Act 0: THE SPECIMEN ORIGIN [EXP//LOG]",
    narrative_body  = "Deep Wood & Mycelium Spore active (Super+o to cycle)",

    -- Typography
    font_family     = "MonaspiceRn Nerd Font",
    font_size       = "9",

    -- Core Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#241e17aa",
    border_focus    = "#9ece6a88",
    border_marked   = "#d08770aa",
    useless_gap     = dpi(6),

    -- Core Color Palette (Deep Forest Soil & Bark Timber)
    bg_normal       = "#141712f5",
    bg_focus        = "#241e17",
    bg_urgent       = "#d08770",
    bg_minimize     = "#1c1914",
    bg_systray      = "#141712",

    fg_normal       = "#d8dee9",
    fg_focus        = "#9ece6a",
    fg_urgent       = "#141712",
    fg_minimize     = "#5a784d",

    -- Taglist Theming
    taglist_bg_focus    = "#241e17",
    taglist_fg_focus    = "#9ece6a",
    taglist_bg_urgent   = "#d08770",
    taglist_fg_urgent   = "#141712",
    taglist_bg_occupied = "#1c1914",
    taglist_fg_occupied = "#d8dee9",
    taglist_bg_empty    = "#141712",
    taglist_fg_empty    = "#5a784d",

    -- Tasklist Theming
    tasklist_bg_normal   = "#1c1914",
    tasklist_fg_normal   = "#d8dee9",
    tasklist_bg_focus    = "#241e17",
    tasklist_fg_focus    = "#9ece6a",
    tasklist_bg_urgent   = "#d08770",
    tasklist_fg_urgent   = "#141712",
    tasklist_bg_minimize = "#141712",
    tasklist_fg_minimize = "#5a784d",

    -- Context Menu Theming
    menu_bg_normal    = "#141712f8",
    menu_bg_focus     = "#241e17",
    menu_fg_normal    = "#d8dee9",
    menu_fg_focus     = "#9ece6a",
    menu_border_color = "#5a784d",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#141712f8",
    hotkeys_fg           = "#d8dee9",
    hotkeys_border_color = "#9ece6a",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#d08770",
    hotkeys_label_bg     = "#241e17",
    hotkeys_label_fg     = "#9ece6a",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#141712",
    titlebar_bg_focus  = "#241e17",
    titlebar_fg_normal = "#5a784d",
    titlebar_fg_focus  = "#9ece6a",

    -- Wallpaper & Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/origin.jpg",
    layout_color = "#9ece6a",

    -- Telemetry Palette (Top bar widgets)
    palette = {
        cpu        = "#9ece6a",
        temp_ok    = "#5a784d",
        temp_hot   = "#d08770",
        gpu        = "#8fbcbb",
        sys        = "#d8dee9",
        net_ok     = "#9ece6a",
        net_off    = "#d08770",
        vol_ok     = "#d8dee9",
        vol_mute   = "#d08770",
        bat_ok     = "#9ece6a",
        bat_chg    = "#ebcb8b",
        bat_warn   = "#d08770",
        bat_crit   = "#bf616a",
        bat_badge  = "#5a784d",
        pill_bg1   = "#241e17",
        pill_bg2   = "#1c1914",
        pill_fg    = "#d8dee9",
        pill_bdr   = "#5a784d",
        pill_bw    = 1,
    },

    -- Top Bar Styling
    bar_height      = 52,
    bar_strut_top   = 34,
    bar_drip_height = 20,
    is_flat         = false,
    bar_shape       = slime_shapes.rocky_bar(20, 4.1),
    bar_bgimage     = slime_shapes.render_origin_bar_bg(20, 4.1),
    pill_shape_fn   = function(seed) return slime_shapes.rocky_pill(6, seed) end,
    task_shape      = slime_shapes.rocky_pill(5, 4.2),
    task_border_w   = 1,
    task_border_col = "#5a784d",

    -- Window Styling & Signals
    window_style    = "bottom_rocks",
    window_shape_fn = function(c, seed) return slime_shapes.rocky_window(10, 18, seed) end,
    window_edge_fn  = function(c, seed) return slime_shapes.render_window_bottom_rocks(c, 10, 18, seed) end,

    -- Notifications
    notification_shape = slime_shapes.rocky_window(8, 10, 2.9),
    notification_presets = {
        normal = {
            bg           = "#141712f5",
            fg           = "#d8dee9",
            border_color = "#9ece6a",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#241e17f8",
            fg           = "#d8dee9",
            border_color = "#d08770",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#141712f2",
            fg           = "#9ece6a",
            border_color = "#5a784d",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
