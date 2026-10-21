-- Special Edition: Peak 90s Neon Windbreaker (Light Theme)
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "windbreaker",
    display_name    = "90s Neon Windbreaker",
    act             = "Special Edition",
    narrative_title = "PEAK 90s WINDBREAKER [NEON//NYLON]",
    narrative_body  = "Peak 90s Windbreaker light theme active (Super+o to cycle)",
    is_light        = true,

    -- Typography: Authentic 90s playful monospace font
    font_family     = "ComicShannsMono Nerd Font",
    font_size       = "10",

    -- Core Window Borders & Gaps (Electric Hot Pink focus border!)
    border_width    = dpi(3),
    border_normal   = "#cbd5e1",
    border_focus    = "#ff007f",
    border_marked   = "#ffe600",
    useless_gap     = dpi(6),

    -- Core Color Palette (Crisp nylon light background, deep indigo ink foreground)
    bg_normal       = "#f4f6faf5",
    bg_focus        = "#151324",
    bg_urgent       = "#ff007f",
    bg_minimize     = "#e2e8f0",
    bg_systray      = "#f4f6fa",

    fg_normal       = "#151324",
    fg_focus        = "#ffffff",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#625c7e",

    -- Taglist Theming (Hot Pink active pill, Electric Cyan occupied)
    taglist_bg_focus    = "#ff007f",
    taglist_fg_focus    = "#ffffff",
    taglist_bg_urgent   = "#ffe600",
    taglist_fg_urgent   = "#151324",
    taglist_bg_occupied = "#e0f7fa",
    taglist_fg_occupied = "#0077cc",
    taglist_bg_empty    = "#ffffff",
    taglist_fg_empty    = "#94a3b8",

    -- Tasklist Theming
    tasklist_bg_normal   = "#ffffff",
    tasklist_fg_normal   = "#151324",
    tasklist_bg_focus    = "#ff007f",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#ffe600",
    tasklist_fg_urgent   = "#151324",
    tasklist_bg_minimize = "#e2e8f0",
    tasklist_fg_minimize = "#625c7e",

    -- Context Menu Theming
    menu_bg_normal    = "#ffffff",
    menu_bg_focus     = "#ff007f",
    menu_fg_normal    = "#151324",
    menu_fg_focus     = "#ffffff",
    menu_border_color = "#00d2ff",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#ffffff",
    hotkeys_fg           = "#151324",
    hotkeys_border_color = "#ff007f",
    hotkeys_border_width = dpi(3),
    hotkeys_modifiers_fg = "#0077cc",
    hotkeys_label_bg     = "#ff007f",
    hotkeys_label_fg     = "#ffffff",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#e2e8f0",
    titlebar_bg_focus  = "#ffffff",
    titlebar_fg_normal = "#625c7e",
    titlebar_fg_focus  = "#ff007f",

    -- Wallpaper & Layout Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/windbreaker.jpg",
    layout_color = "#ff007f",

    -- Telemetry Palette (Vivid 90s Neon Accents)
    palette = {
        cpu        = "#ff007f", -- Hot Pink
        temp_ok    = "#00a6c0", -- Cyan
        temp_hot   = "#ff007f", -- Hot Pink
        gpu        = "#7000ff", -- Royal Purple
        sys        = "#151324", -- Deep Indigo
        net_ok     = "#05b34c", -- Neon Lime
        net_off    = "#ff2a5f", -- Alert Pink
        vol_ok     = "#0077cc", -- Electric Blue
        vol_mute   = "#ff2a5f",
        bat_ok     = "#05b34c", -- Neon Lime
        bat_chg    = "#00a6c0", -- Cyan
        bat_warn   = "#bfa100", -- Amber Yellow
        bat_crit   = "#ff2a5f", -- Critical Coral/Red
        bat_badge  = "#ff007f",
        pill_bg1   = "#ffffff",
        pill_bg2   = "#f0f4f8",
        pill_fg    = "#151324",
        pill_bdr   = "#00d2ff", -- Electric Cyan rim
        pill_bw    = 2,
    },

    -- Top Bar Styling with 90s Neon Racing Stripe
    bar_height      = 36,
    bar_strut_top   = 36,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_windbreaker_bar_bg(),
    pill_shape_fn   = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_shape      = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    task_border_w   = 2,
    task_border_col = "#ff007f",

    -- Window Styling & Rounded Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,

    -- Notifications
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    notification_presets = {
        normal = {
            bg           = "#ffffff",
            fg           = "#151324",
            border_color = "#ff007f",
            border_width = 3,
            timeout      = 5,
        },
        critical = {
            bg           = "#fff0f5",
            fg           = "#ff007f",
            border_color = "#ff007f",
            border_width = 3,
            timeout      = 0,
        },
        low = {
            bg           = "#f0fbff",
            fg           = "#0077cc",
            border_color = "#00d2ff",
            border_width = 2,
            timeout      = 4,
        },
    },
}

return theme
