-- Each screen owns a transparent edge sensor and an overlay bar with no strut.
local gears = require('gears')
local wibox = require('wibox')
local mouse = mouse
local GLib = require('lgi').GLib
local M = {}

function M.attach(s, bar, options)
    options = options or {}
    local strip_height = options.strip_height or 2
    local delay = options.hide_delay or 0.45
    local now = options.now or function() return GLib.get_monotonic_time() / 1000000 end
    local pointer = options.pointer or function() return mouse.coords() end
    local trigger = wibox {
        screen = s, type = 'dock', ontop = true, visible = false,
        bg = '#00000000', input_passthrough = false,
    }
    local outside_since
    local disposed = false
    local poll
    local function inside_reveal_area()
        local p, g, b = pointer(), s.geometry, bar:geometry()
        -- Include the top gap and side insets so detached art stays reachable.
        return p.x >= g.x and p.x < g.x + g.width
            and p.y >= g.y and p.y < math.max(g.y + strip_height, b.y + b.height)
    end
    local function hide()
        bar.visible = false
        outside_since = nil
        if poll.started then poll:stop() end
    end
    local function show()
        if disposed then return end
        outside_since = nil
        bar.visible = true
        if not poll.started then poll:start() end
    end
    poll = gears.timer {
        timeout = 0.1,
        callback = function()
            if disposed then return end
            if inside_reveal_area() then
                outside_since = nil
            else
                outside_since = outside_since or now()
                if now() - outside_since >= delay then hide() end
            end
        end,
    }
    local function place()
        local g = s.geometry
        local b
        if options.floating then
            b = require('ui.bar_geometry')(g, options.height,
                options.inset, options.offset, 0)
        else
            b = {x=g.x, y=g.y, width=g.width, height=options.height}
        end
        bar:geometry(b)
        bar:struts {top=0, bottom=0, left=0, right=0}
        trigger:geometry {x=g.x, y=g.y, width=g.width, height=strip_height}
        trigger:struts {top=0, bottom=0, left=0, right=0}
        trigger.visible = true
    end
    local function dispose()
        if disposed then return end
        disposed = true
        hide()
        trigger.visible = false
        trigger:disconnect_signal('mouse::enter', show)
        bar:disconnect_signal('mouse::enter', show)
        s:disconnect_signal('property::geometry', place)
        s:disconnect_signal('removed', dispose)
    end
    bar.ontop = true
    bar.type = 'dock'
    bar.visible = false
    trigger:connect_signal('mouse::enter', show)
    bar:connect_signal('mouse::enter', show)
    s:connect_signal('property::geometry', place)
    s:connect_signal('removed', dispose)
    place()
    return {trigger=trigger, dispose=dispose}
end

return M
