-- ==============================================================================
-- Teenage Mutant Ninja Turtles (TMNT) Theme: Heroes in a Half Shell
-- ==============================================================================
-- Inspired by the classic 1987 animated series and Kevin Eastman & Peter Laird comics:
-- Dark NYC sewer brick / mossy slate canvas (#0e1510), glowing radioactive mutagen ooze (#39ff14),
-- Leonardo Katana Blue (#00aaff), Raphael Sais Red (#ff2a4b), Donatello Tech Purple (#9d4edd),
-- Michelangelo Orange (#ff8800), and hot pepperoni pizza gold (#ffd700). "Cowabunga!"
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/tmnt.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/tmnt.png"
end

local theme = {
    -- 1. Metadata
    name                 = "tmnt",
    display_name         = "Ninja Turtles",
    act                  = "Cowabunga!",
    narrative_title      = "TEENAGE MUTANT NINJA TURTLES: HEROES IN A HALF SHELL [NYC//COWABUNGA]",
    narrative_body       = "TMNT active - Turtle Power! Cowabunga! (Super+o to cycle)",
    is_light             = false,
    has_tmnt_mascot      = true,
    has_tmnt_prompt      = true,

    -- 2. Typography
    font_family          = "ComicShannsMono Nerd Font",
    font_size            = "10",

    -- 3. Window Borders & Gaps (Toxic Mutagen Ooze Glow Border)
    border_width         = dpi(2),
    border_normal        = "#1e3022",
    border_focus         = "#39ff14",
    border_marked        = "#ff8800",
    useless_gap          = dpi(6),

    -- 4. Core Window & Widget Palette (Dark Sewer Slate & Radioactive Highlights)
    bg_normal            = "#0e1510f5",
    bg_focus             = "#152218",
    bg_urgent            = "#ff2a4b",
    bg_minimize          = "#080c09",
    bg_systray           = "#0e1510",

    fg_normal            = "#d8ebd8",
    fg_focus             = "#ffffff",
    fg_urgent            = "#ffffff",
    fg_minimize          = "#5a7d5f",

    -- Taglist Theming (Mutagen Green Focus Pill, Pizza Orange Occupied)
    taglist_bg_focus     = "#39ff14",
    taglist_fg_focus     = "#0e1510",
    taglist_bg_urgent    = "#ff2a4b",
    taglist_fg_urgent    = "#ffffff",
    taglist_bg_occupied  = "#1b2b1f",
    taglist_fg_occupied  = "#ff8800",
    taglist_bg_empty     = "#0e1510",
    taglist_fg_empty     = "#415a45",

    -- Tasklist Theming
    tasklist_bg_normal   = "#131d14dd",
    tasklist_fg_normal   = "#98b89a",
    tasklist_bg_focus    = "#1d2e1f",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff2a4b",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#080c09",
    tasklist_fg_minimize = "#415a45",

    -- Context Menu Theming
    menu_bg_normal     = "#131d14f8",
    menu_bg_focus      = "#39ff14",
    menu_fg_normal     = "#d8ebd8",
    menu_fg_focus      = "#0e1510",
    menu_border_color  = "#39ff14",
    menu_border_width  = dpi(2),
    menu_height        = dpi(26),
    menu_width         = dpi(160),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#131d14",
    hotkeys_fg           = "#d8ebd8",
    hotkeys_border_color = "#39ff14",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#ffd700",
    hotkeys_label_bg     = "#39ff14",
    hotkeys_label_fg     = "#0e1510",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#0e1510",
    titlebar_bg_focus  = "#152218",
    titlebar_fg_normal = "#5a7d5f",
    titlebar_fg_focus  = "#39ff14",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#39ff14",

    -- 5. Top Bar Telemetry Palette (Vivid Turtle & Ooze Colors)
    palette = {
        cpu        = "#ff2a4b", -- Raphael Sais Red
        temp_ok    = "#39ff14", -- Mutagen Green
        temp_hot   = "#ff2a4b",
        gpu        = "#9d4edd", -- Donatello Bo Staff Purple
        sys        = "#d8ebd8", -- Sewer Cel Mint
        net_ok     = "#00aaff", -- Leonardo Katana Blue
        net_off    = "#ff2a4b",
        vol_ok     = "#ff8800", -- Michelangelo Orange
        vol_mute   = "#ff2a4b",
        bat_ok     = "#39ff14", -- Mutagen Green
        bat_chg    = "#00aaff", -- Katana Blue
        bat_warn   = "#ffd700", -- Pepperoni Pizza Gold
        bat_crit   = "#ff2a4b",
        bat_badge  = "#ffd700",
        pill_bg1   = "#152218",
        pill_bg2   = "#1b2b1f",
        pill_fg    = "#ffffff",
        pill_bdr   = "#39ff14", -- Radioactive green rim
        pill_bw    = 1,
    },

    -- 6. Top Bar Styling with Custom TMNT Cairo Renderer
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_tmnt_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 1,
    task_border_col = "#39ff14",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#131d14",
            fg           = "#d8ebd8",
            border_color = "#39ff14",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#2a0e14",
            fg           = "#ff2a4b",
            border_color = "#ff2a4b",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#0e1510",
            fg           = "#ffd700",
            border_color = "#ffd700",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
