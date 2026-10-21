-- Standalone: The Shredder (Gunmetal, Razor Angles & Ripper Teeth)
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "shred",
    display_name    = "The Shredder",
    narrative_title = "Standalone: THE SHREDDER [SHRED//RPM]",
    narrative_body  = "Gunmetal, Razor Angles & Rotary Ripper Teeth active (Super+o to cycle)",

    -- Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- Core Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#242a34aa",
    border_focus    = "#c8d0dccc",
    border_marked   = "#ff2a2acc",
    useless_gap     = dpi(6),

    -- Core Color Palette
    bg_normal       = "#0b0c0ef5",
    bg_focus        = "#1c2129",
    bg_urgent       = "#ff2a2a",
    bg_minimize     = "#111318",
    bg_systray      = "#0b0c0e",

    fg_normal       = "#c8d0dc",
    fg_focus        = "#ffffff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#525b69",

    -- Taglist Theming
    taglist_bg_focus    = "#242a34",
    taglist_fg_focus    = "#ff2a2a",
    taglist_bg_urgent   = "#ff2a2a",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#14171c",
    taglist_fg_occupied = "#e2e8f0",
    taglist_bg_empty    = "#0b0c0e",
    taglist_fg_empty    = "#4a5260",

    -- Tasklist Theming
    tasklist_bg_normal   = "#14171c",
    tasklist_fg_normal   = "#8b95a5",
    tasklist_bg_focus    = "#242a34",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff2a2a",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0b0c0e",
    tasklist_fg_minimize = "#4a5260",

    -- Context Menu Theming
    menu_bg_normal    = "#0b0c0ef8",
    menu_bg_focus     = "#242a34",
    menu_fg_normal    = "#c8d0dc",
    menu_fg_focus     = "#ffffff",
    menu_border_color = "#c8d0dc",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#0b0c0ef8",
    hotkeys_fg           = "#d8dee9",
    hotkeys_border_color = "#c8d0dc",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ff5500",
    hotkeys_label_bg     = "#242a34",
    hotkeys_label_fg     = "#ff2a2a",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#0b0c0e",
    titlebar_bg_focus  = "#1c2129",
    titlebar_fg_normal = "#525b69",
    titlebar_fg_focus  = "#e2e8f0",

    -- Wallpaper & Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/shred.jpg",
    layout_color = "#c8d0dc",

    -- Telemetry Palette
    palette = {
        cpu        = "#e2e8f0",
        temp_ok    = "#8b95a5",
        temp_hot   = "#ff2a2a",
        gpu        = "#ff5500",
        sys        = "#c8d0dc",
        net_ok     = "#e2e8f0",
        net_off    = "#ff2a2a",
        vol_ok     = "#c8d0dc",
        vol_mute   = "#ff2a2a",
        bat_ok     = "#c8d0dc",
        bat_chg    = "#ff5500",
        bat_warn   = "#ff5500",
        bat_crit   = "#ff2a2a",
        bat_badge  = "#8b95a5",
        pill_bg1   = "#16191f",
        pill_bg2   = "#111318",
        pill_fg    = "#e2e8f0",
        pill_bdr   = "#4a5260",
        pill_bw    = 1,
    },

    -- Top Bar Styling
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_shred_bar_bg(),
    pill_shape_fn   = function(seed) return slime_shapes.shred_pill(7, seed) end,
    task_shape      = slime_shapes.shred_pill(6, 4.2),
    task_border_w   = 1,
    task_border_col = "#4a5260",

    -- Window Styling & Signals
    window_style    = "chamfer",
    window_shape_fn = slime_shapes.shred_window(12),

    -- Notifications
    notification_shape = slime_shapes.shred_window(10),
    notification_presets = {
        normal = {
            bg           = "#0b0c0ef6",
            fg           = "#e2e8f0",
            border_color = "#c8d0dc",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#1c2129f8",
            fg           = "#ffffff",
            border_color = "#ff2a2a",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#0b0c0ef2",
            fg           = "#8b95a5",
            border_color = "#4a5260",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
