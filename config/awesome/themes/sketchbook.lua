local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/sketchbook.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/sketchbook.png"
end

-- A clipped paper corner keeps the silhouette loose without clipping controls.
local function paper_shape(cr, w, h)
    cr:move_to(0, 1)
    cr:line_to(w - 5, 0)
    cr:line_to(w, 4)
    cr:line_to(w - 1, h - 1)
    cr:line_to(3, h)
    cr:line_to(0, h - 3)
    cr:close_path()
end

local theme = {
    -- 1. Metadata
    name            = "sketchbook",
    display_name    = "Sketchbook",
    narrative_title = "MOTHGOMERY: NOTES IN PROGRESS",
    narrative_body  = "Sketchbook active - I was just about to... (Super+o to cycle)",
    is_light        = true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Deep cavern slate with warm brass active borders)
    border_width    = dpi(2),
    border_normal   = "#f6efdf",
    border_focus    = "#276c67",
    border_marked   = "#945b29",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Workshop Cavern & Lamplight Accents)
    bg_normal       = "#f6efdfff",
    bg_focus        = "#d2e6de",
    bg_urgent       = "#994b58",
    bg_minimize     = "#e9dfcd",
    bg_systray      = "#f6efdf",

    fg_normal       = "#343b39",
    fg_focus        = "#273331",
    fg_urgent       = "#343b39",
    fg_minimize     = "#686b60",

    -- Taglist Theming (Lamplit Workshop Pods)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#276c67",
    taglist_fg_focus    = "#e9dfcd",
    taglist_bg_urgent   = "#994b58",
    taglist_fg_urgent   = "#343b39",
    taglist_bg_occupied = "#e2e8dc",
    taglist_fg_occupied = "#2b666f",
    taglist_bg_empty    = "#f6efdfff",
    taglist_fg_empty    = "#686b60",
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
        shape              = function(cr, w, h) paper_shape(cr, w, h) end,
        shape_border_width = 1,
        shape_border_color = "#276c67ff",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Workshop Glass Pods)
    tasklist_bg_normal   = "#f6efdfff",
    tasklist_fg_normal   = "#555e57",
    tasklist_bg_focus    = "#d2e6deff",
    tasklist_fg_focus    = "#343b39",
    tasklist_bg_urgent   = "#994b58",
    tasklist_fg_urgent   = "#343b39",
    tasklist_bg_minimize = "#e9dfcd",
    tasklist_fg_minimize = "#686b60",
    task_shape           = function(cr, w, h) paper_shape(cr, w, h) end,
    task_border_w        = 1,
    task_border_col      = "#276c67ff",

    -- Context Menu
    menu_bg_normal    = "#f6efdfff",
    menu_bg_focus     = "#d0dfd5",
    menu_fg_normal    = "#343b39",
    menu_fg_focus     = "#276c67",
    menu_border_color = "#276c67",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#f6efdfff",
    hotkeys_fg           = "#343b39",
    hotkeys_border_color = "#276c67",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#86591f",
    hotkeys_label_bg     = "#e2e8dc",
    hotkeys_label_fg     = "#276c67",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#f6efdf",
    titlebar_bg_focus  = "#d2e6de",
    titlebar_fg_normal = "#686b60",
    titlebar_fg_focus  = "#276c67",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#276c67",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#276c67",
        temp_ok    = "#326f60",
        temp_hot   = "#945b29",
        gpu        = "#2b666f",
        sys        = "#343b39",
        net_ok     = "#486d45",
        net_off    = "#994b58",
        vol_ok     = "#276c67",
        vol_mute   = "#994b58",
        bat_ok     = "#276c67",
        bat_chg    = "#86591f",
        bat_warn   = "#86591f",
        bat_crit   = "#994b58",
        bat_badge  = "#276c67",
        pill_bg1   = "#f6efdfff",
        pill_bg2   = "#e9dfcdff",
        pill_fg    = "#343b39",
        pill_bdr   = "#276c67ff",
        pill_bw    = 1,
    },

    -- 6. Bar Layout & Geometry
    bar_height      = 38,
    bar_strut_top   = 38,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = require("theme.sketchbook_shapes").paper,
    pill_shape_fn   = function(cr, w, h) paper_shape(cr, w, h) end,

    -- 7. Window Geometry & Masks
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) paper_shape(cr, w, h) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#f6efdfff",
            fg           = "#343b39",
            border_color = "#276c67",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#f3dce0ff",
            fg           = "#343b39",
            border_color = "#945b29",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#e9dfcdff",
            fg           = "#326f60",
            border_color = "#d0dfd5",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
