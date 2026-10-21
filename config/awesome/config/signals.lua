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

-- Apply mode-appropriate shape mask to a client window (Theme-Agnostic)
local function apply_window_shape(c)
    if c.fullscreen then
        c.shape = nil
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            awful.titlebar.hide(c, side)
        end
        return
    end

    if beautiful.perimeter_titlebars then
        c.shape = nil
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            awful.titlebar.show(c, side)
        end
    else
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            awful.titlebar.hide(c, side)
        end

        local shape_fn = beautiful.window_shape_fn
        if type(shape_fn) == "function" then
            local seed = get_client_seed(c)
            local ok, s = pcall(shape_fn, c, seed)
            if ok and s then
                c.shape = s
            else
                -- Might be a direct shape function (cr, w, h)
                c.shape = shape_fn
            end
        else
            c.shape = shape_fn
        end

        if (beautiful.window_style == "bottom_rocks" or beautiful.window_style == "bottom_drips" or beautiful.window_style == "bottom_gears") then
            awful.titlebar.show(c, "bottom")
        end
    end
end

-- Legacy bars follow fullscreen visibility; autohide owns its own visibility.
local function update_screen_wibar(s, ignoring_c)
    if not s or not s.mywibox or s._bar_autohide then return end
    local has_fullscreen = false
    for _, cl in ipairs(s.clients) do
        if cl ~= ignoring_c and cl.valid and cl.fullscreen and cl:isvisible() then
            has_fullscreen = true
            break
        end
    end
    s.mywibox.visible = not has_fullscreen
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if c.fullscreen then
        c.border_width = 0
        update_screen_wibar(c.screen)
    else
        -- Prevent X11 maximized state from overriding tiling layouts
        c.maximized = false
        c.maximized_horizontal = false
        c.maximized_vertical = false
    end

    apply_window_shape(c)

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Awesome implicitly floats fullscreen clients; leave their explicit floating state alone.
-- Hide borders, remove titlebar/shapes, and hide the wibar.
client.connect_signal("property::fullscreen", function(c)
    apply_window_shape(c)
    if c.fullscreen then
        c.border_width = 0
        c:raise()
    else
        c.border_width = (client.focus == c)
            and (beautiful.border_width_focus or beautiful.border_width or 2)
            or (beautiful.border_width or 2)
    end
    update_screen_wibar(c.screen)
end)

-- Restore wibar when client unmanages (closes / quits / killed)
client.connect_signal("unmanage", function(c)
    update_screen_wibar(c.screen, c)
    gears.timer.delayed_call(function()
        if c.screen and c.screen.valid then
            update_screen_wibar(c.screen)
        end
    end)
end)

-- Update wibar on client minimize/unminimize
client.connect_signal("property::minimized", function(c)
    update_screen_wibar(c.screen)
end)

-- Update wibar on tag change
tag.connect_signal("property::selected", function(t)
    update_screen_wibar(t.screen)
end)

-- Update wibar when a client moves between screens
client.connect_signal("property::screen", function(c, old_screen)
    if old_screen then update_screen_wibar(old_screen) end
    if c.screen then update_screen_wibar(c.screen) end
end)

-- Prevent non-floating applications (e.g. Firefox) from forcing X11 maximized state and breaking tiling
client.connect_signal("property::maximized", function(c)
    if c.maximized and not c.floating and not c.fullscreen then
        c.maximized = false
    end
end)
client.connect_signal("property::maximized_horizontal", function(c)
    if c.maximized_horizontal and not c.floating and not c.fullscreen then
        c.maximized_horizontal = false
    end
end)
client.connect_signal("property::maximized_vertical", function(c)
    if c.maximized_vertical and not c.floating and not c.fullscreen then
        c.maximized_vertical = false
    end
end)

-- Add perimeter bars (space/cyber) or bottom overhang bar (slime drips / origin rocks)
client.connect_signal("request::titlebars", function(c)
    if beautiful.perimeter_titlebars and beautiful.window_edge_fn then
        local store = {}
        c._edge_widgets = store
        for _, side in ipairs({ "top", "right", "bottom", "left" }) do
            local edge_bar = awful.titlebar(c, {
                position = side,
                size     = 4,
                bg       = "#00000000",
            })
            local edge_bg = wibox.widget {
                wibox.widget.base.make_widget(),
                bgimage = beautiful.window_edge_fn(c, side),
                widget  = wibox.container.background,
            }
            store[side] = edge_bg
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

    if (beautiful.window_style == "bottom_rocks" or beautiful.window_style == "bottom_drips" or beautiful.window_style == "bottom_gears") and beautiful.window_edge_fn then
        local seed = get_client_seed(c)
        local bottom_bar = awful.titlebar(c, {
            position = "bottom",
            size     = beautiful.window_titlebar_height or ((beautiful.window_edge_height or WIN_DRIP_HEIGHT) + 1),
            bg       = "#00000000",
        })
        local drip_bg = wibox.widget {
            wibox.widget.base.make_widget(),
            bgimage = beautiful.window_edge_fn(c, seed),
            widget  = wibox.container.background,
        }
        c._bottom_drip_bg = drip_bg
        bottom_bar:setup {
            drip_bg,
            layout = wibox.layout.flex.horizontal,
        }
        return
    end

    awful.titlebar.hide(c, "bottom")
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Border styling & redraw on focus/unfocus
client.connect_signal("focus", function(c)
    if c.fullscreen then
        c.border_width = 0
        return
    end
    c.border_width = beautiful.border_width_focus or beautiful.border_width or 2
    c.border_color = beautiful.border_focus or "#55f736"
    if c._bottom_drip_bg then
        c._bottom_drip_bg:emit_signal("widget::redraw_needed")
    end
    if c._edge_widgets then
        for _, w in pairs(c._edge_widgets) do
            w:emit_signal("widget::redraw_needed")
        end
    end
end)

client.connect_signal("unfocus", function(c)
    if c.fullscreen then
        c.border_width = 0
        return
    end
    c.border_width = beautiful.border_width or 2
    c.border_color = beautiful.border_normal or "#222222"
    if c._bottom_drip_bg then
        c._bottom_drip_bg:emit_signal("widget::redraw_needed")
    end
    if c._edge_widgets then
        for _, w in pairs(c._edge_widgets) do
            w:emit_signal("widget::redraw_needed")
        end
    end
end)
