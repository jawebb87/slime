-- Act II: Biological Contamination (Biohazard Slime)
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local theme = {
    name            = "slime",
    display_name    = "Biohazard Slime",
    act             = "Act II",
    narrative_title = "Act II: BIOLOGICAL CONTAMINATION [BIO//HAZARD]",
    narrative_body  = "Biohazard Slime theme active (Super+o to cycle)",

    -- Typography
    font_family     = "OpenDyslexic Nerd Font",
    font_size       = "10",

    -- Core Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#15241777",
    border_focus    = "#55f73677",
    border_marked   = "#ff434399",
    useless_gap     = dpi(6),

    -- Core Color Palette
    bg_normal       = "#0c140df0",
    bg_focus        = "#1b351e",
    bg_urgent       = "#ff4343",
    bg_minimize     = "#101d12",
    bg_systray      = "#0c140df0",

    fg_normal       = "#b9e69c",
    fg_focus        = "#f0ffcd",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#476b4e",

    -- Taglist Theming
    taglist_bg_focus    = "#1f3d23",
    taglist_fg_focus    = "#74ff2e",
    taglist_bg_urgent   = "#ff4343",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#101d12",
    taglist_fg_occupied = "#c6f582",
    taglist_bg_empty    = "#0c140df0",
    taglist_fg_empty    = "#3a563f",

    -- Tasklist Theming
    tasklist_bg_normal   = "#0c140df0",
    tasklist_fg_normal   = "#98c481",
    tasklist_bg_focus    = "#1c3820",
    tasklist_fg_focus    = "#64f830",
    tasklist_bg_urgent   = "#ff4343",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#101a11",
    tasklist_fg_minimize = "#476b4e",

    -- Context Menu Theming
    menu_bg_normal    = "#0c140df6",
    menu_bg_focus     = "#1f3f24",
    menu_fg_normal    = "#c6f582",
    menu_fg_focus     = "#f0ffcd",
    menu_border_color = "#396b3f",
    menu_border_width = dpi(2),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys Popup / Help Modal
    hotkeys_bg           = "#0c140df6",
    hotkeys_fg           = "#c6f582",
    hotkeys_border_color = "#55f736",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#d8eb34",
    hotkeys_label_bg     = "#1b351e",
    hotkeys_label_fg     = "#f0ffcd",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#0c140d",
    titlebar_bg_focus  = "#152618",
    titlebar_fg_normal = "#6d9c74",
    titlebar_fg_focus  = "#c6f582",

    -- Wallpaper & Icons
    wallpaper    = os.getenv("HOME") .. "/Pictures/wallpaper/slime.jpg",
    layout_color = "#55f736",

    -- Telemetry Palette
    palette = {
        cpu        = "#d8eb34",
        temp_ok    = "#d8eb34",
        temp_hot   = "#ff4343",
        gpu        = "#55ffaa",
        sys        = "#c6f582",
        net_ok     = "#74ff2e",
        net_off    = "#ff4343",
        vol_ok     = "#c6f582",
        vol_mute   = "#ff4343",
        bat_ok     = "#55f736",
        bat_chg    = "#d8eb34",
        bat_warn   = "#d8eb34",
        bat_crit   = "#ff4343",
        bat_badge  = "#36e385",
        pill_bg1   = "#142417",
        pill_bg2   = "#16281a",
        pill_fg    = "#c6f582",
        pill_bdr   = "#24492b",
        pill_bw    = 1,
    },

    -- Top Bar Styling
    bar_height      = 52,
    bar_strut_top   = 34,
    bar_drip_height = 22,
    is_flat         = false,
    bar_shape       = slime_shapes.dripping_bar(22, 3.7),
    bar_bgimage     = slime_shapes.render_bar_bg(22, 3.7),
    pill_shape_fn   = function(seed) return slime_shapes.wobbly_pill(7, seed) end,
    task_shape      = slime_shapes.wobbly_pill(6, 4.2),
    task_border_w   = 0,
    task_border_col = "#7928ca",

    -- Window Styling & Signals
    window_style    = "bottom_drips",
    window_shape_fn = function(c, seed) return slime_shapes.dripping_window(12, 18, seed) end,
    window_edge_fn  = function(c, seed) return slime_shapes.render_window_bottom_drips(c, 12, 18, seed) end,

    -- Notifications
    notification_shape = slime_shapes.dripping_window(10, 9, 2.9),
    notification_presets = {
        normal = {
            bg           = "#0c140df2",
            fg           = "#c6f582",
            border_color = "#55f736",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#1f0909f8",
            fg           = "#ffdddd",
            border_color = "#ff4343",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#0a120cf2",
            fg           = "#97bd85",
            border_color = "#2c4c30",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
