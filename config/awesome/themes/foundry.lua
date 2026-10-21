-- Foundry: Victorian engine-room cast iron, brass, copper, and oxidized green.
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local foundry = require("theme.foundry_shapes")
local edge_depth = dpi(20)

local theme = {
    -- 1. Metadata
    name            = "foundry",
    display_name    = "Foundry — Victorian Engine Room",
    narrative_title = "FOUNDRY // ENGINE ROOM",
    narrative_body  = "Brass instruments. Cast iron. Steam pressure steady. (Super+o to cycle)",

    -- 2. Typography
    font_family     = "IosevkaTermSlab Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#4a4437",
    border_focus    = "#d3b77c",
    border_marked   = "#d57659",
    useless_gap     = dpi(6),

    -- 4. Core Window & Widget Palette
    bg_normal       = "#171b1bf5",
    bg_focus        = "#30362f",
    bg_urgent       = "#d57659",
    bg_minimize     = "#101414",
    bg_systray      = "#171b1b",

    fg_normal       = "#dfd4b9",
    fg_focus        = "#d3b77c",
    fg_urgent       = "#f7ecd2",
    fg_minimize     = "#8f9382",

    tag_names = { "I", "II", "III", "IV", "V" },

    -- Taglist
    taglist_bg_focus    = "#30362f",
    taglist_fg_focus    = "#d3b77c",
    taglist_bg_urgent   = "#d57659",
    taglist_fg_urgent   = "#f7ecd2",
    taglist_bg_occupied = "#232927",
    taglist_fg_occupied = "#e8dcc0",
    taglist_bg_empty    = "#171b1b",
    taglist_fg_empty    = "#8f9382",

    -- Tasklist
    tasklist_bg_normal   = "#232927",
    tasklist_fg_normal   = "#dfd4b9",
    tasklist_bg_focus    = "#30362f",
    tasklist_fg_focus    = "#d3b77c",
    tasklist_bg_urgent   = "#d57659",
    tasklist_fg_urgent   = "#f7ecd2",
    tasklist_bg_minimize = "#101414",
    tasklist_fg_minimize = "#8f9382",

    -- Context Menu
    menu_bg_normal    = "#171b1bf8",
    menu_bg_focus     = "#30362f",
    menu_fg_normal    = "#dfd4b9",
    menu_fg_focus     = "#d3b77c",
    menu_border_color = "#d3b77c",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#171b1bf8",
    hotkeys_fg           = "#dfd4b9",
    hotkeys_border_color = "#d3b77c",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#c38b59",
    hotkeys_label_bg     = "#30362f",
    hotkeys_label_fg     = "#d3b77c",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#171b1b",
    titlebar_bg_focus  = "#30362f",
    titlebar_fg_normal = "#8f9382",
    titlebar_fg_focus  = "#d3b77c",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/foundry.png",
    layout_color = "#d3b77c",

    -- 5. Top Bar Telemetry Palette (CPU, RAM, Wi-Fi, Volume, Battery)
    palette = {
        cpu        = "#d3b77c",
        temp_ok    = "#91b6a2",
        temp_hot   = "#d57659",
        gpu        = "#b38d78",
        sys        = "#e8dcc0",
        net_ok     = "#91ae83",
        net_off    = "#d57659",
        vol_ok     = "#e8dcc0",
        vol_mute   = "#d57659",
        bat_ok     = "#91ae83",
        bat_chg    = "#e5bd6d",
        bat_warn   = "#c38b59",
        bat_crit   = "#d57659",
        bat_badge  = "#d3b77c",
        pill_bg1   = "#232927",
        pill_bg2   = "#101414",
        pill_fg    = "#e8dcc0",
        pill_bdr   = "#685b42",
        pill_bw    = 1,
    },

    -- 6. Bar Layout & Geometry
    bar_height      = dpi(74),
    bar_strut_top   = dpi(74),
    bar_drip_height = edge_depth,
    bar_margin_top  = dpi(7),
    bar_margin_bottom = edge_depth + dpi(20),
    is_flat         = false,
    bar_shape       = foundry.edge_shape(edge_depth),
    bar_bgimage     = foundry.bar_background(edge_depth),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    task_border_w   = 1,
    task_border_col = "#685b42",

    -- 7. Window Geometry & Masks
    window_style    = "bottom_gears",
    window_edge_height = edge_depth,
    window_titlebar_height = dpi(40),
    window_edge_fn = function(c) return foundry.window_background(c, edge_depth) end,
    window_shape_fn = function() return foundry.edge_shape(edge_depth, "window") end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
    notification_presets = {
        normal = {
            bg           = "#171b1bf5",
            fg           = "#e8dcc0",
            border_color = "#d3b77c",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#241820f8",
            fg           = "#f7ecd2",
            border_color = "#d57659",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#101414f2",
            fg           = "#d3b77c",
            border_color = "#685b42",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
