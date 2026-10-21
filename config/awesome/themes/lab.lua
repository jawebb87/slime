-- Act I: Pre-Contamination (Laboratory White)
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "lab",
    display_name    = "Laboratory White",
    act             = "Act I",
    narrative_title = "Act I: PRE-CONTAMINATION [LAB//SYS]",
    narrative_body  = "Laboratory White theme active (Super+o to cycle)",
    is_light        = true,

    -- Typography
    font_family     = "ShureTechMono Nerd Font",
    font_size       = "10",

    -- Core Window Borders & Gaps
    border_width    = dpi(3),
    border_normal   = "#475569",
    border_focus    = "#000000",
    border_marked   = "#dc2626",
    useless_gap     = dpi(6),

    -- Core Color Palette (Sterile white & stark jet-black)
    bg_normal       = "#f4f6f8f5",
    bg_focus        = "#0a0c0e",
    bg_urgent       = "#dc2626",
    bg_minimize     = "#e2e8f0",
    bg_systray      = "#f4f6f8",

    fg_normal       = "#0a0c0e",
    fg_focus        = "#ffffff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#64748b",

    -- Taglist Theming
    taglist_bg_focus    = "#0a0c0e",
    taglist_fg_focus    = "#ffffff",
    taglist_bg_urgent   = "#dc2626",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#dde4ec",
    taglist_fg_occupied = "#0a0c0e",
    taglist_bg_empty    = "#ffffff",
    taglist_fg_empty    = "#94a3b8",

    -- Tasklist Theming
    tasklist_bg_normal   = "#ffffff",
    tasklist_fg_normal   = "#334155",
    tasklist_bg_focus    = "#0a0c0e",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#dc2626",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#e2e8f0",
    tasklist_fg_minimize = "#64748b",

    -- Context Menu Theming
    menu_bg_normal    = "#ffffff",
    menu_bg_focus     = "#0a0c0e",
    menu_fg_normal    = "#0a0c0e",
    menu_fg_focus     = "#ffffff",
    menu_border_color = "#000000",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#ffffff",
    hotkeys_fg           = "#0a0c0e",
    hotkeys_border_color = "#000000",
    hotkeys_border_width = dpi(3),
    hotkeys_modifiers_fg = "#0284c7",
    hotkeys_label_bg     = "#0a0c0e",
    hotkeys_label_fg     = "#ffffff",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#e2e8f0",
    titlebar_bg_focus  = "#ffffff",
    titlebar_fg_normal = "#475569",
    titlebar_fg_focus  = "#0a0c0e",

    -- Wallpaper & Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/lab.jpg",
    layout_color = "#0a0c0e",

    -- Telemetry Palette
    palette = {
        cpu        = "#0a0c0e",
        temp_ok    = "#0284c7",
        temp_hot   = "#dc2626",
        gpu        = "#0369a1",
        sys        = "#0a0c0e",
        net_ok     = "#0a0c0e",
        net_off    = "#dc2626",
        vol_ok     = "#0a0c0e",
        vol_mute   = "#dc2626",
        bat_ok     = "#0a0c0e",
        bat_chg    = "#0284c7",
        bat_warn   = "#b45309",
        bat_crit   = "#dc2626",
        bat_badge  = "#0284c7",
        pill_bg1   = "#ffffff",
        pill_bg2   = "#f8fafc",
        pill_fg    = "#0a0c0e",
        pill_bdr   = "#000000",
        pill_bw    = 2,
    },

    -- Top Bar Styling
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_lab_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_border_w   = 2,
    task_border_col = "#000000",

    -- Window Styling & Signals
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,

    -- Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    notification_presets = {
        normal = {
            bg           = "#ffffff",
            fg           = "#0a0c0e",
            border_color = "#000000",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#fef2f2",
            fg           = "#991b1b",
            border_color = "#dc2626",
            border_width = 3,
            timeout      = 0,
        },
        low = {
            bg           = "#f8fafc",
            fg           = "#334155",
            border_color = "#475569",
            border_width = 2,
            timeout      = 4,
        },
    },
}

return theme
