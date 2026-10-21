-- ==============================================================================
-- Miss Rable Theme: Neon Punk Alleyway & Wet Asphalt
-- ==============================================================================
-- Domain of Miss Rable: spiked leather jackets, chains, and safety pins in a
-- rainy urban alleyway ablaze with dripping neon magenta and electric cyan graffiti.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/rable.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/rable.png"
end

local theme = {
    -- 1. Metadata
    name            = "rable",
    display_name    = "Miss Rable",
    narrative_title = "MISS RABLE: NEON PUNK ALLEYWAY [PUNK//RIOT]",
    narrative_body  = "Neon Punk Alleyway active - Miss Rable (Super+o to cycle)",
    is_light        = false,
    has_rable_mascot= true,
    has_rable_prompt= true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Leather shadow with hot neon magenta active borders)
    border_width    = dpi(2),
    border_normal   = "#181424",
    border_focus    = "#ff2a85",
    border_marked   = "#00f0ff",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Wet Asphalt & Dripping Neon)
    bg_normal       = "#12101bee",
    bg_focus        = "#1c152e",
    bg_urgent       = "#ff2a85",
    bg_minimize     = "#07050a",
    bg_systray      = "#12101b",

    fg_normal       = "#cbd5e1",
    fg_focus        = "#ffffff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#5a5261",

    -- Taglist Theming (Neon Graffiti Pills)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#ff2a85",
    taglist_fg_focus    = "#ffffff",
    taglist_bg_urgent   = "#00f0ff",
    taglist_fg_urgent   = "#07050a",
    taglist_bg_occupied = "#1a1628",
    taglist_fg_occupied = "#00f0ff",
    taglist_bg_empty    = "#12101baa",
    taglist_fg_empty    = "#5a5261",
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
        shape_border_color = "#ff2a8544",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Smoked Leather Pods)
    tasklist_bg_normal   = "#12101bdd",
    tasklist_fg_normal   = "#94a3b8",
    tasklist_bg_focus    = "#1c152eee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff2a85",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#07050a",
    tasklist_fg_minimize = "#5a5261",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#ff2a8566",

    -- Context Menu
    menu_bg_normal    = "#12101bf8",
    menu_bg_focus     = "#241a38",
    menu_fg_normal    = "#cbd5e1",
    menu_fg_focus     = "#ff2a85",
    menu_border_color = "#ff2a85",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#12101bf8",
    hotkeys_fg           = "#cbd5e1",
    hotkeys_border_color = "#ff2a85",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#00f0ff",
    hotkeys_label_bg     = "#1a1628",
    hotkeys_label_fg     = "#ff2a85",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#12101b",
    titlebar_bg_focus  = "#1c152e",
    titlebar_fg_normal = "#5a5261",
    titlebar_fg_focus  = "#ff2a85",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#ff2a85",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#ff2a85",
        temp_ok    = "#00f0ff",
        temp_hot   = "#ff0055",
        gpu        = "#c084fc",
        sys        = "#e2e8f0",
        net_ok     = "#39ff14",
        net_off    = "#ff0055",
        vol_ok     = "#00f0ff",
        vol_mute   = "#ff0055",
        bat_ok     = "#39ff14",
        bat_chg    = "#ffb000",
        bat_warn   = "#ff8800",
        bat_crit   = "#ff0055",
        bat_badge  = "#ff2a85",
        pill_bg1   = "#12101bee",
        pill_bg2   = "#07050aee",
        pill_fg    = "#cbd5e1",
        pill_bdr   = "#ff2a8555",
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
            bg           = "#12101bf5",
            fg           = "#e2e8f0",
            border_color = "#ff2a85",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2b0a16f8",
            fg           = "#ffffff",
            border_color = "#00f0ff",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#07050af2",
            fg           = "#00f0ff",
            border_color = "#241c38",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
