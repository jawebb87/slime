-- ==============================================================================
-- Clay Theme: Sunbaked Terracotta & Mesopotamian Cuneiform Tablets
-- ==============================================================================
-- Inspired by tactile neomorphic clay tablet tiles, carved stone stamps,
-- warm biscuit earthenware, and ancient cuneiform scribe markings.
-- ==============================================================================

local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local slime_shapes = require("theme.slime_shapes")

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/clay.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/clay_art.jpg"
end

local theme = {
    -- 1. Metadata
    name            = "clay",
    display_name    = "Clay Tablet",
    narrative_title = "CLAY TABLET: MESOPOTAMIAN PROTOCOL [CLAY//TABLET]",
    narrative_body  = "Sunbaked Terracotta & Cuneiform Clay Tablet theme active (Super+o to cycle)",
    is_light        = false,

    -- 2. Typography (Slab-serif monospace for carved tablet lettering)
    font_family     = "IosevkaTermSlab Nerd Font",
    font_size       = "10",

    -- 3. Window Borders & Gaps
    border_width    = dpi(2),
    border_normal   = "#413a3b",
    border_focus    = "#d1c4af",
    border_marked   = "#c26d55",
    useless_gap     = dpi(6),

    -- 4. Core Window & Widget Palette
    bg_normal       = "#585153",
    bg_focus        = "#a39990",
    bg_urgent       = "#c26d55",
    bg_minimize     = "#413a3b",
    bg_systray      = "#585153",

    fg_normal       = "#d1c4af",
    fg_focus        = "#2b2526",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#786f69",

    -- Taglist Theming (Tactile 3D Clay Tablet Stamps)
    tag_names           = { "APPS", "WEB", "CODE", "DATA", "SYS" },
    taglist_bg_focus    = "#d1c4af",
    taglist_fg_focus    = "#2b2526",
    taglist_bg_urgent   = "#c26d55",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#8b817e",
    taglist_fg_occupied = "#e4dccf",
    taglist_bg_empty    = "#504a4b",
    taglist_fg_empty    = "#8b817e",
    taglist_layout      = {
        spacing = 5,
        layout  = wibox.layout.fixed.horizontal,
    },

    -- Tasklist Theming
    tasklist_bg_normal   = "#665e59",
    tasklist_fg_normal   = "#d1c4af",
    tasklist_bg_focus    = "#d1c4af",
    tasklist_fg_focus    = "#2b2526",
    tasklist_bg_urgent   = "#c26d55",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#413a3b",
    tasklist_fg_minimize = "#786f69",

    -- Context Menu
    menu_bg_normal    = "#585153f8",
    menu_bg_focus     = "#a39990",
    menu_fg_normal    = "#d1c4af",
    menu_fg_focus     = "#2b2526",
    menu_border_color = "#b6a994",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(140),

    -- Hotkeys / Cheat Modal
    hotkeys_bg           = "#585153f8",
    hotkeys_fg           = "#d1c4af",
    hotkeys_border_color = "#d1c4af",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#d49b52",
    hotkeys_label_bg     = "#413a3b",
    hotkeys_label_fg     = "#e4dccf",
    hotkeys_group_margin = dpi(16),

    -- Titlebars
    titlebar_bg_normal = "#413a3b",
    titlebar_bg_focus  = "#585153",
    titlebar_fg_normal = "#786f69",
    titlebar_fg_focus  = "#d1c4af",

    -- Wallpaper & Layout Icon Tint
    wallpaper    = wp_path,
    layout_color = "#d1c4af",

    -- 5. Top Bar Telemetry Palette (Warm Earthen Terracotta & Clay)
    palette = {
        cpu        = "#d49b52", -- Warm Sunbaked Ochre
        temp_ok    = "#889c6d", -- Sage / Dried Reed Green
        temp_hot   = "#c26d55", -- Terracotta Red
        gpu        = "#cfa15d", -- Golden Silt
        sys        = "#d1c4af", -- Sandstone Slip
        net_ok     = "#889c6d", -- Sage Green
        net_off    = "#c26d55", -- Terracotta Alert
        vol_ok     = "#d1c4af", -- Sandstone Slip
        vol_mute   = "#786f69", -- Muted Clay
        bat_ok     = "#889c6d", -- Sage Green
        bat_chg    = "#d49b52", -- Ochre
        bat_warn   = "#d49b52", -- Ochre
        bat_crit   = "#c26d55", -- Terracotta Red
        bat_badge  = "#a39990",
        pill_bg1   = "#786f69", -- Mid Earthen Clay
        pill_bg2   = "#665e59", -- Deep Slate Clay
        pill_fg    = "#e4dccf", -- Bone Chalk White
        pill_bdr   = "#8b817e",
        pill_bw    = 1,
    },

    -- 6. Top Bar Layout & Geometry (Ancient Clay Tablet Slab Frieze)
    bar_height      = 42,
    bar_strut_top   = 42,
    bar_drip_height = 0,
    is_flat         = true,
    bar_shape       = nil,
    bar_bgimage     = slime_shapes.render_clay_bar_bg(),
    has_clay_prompt = true,
    telemetry_style = "icon",
    clock_format    = "  %H:%M ",

    -- 3D Clay Tablet Pill Container Wrapper:
    -- Wraps every telemetry pill in a tactile 3D clay tablet tile with
    -- an elevated sandstone face, light lip border, and dark 3D base depth (#383233).
    pill_wrapper = function(widget, bg_color, fg_color, P)
        return wibox.widget {
            {
                {
                    widget,
                    left   = 10,
                    right  = 10,
                    top    = 3,
                    bottom = 3,
                    widget = wibox.container.margin,
                },
                bg                 = bg_color or P.pill_bg1,
                fg                 = fg_color or P.pill_fg,
                shape              = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
                shape_border_width = 1,
                shape_border_color = "#8b817e",
                widget             = wibox.container.background,
            },
            bottom = 3,
            widget = wibox.container.margin,
            bg     = "#383233",
            shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
            widget = wibox.container.background,
        }
    end,

    -- 3D Clay Tablet Workspace Tags Template:
    taglist_template = {
        {
            {
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                left   = 10,
                right  = 10,
                top    = 3,
                bottom = 3,
                widget = wibox.container.margin,
            },
            id                 = "background_role",
            widget             = wibox.container.background,
            shape              = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
            shape_border_width = 1,
            shape_border_color = "#b6a994",
        },
        bottom = 3,
        widget = wibox.container.margin,
        bg     = "#383233",
        shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
        widget = wibox.container.background,
    },

    -- 3D Clay Tablet Tasklist Template:
    tasklist_template = {
        {
            {
                {
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    top    = 3,
                    bottom = 3,
                    left   = 6,
                    right  = 4,
                    widget = wibox.container.margin,
                },
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            id                 = "background_role",
            widget             = wibox.container.background,
            shape              = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
            shape_border_width = 1,
            shape_border_color = "#8b817e",
        },
        bottom = 3,
        widget = wibox.container.margin,
        bg     = "#383233",
        shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
        widget = wibox.container.background,
    },

    -- 7. Window Styling & Geometry
    window_style    = "rounded_rect",
    window_shape_fn = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 5) end,

    -- 8. Notifications (Carved Clay Tablet Style)
    notification_shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end,
    notification_presets = {
        normal = {
            bg           = "#585153f5",
            fg           = "#d1c4af",
            border_color = "#b6a994",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#3d1f1ff8",
            fg           = "#faebe8",
            border_color = "#c26d55",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#413a3bf2",
            fg           = "#a39990",
            border_color = "#786f69",
            border_width = 1,
            timeout      = 3,
        },
    },
}

return theme
