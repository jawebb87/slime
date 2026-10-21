-- ==============================================================================
-- Crust Theme: Crustpunk Drifter & Alleyway Phantom
-- ==============================================================================
-- Domain of Crust: weathered military cadet cap, heavily studded patch vest,
-- malt liquor can, cigarette haze, and faded stencil graffiti slouched beside
-- the alley dumpster.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/crust.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/crust.png"
end

local theme = {
    -- 1. Metadata
    name            = "crust",
    display_name    = "Crust",
    narrative_title = "CRUST: DRIFTER & ALLEYWAY PHANTOM [CRUST//DUMPSTER]",
    narrative_body  = "Crustpunk Alley active - Crust (Super+o to cycle)",
    is_light        = false,
    has_crust_mascot = true,
    has_crust_prompt = true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Rusted steel with weathered stencil bone active borders)
    border_width    = dpi(2),
    border_normal   = "#3a322c",
    border_focus    = "#f4d06f",
    border_marked   = "#d97706",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Smoked Rust Brick & Weathered Stencil Accents)
    bg_normal       = "#1a1716ee",
    bg_focus        = "#27221f",
    bg_urgent       = "#991b1b",
    bg_minimize     = "#0f0e0f",
    bg_systray      = "#1a1716",

    fg_normal       = "#cbd5e1",
    fg_focus        = "#f5f5f4",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#a8a29e",

    -- Taglist Theming (Weathered Bone & Rusted Amber Pills)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#f4d06f",
    taglist_fg_focus    = "#0f0e0f",
    taglist_bg_urgent   = "#991b1b",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#27221f",
    taglist_fg_occupied = "#d97706",
    taglist_bg_empty    = "#1a1716aa",
    taglist_fg_empty    = "#a8a29e",
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
        shape_border_color = "#f4d06f44",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Smoked Brick Pods)
    tasklist_bg_normal   = "#1a1716dd",
    tasklist_fg_normal   = "#a8a29e",
    tasklist_bg_focus    = "#27221fee",
    tasklist_fg_focus    = "#f5f5f4",
    tasklist_bg_urgent   = "#991b1b",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0f0e0f",
    tasklist_fg_minimize = "#a8a29e",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#f4d06f66",

    -- Context Menu
    menu_bg_normal    = "#1a1716f8",
    menu_bg_focus     = "#332c27",
    menu_fg_normal    = "#cbd5e1",
    menu_fg_focus     = "#f4d06f",
    menu_border_color = "#f4d06f",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#1a1716f8",
    hotkeys_fg           = "#f5f5f4",
    hotkeys_border_color = "#f4d06f",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#d97706",
    hotkeys_label_bg     = "#27221f",
    hotkeys_label_fg     = "#f4d06f",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#1a1716",
    titlebar_bg_focus  = "#27221f",
    titlebar_fg_normal = "#a8a29e",
    titlebar_fg_focus  = "#f4d06f",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#f4d06f",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#f4d06f",
        temp_ok    = "#d97706",
        temp_hot   = "#991b1b",
        gpu        = "#38bdf8",
        sys        = "#f5f5f4",
        net_ok     = "#65a30d",
        net_off    = "#991b1b",
        vol_ok     = "#d97706",
        vol_mute   = "#991b1b",
        bat_ok     = "#65a30d",
        bat_chg    = "#f4d06f",
        bat_warn   = "#d97706",
        bat_crit   = "#991b1b",
        bat_badge  = "#f4d06f",
        pill_bg1   = "#1a1716ee",
        pill_bg2   = "#0f0e0fee",
        pill_fg    = "#f5f5f4",
        pill_bdr   = "#f4d06f55",
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
            bg           = "#1a1716f5",
            fg           = "#f5f5f4",
            border_color = "#f4d06f",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2e0f12f8",
            fg           = "#ffffff",
            border_color = "#991b1b",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#0f0e0ff2",
            fg           = "#d97706",
            border_color = "#3a322c",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
