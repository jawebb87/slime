local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/moonlit-well.jpg"
if not gfs.file_readable(wp_path) then
    wp_path = os.getenv("HOME") .. "/Pictures/wallpaper/moonlit-well.png"
end

local console = require("theme.well_shapes")
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
    name            = "moonlit-well",
    display_name    = "The Well",
    narrative_title = "THE WELL / SOMETHING ANSWERED",
    narrative_body  = "No one remembers when the well appeared. Tonight, something answered. (Super+o to cycle)",
    is_light        = false,
    companion_label = "THE WELL",
    companion_accent = "#79c9c3",
    companion_bg = "#142229",
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
    border_normal   = "#142229",
    border_focus    = "#79c9c3",
    border_marked   = "#cd8792",
    useless_gap     = dpi(7),

    bg_normal       = "#142229ee",
    bg_focus        = "#20343c",
    bg_urgent       = "#8f5269",
    bg_minimize     = "#050b0f",
    bg_systray      = "#142229",

    fg_normal       = "#d9e7ec",
    fg_focus        = "#f0f7fa",
    fg_urgent       = "#ffffff",
    fg_minimize     = "#92a6ae",

    tag_names           = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    taglist_bg_focus    = "#79c9c3",
    taglist_fg_focus    = "#050b0f",
    taglist_bg_urgent   = "#8f5269",
    taglist_fg_urgent   = "#ffffff",
    taglist_bg_occupied = "#22343b",
    taglist_fg_occupied = "#9bb9cb",
    taglist_bg_empty    = "#142229aa",
    taglist_fg_empty    = "#92a6ae",
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

    tasklist_bg_normal   = "#142229dd",
    tasklist_fg_normal   = "#c0d1d7",
    tasklist_bg_focus    = "#20343cee",
    tasklist_fg_focus    = "#ffffff",
    tasklist_bg_urgent   = "#8f5269",
    tasklist_fg_urgent   = "#ffffff",
    tasklist_bg_minimize = "#050b0f",
    tasklist_fg_minimize = "#92a6ae",
    task_shape           = console.panel,
    task_border_w        = 0,
    task_border_col      = "#79c9c366",

    menu_bg_normal    = "#142229f8",
    menu_bg_focus     = "#354c54",
    menu_fg_normal    = "#d9e7ec",
    menu_fg_focus     = "#79c9c3",
    menu_border_color = "#79c9c3",
    menu_border_width = dpi(1),
    menu_height       = dpi(26),
    menu_width        = dpi(150),

    hotkeys_bg           = "#142229f8",
    hotkeys_fg           = "#d9e7ec",
    hotkeys_border_color = "#79c9c3",
    hotkeys_border_width = dpi(2),
    hotkeys_modifiers_fg = "#c4b788",
    hotkeys_label_bg     = "#22343b",
    hotkeys_label_fg     = "#79c9c3",
    hotkeys_group_margin = dpi(16),

    titlebar_bg_normal = "#142229",
    titlebar_bg_focus  = "#20343c",
    titlebar_fg_normal = "#92a6ae",
    titlebar_fg_focus  = "#79c9c3",

    wallpaper    = gfs.file_readable(wp_path) and wp_path or false,
    layout_color = "#79c9c3",

    palette = {
        cpu        = "#79c9c3",
        temp_ok    = "#9bb789",
        temp_hot   = "#cd8792",
        gpu        = "#9bb9cb",
        sys        = "#d9e7ec",
        net_ok     = "#9bb9cb",
        net_off    = "#8f5269",
        vol_ok     = "#b9d4df",
        vol_mute   = "#8f5269",
        bat_ok     = "#79c9c3",
        bat_chg    = "#c4b788",
        bat_warn   = "#c4b788",
        bat_crit   = "#8f5269",
        bat_badge  = "#79c9c3",
        pill_bg1   = "#00000000",
        pill_bg2   = "#050b0fee",
        pill_fg    = "#d9e7ec",
        pill_bdr   = "#79c9c355",
        pill_bw    = 0,
    },

    bar_height      = dpi(64),
    bar_floating    = true,
    bar_inset       = dpi(12),
    bar_offset      = dpi(10),
    bar_clearance   = dpi(12),
    bar_margin_top  = dpi(12),
    bar_margin_bottom = dpi(12),
    bar_padding_horizontal = dpi(40),
    bar_strut_top   = dpi(86),
    is_flat         = true,
    bar_shape       = console.shape,
    bar_bgimage     = console.background,
    pill_wrapper = function(widget,bg,fg)
        return wibox.widget {
            {widget,left=dpi(5),right=dpi(5),widget=wibox.container.margin},
            bg=bg or "#00000000", fg=fg or "#d9e7ec",
            widget=wibox.container.background,
        }
    end,
    pill_shape_fn   = console.panel,

    window_style    = "rounded_rect",
    window_shape_fn = console.panel,

    notification_shape = console.panel,
    notification_presets = {
        normal = {
            bg           = "#142229f5",
            fg           = "#d9e7ec",
            border_color = "#79c9c3",
            border_width = 2,
            timeout      = 5,
        },
        critical = {
            bg           = "#30202bf8",
            fg           = "#ffffff",
            border_color = "#cd8792",
            border_width = 2,
            timeout      = 0,
        },
        low = {
            bg           = "#050b0ff2",
            fg           = "#9bb789",
            border_color = "#354c54",
            border_width = 1,
            timeout      = 4,
        },
    },
}

return theme
