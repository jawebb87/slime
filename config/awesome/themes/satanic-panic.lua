local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/satanic-panic.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/satanic-panic.png"
end

local console = require("theme.satanic_panic_shapes")
local function channel_widget()
    local widget = wibox.widget.base.make_widget()
    widget.fit = function() return dpi(32), dpi(40) end
    widget.draw = function(self, _, cr, w, h)
        local tag = self.tag
        console.channel(cr,w,h,tag and tag.name or '0',tag and tag.selected,
            tag and #tag:clients()>0,tag and tag.urgent)
    end
    return widget
end
local function update_channel(self, tag)
    local widget = self:get_children_by_id("channel")[1]
    widget.tag = tag
    widget:emit_signal("widget::redraw_needed")
end
local function meter_widget(name)
    local widget = wibox.widget.base.make_widget()
    widget.value = 0
    widget.fit = function() return dpi(112), dpi(40) end
    widget.draw = function(self, _, cr, w, h) console.meter(cr,w,h,name,self.value) end
    widget.set_value = function(self,value)
        self.value = value
        self:emit_signal("widget::redraw_needed")
    end
    return widget
end
local function clock_widget()
    local widget = wibox.widget.base.make_widget()
    widget.time = os.date('%H:%M')
    widget.fit = function() return dpi(112), dpi(40) end
    widget.draw = function(self, _, cr, w, h) console.clock(cr,w,h,self.time) end
    gears.timer {timeout=1, autostart=true, callback=function()
        local time = os.date('%H:%M')
        if time ~= widget.time then
            widget.time = time
            widget:emit_signal("widget::redraw_needed")
        end
    end}
    return widget
end

local theme = {
    name            = "satanic-panic",
    display_name    = "Satanic Panic!",
    narrative_title = "SATANIC PANIC! / DO NOT PLAY",
    narrative_body  = "Tracking noise. Rusted steel. Do not play. (Super+o to cycle)",
    is_light        = false,
    companion_label = "SATANIC PANIC",
    companion_accent = "#b63d30",
    companion_bg = "#29211e",
    has_gill_prompt = false,
    bar_deck_tags = true,
    cpu_meter_widget = function() return meter_widget("CPU") end,
    memory_meter_widget = function() return meter_widget("RAM") end,
    clock_widget = clock_widget,
    telemetry_style = "label",
    telemetry_font = "Liberation Mono Bold 9",
    clock_font = "Liberation Mono Bold 19",
    clock_format = " %H:%M ",
    clock_scoreboard = false,

    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    border_width    = dpi(2),
    border_normal   = "#29211e",
    border_focus    = "#b63d30",
    border_marked   = "#d65a3d",
    useless_gap     = dpi(7),

    bg_normal       = "#29211eee",
    bg_focus        = "#3c4035",
    bg_urgent       = "#9d3339",
    bg_minimize     = "#10120f",
    bg_systray      = "#29211e",

    fg_normal       = "#dbc3a0",
    fg_focus        = "#fff0d7",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#a68b73",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#b63d30",
    taglist_fg_focus    = "#10120f",
    taglist_bg_urgent   = "#9d3339",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#363b30",
    taglist_fg_occupied = "#b29a70",
    taglist_bg_empty    = "#29211eaa",
    taglist_fg_empty    = "#a68b73",
    taglist_template = {
        { id = "channel", widget = channel_widget },
        widget = wibox.container.background,
        create_callback = update_channel,
        update_callback = update_channel,
    },
    taglist_layout      = {
        spacing = 4,
        layout  = wibox.layout.fixed.horizontal,
    },

    tasklist_bg_normal   = "#29211edd",
    tasklist_fg_normal   = "#c4c4aa",
    tasklist_bg_focus    = "#3c4035ee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#9d3339",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#10120f",
    tasklist_fg_minimize = "#a68b73",
    task_shape           = console.panel,
    task_border_w        = 0,
    task_border_col      = "#b63d3066",

    menu_bg_normal    = "#29211ef8",
    menu_bg_focus     = "#505444",
    menu_fg_normal    = "#dbc3a0",
    menu_fg_focus     = "#b63d30",
    menu_border_color = "#b63d30",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#29211ef8",
    hotkeys_fg           = "#dbc3a0",
    hotkeys_border_color = "#b63d30",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#c38d52",
    hotkeys_label_bg     = "#363b30",
    hotkeys_label_fg     = "#b63d30",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#29211e",
    titlebar_bg_focus  = "#3c4035",
    titlebar_fg_normal = "#a68b73",
    titlebar_fg_focus  = "#b63d30",

    wallpaper    = gfs.file_readable(wp_path) and wp_path or false,
    layout_color = "#b63d30",

    palette = {
        cpu        = "#b63d30",
        temp_ok    = "#bbc6a1",
        temp_hot   = "#d65a3d",
        gpu        = "#b29a70",
        sys        = "#dbc3a0",
        net_ok     = "#b29a70",
        net_off    = "#9d3339",
        vol_ok     = "#c9cbb1",
        vol_mute   = "#9d3339",
        bat_ok     = "#b63d30",
        bat_chg    = "#c38d52",
        bat_warn   = "#c38d52",
        bat_crit   = "#9d3339",
        bat_badge  = "#b63d30",
        pill_bg1   = "#00000000",
        pill_bg2   = "#10120fee",
        pill_fg    = "#dbc3a0",
        pill_bdr   = "#b63d3055",
        pill_bw    = 0,
    },

    bar_height      = dpi(70),
    bar_floating    = true,
    bar_inset       = dpi(12),
    bar_offset      = dpi(10),
    bar_clearance   = dpi(12),
    bar_margin_top  = dpi(12),
    bar_margin_bottom = dpi(12),
    bar_padding_horizontal = dpi(52),
    bar_strut_top   = dpi(86),
    is_flat         = true,
    bar_shape       = console.shape,
    bar_bgimage     = console.background,
    pill_wrapper = function(widget,bg,fg)
        return wibox.widget {
            {widget,left=dpi(5),right=dpi(5),widget=wibox.container.margin},
            bg=bg or "#00000000", fg=fg or "#dbc3a0",
            widget=wibox.container.background,
        }
    end,
    pill_shape_fn   = console.panel,

    window_style    = "rounded_rect",
    window_shape_fn = console.panel,

    notification_shape = console.panel,
    notification_presets = {
        normal = {
            bg           = "#29211ef5",
            fg           = "#dbc3a0",
            border_color = "#b63d30",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#3b2425f8",
            fg           = "#ffffff",
            border_color = "#d65a3d",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#10120ff2",
            fg           = "#bbc6a1",
            border_color = "#505444",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
