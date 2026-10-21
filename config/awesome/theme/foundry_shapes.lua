-- Foundry: static gear trains carried by cast housings and a shared line shaft.
-- Layout uses 20px edge-depth units, so masks and paint scale together with DPI.
local cairo = require("lgi").cairo
local foundry = {}
local tau = math.pi * 2

local function color(cr, hex, alpha)
    cr:set_source_rgba(tonumber(hex:sub(2, 3), 16) / 255,
        tonumber(hex:sub(4, 5), 16) / 255,
        tonumber(hex:sub(6, 7), 16) / 255, alpha or 1)
end

local function gradient(cr, x, y, height, stops)
    local pat = cairo.Pattern.create_linear(x, y, x + height * 0.25, y + height)
    for i, hex in ipairs(stops) do
        pat:add_color_stop_rgb((i - 1) / (#stops - 1),
            tonumber(hex:sub(2, 3), 16) / 255,
            tonumber(hex:sub(4, 5), 16) / 255,
            tonumber(hex:sub(6, 7), 16) / 255)
    end
    cr:set_source(pat)
end

local function disk(cr, x, y, radius, hex)
    cr:new_sub_path()
    cr:arc(x, y, radius, 0, tau)
    color(cr, hex)
    cr:fill()
end

local function plate(cr, x, y, w, h, bevel)
    local b = math.min(bevel or 3, w / 3, h / 3)
    cr:new_sub_path()
    cr:move_to(x + b, y)
    cr:line_to(x + w - b, y)
    cr:line_to(x + w, y + b)
    cr:line_to(x + w, y + h - b)
    cr:line_to(x + w - b, y + h)
    cr:line_to(x + b, y + h)
    cr:line_to(x, y + h - b)
    cr:line_to(x, y + b)
    cr:close_path()
end

local function bolt(cr, x, y, r)
    disk(cr, x + 0.4, y + 0.9, r + 0.6, "#090c0b")
    cr:arc(x, y, r, 0, tau)
    gradient(cr, x, y - r, r * 2, {"#dfc896", "#9b8050", "#514530"})
    cr:fill()
    cr:move_to(x - r * 0.50, y - r * 0.22)
    cr:line_to(x + r * 0.50, y + r * 0.22)
    color(cr, "#392d1f")
    cr:set_line_width(0.65)
    cr:stroke()
end

-- All wheels in a train share a module (circular tooth pitch). Their centers
-- are separated by pitch radii, rather than stretching the wheels to fill space.
function foundry.assembly_layout(width)
    local layout = {trains = {}, gears = {}, supports = {}}
    local anchors
    if width < 140 then
        anchors = {{width * 0.38, 1, {20, 10}}}
    elseif width < 420 then
        anchors = {{36, 1, {40, 12, 28}}, {width - 30, -1, {20, 10}}}
        if width < 240 then anchors[2] = nil end
    else
        anchors = {
            {42, 1, {40, 12, 28, 10}},
            {width * 0.53, -1, {32, 10, 22}},
            {width - 38, -1, {40, 14, 28}},
        }
        if width > 1450 then
            table.insert(anchors, 2, {width * 0.29, 1, {24, 12, 36}})
        end
    end
    local unit = math.min(1, width / 100)
    local module = 1.2 * unit
    for index, anchor in ipairs(anchors) do
        local train = {gears = {}, left = math.huge, right = -math.huge}
        local previous
        for j, teeth in ipairs(anchor[3]) do
            local pitch = teeth * module / 2
            local g = {teeth = teeth, pitch = pitch, radius = pitch + module,
                module = module, phase = (index % 3) * 0.07, copper = j % 2 == 0}
            -- Bigger wheels sit higher inside the casting; only their lower
            -- section emerges below the instrument fascia. Pinions meet the shaft.
            g.y = math.min((j % 2 == 0 or j == 1) and -1 or 1,
                18 - g.radius) * unit
            if previous then
                local distance = previous.pitch + pitch
                local dy = g.y - previous.y
                g.x = previous.x + anchor[2] * math.sqrt(distance * distance - dy * dy)
                local angle = math.atan(g.y - previous.y, g.x - previous.x)
                -- Tooth on one pitch circle faces a gap on the other.
                g.phase = (angle + math.pi
                    - (math.pi - (angle - previous.phase) * previous.teeth) / teeth) % (tau / teeth)
                g.parent = previous
            else
                g.x = anchor[1]
            end
            train.left = math.min(train.left, g.x - g.radius - 5)
            train.right = math.max(train.right, g.x + g.radius + 5)
            table.insert(train.gears, g)
            table.insert(layout.gears, g)
            previous = g
        end
        -- Narrow windows keep the same machinery, scaled to remain inside them.
        local shift = math.max(0, 2 - train.left) - math.max(0, train.right - width + 2)
        for _, g in ipairs(train.gears) do g.x = g.x + shift end
        train.left = math.max(1, train.left + shift)
        train.right = math.min(width - 1, train.right + shift)
        table.insert(layout.trains, train)
    end
    table.sort(layout.trains, function(a, b) return a.left < b.left end)
    for i = 1, #layout.trains - 1 do
        local left, right = layout.trains[i].right, layout.trains[i + 1].left
        if right - left > 42 then
            table.insert(layout.supports, {x = (left + right) / 2, left = left, right = right})
        end
    end
    return layout
end

-- Reuse local-coordinate tooth paths across masks, shadows and resized clients.
-- This avoids thousands of Lua-to-Cairo line calls on each new surface size.
local tooth_paths, tooth_queue = {}, {}
local path_context = cairo.Context(cairo.ImageSurface.create(cairo.Format.ARGB32, 1, 1))
local function gear_path(cr, g)
    local key = table.concat({g.teeth, g.module, g.phase}, ":")
    local path = tooth_paths[key]
    if path then
        cr:save()
        cr:translate(g.x, g.y)
        cr:append_path(path)
        cr:restore()
        return
    end
    local pitch, m = g.pitch, g.module
    local offsets = {-0.5, -0.34, -0.24, -0.16, 0.16, 0.24, 0.34, 0.5}
    local radii = {pitch - 1.25*m, pitch - 1.25*m, pitch, pitch+m,
        pitch+m, pitch, pitch - 1.25*m, pitch - 1.25*m}
    path_context:new_path()
    for tooth = 0, g.teeth - 1 do
        for i, offset in ipairs(offsets) do
            local angle = (tooth + offset) * tau / g.teeth + g.phase
            local x, y = math.cos(angle) * radii[i], math.sin(angle) * radii[i]
            if tooth == 0 and i == 1 then path_context:move_to(x,y) else path_context:line_to(x,y) end
        end
    end
    path_context:close_path()
    path = path_context:copy_path()
    if #tooth_queue >= 64 then tooth_paths[table.remove(tooth_queue, 1)] = nil end
    tooth_paths[key] = path
    tooth_queue[#tooth_queue+1] = key
    cr:save()
    cr:translate(g.x, g.y)
    cr:append_path(path)
    cr:restore()
end

local function silhouette(cr, w, h, depth, mode, layout)
    if mode == "window" then
        cr:new_path()
        cr:rectangle(0, 0, w, h)
        return
    end
    local scale = depth / 20
    local base = math.max(1, h - depth)
    layout = layout or foundry.assembly_layout(w / scale, mode)
    cr:new_path()
    cr:rectangle(0, 0, w, base)
    cr:save()
    cr:translate(0, base)
    cr:scale(scale, scale)
    for _, train in ipairs(layout.trains) do
        plate(cr, train.left, -17, train.right - train.left, 24, 4)
    end
    for _, g in ipairs(layout.gears) do gear_path(cr, g) end
    cr:restore()
end

function foundry.edge_shape(depth, mode)
    return function(cr, w, h) silhouette(cr, w, h, depth, mode) end
end

local function paint_wheel(cr, g, focused)
    cr:save()
    -- Rear extrusion and a short, directional cast shadow.
    cr:translate(0.7, 1.7)
    gear_path(cr, g)
    color(cr, "#080c0b", 0.95)
    cr:fill()
    cr:restore()
    gear_path(cr, g)
    local stops = focused and (g.copper
        and {"#d3aa7d", "#956344", "#67472f"}
        or {"#e0c28a", "#ad8950", "#6b5537"})
        or {"#9b947e", "#766b50", "#493f30"}
    gradient(cr, g.x - g.radius, g.y - g.radius, g.radius * 2, stops)
    cr:fill_preserve()
    color(cr, focused and "#d3b77c" or "#938167")
    cr:set_line_width(0.65)
    cr:stroke()
    local r = g.pitch
    disk(cr, g.x, g.y + 0.6, r * 0.70, "#111916")
    if g.teeth >= 18 then
        -- Broad load-bearing webs, leaving deep recesses between them.
        cr:set_line_width(r * 0.22)
        for spoke = 0, 4 do
            local a = g.phase + spoke * tau / 5
            cr:move_to(g.x + math.cos(a) * r * 0.24, g.y + math.sin(a) * r * 0.24)
            cr:line_to(g.x + math.cos(a) * r * 0.73, g.y + math.sin(a) * r * 0.73)
        end
        gradient(cr, g.x, g.y - r, r * 2, stops)
        cr:stroke()
    else
        disk(cr, g.x, g.y, r * 0.65, focused and "#997747" or "#766b50")
        for bore = 0, 2 do
            local a = g.phase + bore * tau / 3
            disk(cr, g.x + math.cos(a) * r * 0.43, g.y + math.sin(a) * r * 0.43,
                r * 0.12, "#171b1b")
        end
    end
    cr:arc(g.x, g.y, r * 0.72, 0, tau)
    color(cr, "#4a3826")
    cr:set_line_width(0.8)
    cr:stroke()
    -- Turned bearing boss and keyed axle end.
    disk(cr, g.x + 0.4, g.y + 0.8, r * 0.34, "#0c1110")
    cr:arc(g.x, g.y, r * 0.32, 0, tau)
    gradient(cr, g.x, g.y - r * 0.32, r * 0.64, {"#e0c28a", "#8c7049", "#413a2b"})
    cr:fill()
    disk(cr, g.x, g.y, r * 0.20, "#393f39")
    cr:arc(g.x - r*0.02, g.y - r*0.02, r * 0.14, 0, tau)
    gradient(cr, g.x, g.y - r*0.15, r*0.3, {"#acb0a0", "#4a5048"})
    cr:fill()
    color(cr, "#1b211d")
    cr:rectangle(g.x - r*0.035, g.y - r*0.18, r*0.07, r*0.23)
    cr:fill()
end

-- Gear faces survive a window resize: cache them separately at the actual DPI.
-- Backgrounds below reserve 7 MiB; these sprites reserve the remaining 1 MiB.
local wheels, wheel_queue, wheel_bytes = {}, {}, 0
local function wheel(cr, g, focused, scale)
    local key = table.concat({g.teeth, g.module, g.phase, g.copper and 1 or 0,
        focused and 1 or 0, scale}, ":")
    local sprite = wheels[key]
    local pad = g.radius + 3
    if not sprite then
        local dimension = math.ceil(pad * 2 * scale)
        local size = dimension * dimension * 4
        if size > 1024 * 1024 then
            paint_wheel(cr, g, focused)
            return
        end
        sprite = cairo.ImageSurface.create(cairo.Format.ARGB32, dimension, dimension)
        local target = cairo.Context(sprite)
        target:scale(scale, scale)
        target:translate(pad - g.x, pad - g.y)
        paint_wheel(target, g, focused)
        while #wheel_queue >= 32 or wheel_bytes + size > 1024 * 1024 do
            local oldest = table.remove(wheel_queue, 1)
            wheel_bytes = wheel_bytes - wheels[oldest]:get_stride() * wheels[oldest]:get_height()
            wheels[oldest]:finish()
            wheels[oldest] = nil
        end
        wheels[key] = sprite
        wheel_queue[#wheel_queue+1] = key
        wheel_bytes = wheel_bytes + size
    end
    cr:save()
    cr:translate(g.x - pad, g.y - pad)
    cr:scale(1 / scale, 1 / scale)
    cr:set_source_surface(sprite, 0, 0)
    -- The sprite is already rasterized at device DPI; avoid a second softening
    -- pass when a pitch-circle center lands between device pixels.
    cr:get_source():set_filter(cairo.Filter.NEAREST)
    cr:paint()
    cr:restore()
end

-- Window bottoms are solid iron sills, independent of the wibar's gearing.
local function paint_window_sill(cr, w, h, depth, focused)
    local scale = depth / 20
    local width, height = w / scale, h / scale
    cr:save()
    cr:scale(scale, scale)
    cr:rectangle(0, 0, width, height)
    cr:clip()
    gradient(cr, 0, 0, height, {"#51574b", "#252d28", "#101414"})
    cr:paint()
    if width > 8 and height > 12 then
        plate(cr, 3, 4, width - 6, height - 8, 2)
        gradient(cr, 0, 4, height - 8, {"#343e34", "#232927", "#1a211d"})
        cr:fill_preserve()
        color(cr, "#101714")
        cr:set_line_width(1)
        cr:stroke()
    end
    -- Raised upper bevel and a heavy lower return give the bar its thickness.
    cr:move_to(0, 1)
    cr:line_to(width, 1)
    color(cr, focused and "#ac9264" or "#685b42")
    cr:set_line_width(1)
    cr:stroke()
    cr:move_to(0, height - 4)
    cr:line_to(width, height - 4)
    color(cr, "#4a4437")
    cr:stroke()
    cr:rectangle(0, height - 3, width, 3)
    color(cr, "#0b100e")
    cr:fill()
    local count = math.max(1, math.floor((width - 20) / 80))
    for i = 0, (width < 28 and 0 or count) do
        local x = width < 28 and width / 2 or (10 + i * (width - 20) / count)
        for _, y in ipairs({8, height - 9}) do
            bolt(cr, x, y, math.min(2, width / 8, height / 8))
        end
    end
    cr:restore()
end

local function paint(cr, w, h, depth, focused, mode)
    if mode == "window" then
        paint_window_sill(cr, w, h, depth, focused)
        return
    end
    local scale = depth / 20
    local base = math.max(1, h - depth)
    local width = w / scale
    local layout = foundry.assembly_layout(width, mode)
    cr:save()
    silhouette(cr, w, h, depth, mode, layout)
    cr:clip()
    -- Thick fascia: quiet under the controls, with a rolled highlight at its lip.
    gradient(cr, 0, 0, base, {"#4a5044", "#232927", "#101414"})
    cr:paint()
    cr:translate(0, base)
    cr:scale(scale, scale)
    cr:set_line_width(1)
    cr:move_to(0, -base / scale + 1)
    cr:line_to(width, -base / scale + 1)
    color(cr, "#ac9264")
    cr:stroke()
    -- Rolled upper casing and fasteners sit above the controls, not over text.
    if mode ~= "window" then
        local top = -base / scale
        cr:rectangle(0, top + 2, width, 3)
        gradient(cr, 0, top + 2, 3, {"#8b7a53", "#343c30", "#111b14"})
        cr:fill()
        for x = 14, width - 10, 112 do bolt(cr, x, top + 3.5, 1.2) end
        -- End gussets give the instrument fascia the thickness of a casting.
        for _, x in ipairs({1, math.max(1, width - 9)}) do
            plate(cr, x, top + 5, 8, math.max(1, base / scale - 24), 2)
            gradient(cr, x, top + 5, math.max(1, base / scale - 24),
                {"#79704f", "#3d4737", "#1a241c"})
            cr:fill()
        end
    end
    -- Large wheels extend behind the instrument fascia instead of painting over
    -- controls. The mechanical gallery starts at the existing content boundary.
    cr:rectangle(0, -20, width, 40)
    cr:clip()
    -- Sunken service gallery across the base of the assembly.
    cr:rectangle(0, -20, width, 25)
    gradient(cr, 0, -20, 25, {"#080e0c", "#171e1a", "#0c1110"})
    cr:fill()
    cr:move_to(0, -20)
    cr:line_to(width, -20)
    color(cr, "#685b42")
    cr:stroke()
    -- Shared line shaft and sleeves, behind the gear faces and bearing pedestals.
    cr:move_to(8, 1.4)
    cr:line_to(width - 8, 1.4)
    cr:set_line_width(6)
    color(cr, "#060b09", 0.9)
    cr:stroke()
    cr:move_to(8, -1)
    cr:line_to(width - 8, -1)
    cr:set_line_width(3.5)
    gradient(cr, 0, -3, 5, {"#a7a68d", "#626853", "#242e25"})
    cr:stroke()
    for _, support in ipairs(layout.supports) do
        -- Recessed cooling slots in the otherwise quiet spans between gearboxes.
        local available = support.right - support.left
        if available > 105 then
            local count = math.min(9, math.floor((available - 36) / 12))
            local cx = (support.left + support.right) / 2
            for i = 1, count do
                local x = cx + (i - (count+1)/2)*7
                cr:rectangle(x, -15, 3, 6)
                color(cr, "#060b09")
                cr:fill()
                cr:move_to(x, -8)
                cr:line_to(x+3, -8)
                cr:set_line_width(0.5)
                color(cr, "#555c48")
                cr:stroke()
            end
        end
        plate(cr, support.x - 9, -9, 18, 15, 3)
        gradient(cr, support.x, -9, 15, {"#4d5549", "#252d26", "#151d18"})
        cr:fill_preserve()
        color(cr, "#807151")
        cr:set_line_width(0.7)
        cr:stroke()
        bolt(cr, support.x - 5.5, 2, 1.3)
        bolt(cr, support.x + 5.5, 2, 1.3)
        cr:rectangle(support.x - 4, -4, 8, 6)
        gradient(cr, support.x, -4, 6, {"#b49a66", "#65553a", "#343a2e"})
        cr:fill()
    end
    for _, train in ipairs(layout.trains) do
        local x, span = train.left, train.right - train.left
        -- Cast housing: stepped rear shadow, chamfered casting, inset chamber.
        plate(cr, x, -16, span, 23, 4)
        gradient(cr, x, -16, 23, {"#424a3d", "#282f26", "#161e19"})
        cr:fill_preserve()
        color(cr, focused and "#897650" or "#5d5b48")
        cr:set_line_width(1)
        cr:stroke()
        -- Heavy lower casting lip, distinct from the black inspection recess.
        cr:move_to(x + 4, 5)
        cr:line_to(x + span - 4, 5)
        cr:set_line_width(2)
        color(cr, focused and "#83714e" or "#5b5947")
        cr:stroke()
        plate(cr, x + 3, -12, math.max(1, span - 6), 15, 3)
        color(cr, "#0b120f")
        cr:fill()
        for _, g in ipairs(train.gears) do wheel(cr, g, focused, scale) end
        -- Front upper flange occludes part of the wheels, anchoring the mechanism.
        plate(cr, x + 1, -18, math.max(1, span - 2), 6, 2)
        gradient(cr, x, -18, 6, {"#8d805c", "#424b3a", "#20291f"})
        cr:fill()
        bolt(cr, x + 5, -15, 1.6)
        bolt(cr, x + span - 5, -15, 1.6)
        bolt(cr, x + 5, 3.5, 1.3)
        bolt(cr, x + span - 5, 3.5, 1.3)
    end
    -- Reinforced end cheeks, confined below the content area.
    for _, x in ipairs({1, math.max(1, width - 7)}) do
        plate(cr, x, -19, math.min(6, width - 1), 24, 2)
        gradient(cr, x, -19, 24, {"#74674c", "#343e30", "#1a241c"})
        cr:fill()
        bolt(cr, x + 3, -14, 1.1)
        bolt(cr, x + 3, 0, 1.1)
    end
    cr:restore()
end

-- Bounded FIFO surface cache shared across clients. Identical size/focus states
-- reuse their metalwork during telemetry redraws. No animation or refresh timer.
local cache, queue, bytes = {}, {}, 0
local max_bytes, max_entries = 7 * 1024 * 1024, 24
local function cached_paint(cr, w, h, depth, focused, mode)
    if w <= 0 or h <= 0 then return end
    local key = table.concat({w, h, depth, focused and 1 or 0, mode or "bar"}, ":")
    local surface = cache[key]
    if not surface then
        local iw, ih = math.ceil(w), math.ceil(h)
        local size = iw * ih * 4
        if size > max_bytes then
            paint(cr, w, h, depth, focused, mode)
            return
        end
        surface = cairo.ImageSurface.create(cairo.Format.ARGB32, iw, ih)
        local target = cairo.Context(surface)
        paint(target, w, h, depth, focused, mode)
        while #queue >= max_entries or bytes + size > max_bytes do
            local oldest = table.remove(queue, 1)
            bytes = bytes - cache[oldest]:get_stride() * cache[oldest]:get_height()
            cache[oldest]:finish()
            cache[oldest] = nil
        end
        cache[key] = surface
        queue[#queue+1] = key
        bytes = bytes + size
    end
    cr:save()
    cr:set_source_surface(surface, 0, 0)
    cr:paint()
    cr:restore()
end

function foundry.bar_background(depth)
    return function(_, cr, w, h) cached_paint(cr, w, h, depth, true, "bar") end
end

function foundry.window_background(c, depth)
    return function(_, cr, w, h)
        cached_paint(cr, w, h, depth, client.focus == c, "window")
    end
end

return foundry
