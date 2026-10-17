local gears = require("gears")
local lgi = require("lgi")
local cairo = lgi.cairo

local slime_shapes = {}

-- Cache for precomputed drip edge coordinates keyed by (width, base_y, max_drip, seed, step)
local edge_cache = {}
local edge_cache_count = 0

-- Ensure highest quality supersampled antialiasing (CAIRO_ANTIALIAS_BEST)
local function ensure_best_antialias(cr)
    if cr and cr.set_antialias then
        pcall(function()
            cr:set_antialias(cairo.Antialias.BEST)
        end)
    end
end

-- Helper: Evaluate a dramatic, viscous dripping slime edge at horizontal coordinate t.
local function eval_drip_edge(t, width, base_y, max_drip, seed, with_drips)
    seed = seed or 1.0
    -- Slow, thick meniscus wave between drips
    local wave = 1.8 * math.sin(t * 0.017 + seed)
               + 1.1 * math.sin(t * 0.039 + seed * 2.1)
               + 0.6 * math.cos(t * 0.067 - seed * 1.4)

    local dy = wave

    if with_drips and max_drip and max_drip > 3 then
        local spacing = 85
        local num_buckets = math.floor(width / spacing)
        -- Only inspect the local bucket and its immediate neighbors (O(1) per sample)
        local b = math.floor(t / spacing) + 1
        local i_start = math.max(1, b - 1)
        local i_end = math.min(num_buckets, b + 1)

        for i = i_start, i_end do
            local h1 = math.sin(i * 12.9898 + seed * 78.233) * 43758.5453
            local r1 = h1 - math.floor(h1)
            local h2 = math.sin(i * 93.9898 + seed * 19.19) * 24634.6345
            local r2 = h2 - math.floor(h2)
            local h3 = math.sin(i * 45.164 + seed * 37.71) * 15937.1357
            local r3 = h3 - math.floor(h3)

            local center = (i - 0.5 + (r1 - 0.5) * 0.58) * spacing
            if center > 30 and center < (width - 30) then
                local depth_factor
                if r2 > 0.62 then
                    depth_factor = 0.72 + 0.28 * ((r2 - 0.62) / 0.38)
                elseif r2 > 0.28 then
                    depth_factor = 0.35 + 0.30 * ((r2 - 0.28) / 0.34)
                else
                    depth_factor = 0.18 + 0.15 * (r2 / 0.28)
                end

                local amp = max_drip * depth_factor
                local sigma = (depth_factor > 0.65) and (5.8 + r3 * 3.2) or (8.0 + r3 * 4.5)

                local u = (t - center) / sigma
                if math.abs(u) < 3.4 then
                    local u2 = u * u
                    local g = math.exp(-u2 - 0.08 * u2 * u2)
                    dy = dy + amp * g
                end

                -- Secondary companion mini-drip next to deep drips for organic asymmetry
                if depth_factor > 0.70 then
                    local side = (r1 > 0.5) and 1 or -1
                    local c2 = center + side * (sigma * 2.1)
                    local sigma2 = sigma * 0.68
                    local u_sub = (t - c2) / sigma2
                    if math.abs(u_sub) < 3.0 then
                        local g2 = math.exp(-u_sub * u_sub)
                        dy = dy + (amp * 0.42) * g2
                    end
                end
            end
        end
    end

    -- Smoothstep taper near left and right corners (within 28px)
    local edge_dist = math.min(t, width - t)
    local taper = 1.0
    if edge_dist < 28 then
        taper = math.max(0, edge_dist / 28)
        taper = taper * taper * (3 - 2 * taper)
    end

    local final_y = base_y + math.max(-2.2, math.min(max_drip, dy * taper))
    return t, final_y
end

-- Retrieve or compute cached flat coordinate array {x1, y1, x2, y2, ...} from right (w - 6) to left (6)
local function get_drip_points(width, base_h, max_drip, seed, step)
    local key = string.format("%d_%d_%.1f_%.2f_%.2f", math.floor(width), math.floor(base_h), max_drip, seed, step)
    local pts = edge_cache[key]
    if pts then
        return pts
    end

    -- Prevent unbounded cache growth if windows are dynamically resized
    if edge_cache_count > 120 then
        edge_cache = {}
        edge_cache_count = 0
    end

    pts = {}
    local n = 0
    local t = width - 6
    while t >= 6 do
        local x, y = eval_drip_edge(t, width, base_h, max_drip, seed, true)
        pts[n + 1] = x
        pts[n + 2] = y
        n = n + 2
        t = t - step
    end

    edge_cache[key] = pts
    edge_cache_count = edge_cache_count + 1
    return pts
end

-- 1. Dripping Wibar Shape:
function slime_shapes.dripping_bar(drip_height, seed)
    drip_height = drip_height or 22
    seed = seed or 3.7
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local base_h = math.max(10, h - drip_height)
        local pts = get_drip_points(w, base_h, drip_height - 2.0, seed, 1.5)

        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w, 0)
        cr:line_to(w, base_h - 3)
        cr:curve_to(w, base_h, w - 3, base_h, w - 6, base_h)

        for i = 1, #pts, 2 do
            cr:line_to(pts[i], pts[i + 1])
        end

        cr:curve_to(3, base_h, 0, base_h, 0, base_h - 3)
        cr:close_path()
    end
end

-- Custom Cairo renderer for the Wibar background:
-- Draws the translucent swamp fill, an inner bioluminescent glow, and a neon #55f736 -> #d8eb34 dripping rim
function slime_shapes.render_bar_bg(drip_height, seed)
    drip_height = drip_height or 22
    seed = seed or 3.7
    local shape_fn = slime_shapes.dripping_bar(drip_height, seed)
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)
        shape_fn(cr, w, h)

        -- Vertical slime body gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.047, 0.078, 0.051, 0.95) -- #0c140d
        pat:add_color_stop_rgba(0.65, 0.067, 0.125, 0.078, 0.94) -- #112014
        pat:add_color_stop_rgba(1.0, 0.102, 0.215, 0.118, 0.96) -- #1a371e
        cr:set_source(pat)
        cr:fill_preserve()

        -- Clip to bar interior so strokes don't get cut in half by XShape
        cr:clip_preserve()

        -- Soft wide inner neon glow along the bottom drips
        cr:set_line_width(5.5)
        cr:set_source_rgba(0.333, 0.969, 0.212, 0.28) -- #55f73647
        cr:stroke_preserve()

        -- Crisp outer rim transitioning from neon slime green (#55f736) to toxic yellow (#d8eb34) at drip tips
        local rim = cairo.Pattern.create_linear(0, h - drip_height - 2, 0, h)
        rim:add_color_stop_rgba(0.0, 0.333, 0.969, 0.212, 0.95) -- #55f736
        rim:add_color_stop_rgba(0.55, 0.455, 1.000, 0.180, 1.00) -- #74ff2e
        rim:add_color_stop_rgba(1.0, 0.847, 0.922, 0.204, 1.00) -- #d8eb34
        cr:set_line_width(2.4)
        cr:set_source(rim)
        cr:stroke()

        cr:restore()
    end
end

-- 2. Sleek Modern Window Shape with Drips ONLY at the Bottom:
-- Straight, clean top, left, and right edges with smooth rounded corners,
-- and organic, viscous hanging slime drips along the bottom edge.
function slime_shapes.dripping_window(corner_radius, drip_height, seed)
    corner_radius = corner_radius or 12
    drip_height = drip_height or 18
    seed = seed or 1.4
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local r = math.min(corner_radius, w / 4, h / 4)
        local base_h = math.max(r * 2 + 4, h - drip_height)
        local pts = get_drip_points(w, base_h, drip_height - 2.0, seed, 1.5)

        cr:new_path()
        -- Start at top-left, after the corner
        cr:move_to(r, 0)
        -- Straight clean top edge
        cr:line_to(w - r, 0)
        -- Top-right rounded corner
        cr:arc(w - r, r, r, -math.pi / 2, 0)
        -- Straight clean right edge down to bottom drip transition
        cr:line_to(w, base_h - 3)
        cr:curve_to(w, base_h, w - 3, base_h, w - 6, base_h)

        -- Organic hanging slime drips along the bottom from right to left
        for i = 1, #pts, 2 do
            cr:line_to(pts[i], pts[i + 1])
        end

        -- Bottom-left curve back up to straight left edge
        cr:curve_to(3, base_h, 0, base_h, 0, base_h - 3)
        -- Straight clean left edge
        cr:line_to(0, r)
        -- Top-left rounded corner
        cr:arc(r, r, r, math.pi, 3 * math.pi / 2)
        cr:close_path()
    end
end

-- Custom Cairo renderer for the bottom drip bar of client windows:
-- Draws the dripping bottom edge with anti-aliased inner neon glow and translucent toxic yellow-green drip tips!
function slime_shapes.render_window_bottom_drips(c, corner_radius, drip_height, seed)
    corner_radius = corner_radius or 12
    drip_height = drip_height or 18
    seed = seed or 1.4
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)
        local base_h = math.max(1, h - drip_height)
        local pts = get_drip_points(w, base_h, drip_height - 2.0, seed, 1.5)

        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w, 0)
        cr:line_to(w, base_h - 3)
        cr:curve_to(w, base_h, w - 3, base_h, w - 6, base_h)

        for i = 1, #pts, 2 do
            cr:line_to(pts[i], pts[i + 1])
        end
        cr:curve_to(3, base_h, 0, base_h, 0, base_h - 3)
        cr:close_path()

        -- Fill with translucent dark swamp green matching Kitty & theme bg
        local focused = (client.focus == c)
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.047, 0.078, 0.051, 0.88)
        pat:add_color_stop_rgba(1.0, 0.085, 0.175, 0.098, 0.94)
        cr:set_source(pat)
        cr:fill_preserve()
        cr:clip_preserve()

        if focused then
            -- Soft inner glow
            cr:set_line_width(4.5)
            cr:set_source_rgba(0.333, 0.969, 0.212, 0.20)
            cr:stroke_preserve()

            -- Translucent glowing rim along the drips
            local rim = cairo.Pattern.create_linear(0, base_h, 0, h)
            rim:add_color_stop_rgba(0.0, 0.333, 0.969, 0.212, 0.55)
            rim:add_color_stop_rgba(0.6, 0.455, 1.000, 0.180, 0.70)
            rim:add_color_stop_rgba(1.0, 0.847, 0.922, 0.204, 0.85)
            cr:set_line_width(2.0)
            cr:set_source(rim)
            cr:stroke()
        else
            cr:set_line_width(1.5)
            cr:set_source_rgba(0.141, 0.286, 0.169, 0.40)
            cr:stroke()
        end

        cr:restore()
    end
end

-- 3. Wobbly Blob Pill Shape (for status bar pills & tasklist items):
function slime_shapes.wobbly_pill(radius, seed)
    radius = radius or 7
    seed = seed or 2.1
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local r = math.min(radius, w / 2, h / 2)
        local pad = 1.5
        local step = 2.0

        cr:new_path()
        cr:move_to(r, pad)

        local x = r + step
        while x < w - r do
            local taper = math.min(1.0, math.min(x - r, (w - r) - x) / 10)
            local dy = 1.1 * math.sin(x * 0.065 + seed) * taper
            cr:line_to(x, pad + dy)
            x = x + step
        end
        cr:line_to(w - r, pad)
        cr:curve_to(w - pad, pad, w - pad, h - pad, w - r, h - pad)

        x = w - r - step
        while x > r do
            local taper = math.min(1.0, math.min(x - r, (w - r) - x) / 10)
            local dy = 1.2 * math.cos(x * 0.06 - seed) * taper
            cr:line_to(x, h - pad + dy)
            x = x - step
        end
        cr:line_to(r, h - pad)
        cr:curve_to(pad, h - pad, pad, pad, r, pad)
        cr:close_path()
    end
end

return slime_shapes
