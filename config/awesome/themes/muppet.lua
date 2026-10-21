-- ==============================================================================
-- Muppet Babies Theme: We Make Our Dreams Come True (Pastel Vaporwave)
-- ==============================================================================
-- Inspired by the 1984 Jim Henson classic animated series:
-- Deep twilight nursery violet canvas (#1a1528), Baby Piggy bubblegum pink (#ff70a6),
-- Baby Kermit soft mint green (#80ed99), Baby Gonzo periwinkle cyan (#70d6ff),
-- Baby Fozzie warm peach gold (#ffd166), and Baby Animal coral pink (#ff4d6d).
-- "Muppet Babies, we make our dreams come true!"
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/muppet.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/muppet.png"
end

local theme = {
    -- 1. Metadata
    name                 = "muppet",
    display_name         = "Muppet Babies",
    act                  = "Dreams Come True",
    narrative_title      = "MUPPET BABIES: DREAMS COME TRUE [NURSERY//VAPORWAVE]",
    narrative_body       = "Muppet Babies active - When your room looks kind of weird... (Super+o to cycle)",
    is_light             = false,
    has_muppet_mascot    = true,
    has_muppet_prompt    = true,

    -- 2. Typography
    font_family          = "ComicShannsMono Nerd Font",
    font_size            = "10",

    -- 3. Window Borders & Gaps (Baby Piggy Vaporwave Bubblegum Pink Focus Border)
    border_width         = dpi(2),
    border_normal        = "#2e2346",
    border_focus         = "#ff70a6",
    border_marked        = "#70d6ff",
    useless_gap          = dpi(6),

    -- 4. Core Window & Widget Palette (Twilight Nursery Violet & Dream Pastels)
    bg_normal            = "#1a1528f5",
    bg_focus             = "#241c38",
    bg_urgent            = "#ff4d6d",
    bg_minimize          = "#100d1a",
    bg_systray           = "#1a1528",

    fg_normal            = "#f0e6f6",
    fg_focus             = "#ffffff",
    fg_urgent            = "#ffffff",
    fg_minimize          = "#8b7a9e",

    -- Taglist Theming (Baby Piggy Pink Focus Pill, Kermit Mint Occupied)
    taglist_bg_focus     = "#ff70a6",
    taglist_fg_focus     = "#1a1528",
    taglist_bg_urgent    = "#ff4d6d",
    taglist_fg_urgent    = "#ffffff",
    taglist_bg_occupied  = "#2a1f42",
    taglist_fg_occupied  = "#80ed99",
    taglist_bg_empty     = "#1a1528",
    taglist_fg_empty     = "#584a6b",

    -- Tasklist Theming
    tasklist_bg_normal   = "#1f1830dd",
    tasklist_fg_normal   = "#c7b8d8",
    tasklist_bg_focus    = "#2d2345",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff4d6d",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#100d1a",
    tasklist_fg_minimize = "#584a6b",

    -- Context Menu Theming
    menu_bg_normal     = "#1f1830f8",
    menu_bg_focus      = "#ff70a6",
    menu_fg_normal     = "#f0e6f6",
    menu_fg_focus      = "#1a1528",
    menu_border_color  = "#ff70a6",
    menu_border_width  = dpi(2),
    menu_height        = dpi(26),
    menu_width         = dpi(160),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#1f1830",
    hotkeys_fg           = "#f0e6f6",
    hotkeys_border_color = "#ff70a6",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ffd166",
    hotkeys_label_bg     = "#ff70a6",
    hotkeys_label_fg     = "#1a1528",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#1a1528",
    titlebar_bg_focus  = "#241c38",
    titlebar_fg_normal = "#8b7a9e",
    titlebar_fg_focus  = "#ff70a6",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#ff70a6",

    -- 5. Top Bar Telemetry Palette (Vivid Pastel Vaporwave Tones)
    palette = {
        cpu        = "#ff4d6d", -- Baby Animal Coral Pink
        temp_ok    = "#80ed99", -- Baby Kermit Mint Green
        temp_hot   = "#ff4d6d",
        gpu        = "#b388ff", -- Lilac Dream Purple
        sys        = "#f0e6f6", -- Dream White
        net_ok     = "#70d6ff", -- Baby Gonzo Periwinkle Cyan
        net_off    = "#ff4d6d",
        vol_ok     = "#ffd166", -- Baby Fozzie Warm Peach / Yellow
        vol_mute   = "#ff4d6d",
        bat_ok     = "#80ed99", -- Kermit Mint
        bat_chg    = "#70d6ff", -- Gonzo Cyan
        bat_warn   = "#ffd166", -- Fozzie Peach
        bat_crit   = "#ff4d6d",
        bat_badge  = "#ffd166",
        pill_bg1   = "#241c38",
        pill_bg2   = "#2d2345",
        pill_fg    = "#ffffff",
        pill_bdr   = "#ff70a6", -- Piggy Pink rim
        pill_bw    = 1,
    },

    -- 6. Top Bar Styling with Custom Muppet Babies Cairo Renderer
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_muppet_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 1,
    task_border_col = "#ff70a6",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#1f1830",
            fg           = "#f0e6f6",
            border_color = "#ff70a6",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#33121d",
            fg           = "#ff4d6d",
            border_color = "#ff4d6d",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#1a1528",
            fg           = "#ffd166",
            border_color = "#ffd166",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
