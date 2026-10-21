-- ==============================================================================
-- Darkwing Duck Theme: The Terror That Flaps in the Night (Dark Superhero Noir)
-- ==============================================================================
-- Inspired by Disney Afternoon's Darkwing Duck (Drake Mallard): midnight purple canvas,
-- St. Canard art-deco skyline, smoking gas gun teal/cyan mist, cape button gold,
-- and fiery comic orange highlights. "Let's get dangerous!"
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/darkwing.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/darkwing.png"
end

local theme = {
    -- 1. Metadata
    name                 = "darkwing",
    display_name         = "Darkwing Duck",
    act                  = "Let's Get Dangerous",
    narrative_title      = "DARKWING DUCK: THE TERROR THAT FLAPS IN THE NIGHT [ST.CANARD//DANGEROUS]",
    narrative_body       = "Darkwing Duck active - Let's get dangerous! (Super+o to cycle)",
    is_light             = false,
    has_darkwing_mascot  = true,
    has_darkwing_prompt  = true,

    -- 2. Typography
    font_family          = "ComicShannsMono Nerd Font",
    font_size            = "10",

    -- 3. Window Borders & Gaps (Electric Cyan Gas Gun Focus Border)
    border_width         = dpi(2),
    border_normal        = "#261a40",
    border_focus         = "#00e5ff",
    border_marked        = "#ffd700",
    useless_gap          = dpi(6),

    -- 4. Core Window & Widget Palette (Midnight Purple & Heroic Accents)
    bg_normal            = "#120c1ff5",
    bg_focus             = "#1c1330",
    bg_urgent            = "#ff2a6d",
    bg_minimize          = "#0b0714",
    bg_systray           = "#120c1f",

    fg_normal            = "#e2daf0",
    fg_focus             = "#ffffff",
    fg_urgent            = "#ffffff",
    fg_minimize          = "#7c6a99",

    -- Taglist Theming (Electric Cyan Focus Pill, Cape Button Gold Occupied)
    taglist_bg_focus     = "#00e5ff",
    taglist_fg_focus     = "#120c1f",
    taglist_bg_urgent    = "#ff2a6d",
    taglist_fg_urgent    = "#ffffff",
    taglist_bg_occupied  = "#22183b",
    taglist_fg_occupied  = "#ffd700",
    taglist_bg_empty     = "#120c1f",
    taglist_fg_empty     = "#574872",

    -- Tasklist Theming
    tasklist_bg_normal   = "#181029dd",
    tasklist_fg_normal   = "#a899c4",
    tasklist_bg_focus    = "#251744",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff2a6d",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#0b0714",
    tasklist_fg_minimize = "#574872",

    -- Context Menu Theming
    menu_bg_normal     = "#181029f8",
    menu_bg_focus      = "#00e5ff",
    menu_fg_normal     = "#e2daf0",
    menu_fg_focus      = "#120c1f",
    menu_border_color  = "#ffd700",
    menu_border_width  = dpi(2),
    menu_height        = dpi(26),
    menu_width         = dpi(160),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#181029",
    hotkeys_fg           = "#e2daf0",
    hotkeys_border_color = "#00e5ff",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ffd700",
    hotkeys_label_bg     = "#00e5ff",
    hotkeys_label_fg     = "#120c1f",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#120c1f",
    titlebar_bg_focus  = "#1c1330",
    titlebar_fg_normal = "#7c6a99",
    titlebar_fg_focus  = "#00e5ff",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#00e5ff",

    -- 5. Top Bar Telemetry Palette (Vivid Darkwing Colors)
    palette = {
        cpu        = "#ff6b00", -- Comic Action Orange
        temp_ok    = "#00e5ff", -- Electric Cyan
        temp_hot   = "#ff2a6d", -- Gas Canister Alert Red
        gpu        = "#9d4edd", -- Fedora / Cape Purple
        sys        = "#e2daf0", -- Spectral Cel White
        net_ok     = "#1de9b6", -- Gas Mist Teal
        net_off    = "#ff2a6d", -- Alert Red
        vol_ok     = "#00e5ff", -- Electric Cyan
        vol_mute   = "#ff2a6d",
        bat_ok     = "#1de9b6", -- Teal
        bat_chg    = "#00e5ff", -- Cyan
        bat_warn   = "#ffd700", -- Cape Button Gold
        bat_crit   = "#ff2a6d",
        bat_badge  = "#ffd700",
        pill_bg1   = "#1c1330",
        pill_bg2   = "#22183b",
        pill_fg    = "#ffffff",
        pill_bdr   = "#00e5ff", -- Electric Cyan rim
        pill_bw    = 1,
    },

    -- 6. Top Bar Styling with Custom Superhero Cairo Renderer
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_darkwing_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 1,
    task_border_col = "#00e5ff",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#181029",
            fg           = "#e2daf0",
            border_color = "#00e5ff",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#290c1a",
            fg           = "#ff2a6d",
            border_color = "#ff2a6d",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#140e24",
            fg           = "#ffd700",
            border_color = "#ffd700",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
