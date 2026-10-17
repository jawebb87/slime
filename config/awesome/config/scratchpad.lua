local awful = require("awful")
local gears = require("gears")

local scratchpad = {}

-- Retrieve or create the hidden special scratchpad tag on a screen
function scratchpad.get_scratch_tag(s)
    s = s or awful.screen.focused()
    local t = awful.tag.find_by_name(s, "scratchpad")
    if not t then
        t = awful.tag.add("scratchpad", {
            screen    = s,
            hide      = true,        -- Ignored by taglist and viewnext/viewprev
            activated = false,       -- Inactive special tag
            layout    = awful.layout.suit.floating,
        })
    end
    return t
end

-- Generic toggle for any scratchpad/dropdown using the hidden special tag
-- cmd: command string to spawn if not running
-- class_pattern: string or table of strings to match window class/instance
-- placement_fn: optional custom placement function (defaults to awful.placement.centered)
function scratchpad.toggle(cmd, class_pattern, placement_fn)
    local cur_screen = awful.screen.focused()
    local cur_tag = cur_screen.selected_tag
    local scratch_tag = scratchpad.get_scratch_tag(cur_screen)

    local function matches(c)
        if not c then return false end
        local c_class = (c.class or ""):lower()
        local c_inst = (c.instance or ""):lower()

        if type(class_pattern) == "table" then
            for _, pat in ipairs(class_pattern) do
                local p = pat:lower()
                if c_class:find(p, 1, true) or c_inst:find(p, 1, true) then
                    return true
                end
            end
        else
            local p = class_pattern:lower()
            if c_class:find(p, 1, true) or c_inst:find(p, 1, true) then
                return true
            end
        end
        return false
    end

    local found = nil
    for _, c in ipairs(client.get()) do
        if matches(c) then
            found = c
            break
        end
    end

    if not found then
        -- Application is not running -> launch it directly onto current workspace
        awful.spawn(cmd)
        return
    end

    -- Check if client is currently attached to the active visible tag
    local on_current_tag = false
    for _, t in ipairs(found:tags()) do
        if t == cur_tag then
            on_current_tag = true
            break
        end
    end

    -- If focused and visible on active tag: banish to hidden scratchpad tag!
    if on_current_tag and found == client.focus and not found.minimized then
        found:move_to_tag(scratch_tag)
    else
        -- Pull from hidden scratchpad tag onto current active workspace
        found.minimized = false
        found:move_to_tag(cur_tag)
        found.floating = true
        found.ontop = true
        if placement_fn then
            placement_fn(found)
        else
            awful.placement.centered(found)
        end
        found:raise()
        client.focus = found
    end
end

return scratchpad
