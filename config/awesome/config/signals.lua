local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local slime_shapes = require("theme.slime_shapes")

local WIN_CORNER_RADIUS = 12
local WIN_DRIP_HEIGHT = 18

local function get_client_seed(c)
    return ((c.window or 1) % 23) * 0.67 + 1.1
end

-- Apply modern straight-sided + bottom-dripping Cairo shape mask to a client window
local function apply_slime_shape(c)
    if c.fullscreen then
        c.shape = nil
        awful.titlebar.hide(c, "bottom")
    else
        local seed = get_client_seed(c)
        c.shape = slime_shapes.dripping_window(WIN_CORNER_RADIUS, WIN_DRIP_HEIGHT, seed)
        awful.titlebar.show(c, "bottom")
    end
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Prevent X11 maximized state from overriding tiling layouts
    c.maximized = false
    c.maximized_horizontal = false
    c.maximized_vertical = false

    apply_slime_shape(c)

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("property::fullscreen", apply_slime_shape)

-- Prevent applications (e.g. Firefox) from forcing X11 maximized state and breaking tiling
client.connect_signal("property::maximized", function(c)
    if c.maximized then c.maximized = false end
end)
client.connect_signal("property::maximized_horizontal", function(c)
    if c.maximized_horizontal then c.maximized_horizontal = false end
end)
client.connect_signal("property::maximized_vertical", function(c)
    if c.maximized_vertical then c.maximized_vertical = false end
end)

-- Add a bottom slime-drip margin bar (no top titlebar) rendered with Cairo gradients & toxic glow
client.connect_signal("request::titlebars", function(c)
    awful.titlebar.hide(c, "top")
    local seed = get_client_seed(c)
    local bottom_bar = awful.titlebar(c, {
        position = "bottom",
        size     = WIN_DRIP_HEIGHT + 1,
        bg       = "#00000000",
    })
    local drip_bg = wibox.widget {
        wibox.widget.base.make_widget(),
        bgimage = slime_shapes.render_window_bottom_drips(c, WIN_CORNER_RADIUS, WIN_DRIP_HEIGHT, seed),
        widget  = wibox.container.background,
    }
    c._bottom_drip_bg = drip_bg
    bottom_bar:setup {
        drip_bg,
        layout = wibox.layout.flex.horizontal,
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Border styling & lightweight redraw of bottom drip glow on focus/unfocus
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    if c._bottom_drip_bg then
        c._bottom_drip_bg:emit_signal("widget::redraw_needed")
    end
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    if c._bottom_drip_bg then
        c._bottom_drip_bg:emit_signal("widget::redraw_needed")
    end
end)
