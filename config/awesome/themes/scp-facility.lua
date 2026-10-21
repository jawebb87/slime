local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/scp-facility.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/scp-facility.png"
end

local console = require("theme.scp_shapes")
local function channel_widget()
    local widget = wibox.widget.base.make_widget()
    widget.fit = function() return dpi(40), dpi(40) end
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
    name            = "scp-facility",
    display_name    = "SCP Facility",
    narrative_title = "SCP / SECURITY OPERATIONS",
    narrative_body  = "Secure. Contain. Protect. Authorized personnel only. (Super+o to cycle)",
    is_light        = false,
    companion_label = "SCP FACILITY",
    companion_accent = "#d6584d",
    companion_bg = "#1a2228",
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
    border_normal   = "#1a2228",
    border_focus    = "#d6584d",
    border_marked   = "#ff7564",
    useless_gap     = dpi(7),

    bg_normal       = "#1a2228ee",
    bg_focus        = "#2c383f",
    bg_urgent       = "#a63d35",
    bg_minimize     = "#06090b",
    bg_systray      = "#1a2228",

    fg_normal       = "#d8e1e5",
    fg_focus        = "#f0f4f5",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#93a3ad",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#d6584d",
    taglist_fg_focus    = "#06090b",
    taglist_bg_urgent   = "#a63d35",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#26333b",
    taglist_fg_occupied = "#8dbdc9",
    taglist_bg_empty    = "#1a2228aa",
    taglist_fg_empty    = "#93a3ad",
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

    tasklist_bg_normal   = "#1a2228dd",
    tasklist_fg_normal   = "#b9cbd2",
    tasklist_bg_focus    = "#2c383fee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#a63d35",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#06090b",
    tasklist_fg_minimize = "#93a3ad",
    task_shape           = console.panel,
    task_border_w        = 0,
    task_border_col      = "#d6584d66",

    menu_bg_normal    = "#1a2228f8",
    menu_bg_focus     = "#3b4b55",
    menu_fg_normal    = "#d8e1e5",
    menu_fg_focus     = "#d6584d",
    menu_border_color = "#d6584d",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#1a2228f8",
    hotkeys_fg           = "#d8e1e5",
    hotkeys_border_color = "#d6584d",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#d5af58",
    hotkeys_label_bg     = "#26333b",
    hotkeys_label_fg     = "#d6584d",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#1a2228",
    titlebar_bg_focus  = "#2c383f",
    titlebar_fg_normal = "#93a3ad",
    titlebar_fg_focus  = "#d6584d",

    wallpaper    = gfs.file_readable(wp_path) and wp_path or false,
    layout_color = "#d6584d",

    palette = {
        cpu        = "#d6584d",
        temp_ok    = "#8cba99",
        temp_hot   = "#ff7564",
        gpu        = "#8dbdc9",
        sys        = "#d8e1e5",
        net_ok     = "#8dbdc9",
        net_off    = "#a63d35",
        vol_ok     = "#bbd4dd",
        vol_mute   = "#a63d35",
        bat_ok     = "#d6584d",
        bat_chg    = "#d5af58",
        bat_warn   = "#d5af58",
        bat_crit   = "#a63d35",
        bat_badge  = "#d6584d",
        pill_bg1   = "#00000000",
        pill_bg2   = "#06090bee",
        pill_fg    = "#d8e1e5",
        pill_bdr   = "#d6584d55",
        pill_bw    = 0,
    },

    bar_height      = dpi(80),
    bar_floating    = true,
    bar_inset       = dpi(12),
    bar_offset      = dpi(10),
    bar_clearance   = dpi(12),
    bar_margin_top  = dpi(24),
    bar_margin_bottom = dpi(16),
    bar_padding_horizontal = dpi(20),
    bar_strut_top   = dpi(102),
    is_flat         = true,
    bar_shape       = console.shape,
    bar_bgimage     = console.background,
    pill_wrapper = function(widget,bg,fg)
        return wibox.widget {
            {widget,left=dpi(5),right=dpi(5),widget=wibox.container.margin},
            bg=bg or "#00000000", fg=fg or "#d8e1e5",
            widget=wibox.container.background,
        }
    end,
    pill_shape_fn   = console.panel,

    window_style    = "rounded_rect",
    window_shape_fn = console.panel,

    notification_shape = console.panel,
    notification_presets = {
        normal = {
            bg           = "#1a2228f5",
            fg           = "#d8e1e5",
            border_color = "#d6584d",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#321b1cf8",
            fg           = "#ffffff",
            border_color = "#ff7564",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#06090bf2",
            fg           = "#8cba99",
            border_color = "#3b4b55",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
