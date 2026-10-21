-- ==============================================================================
-- Dino Might Theme: Radioactive Bruiser & Street Riot
-- ==============================================================================
-- Domain of Dino Might: powerhouse punk bruiser with heavy afro, dark circular
-- shades, studded leather cut-off vest, spiked baseball bat, and radioactive
-- toxic lime pants standing before dripping "DINO MIGHT" street graffiti.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/dino.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/dino.png"
end

local theme = {
    -- 1. Metadata
    name            = "dino",
    display_name    = "Dino Might",
    narrative_title = "DINO MIGHT: BRUISER & STREET RIOT [RADIOACTIVE//MIGHT]",
    narrative_body  = "Radioactive Street Riot active - Dino Might (Super+o to cycle)",
    is_light        = false,
    has_dino_mascot = true,
    has_dino_prompt = true,

    -- 2. Typography
    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Mortar slate with radioactive toxic lime active borders)
    border_width    = dpi(2),
    border_normal   = "#2e2d36",
    border_focus    = "#76ff03",
    border_marked   = "#ff6d00",
    useless_gap     = dpi(7),

    -- 4. Core Window & Widget Palette (Smoked Studded Leather & Radioactive Accents)
    bg_normal       = "#16161aee",
    bg_focus        = "#222228",
    bg_urgent       = "#ff1744",
    bg_minimize     = "#0c0c0e",
    bg_systray      = "#16161a",

    fg_normal       = "#cbd5e1",
    fg_focus        = "#f4f4f5",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#a1a1aa",

    -- Taglist Theming (Radioactive Lime & Orange Pills)
    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#76ff03",
    taglist_fg_focus    = "#0c0c0e",
    taglist_bg_urgent   = "#ff1744",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#222228",
    taglist_fg_occupied = "#ff6d00",
    taglist_bg_empty    = "#16161aaa",
    taglist_fg_empty    = "#a1a1aa",
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
        shape_border_color = "#76ff0344",
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming (Smoked Leather Pods)
    tasklist_bg_normal   = "#16161add",
    tasklist_fg_normal   = "#a1a1aa",
    tasklist_bg_focus    = "#222228ee",
    tasklist_fg_focus    = "#f4f4f5",
    tasklist_bg_urgent   = "#ff1744",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0c0c0e",
    tasklist_fg_minimize = "#a1a1aa",
    task_shape           = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w        = 1,
    task_border_col      = "#76ff0366",

    -- Context Menu
    menu_bg_normal    = "#16161af8",
    menu_bg_focus     = "#2e2d36",
    menu_fg_normal    = "#cbd5e1",
    menu_fg_focus     = "#76ff03",
    menu_border_color = "#76ff03",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#16161af8",
    hotkeys_fg           = "#f4f4f5",
    hotkeys_border_color = "#76ff03",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ff6d00",
    hotkeys_label_bg     = "#222228",
    hotkeys_label_fg     = "#76ff03",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#16161a",
    titlebar_bg_focus  = "#222228",
    titlebar_fg_normal = "#a1a1aa",
    titlebar_fg_focus  = "#76ff03",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#76ff03",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#76ff03",
        temp_ok    = "#ff6d00",
        temp_hot   = "#ff1744",
        gpu        = "#00b0ff",
        sys        = "#f4f4f5",
        net_ok     = "#76ff03",
        net_off    = "#ff1744",
        vol_ok     = "#ff6d00",
        vol_mute   = "#ff1744",
        bat_ok     = "#76ff03",
        bat_chg    = "#ff6d00",
        bat_warn   = "#ffab00",
        bat_crit   = "#ff1744",
        bat_badge  = "#76ff03",
        pill_bg1   = "#16161aee",
        pill_bg2   = "#0c0c0eee",
        pill_fg    = "#f4f4f5",
        pill_bdr   = "#76ff0355",
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
            bg           = "#16161af5",
            fg           = "#f4f4f5",
            border_color = "#76ff03",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2e0f14f8",
            fg           = "#ffffff",
            border_color = "#ff1744",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#0c0c0ef2",
            fg           = "#ff6d00",
            border_color = "#2e2d36",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
