local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/punk-show.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/punk-show.png"
end

local console = require("theme.punk_show_shapes")
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
    name            = "punk-show",
    display_name    = "Punk Show!",
    narrative_title = "PUNK SHOW! / SOUND CHECK",
    narrative_body  = "Plug in. Turn up. Make some noise. (Super+o to cycle)",
    is_light        = false,
    companion_label = "PUNK SHOW",
    companion_accent = "#ef4148",
    companion_bg = "#272a24",
    has_gill_prompt = false,
    bar_deck_tags = true,
    cpu_meter_widget = function() return meter_widget("CPU / VU") end,
    memory_meter_widget = function() return meter_widget("MEM / VU") end,
    clock_widget = clock_widget,
    telemetry_style = "label",
    telemetry_font = "Liberation Mono Bold 9",
    clock_font = "Liberation Mono Bold 19",
    clock_format = " %H:%M ",
    clock_scoreboard = false,

    font_family     = "JetBrainsMono Nerd Font",
    font_size       = "10",

    border_width    = dpi(2),
    border_normal   = "#272a24",
    border_focus    = "#ef4148",
    border_marked   = "#f46b66",
    useless_gap     = dpi(7),

    bg_normal       = "#272a24ee",
    bg_focus        = "#3c4035",
    bg_urgent       = "#9d3339",
    bg_minimize     = "#10120f",
    bg_systray      = "#272a24",

    fg_normal       = "#ddd7c0",
    fg_focus        = "#fff0d7",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#9c9e8b",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#ef4148",
    taglist_fg_focus    = "#10120f",
    taglist_bg_urgent   = "#9d3339",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#363b30",
    taglist_fg_occupied = "#91ad6e",
    taglist_bg_empty    = "#272a24aa",
    taglist_fg_empty    = "#9c9e8b",
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

    tasklist_bg_normal   = "#272a24dd",
    tasklist_fg_normal   = "#c4c4aa",
    tasklist_bg_focus    = "#3c4035ee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#9d3339",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#10120f",
    tasklist_fg_minimize = "#9c9e8b",
    task_shape           = console.panel,
    task_border_w        = 0,
    task_border_col      = "#ef414866",

    menu_bg_normal    = "#272a24f8",
    menu_bg_focus     = "#505444",
    menu_fg_normal    = "#ddd7c0",
    menu_fg_focus     = "#ef4148",
    menu_border_color = "#ef4148",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#272a24f8",
    hotkeys_fg           = "#ddd7c0",
    hotkeys_border_color = "#ef4148",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#d1ac63",
    hotkeys_label_bg     = "#363b30",
    hotkeys_label_fg     = "#ef4148",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#272a24",
    titlebar_bg_focus  = "#3c4035",
    titlebar_fg_normal = "#9c9e8b",
    titlebar_fg_focus  = "#ef4148",

    wallpaper    = gfs.file_readable(wp_path) and wp_path or false,
    layout_color = "#ef4148",

    palette = {
        cpu        = "#ef4148",
        temp_ok    = "#bbc6a1",
        temp_hot   = "#f46b66",
        gpu        = "#91ad6e",
        sys        = "#ddd7c0",
        net_ok     = "#91ad6e",
        net_off    = "#9d3339",
        vol_ok     = "#c9cbb1",
        vol_mute   = "#9d3339",
        bat_ok     = "#ef4148",
        bat_chg    = "#d1ac63",
        bat_warn   = "#d1ac63",
        bat_crit   = "#9d3339",
        bat_badge  = "#ef4148",
        pill_bg1   = "#00000000",
        pill_bg2   = "#10120fee",
        pill_fg    = "#ddd7c0",
        pill_bdr   = "#ef414855",
        pill_bw    = 0,
    },

    bar_height      = dpi(64),
    bar_floating    = true,
    bar_inset       = dpi(12),
    bar_offset      = dpi(10),
    bar_clearance   = dpi(12),
    bar_margin_top  = dpi(12),
    bar_margin_bottom = dpi(12),
    bar_padding_horizontal = dpi(26),
    bar_strut_top   = dpi(86),
    is_flat         = true,
    bar_shape       = console.panel,
    bar_bgimage     = console.background,
    pill_wrapper = function(widget,bg,fg)
        return wibox.widget {
            {widget,left=dpi(5),right=dpi(5),widget=wibox.container.margin},
            bg=bg or "#00000000", fg=fg or "#ddd7c0",
            widget=wibox.container.background,
        }
    end,
    pill_shape_fn   = console.panel,

    window_style    = "rounded_rect",
    window_shape_fn = console.panel,

    notification_shape = console.panel,
    notification_presets = {
        normal = {
            bg           = "#272a24f5",
            fg           = "#ddd7c0",
            border_color = "#ef4148",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#3b2425f8",
            fg           = "#ffffff",
            border_color = "#f46b66",
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
