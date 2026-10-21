local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/eeyore.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/eeyore.png"
end

local theme = {
    name            = "eeyore",
    display_name    = "Eeyore — Watercolor Sky",
    narrative_title = "EEYORE: WATERCOLOR SKY",
    narrative_body  = "A little sky. A little quiet. (Super+o to cycle)",
    is_light        = true,
    companion_label = "SKY",
    companion_accent = "#326d8b",
    companion_bg = "#e7efee",
    has_gill_prompt = true,

    font_family     = "Noto Sans",
    font_size       = "10",

    border_width    = dpi(2),
    border_normal   = "#e7efee",
    border_focus    = "#326d8b",
    border_marked   = "#a34f69",
    useless_gap     = dpi(7),

    bg_normal       = "#e7efee",
    bg_focus        = "#d6e8ee",
    bg_urgent       = "#974f68",
    bg_minimize     = "#e0e7e7",
    bg_systray      = "#e7efee",

    fg_normal       = "#34444e",
    fg_focus        = "#253540",
    fg_urgent       = "#253540",
    fg_minimize     = "#697d85",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#326d8b",
    taglist_fg_focus    = "#e0e7e7",
    taglist_bg_urgent   = "#974f68",
    taglist_fg_urgent   = "#253540",
    taglist_bg_occupied = "#dce7e5",
    taglist_fg_occupied = "#477666",
    taglist_bg_empty    = "#e7efeeaa",
    taglist_fg_empty    = "#697d85",
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
        shape_border_width = 0,
        shape_border_color = "#326d8b44",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    tasklist_bg_normal   = "#e7efeedd",
    tasklist_fg_normal   = "#526774",
    tasklist_bg_focus    = "#d6e8eeee",
    tasklist_fg_focus    = "#253540",
    tasklist_bg_urgent   = "#974f68",
    tasklist_fg_urgent   = "#253540",
    tasklist_bg_minimize = "#e0e7e7",
    tasklist_fg_minimize = "#697d85",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 0,
    task_border_col      = "#326d8b66",

    menu_bg_normal    = "#e7efeef8",
    menu_bg_focus     = "#cadde4",
    menu_fg_normal    = "#34444e",
    menu_fg_focus     = "#326d8b",
    menu_border_color = "#326d8b",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#e7efeef8",
    hotkeys_fg           = "#34444e",
    hotkeys_border_color = "#326d8b",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#866a2e",
    hotkeys_label_bg     = "#dce7e5",
    hotkeys_label_fg     = "#326d8b",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#e7efee",
    titlebar_bg_focus  = "#d6e8ee",
    titlebar_fg_normal = "#697d85",
    titlebar_fg_focus  = "#326d8b",

    wallpaper    = wp_path,
    layout_color = "#326d8b",

    palette = {
        cpu        = "#326d8b",
        temp_ok    = "#4d796d",
        temp_hot   = "#a34f69",
        gpu        = "#477666",
        sys        = "#34444e",
        net_ok     = "#59784b",
        net_off    = "#974f68",
        vol_ok     = "#477666",
        vol_mute   = "#974f68",
        bat_ok     = "#326d8b",
        bat_chg    = "#866a2e",
        bat_warn   = "#947139",
        bat_crit   = "#974f68",
        bat_badge  = "#326d8b",
        pill_bg1   = "#e7efeeee",
        pill_bg2   = "#e0e7e7ee",
        pill_fg    = "#34444e",
        pill_bdr   = "#326d8b55",
        pill_bw    = 0,
    },

    bar_height      = dpi(44),
    bar_floating    = true,
    bar_compact     = true,
    bar_inset       = dpi(20),
    bar_offset      = dpi(12),
    bar_clearance   = dpi(12),
    bar_background  = "#eef5f4f2",
    bar_margin_top  = dpi(6),
    bar_margin_bottom = dpi(6),
    bar_padding_horizontal = dpi(10),
    bar_strut_top   = dpi(68),
    is_flat         = true,
    bar_shape       = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(16)) end,
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#e7efeef5",
            fg           = "#34444e",
            border_color = "#326d8b",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#f3e0e5f8",
            fg           = "#253540",
            border_color = "#a34f69",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#e0e7e7f2",
            fg           = "#4d796d",
            border_color = "#cadde4",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
