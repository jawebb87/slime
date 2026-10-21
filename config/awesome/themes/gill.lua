-- ==============================================================================
-- Baron von Gill Theme: Subterranean Grotto & Bioluminescence
-- ==============================================================================
-- Home of Baron von Gill - the dapper axolotl aristocrat.
-- Deep subterranean cavern rock, abyssal pools, and luminous glowing aquamarine
-- bioluminescence with warm coral gill and antique gold monocle accents.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/gill.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/gill.png"
end

local theme = {
    -- 1. Metadata
    name            = "gill",
    display_name    = "Baron von Gill",
    narrative_title = "BARON VON GILL: SUBTERRANEAN GROTTO [GROTTO//BIOLUM]",
    narrative_body  = "Subterranean Grotto active - Home of Baron von Gill (Super+o to cycle)",
    is_light        = false,
    has_gill_mascot = true,
    has_gill_prompt = true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Deep cavern slate with luminous cyan active borders)
    border_width    = dpi(2),
    border_normal   = "#0c1520",
    border_focus    = "#00f5d4",
    border_marked   = "#fb7185",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Subterranean Cavern & Bioluminescent Accents)
    bg_normal       = "#0c1520ee",
    bg_focus        = "#122030",
    bg_urgent       = "#f43f5e",
    bg_minimize     = "#070b10",
    bg_systray      = "#0c1520",

    fg_normal       = "#cbd5e1",
    fg_focus        = "#f8fafc",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#475569",

    -- Taglist Theming (Bioluminescent Grotto Pods)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#00f5d4",
    taglist_fg_focus    = "#070b10",
    taglist_bg_urgent   = "#f43f5e",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#13202e",
    taglist_fg_occupied = "#38bdf8",
    taglist_bg_empty    = "#0c1520aa",
    taglist_fg_empty    = "#475569",
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
        shape_border_color = "#00f5d444",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Deep Water Glass Pods)
    tasklist_bg_normal   = "#0c1520dd",
    tasklist_fg_normal   = "#94a3b8",
    tasklist_bg_focus    = "#122030ee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#f43f5e",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#070b10",
    tasklist_fg_minimize = "#475569",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#00f5d466",

    -- Context Menu
    menu_bg_normal    = "#0c1520f8",
    menu_bg_focus     = "#16283d",
    menu_fg_normal    = "#cbd5e1",
    menu_fg_focus     = "#00f5d4",
    menu_border_color = "#00f5d4",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#0c1520f8",
    hotkeys_fg           = "#cbd5e1",
    hotkeys_border_color = "#00f5d4",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#fbbf24",
    hotkeys_label_bg     = "#13202e",
    hotkeys_label_fg     = "#00f5d4",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#0c1520",
    titlebar_bg_focus  = "#122030",
    titlebar_fg_normal = "#475569",
    titlebar_fg_focus  = "#00f5d4",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#00f5d4",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#00f5d4",
        temp_ok    = "#5eead4",
        temp_hot   = "#fb7185",
        gpu        = "#38bdf8",
        sys        = "#cbd5e1",
        net_ok     = "#34d399",
        net_off    = "#f43f5e",
        vol_ok     = "#e0fbfc",
        vol_mute   = "#f43f5e",
        bat_ok     = "#00f5d4",
        bat_chg    = "#fbbf24",
        bat_warn   = "#f59e0b",
        bat_crit   = "#f43f5e",
        bat_badge  = "#00f5d4",
        pill_bg1   = "#0c1520ee",
        pill_bg2   = "#070b10ee",
        pill_fg    = "#cbd5e1",
        pill_bdr   = "#00f5d455",
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
            bg           = "#0c1520f5",
            fg           = "#e2e8f0",
            border_color = "#00f5d4",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#241018f8",
            fg           = "#ffffff",
            border_color = "#fb7185",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#070b10f2",
            fg           = "#5eead4",
            border_color = "#16283d",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
