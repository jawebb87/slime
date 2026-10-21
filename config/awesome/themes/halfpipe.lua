local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/halfpipe.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/halfpipe.png"
end

local ramp = require("theme.halfpipe_shapes")
local function deck_widget()
    local widget = wibox.widget.base.make_widget()
    widget.fit = function() return dpi(30), dpi(34) end
    widget.draw = function(self, _, cr, w, h)
        local tag = self.tag
        ramp.deck(cr, w, h, tag and tag.selected,
            tag and #tag:clients() > 0, tag and tag.urgent)
        if tag then
            cr:set_source_rgb(0.90, 0.92, 0.83)
            cr:select_font_face("Liberation Mono", 0, 1)
            cr:set_font_size(dpi(8)); cr:move_to(1, dpi(8))
            cr:show_text(tag.name)
        end
    end
    return widget
end
local function update_deck(self, tag)
    local widget = self:get_children_by_id("deck")[1]
    widget.tag = tag
    widget:emit_signal("widget::redraw_needed")
end

local theme = {
    name            = "halfpipe",
    display_name    = "Halfpipe",
    narrative_title = "HALFPIPE: AFTER HOURS",
    narrative_body  = "Concrete, coping, and one more run. (Super+o to cycle)",
    is_light        = false,
    companion_label = "HALFPIPE",
    companion_accent = "#9cdb45",
    companion_bg = "#27322e",
    has_gill_prompt = false,
    bar_deck_tags = true,
    telemetry_style = "label",
    telemetry_font = "Liberation Mono Bold 9",
    clock_font = "Liberation Mono Bold 19",
    clock_format = " %H:%M ",
    clock_scoreboard = true,

    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    border_width    = dpi(2),
    border_normal   = "#27322e",
    border_focus    = "#9cdb45",
    border_marked   = "#df6094",
    useless_gap     = dpi(7),

    bg_normal       = "#27322eee",
    bg_focus        = "#394840",
    bg_urgent       = "#a83d70",
    bg_minimize     = "#101613",
    bg_systray      = "#27322e",

    fg_normal       = "#e5e6d6",
    fg_focus        = "#f7f6e8",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#9eada1",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#9cdb45",
    taglist_fg_focus    = "#101613",
    taglist_bg_urgent   = "#a83d70",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#37473d",
    taglist_fg_occupied = "#7fc1b0",
    taglist_bg_empty    = "#27322eaa",
    taglist_fg_empty    = "#9eada1",
    taglist_template = {
        { id = "deck", widget = deck_widget },
        widget = wibox.container.background,
        create_callback = update_deck,
        update_callback = update_deck,
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    tasklist_bg_normal   = "#27322edd",
    tasklist_fg_normal   = "#c0c9b8",
    tasklist_bg_focus    = "#394840ee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#a83d70",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#101613",
    tasklist_fg_minimize = "#9eada1",
    task_shape           = ramp.panel,
    task_border_w        = 0,
    task_border_col      = "#9cdb4566",

    menu_bg_normal    = "#27322ef8",
    menu_bg_focus     = "#4c6052",
    menu_fg_normal    = "#e5e6d6",
    menu_fg_focus     = "#9cdb45",
    menu_border_color = "#9cdb45",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#27322ef8",
    hotkeys_fg           = "#e5e6d6",
    hotkeys_border_color = "#9cdb45",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#e6c56a",
    hotkeys_label_bg     = "#37473d",
    hotkeys_label_fg     = "#9cdb45",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#27322e",
    titlebar_bg_focus  = "#394840",
    titlebar_fg_normal = "#9eada1",
    titlebar_fg_focus  = "#9cdb45",

    wallpaper    = gfs.file_readable(wp_path) and wp_path or false,
    layout_color = "#9cdb45",

    palette = {
        cpu        = "#9cdb45",
        temp_ok    = "#aed5bf",
        temp_hot   = "#df6094",
        gpu        = "#7fc1b0",
        sys        = "#e5e6d6",
        net_ok     = "#9fbd88",
        net_off    = "#a83d70",
        vol_ok     = "#c5d1b8",
        vol_mute   = "#a83d70",
        bat_ok     = "#9cdb45",
        bat_chg    = "#e6c56a",
        bat_warn   = "#d7b958",
        bat_crit   = "#a83d70",
        bat_badge  = "#9cdb45",
        pill_bg1   = "#00000000",
        pill_bg2   = "#101613ee",
        pill_fg    = "#e5e6d6",
        pill_bdr   = "#9cdb4555",
        pill_bw    = 0,
    },

    bar_height      = dpi(94),
    bar_floating    = true,
    bar_inset       = dpi(12),
    bar_offset      = dpi(8),
    bar_clearance   = dpi(12),
    bar_margin_top  = dpi(53),
    bar_margin_bottom = dpi(7),
    bar_padding_horizontal = dpi(88),
    bar_strut_top   = dpi(114),
    is_flat         = true,
    bar_shape       = ramp.shape,
    bar_bgimage     = ramp.background,
    pill_shape_fn   = ramp.panel,

    window_style    = "rounded_rect",
    window_shape_fn = ramp.panel,

    notification_shape = ramp.panel,
    notification_presets = {
        normal = {
            bg           = "#27322ef5",
            fg           = "#e5e6d6",
            border_color = "#9cdb45",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#3d2926f8",
            fg           = "#ffffff",
            border_color = "#df6094",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#101613f2",
            fg           = "#aed5bf",
            border_color = "#4c6052",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
