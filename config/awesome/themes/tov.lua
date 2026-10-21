-- ==============================================================================
-- Molly Tov Theme: Street Riot & Burning Anarchy
-- ==============================================================================
-- Domain of Molly Tov: acid green mohawk, patched denim battle vest, and a
-- flaming Molotov cocktail lighting up the smoky night streets.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/tov.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/tov.png"
end

local theme = {
    -- 1. Metadata
    name            = "tov",
    display_name    = "Molly Tov",
    narrative_title = "MOLLY TOV: STREET RIOT & ANARCHY [ANARCHY//TOV]",
    narrative_body  = "Street Riot active - Molly Tov (Super+o to cycle)",
    is_light        = false,
    has_tov_mascot  = true,
    has_tov_prompt  = true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Urban slate with flaming molotov amber active borders)
    border_width    = dpi(2),
    border_normal   = "#2d272a",
    border_focus    = "#f77f00",
    border_marked   = "#e63946",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Smoky Grime & Fiery Accents)
    bg_normal       = "#1e1a1cee",
    bg_focus        = "#2d272a",
    bg_urgent       = "#e63946",
    bg_minimize     = "#0f0d0e",
    bg_systray      = "#1e1a1c",

    fg_normal       = "#cbd5e1",
    fg_focus        = "#f1faee",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#a8dadc",

    -- Taglist Theming (Molotov Flare Pills)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#f77f00",
    taglist_fg_focus    = "#0f0d0e",
    taglist_bg_urgent   = "#e63946",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#2d272a",
    taglist_fg_occupied = "#fcbf49",
    taglist_bg_empty    = "#1e1a1caa",
    taglist_fg_empty    = "#a8dadc",
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
        shape_border_color = "#f77f0044",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Smoky Ashen Pods)
    tasklist_bg_normal   = "#1e1a1cdd",
    tasklist_fg_normal   = "#a8dadc",
    tasklist_bg_focus    = "#2d272aee",
    tasklist_fg_focus    = "#f1faee",
    tasklist_bg_urgent   = "#e63946",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0f0d0e",
    tasklist_fg_minimize = "#a8dadc",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#f77f0066",

    -- Context Menu
    menu_bg_normal    = "#1e1a1cf8",
    menu_bg_focus     = "#352c30",
    menu_fg_normal    = "#cbd5e1",
    menu_fg_focus     = "#f77f00",
    menu_border_color = "#f77f00",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#1e1a1cf8",
    hotkeys_fg           = "#f1faee",
    hotkeys_border_color = "#f77f00",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#fcbf49",
    hotkeys_label_bg     = "#2d272a",
    hotkeys_label_fg     = "#f77f00",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#1e1a1c",
    titlebar_bg_focus  = "#2d272a",
    titlebar_fg_normal = "#a8dadc",
    titlebar_fg_focus  = "#f77f00",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#f77f00",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#f77f00",
        temp_ok    = "#fcbf49",
        temp_hot   = "#e63946",
        gpu        = "#457b9d",
        sys        = "#f1faee",
        net_ok     = "#70e000",
        net_off    = "#e63946",
        vol_ok     = "#fcbf49",
        vol_mute   = "#e63946",
        bat_ok     = "#70e000",
        bat_chg    = "#fcbf49",
        bat_warn   = "#f77f00",
        bat_crit   = "#e63946",
        bat_badge  = "#f77f00",
        pill_bg1   = "#1e1a1cee",
        pill_bg2   = "#0f0d0eee",
        pill_fg    = "#f1faee",
        pill_bdr   = "#f77f0055",
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
            bg           = "#1e1a1cf5",
            fg           = "#f1faee",
            border_color = "#f77f00",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2a0d10f8",
            fg           = "#ffffff",
            border_color = "#e63946",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#0f0d0ef2",
            fg           = "#fcbf49",
            border_color = "#2d272a",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
