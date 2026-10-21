-- ==============================================================================
-- Looney Tunes Theme: Golden Age Cartoon Animation (Light Theme)
-- ==============================================================================
-- Inspired by the iconic Warner Bros cartoons, Maurice Noble painted desert
-- backgrounds, Bugs Bunny, Road Runner & Wile E. Coyote, and ACME contraptions.
-- Crisp warm cartoon cel parchment with high-contrast, bright poppy cartoon colors.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/tunes.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/tunes.png"
end

local theme = {
    -- 1. Metadata
    name            = "tunes",
    display_name    = "Looney Tunes",
    act             = "Golden Age Animation",
    narrative_title = "THAT'S ALL FOLKS! [LOONEY//TUNES]",
    narrative_body  = "Looney Tunes cartoon light theme active (Super+o to cycle)",
    is_light        = true,
    has_tunes_mascot = true,
    has_tunes_prompt = true,

    -- 2. Typography
    font_family     = "ComicShannsMono Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps (Acme Dynamite Red active focus border)
    border_width    = dpi(3),
    border_normal   = "#dcd3c5",
    border_focus    = "#d91424",
    border_marked   = "#ff6b00",
    useless_gap     = dpi(6),

    -- 4. Core Window & Widget Palette (Warm Cartoon Parchment & Deep Toon Ink)
    bg_normal       = "#faf5ebf5",
    bg_focus        = "#1c1612",
    bg_urgent       = "#d91424",
    bg_minimize     = "#ebdcca",
    bg_systray      = "#faf5eb",

    fg_normal       = "#1c1612",
    fg_focus        = "#ffffff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#786c62",

    -- Taglist Theming (Acme Red Active Pill, Warm Peach Occupied)
    taglist_bg_focus    = "#d91424",
    taglist_fg_focus    = "#ffffff",
    taglist_bg_urgent   = "#ff6b00",
    taglist_fg_urgent   = "#1c1612",
    taglist_bg_occupied = "#fed7aa",
    taglist_fg_occupied = "#c8102e",
    taglist_bg_empty    = "#ffffff",
    taglist_fg_empty    = "#8c7e74",

    -- Tasklist Theming
    tasklist_bg_normal   = "#ffffff",
    tasklist_fg_normal   = "#1c1612",
    tasklist_bg_focus    = "#d91424",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ff6b00",
    tasklist_fg_urgent   = "#1c1612",
    tasklist_bg_minimize = "#ebdcca",
    tasklist_fg_minimize = "#786c62",

    -- Context Menu Theming
    menu_bg_normal    = "#ffffff",
    menu_bg_focus     = "#d91424",
    menu_fg_normal    = "#1c1612",
    menu_fg_focus     = "#ffffff",
    menu_border_color = "#ff6b00",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#ffffff",
    hotkeys_fg           = "#1c1612",
    hotkeys_border_color = "#d91424",
    hotkeys_border_width = dpi(3),
    hotkeys_modifiers_fg = "#005bbb",
    hotkeys_label_bg     = "#d91424",
    hotkeys_label_fg     = "#ffffff",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#ebdcca",
    titlebar_bg_focus  = "#ffffff",
    titlebar_fg_normal = "#786c62",
    titlebar_fg_focus  = "#d91424",

    -- Wallpaper & Layout Icons
    wallpaper    = wp_path,
    layout_color = "#d91424",

    -- 5. Top Bar Telemetry Palette (Vivid Cartoon Accents)
    palette = {
        cpu        = "#d91424", -- Acme Dynamite Red
        temp_ok    = "#005bbb", -- Warner Azure Blue
        temp_hot   = "#d91424", -- Dynamite Red
        gpu        = "#86198f", -- Cartoon Mallet Purple
        sys        = "#1c1612", -- Deep Toon Ink
        net_ok     = "#0c7a36", -- Marvin Green
        net_off    = "#d91424", -- Alert Red
        vol_ok     = "#005bbb", -- Azure Blue
        vol_mute   = "#d91424",
        bat_ok     = "#0c7a36", -- Green
        bat_chg    = "#005bbb", -- Blue
        bat_warn   = "#b85d00", -- Daffy Gold
        bat_crit   = "#d91424", -- Red
        bat_badge  = "#d91424",
        pill_bg1   = "#ffffff",
        pill_bg2   = "#f6efe2",
        pill_fg    = "#1c1612",
        pill_bdr   = "#d91424", -- Acme Red rim
        pill_bw    = 2,
    },

    -- 6. Top Bar Styling with Concentric Cartoon Bullseye Rings
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_tunes_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 2,
    task_border_col = "#d91424",

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- 8. Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    notification_presets = {
        normal = {
            bg           = "#ffffff",
            fg           = "#1c1612",
            border_color = "#d91424",
            border_width = 3,
            timeout      = 5,
        },
        critical = {
            bg           = "#fff1f2",
            fg           = "#c8102e",
            border_color = "#d91424",
            border_width = 3,
            timeout      = 0,
        },
        low = {
            bg           = "#fefce8",
            fg           = "#b85d00",
            border_color = "#ff6b00",
            border_width = 2,
            timeout      = 4,
        },
    },
}

return theme
