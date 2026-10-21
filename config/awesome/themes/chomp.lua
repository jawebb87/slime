-- Standalone: "Chomp the Haxor" / CHOMP_0x Cyber-Swamp Brutalist Theme
local gears = require("gears")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "chomp",
    display_name    = "Chomp the Haxor",
    narrative_title = "Standalone: CHOMP THE HAXOR [CHOMP//0x_CHOMP]",
    narrative_body  = "Cyber-Swamp Brutalist Console & Full Couchlock active (Super+o to cycle)",

    -- Typography
    font_family     = "BigBlueTermPlus Nerd Font",
    font_size       = "10",

    -- Core Window Borders & Gaps
    border_width       = dpi(2),
    border_width_focus = dpi(3),
    border_normal      = "#16382f",
    border_focus       = "#39ff14",
    border_marked      = "#ffb000",
    useless_gap        = dpi(6),

    -- Core Color Palette
    bg_normal       = "#111415",
    bg_focus        = "#0d2822",
    bg_urgent       = "#ffb000",
    bg_minimize     = "#090c0c",
    bg_systray      = "#111415",

    fg_normal       = "#e2f5ec",
    fg_focus        = "#39ff14",
    fg_urgent       = "#000000",
    fg_minimize     = "#6f8a7e",

    -- Taglist Theming (SYS, DEV, SWAMP, ROOT, LOGS)
    tag_names           = { "SYS", "DEV", "SWAMP", "ROOT", "LOGS" },
    taglist_bg_focus    = "#39ff14",
    taglist_fg_focus    = "#0a140f",
    taglist_bg_urgent   = "#ffb000",
    taglist_fg_urgent   = "#000000",
    taglist_bg_occupied = "#182622",
    taglist_fg_occupied = "#e2f5ec",
    taglist_bg_empty    = "#111415",
    taglist_fg_empty    = "#6f8a7e",

    -- Tasklist Theming
    tasklist_bg_normal   = "#111415",
    tasklist_fg_normal   = "#e2f5ec",
    tasklist_bg_focus    = "#0d2822",
    tasklist_fg_focus    = "#39ff14",
    tasklist_bg_urgent   = "#ffb000",
    tasklist_fg_urgent   = "#000000",
    tasklist_bg_minimize = "#090c0c",
    tasklist_fg_minimize = "#6f8a7e",

    -- Context Menu Theming
    menu_bg_normal    = "#111415f8",
    menu_bg_focus     = "#0d2822",
    menu_fg_normal    = "#e2f5ec",
    menu_fg_focus     = "#39ff14",
    menu_border_color = "#39ff14",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#111415f8",
    hotkeys_fg           = "#e2f5ec",
    hotkeys_border_color = "#39ff14",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ffb000",
    hotkeys_label_bg     = "#0d2822",
    hotkeys_label_fg     = "#39ff14",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#111415",
    titlebar_bg_focus  = "#0d2822",
    titlebar_fg_normal = "#6f8a7e",
    titlebar_fg_focus  = "#39ff14",

    -- Wallpaper & Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/muskrat_raw.jpg",
    layout_color = "#39ff14",

    -- Telemetry Palette
    palette = {
        cpu        = "#39ff14",
        temp_ok    = "#39ff14",
        temp_hot   = "#ffb000",
        gpu        = "#39ff14",
        sys        = "#6ee7b7",
        net_ok     = "#39ff14",
        net_off    = "#ffb000",
        vol_ok     = "#39ff14",
        vol_mute   = "#ffb000",
        bat_ok     = "#39ff14",
        bat_chg    = "#39ff14",
        bat_warn   = "#ffb000",
        bat_crit   = "#ff3b5c",
        bat_badge  = "#0d2822",
        pill_bg1   = "#111415",
        pill_bg2   = "#111415",
        pill_fg    = "#e2f5ec",
        pill_bdr   = "#39ff14",
        pill_bw    = 1,
    },

    -- Top Bar Styling
    bar_height      = 36,
    bar_strut_top   = 36,
    bar_drip_height = 0,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_chomp_bar_bg(),
    pill_shape_fn   = function(seed) return slime_shapes.larry_widget_pod(6) end,
    task_shape      = slime_shapes.chomp_widget_pod(6),
    task_border_w   = 1,
    task_border_col = "#39ff14",

    -- Tags, Clock & Telemetry HUD format
    tag_names       = { "SYS", "DEV", "SWAMP", "ROOT", "LOGS" },
    telemetry_style = "label",
    clock_format    = "  %H:%M ",
    taglist_template = {
        {
            {
                id     = "text_role",
                widget = wibox.widget.textbox,
            },
            left   = 10,
            right  = 10,
            top    = 3,
            bottom = 3,
            widget = wibox.container.margin,
        },
        id                 = "background_role",
        widget             = wibox.container.background,
        shape              = slime_shapes.chomp_tag_wedge(8, 4),
        shape_border_width = 1,
        shape_border_color = "#39ff1444",
    },
    taglist_layout   = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Chomp mascot and launcher widgets
    has_chomp_mascot = true,
    has_chomp_prompt = true,

    -- Window Styling & Signals
    window_style    = "chamfer",
    window_shape_fn = slime_shapes.chomp_window(6),

    -- Notifications
    notification_shape = slime_shapes.chomp_window(6),
    notification_presets = {
        normal = {
            bg           = "#111415f8",
            fg           = "#e2f5ec",
            border_color = "#39ff14",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#240a0df8",
            fg           = "#ffffff",
            border_color = "#ff3b5c",
            border_width = 3,
            timeout      = 0,
        },
        low = {
            bg           = "#0d1a16f2",
            fg           = "#6ee7b7",
            border_color = "#16382f",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
