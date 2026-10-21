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
-- placement_fn: optional custom placement function (defaults to awful.placement.centered) or boolean for is_ephemeral
-- is_ephemeral: boolean (if true, dismissing kills the process to free RAM instead of hiding it)
function scratchpad.toggle(cmd, class_pattern, placement_fn, is_ephemeral)
    if type(placement_fn) == "boolean" then
        is_ephemeral = placement_fn
        placement_fn = nil
    end

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

    -- If focused and visible on active tag: kill if ephemeral, else banish to hidden scratchpad tag
    if on_current_tag and found == client.focus and not found.minimized then
        if is_ephemeral then
            found:kill()
        else
            found:move_to_tag(scratch_tag)
        end
    else
        -- Pull from hidden scratchpad tag onto current active workspace
        found.minimized = false
        found:move_to_tag(cur_tag)
        found.floating = true
        found.ontop = true
        if placement_fn then
            placement_fn(found)
        else
            -- Ensure terminal scratchpads are at least 75% wide by 60% high
            local c_class = (found.class or ""):lower()
            local c_inst = (found.instance or ""):lower()
            local is_term = false
            for _, kw in ipairs({ "btop", "notes", "fzf", "chomp", "larry", "mothgomery", "gill", "baron", "rable", "tov", "molly", "dino", "crust", "tunes", "mystery", "scooby", "darkwing", "duck", "tmnt", "turtle", "muppet", "babies", "jon", "garfield", "bake", "wake", "weed", "sloth", "agy", "theme-console", "term-scratch", "lazygit", "ranger", "ipython" }) do
                if c_class:find(kw, 1, true) or c_inst:find(kw, 1, true) then
                    is_term = true
                    break
                end
            end

            if is_term then
                local geo = cur_screen.workarea
                local min_w = math.floor(geo.width * 0.75)
                local min_h = math.floor(geo.height * 0.60)
                local w = math.max(found.width or 0, min_w)
                local h = math.max(found.height or 0, min_h)
                found:geometry({
                    width  = w,
                    height = h,
                    x      = geo.x + math.floor((geo.width - w) / 2),
                    y      = geo.y + math.floor((geo.height - h) / 2),
                })
            else
                awful.placement.centered(found)
            end
        end
        found:raise()
        client.focus = found
    end
end

return scratchpad
