-- Act III: Cyberpunk Future (Bio-Grid Cyberdeck)
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "cyber",
    display_name    = "Cyberpunk Future",
    act             = "Act III",
    narrative_title = "Act III: CYBERPUNK FUTURE [NET//LINK]",
    narrative_body  = "Obsidian UV + Slime Bio-Reactor active (Super+o to cycle)",

    -- Typography
    font_family     = "ZedMono Nerd Font",
    font_size       = "10",

    -- Core Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#7928ca",
    border_focus    = "#55f736",
    border_marked   = "#ff007f",
    useless_gap     = dpi(6),

    -- Core Color Palette
    bg_normal       = "#090812f5",
    bg_focus        = "#161326",
    bg_urgent       = "#ff007f",
    bg_minimize     = "#120f24",
    bg_systray      = "#090812",

    fg_normal       = "#e0d8f6",
    fg_focus        = "#00f0ff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#7928ca",

    -- Taglist Theming
    taglist_bg_focus    = "#161326",
    taglist_fg_focus    = "#55f736",
    taglist_bg_urgent   = "#ff007f",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#120f24",
    taglist_fg_occupied = "#00f0ff",
    taglist_bg_empty    = "#090812",
    taglist_fg_empty    = "#7928ca",

    -- Tasklist Theming
    tasklist_bg_normal   = "#120f24",
    tasklist_fg_normal   = "#e0d8f6",
    tasklist_bg_focus    = "#161326",
    tasklist_fg_focus    = "#00f0ff",
    tasklist_bg_urgent   = "#ff007f",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#090812",
    tasklist_fg_minimize = "#7928ca",

    -- Context Menu Theming
    menu_bg_normal    = "#090812f8",
    menu_bg_focus     = "#161326",
    menu_fg_normal    = "#e0d8f6",
    menu_fg_focus     = "#00f0ff",
    menu_border_color = "#a855f7",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#090812f8",
    hotkeys_fg           = "#e0d8f6",
    hotkeys_border_color = "#a855f7",
    hotkeys_border_width = dpi(1),
    hotkeys_modifiers_fg = "#00f0ff",
    hotkeys_label_bg     = "#161326",
    hotkeys_label_fg     = "#55f736",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#120f24",
    titlebar_bg_focus  = "#161326",
    titlebar_fg_normal = "#7928ca",
    titlebar_fg_focus  = "#00f0ff",

    -- Wallpaper & Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/cyber.jpg",
    layout_color = "#00f0ff",

    -- Telemetry Palette
    palette = {
        cpu        = "#00f0ff",
        temp_ok    = "#a855f7",
        temp_hot   = "#ff007f",
        gpu        = "#55f736",
        sys        = "#e0d8f6",
        net_ok     = "#00f0ff",
        net_off    = "#ff007f",
        vol_ok     = "#a855f7",
        vol_mute   = "#ff007f",
        bat_ok     = "#55f736",
        bat_chg    = "#74ff2e",
        bat_warn   = "#ff007f",
        bat_crit   = "#ff007f",
        bat_badge  = "#00f0ff",
        pill_bg1   = "#161326",
        pill_bg2   = "#120f24",
        pill_fg    = "#e0d8f6",
        pill_bdr   = "#a855f7",
        pill_bw    = 1,
    },

    -- Top Bar Styling
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_cyber_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end,
    task_border_w   = 1,
    task_border_col = "#7928ca",

    -- Window Styling & Signals
    window_style    = "cyber_perimeter",
    window_shape_fn = nil, -- Uses 4-sided titlebars with edge renderer
    perimeter_titlebars = true,
    window_edge_fn  = function(c, side) return slime_shapes.render_cyber_window_edge(c, side) end,

    -- Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end,
    notification_presets = {
        normal = {
            bg           = "#090812f8",
            fg           = "#e0d8f6",
            border_color = "#a855f7",
            border_width = 1,
            timeout      = 5,
        },
        critical = {
            bg           = "#161326f8",
            fg           = "#ffffff",
            border_color = "#ff007f",
            border_width = 1,
            timeout      = 0,
        },
        low = {
            bg           = "#120f24f8",
            fg           = "#00f0ff",
            border_color = "#7928ca",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
