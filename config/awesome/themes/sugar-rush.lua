local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/sugar-rush.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/sugar-rush.png"
end

local console = require("theme.sugar_rush_shapes")
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
    name            = "sugar-rush",
    display_name    = "Sugar Rush",
    narrative_title = "SUGAR RUSH / PEW-PEW!",
    narrative_body  = "Sweet frosting. Questionable power tools. (Super+o to cycle)",
    is_light        = true,
    companion_label = "SUGAR RUSH",
    companion_accent = "#a33c83",
    companion_bg = "#f4e3fa",
    has_gill_prompt = false,
    bar_deck_tags = true,
    cpu_meter_widget = function() return meter_widget("CPU / POP") end,
    memory_meter_widget = function() return meter_widget("MEM / POP") end,
    clock_widget = clock_widget,
    telemetry_style = "label",
    telemetry_font = "Noto Sans Bold 9",
    clock_font = "Liberation Mono Bold 19",
    clock_format = " %H:%M ",
    clock_scoreboard = false,

    font_family     = "Noto Sans",
    font_size       = "10",

    border_width    = dpi(2),
    border_normal   = "#f4e3fa",
    border_focus    = "#a33c83",
    border_marked   = "#b74c85",
    useless_gap     = dpi(7),

    bg_normal       = "#f4e3faee",
    bg_focus        = "#e6d4f1",
    bg_urgent       = "#a84578",
    bg_minimize     = "#f0e7f7",
    bg_systray      = "#f4e3fa",

    fg_normal       = "#603575",
    fg_focus        = "#4c285e",
    fg_urgent       = "#603575",
    fg_minimize     = "#8b7197",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#a33c83",
    taglist_fg_focus    = "#f0e7f7",
    taglist_bg_urgent   = "#a84578",
    taglist_fg_urgent   = "#603575",
    taglist_bg_occupied = "#e3dcef",
    taglist_fg_occupied = "#45836b",
    taglist_bg_empty    = "#f4e3faaa",
    taglist_fg_empty    = "#8b7197",
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

    tasklist_bg_normal   = "#f4e3fadd",
    tasklist_fg_normal   = "#76518a",
    tasklist_bg_focus    = "#e6d4f1ee",
    tasklist_fg_focus    = "#603575",
    tasklist_bg_urgent   = "#a84578",
    tasklist_fg_urgent   = "#603575",
    tasklist_bg_minimize = "#f0e7f7",
    tasklist_fg_minimize = "#8b7197",
    task_shape           = console.panel,
    task_border_w        = 0,
    task_border_col      = "#a33c8366",

    menu_bg_normal    = "#f4e3faf8",
    menu_bg_focus     = "#dcc9e8",
    menu_fg_normal    = "#603575",
    menu_fg_focus     = "#a33c83",
    menu_border_color = "#a33c83",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#f4e3faf8",
    hotkeys_fg           = "#603575",
    hotkeys_border_color = "#a33c83",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#916b26",
    hotkeys_label_bg     = "#e3dcef",
    hotkeys_label_fg     = "#a33c83",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#f4e3fa",
    titlebar_bg_focus  = "#e6d4f1",
    titlebar_fg_normal = "#8b7197",
    titlebar_fg_focus  = "#a33c83",

    wallpaper    = gfs.file_readable(wp_path) and wp_path or false,
    layout_color = "#a33c83",

    palette = {
        cpu        = "#a33c83",
        temp_ok    = "#4c806d",
        temp_hot   = "#b74c85",
        gpu        = "#45836b",
        sys        = "#603575",
        net_ok     = "#45836b",
        net_off    = "#a84578",
        vol_ok     = "#4d786f",
        vol_mute   = "#a84578",
        bat_ok     = "#a33c83",
        bat_chg    = "#916b26",
        bat_warn   = "#916b26",
        bat_crit   = "#a84578",
        bat_badge  = "#a33c83",
        pill_bg1   = "#00000000",
        pill_bg2   = "#f0e7f7ee",
        pill_fg    = "#603575",
        pill_bdr   = "#a33c8355",
        pill_bw    = 0,
    },

    bar_height      = dpi(72),
    bar_floating    = true,
    bar_inset       = dpi(12),
    bar_offset      = dpi(10),
    bar_clearance   = dpi(12),
    bar_margin_top  = dpi(12),
    bar_margin_bottom = dpi(20),
    bar_padding_horizontal = dpi(40),
    bar_strut_top   = dpi(94),
    is_flat         = true,
    bar_shape       = console.shape,
    bar_bgimage     = console.background,
    pill_wrapper = function(widget,bg,fg)
        return wibox.widget {
            {widget,left=dpi(5),right=dpi(5),widget=wibox.container.margin},
            bg=bg or "#00000000", fg=fg or "#603575",
            widget=wibox.container.background,
        }
    end,
    pill_shape_fn   = console.panel,

    window_style    = "rounded_rect",
    window_shape_fn = console.panel,

    notification_shape = console.panel,
    notification_presets = {
        normal = {
            bg           = "#f4e3faf5",
            fg           = "#603575",
            border_color = "#a33c83",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#f6d4e8f8",
            fg           = "#603575",
            border_color = "#b74c85",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#f0e7f7f2",
            fg           = "#4c806d",
            border_color = "#dcc9e8",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
