-- Mothgomery: Gill's companion in a lamplit cavern workshop.
-- Shared glass pods and geometry; brass, parchment, copper, and fungal teal.
local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/mothgomery.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/mothgomery.png"
end

local theme = {
    -- 1. Metadata
    name            = "mothgomery",
    display_name    = "Mothgomery",
    narrative_title = "MOTHGOMERY: LAMPLIT WORKSHOP [WORKSHOP//LAMPLIGHT]",
    narrative_body  = "Lamplit Workshop active - Mothgomery at the workbench (Super+o to cycle)",
    is_light        = false,
    companion_label = "MOTH",
    companion_accent = "#e8bb76",
    companion_bg = "#142a30",
    companion_image = "mothgomery_head.svg",
    companion_console = "mothgomery-pad",
    has_gill_mascot = true,
    has_gill_prompt = true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Deep cavern slate with warm brass active borders)
    border_width    = dpi(2),
    border_normal   = "#142a30",
    border_focus    = "#e8bb76",
    border_marked   = "#df9774",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Workshop Cavern & Lamplight Accents)
    bg_normal       = "#142a30ee",
    bg_focus        = "#203b40",
    bg_urgent       = "#c96c59",
    bg_minimize     = "#091519",
    bg_systray      = "#142a30",

    fg_normal       = "#efdfbf",
    fg_focus        = "#fff1d5",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#9b9e8c",

    -- Taglist Theming (Lamplit Workshop Pods)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#e8bb76",
    taglist_fg_focus    = "#091519",
    taglist_bg_urgent   = "#c96c59",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#254148",
    taglist_fg_occupied = "#75c9c7",
    taglist_bg_empty    = "#142a30aa",
    taglist_fg_empty    = "#9b9e8c",
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
        shape_border_color = "#e8bb7644",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Workshop Glass Pods)
    tasklist_bg_normal   = "#142a30dd",
    tasklist_fg_normal   = "#c2b69e",
    tasklist_bg_focus    = "#203b40ee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#c96c59",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#091519",
    tasklist_fg_minimize = "#9b9e8c",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#e8bb7666",

    -- Context Menu
    menu_bg_normal    = "#142a30f8",
    menu_bg_focus     = "#304e51",
    menu_fg_normal    = "#efdfbf",
    menu_fg_focus     = "#e8bb76",
    menu_border_color = "#e8bb76",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#142a30f8",
    hotkeys_fg           = "#efdfbf",
    hotkeys_border_color = "#e8bb76",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#f3d395",
    hotkeys_label_bg     = "#254148",
    hotkeys_label_fg     = "#e8bb76",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#142a30",
    titlebar_bg_focus  = "#203b40",
    titlebar_fg_normal = "#9b9e8c",
    titlebar_fg_focus  = "#e8bb76",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#e8bb76",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#e8bb76",
        temp_ok    = "#a0e3d0",
        temp_hot   = "#df9774",
        gpu        = "#75c9c7",
        sys        = "#efdfbf",
        net_ok     = "#a9c593",
        net_off    = "#c96c59",
        vol_ok     = "#c5e8dc",
        vol_mute   = "#c96c59",
        bat_ok     = "#e8bb76",
        bat_chg    = "#f3d395",
        bat_warn   = "#c99b5c",
        bat_crit   = "#c96c59",
        bat_badge  = "#e8bb76",
        pill_bg1   = "#142a30ee",
        pill_bg2   = "#091519ee",
        pill_fg    = "#efdfbf",
        pill_bdr   = "#e8bb7655",
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
            bg           = "#142a30f5",
            fg           = "#f2e3c7",
            border_color = "#e8bb76",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#352328f8",
            fg           = "#ffffff",
            border_color = "#df9774",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#091519f2",
            fg           = "#a0e3d0",
            border_color = "#304e51",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
