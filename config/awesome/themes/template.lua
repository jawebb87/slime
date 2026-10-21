-- ==============================================================================
-- AwesomeWM Modular Theme Template
-- ==============================================================================
-- Copy this file to `~/.config/awesome/themes/<your_theme_name>.lua` to add a new
-- theme to your desktop. Once saved, it will be automatically discovered by
-- AwesomeWM and `theme-toggle` without modifying any other configuration files!
-- ==============================================================================

local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme = {
    -- 1. Metadata
    name            = "template",
    display_name    = "Custom Theme Template",
    narrative_title = "Custom Theme [CUSTOM//MOD]",
    narrative_body  = "Custom theme active (Super+o to cycle)",

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#333b4d",
    border_focus    = "#7aa2f7",
    border_marked   = "#f7768e",
    useless_gap     = dpi(6),

    -- 4. Core Window & Widget Palette
    bg_normal       = "#1a1b26f5",
    bg_focus        = "#24283b",
    bg_urgent       = "#f7768e",
    bg_minimize     = "#16161e",
    bg_systray      = "#1a1b26",

    fg_normal       = "#a9b1d6",
    fg_focus        = "#7aa2f7",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#565f89",

    -- Taglist
    taglist_bg_focus    = "#24283b",
    taglist_fg_focus    = "#7aa2f7",
    taglist_bg_urgent   = "#f7768e",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#1f2335",
    taglist_fg_occupied = "#c0caf5",
    taglist_bg_empty    = "#1a1b26",
    taglist_fg_empty    = "#565f89",

    -- Tasklist
    tasklist_bg_normal   = "#1f2335",
    tasklist_fg_normal   = "#a9b1d6",
    tasklist_bg_focus    = "#24283b",
    tasklist_fg_focus    = "#7aa2f7",
    tasklist_bg_urgent   = "#f7768e",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#16161e",
    tasklist_fg_minimize = "#565f89",

    -- Context Menu
    menu_bg_normal    = "#1a1b26f8",
    menu_bg_focus     = "#24283b",
    menu_fg_normal    = "#a9b1d6",
    menu_fg_focus     = "#7aa2f7",
    menu_border_color = "#7aa2f7",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#1a1b26f8",
    hotkeys_fg           = "#a9b1d6",
    hotkeys_border_color = "#7aa2f7",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ff9e64",
    hotkeys_label_bg     = "#24283b",
    hotkeys_label_fg     = "#7aa2f7",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#1a1b26",
    titlebar_bg_focus  = "#24283b",
    titlebar_fg_normal = "#565f89",
    titlebar_fg_focus  = "#7aa2f7",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/slime.jpg",
    layout_color = "#7aa2f7",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#7aa2f7",
        temp_ok    = "#7dcfff",
        temp_hot   = "#f7768e",
        gpu        = "#bb9af7",
        sys        = "#c0caf5",
        net_ok     = "#73daca",
        net_off    = "#f7768e",
        vol_ok     = "#c0caf5",
        vol_mute   = "#f7768e",
        bat_ok     = "#73daca",
        bat_chg    = "#e0af68",
        bat_warn   = "#ff9e64",
        bat_crit   = "#f7768e",
        bat_badge  = "#7aa2f7",
        pill_bg1   = "#1f2335",
        pill_bg2   = "#16161e",
        pill_fg    = "#c0caf5",
        pill_bdr   = "#3b4261",
        pill_bw    = 1,
    },

    -- 6. Bar Layout & Geometry
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_border_w   = 1,
    task_border_col = "#3b4261",

    -- 7. Window Geometry & Masks
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    notification_presets = {
        normal = {
            bg           = "#1a1b26f5",
            fg           = "#c0caf5",
            border_color = "#7aa2f7",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#241820f8",
            fg           = "#ffffff",
            border_color = "#f7768e",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#16161ef2",
            fg           = "#7aa2f7",
            border_color = "#3b4261",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
