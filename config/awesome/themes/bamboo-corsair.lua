local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/bamboo-corsair.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/bamboo-corsair.png"
end

local theme = {
    name            = "bamboo-corsair",
    display_name    = "The Bamboo Corsair",
    narrative_title = "THE BAMBOO CORSAIR",
    narrative_body  = "Raise the bamboo flag. Follow the ghost lanterns. (Super+o to cycle)",
    is_light        = false,
    companion_label = "CORSAIR",
    companion_accent = "#91e66d",
    companion_bg = "#211531",
    has_gill_prompt = true,

    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    border_width    = dpi(2),
    border_normal   = "#211531",
    border_focus    = "#91e66d",
    border_marked   = "#ef8198",
    useless_gap     = dpi(7),

    bg_normal       = "#211531ee",
    bg_focus        = "#352049",
    bg_urgent       = "#ad4e79",
    bg_minimize     = "#090c19",
    bg_systray      = "#211531",

    fg_normal       = "#d9efcf",
    fg_focus        = "#edffe2",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#9a9cac",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#91e66d",
    taglist_fg_focus    = "#090c19",
    taglist_bg_urgent   = "#ad4e79",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#39264e",
    taglist_fg_occupied = "#76cda8",
    taglist_bg_empty    = "#211531aa",
    taglist_fg_empty    = "#9a9cac",
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
        shape_border_color = "#91e66d44",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    tasklist_bg_normal   = "#211531dd",
    tasklist_fg_normal   = "#bbcbb9",
    tasklist_bg_focus    = "#352049ee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ad4e79",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#090c19",
    tasklist_fg_minimize = "#9a9cac",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#91e66d66",

    menu_bg_normal    = "#211531f8",
    menu_bg_focus     = "#4b3562",
    menu_fg_normal    = "#d9efcf",
    menu_fg_focus     = "#91e66d",
    menu_border_color = "#91e66d",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#211531f8",
    hotkeys_fg           = "#d9efcf",
    hotkeys_border_color = "#91e66d",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#cbe889",
    hotkeys_label_bg     = "#39264e",
    hotkeys_label_fg     = "#91e66d",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#211531",
    titlebar_bg_focus  = "#352049",
    titlebar_fg_normal = "#9a9cac",
    titlebar_fg_focus  = "#91e66d",

    wallpaper    = wp_path,
    layout_color = "#91e66d",

    palette = {
        cpu        = "#91e66d",
        temp_ok    = "#a8edb4",
        temp_hot   = "#ef8198",
        gpu        = "#76cda8",
        sys        = "#d9efcf",
        net_ok     = "#73c983",
        net_off    = "#ad4e79",
        vol_ok     = "#c0edca",
        vol_mute   = "#ad4e79",
        bat_ok     = "#91e66d",
        bat_chg    = "#cbe889",
        bat_warn   = "#c9b56e",
        bat_crit   = "#ad4e79",
        bat_badge  = "#91e66d",
        pill_bg1   = "#211531ee",
        pill_bg2   = "#090c19ee",
        pill_fg    = "#d9efcf",
        pill_bdr   = "#91e66d55",
        pill_bw    = 1,
    },

    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#211531f5",
            fg           = "#d9efcf",
            border_color = "#91e66d",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#392039f8",
            fg           = "#ffffff",
            border_color = "#ef8198",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#090c19f2",
            fg           = "#a8edb4",
            border_color = "#4b3562",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
