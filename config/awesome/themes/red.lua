-- ==============================================================================
-- Doom Theme ("Rip & Tear" / DOOM 1993 & Eternal Cyber-Demonic Aesthetic)
-- ==============================================================================
-- Deep scorched obsidian, infernal blood crimson, molten lava and crucible amber.
-- In terminal: Red is mapped to green so errors stand out with stark contrast.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/red.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/shred.jpg"
end

local theme = {
    -- 1. Metadata
    name            = "red",
    display_name    = "Doom (Rip & Tear)",
    narrative_title = "DOOM: KNEE-DEEP IN THE DEAD [DOOM//BFG]",
    narrative_body  = "Infernal Crimson, Brimstone & Praetor Obsidian active (Super+o to cycle)",

    -- 2. Typography
    font_family     = "GohuFont 11 Nerd Font",
    font_size       = "11",

    -- 3. Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#48161e",
    border_focus    = "#ff1a2a",
    border_marked   = "#ffaa00",
    useless_gap     = dpi(6),

    -- 4. Core Window & Widget Palette (Obsidian & Infernal Crimson)
    bg_normal       = "#0e0708f5",
    bg_focus        = "#2e0d13",
    bg_urgent       = "#ff1a2a",
    bg_minimize     = "#1c090c",
    bg_systray      = "#0e0708",

    fg_normal       = "#faebe8",
    fg_focus        = "#ffffff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#ba6874",

    -- Taglist
    taglist_bg_focus    = "#380e15",
    taglist_fg_focus    = "#ffffff",
    taglist_bg_urgent   = "#ff1a2a",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#240b10",
    taglist_fg_occupied = "#ff6b7d",
    taglist_bg_empty    = "#0e0708",
    taglist_fg_empty    = "#9e4854",

    -- Tasklist
    tasklist_bg_normal   = "#1a080c",
    tasklist_fg_normal   = "#faebe8",
    tasklist_bg_focus    = "#380e15",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff1a2a",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0e0708",
    tasklist_fg_minimize = "#ba6874",

    -- Context Menu
    menu_bg_normal    = "#0e0708f8",
    menu_bg_focus     = "#380e15",
    menu_fg_normal    = "#faebe8",
    menu_fg_focus     = "#ffffff",
    menu_border_color = "#ff1a2a",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#0e0708f8",
    hotkeys_fg           = "#faebe8",
    hotkeys_border_color = "#ff1a2a",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ffaa00",
    hotkeys_label_bg     = "#380e15",
    hotkeys_label_fg     = "#ffffff",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#0e0708",
    titlebar_bg_focus  = "#2e0d13",
    titlebar_fg_normal = "#9e4854",
    titlebar_fg_focus  = "#ffffff",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#ff2a2a",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#ff3b4b",
        temp_ok    = "#ffaa33",
        temp_hot   = "#ff1a2a",
        gpu        = "#ff6075",
        sys        = "#faebe8",
        net_ok     = "#38bdf8",
        net_off    = "#ff5500",
        vol_ok     = "#faebe8",
        vol_mute   = "#ba6874",
        bat_ok     = "#ff556b",
        bat_chg    = "#ffd033",
        bat_warn   = "#ff9900",
        bat_crit   = "#39ff14",
        bat_badge  = "#ff2a2a",
        pill_bg1   = "#20090c",
        pill_bg2   = "#180608",
        pill_fg    = "#ffffff",
        pill_bdr   = "#ffaa00",
        pill_bw    = 1,
    },

    -- 6. Bar Layout & Geometry (Physical Rust-Red Bulkhead with Gold Accents & Drop Shadow)
    bar_height             = 52,
    bar_strut_top          = 52,
    bar_drip_height        = 20,
    is_flat                = false,
    bar_pod_left_width     = 210,
    bar_pod_right_width    = 880,
    bar_pod_height         = 52,
    bar_mid_height         = 32,
    bar_chamfer            = 12,
    bar_shape              = slime_shapes.red_bar_shape(210, 880, 52, 32, 12),
    bar_bgimage            = slime_shapes.render_red_bar_bg(210, 880, 52, 32, 12),
    pill_shape_fn          = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 3) end,
    task_shape             = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 3) end,
    task_border_w          = 1,
    task_border_col        = "#ffaa00",

    -- 7. Window Geometry & Masks (Aggressive chamfers)
    window_style    = "chamfer",
    window_shape_fn = slime_shapes.shred_window(8),

    -- 8. Notifications
    notification_shape = slime_shapes.shred_window(6),
    notification_presets = {
        normal = {
            bg           = "#160709f6",
            fg           = "#faebe8",
            border_color = "#ff1a2a",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2e090df8",
            fg           = "#ffffff",
            border_color = "#ffaa00",
            border_width = 3,
            timeout      = 0,
        },
        low = {
            bg           = "#160709f2",
            fg           = "#ff6b7d",
            border_color = "#8a2430",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
