local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/jaws.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/jaws.png"
end

local theme = {
    -- 1. Metadata
    name            = "jaws",
    display_name    = "Grindhouse JAWS",
    narrative_title = "GRINDHOUSE JAWS: TERROR FROM THE DEEP",
    narrative_body  = "You are going to need a bigger boat. (Super+o to cycle)",
    is_light        = false,
    companion_label = "JAWS",
    companion_accent = "#e8bd4e",
    companion_bg = "#14252d",
    has_gill_prompt = true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Deep cavern slate with warm brass active borders)
    border_width    = dpi(2),
    border_normal   = "#14252d",
    border_focus    = "#e8bd4e",
    border_marked   = "#ef7160",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Workshop Cavern & Lamplight Accents)
    bg_normal       = "#14252dee",
    bg_focus        = "#263b43",
    bg_urgent       = "#ad3933",
    bg_minimize     = "#080f14",
    bg_systray      = "#14252d",

    fg_normal       = "#ecdfbf",
    fg_focus        = "#fff0cf",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#a4aaa3",

    -- Taglist Theming (Terror from the Deep Pods)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#e8bd4e",
    taglist_fg_focus    = "#080f14",
    taglist_bg_urgent   = "#ad3933",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#2a4149",
    taglist_fg_occupied = "#7db4ba",
    taglist_bg_empty    = "#14252daa",
    taglist_fg_empty    = "#a4aaa3",
    taglist_template    = {
        {
            {
                id     = "text_role",
                widget = wibox.widget.textbox,
            },
            left   = 8,
            right  = 8,
            top    = 2,
            bottom = 2,
            widget = wibox.container.margin,
        },
        id                 = "background_role",
        widget             = wibox.container.background,
        shape              = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
        shape_border_width = 1,
        shape_border_color = "#e8bd4e44",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Workshop Glass Pods)
    tasklist_bg_normal   = "#14252ddd",
    tasklist_fg_normal   = "#c8bda6",
    tasklist_bg_focus    = "#263b43ee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ad3933",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#080f14",
    tasklist_fg_minimize = "#a4aaa3",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#e8bd4e66",

    -- Context Menu
    menu_bg_normal    = "#14252df8",
    menu_bg_focus     = "#36505a",
    menu_fg_normal    = "#ecdfbf",
    menu_fg_focus     = "#e8bd4e",
    menu_border_color = "#e8bd4e",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#14252df8",
    hotkeys_fg           = "#ecdfbf",
    hotkeys_border_color = "#e8bd4e",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#f5d675",
    hotkeys_label_bg     = "#2a4149",
    hotkeys_label_fg     = "#e8bd4e",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#14252d",
    titlebar_bg_focus  = "#263b43",
    titlebar_fg_normal = "#a4aaa3",
    titlebar_fg_focus  = "#e8bd4e",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#e8bd4e",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#e8bd4e",
        temp_ok    = "#a7ceca",
        temp_hot   = "#ef7160",
        gpu        = "#7db4ba",
        sys        = "#ecdfbf",
        net_ok     = "#aab987",
        net_off    = "#ad3933",
        vol_ok     = "#c4d7ce",
        vol_mute   = "#ad3933",
        bat_ok     = "#e8bd4e",
        bat_chg    = "#f5d675",
        bat_warn   = "#d89850",
        bat_crit   = "#ad3933",
        bat_badge  = "#e8bd4e",
        pill_bg1   = "#14252dee",
        pill_bg2   = "#080f14ee",
        pill_fg    = "#ecdfbf",
        pill_bdr   = "#e8bd4e55",
        pill_bw    = 1,
    },

    -- 6. Bar Layout & Geometry
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 7. Window Geometry & Masks
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#14252df5",
            fg           = "#ecdfbf",
            border_color = "#e8bd4e",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#351c22f8",
            fg           = "#ffffff",
            border_color = "#ef7160",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#080f14f2",
            fg           = "#a7ceca",
            border_color = "#36505a",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
