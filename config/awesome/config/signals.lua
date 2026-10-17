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

-- Apply mode-appropriate shape mask to a client window
local function apply_window_shape(c)
    if c.fullscreen then
        c.shape = nil
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            awful.titlebar.hide(c, side)
        end
    elseif beautiful.mode == "cyber" or beautiful.mode == "space" then
        -- 4-sided perimeter titlebars (Cyber circling bio-pulse / Space Double-Pencil HUD & corner brackets)
        c.shape = nil
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            awful.titlebar.show(c, side)
        end
    elseif beautiful.mode == "lab" then
        -- Sterile laboratory geometry: crisp 4px corners, no slime drips
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 4)
        end
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            awful.titlebar.hide(c, side)
        end
    elseif beautiful.mode == "origin" then
        -- Act 0 Deep Wood: chiseled stone top bevels + craggy rocky outcroppings along the bottom
        local seed = get_client_seed(c)
        c.shape = slime_shapes.rocky_window(10, WIN_DRIP_HEIGHT, seed)
        awful.titlebar.hide(c, "top")
        awful.titlebar.hide(c, "left")
        awful.titlebar.hide(c, "right")
        awful.titlebar.show(c, "bottom")
    elseif beautiful.mode == "shred" then
        -- Standalone Shredder: clean planar edges + sharp 45° precision stealth chamfers, zero jagged teeth
        c.shape = slime_shapes.shred_window(12)
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            awful.titlebar.hide(c, side)
        end
    else
        local seed = get_client_seed(c)
        c.shape = slime_shapes.dripping_window(WIN_CORNER_RADIUS, WIN_DRIP_HEIGHT, seed)
        awful.titlebar.hide(c, "top")
        awful.titlebar.hide(c, "left")
        awful.titlebar.hide(c, "right")
        awful.titlebar.show(c, "bottom")
    end
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Prevent X11 maximized state from overriding tiling layouts
    c.maximized = false
    c.maximized_horizontal = false
    c.maximized_vertical = false

    apply_window_shape(c)

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("property::fullscreen", apply_window_shape)

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

-- Add perimeter bars (cyber / space modes) or bottom overhang bar (slime drips / origin rocks / shredder teeth)
client.connect_signal("request::titlebars", function(c)
    if beautiful.mode == "cyber" then
        c._cyber_edge_widgets = {}
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            local edge_bar = awful.titlebar(c, {
                position = side,
                size     = 3,
                bg       = "#00000000",
            })
            local edge_bg = wibox.widget {
                wibox.widget.base.make_widget(),
                bgimage = slime_shapes.render_cyber_window_edge(c, side),
                widget  = wibox.container.background,
            }
            c._cyber_edge_widgets[side] = edge_bg
            edge_bar:setup {
                edge_bg,
                layout = wibox.layout.flex.horizontal,
            }
        end
        return
    elseif beautiful.mode == "space" then
        c._space_edge_widgets = {}
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            local edge_bar = awful.titlebar(c, {
                position = side,
                size     = 4,
                bg       = "#00000000",
            })
            local edge_bg = wibox.widget {
                wibox.widget.base.make_widget(),
                bgimage = slime_shapes.render_space_window_edge(c, side),
                widget  = wibox.container.background,
            }
            c._space_edge_widgets[side] = edge_bg
            edge_bar:setup {
                edge_bg,
                layout = wibox.layout.flex.horizontal,
            }
        end
        return
    end

    awful.titlebar.hide(c, "top")
    awful.titlebar.hide(c, "left")
    awful.titlebar.hide(c, "right")
    if beautiful.mode == "lab" or beautiful.mode == "shred" then
        awful.titlebar.hide(c, "bottom")
        return
    end
    local seed = get_client_seed(c)
    local bottom_bar = awful.titlebar(c, {
        position = "bottom",
        size     = WIN_DRIP_HEIGHT + 1,
        bg       = "#00000000",
    })
    local bg_renderer
    if beautiful.mode == "origin" then
        bg_renderer = slime_shapes.render_window_bottom_rocks(c, 10, WIN_DRIP_HEIGHT, seed)
    else
        bg_renderer = slime_shapes.render_window_bottom_drips(c, WIN_CORNER_RADIUS, WIN_DRIP_HEIGHT, seed)
    end
    local drip_bg = wibox.widget {
        wibox.widget.base.make_widget(),
        bgimage = bg_renderer,
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

-- Border styling & lightweight redraw of bottom drip / cyber / space perimeter glow on focus/unfocus
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    if c._bottom_drip_bg then
        c._bottom_drip_bg:emit_signal("widget::redraw_needed")
    end
    if c._cyber_edge_widgets then
        for _, w in pairs(c._cyber_edge_widgets) do
            w:emit_signal("widget::redraw_needed")
        end
    end
    if c._space_edge_widgets then
        for _, w in pairs(c._space_edge_widgets) do
            w:emit_signal("widget::redraw_needed")
        end
    end
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    if c._bottom_drip_bg then
        c._bottom_drip_bg:emit_signal("widget::redraw_needed")
    end
    if c._cyber_edge_widgets then
        for _, w in pairs(c._cyber_edge_widgets) do
            w:emit_signal("widget::redraw_needed")
        end
    end
    if c._space_edge_widgets then
        for _, w in pairs(c._space_edge_widgets) do
            w:emit_signal("widget::redraw_needed")
        end
    end
end)
