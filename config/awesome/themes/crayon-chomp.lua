local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/crayon-chomp.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/crayon-chomp.png"
end

local console = require("theme.crayon_shapes")
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
    name            = "crayon-chomp",
    display_name    = "Crayon Chomp",
    narrative_title = "CHOMP! / HACKER MUSKRAT",
    narrative_body  = "Wax crayons. Pond-side computing. (Super+o to cycle)",
    is_light        = true,
    companion_label = "CRAYON CHOMP",
    companion_accent = "#246d9b",
    companion_bg = "#f5efd9",
    has_gill_prompt = false,
    bar_deck_tags = true,
    cpu_meter_widget = function() return meter_widget("CPU") end,
    memory_meter_widget = function() return meter_widget("RAM") end,
    clock_widget = clock_widget,
    telemetry_style = "label",
    telemetry_font = "Noto Sans Bold 9",
    clock_font = "Liberation Mono Bold 19",
    clock_format = " %H:%M ",
    clock_scoreboard = false,

    font_family     = "Noto Sans",
    font_size       = "10",

    border_width    = dpi(2),
    border_normal   = "#f5efd9",
    border_focus    = "#246d9b",
    border_marked   = "#b84435",
    useless_gap     = dpi(7),

    bg_normal       = "#f5efd9ee",
    bg_focus        = "#e6edda",
    bg_urgent       = "#b84435",
    bg_minimize     = "#f8f1de",
    bg_systray      = "#f5efd9",

    fg_normal       = "#39382f",
    fg_focus        = "#263b42",
    fg_urgent       = "#39382f",
    fg_minimize     = "#8a806a",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#246d9b",
    taglist_fg_focus    = "#f8f1de",
    taglist_bg_urgent   = "#b84435",
    taglist_fg_urgent   = "#39382f",
    taglist_bg_occupied = "#d8e8ce",
    taglist_fg_occupied = "#43812e",
    taglist_bg_empty    = "#f5efd9aa",
    taglist_fg_empty    = "#8a806a",
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

    tasklist_bg_normal   = "#f5efd9dd",
    tasklist_fg_normal   = "#66533f",
    tasklist_bg_focus    = "#e6eddaee",
    tasklist_fg_focus    = "#39382f",
    tasklist_bg_urgent   = "#b84435",
    tasklist_fg_urgent   = "#39382f",
    tasklist_bg_minimize = "#f8f1de",
    tasklist_fg_minimize = "#8a806a",
    task_shape           = console.panel,
    task_border_w        = 0,
    task_border_col      = "#246d9b66",

    menu_bg_normal    = "#f5efd9f8",
    menu_bg_focus     = "#c4dbc1",
    menu_fg_normal    = "#39382f",
    menu_fg_focus     = "#246d9b",
    menu_border_color = "#246d9b",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#f5efd9f8",
    hotkeys_fg           = "#39382f",
    hotkeys_border_color = "#246d9b",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#a16c18",
    hotkeys_label_bg     = "#d8e8ce",
    hotkeys_label_fg     = "#246d9b",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#f5efd9",
    titlebar_bg_focus  = "#e6edda",
    titlebar_fg_normal = "#8a806a",
    titlebar_fg_focus  = "#246d9b",

    wallpaper    = gfs.file_readable(wp_path) and wp_path or false,
    layout_color = "#246d9b",

    palette = {
        cpu        = "#246d9b",
        temp_ok    = "#43812e",
        temp_hot   = "#b84435",
        gpu        = "#43812e",
        sys        = "#39382f",
        net_ok     = "#43812e",
        net_off    = "#b84435",
        vol_ok     = "#4d786f",
        vol_mute   = "#b84435",
        bat_ok     = "#246d9b",
        bat_chg    = "#a16c18",
        bat_warn   = "#a16c18",
        bat_crit   = "#b84435",
        bat_badge  = "#246d9b",
        pill_bg1   = "#00000000",
        pill_bg2   = "#f8f1deee",
        pill_fg    = "#39382f",
        pill_bdr   = "#246d9b55",
        pill_bw    = 0,
    },

    bar_height      = dpi(64),
    bar_floating    = true,
    bar_inset       = dpi(12),
    bar_offset      = dpi(10),
    bar_clearance   = dpi(12),
    bar_margin_top  = dpi(12),
    bar_margin_bottom = dpi(10),
    bar_padding_horizontal = dpi(22),
    bar_strut_top   = dpi(86),
    is_flat         = true,
    bar_shape       = console.shape,
    bar_bgimage     = console.background,
    pill_wrapper = function(widget,bg,fg)
        return wibox.widget {
            {widget,left=dpi(5),right=dpi(5),widget=wibox.container.margin},
            bg=bg or "#00000000", fg=fg or "#39382f",
            widget=wibox.container.background,
        }
    end,
    pill_shape_fn   = console.panel,

    window_style    = "rounded_rect",
    window_shape_fn = console.panel,

    notification_shape = console.panel,
    notification_presets = {
        normal = {
            bg           = "#f5efd9f5",
            fg           = "#39382f",
            border_color = "#246d9b",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#f6d4e8f8",
            fg           = "#39382f",
            border_color = "#b84435",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#f8f1def2",
            fg           = "#43812e",
            border_color = "#c4dbc1",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
