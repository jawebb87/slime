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

-- 4. Sterile Laboratory Bar Background Renderer (Pre-Contamination):
-- Draws a crisp clinical white ceramic surface with a stark 2px solid black bottom border.
function slime_shapes.render_lab_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Clinical white -> subtle brushed light grey gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.985, 0.990, 0.996, 0.97) -- #fbfcfe
        pat:add_color_stop_rgba(1.0, 0.941, 0.957, 0.973, 0.98) -- #f0f4f8
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- Stark 2px jet-black bottom border line
        cr:rectangle(0, h - 2, w, 2)
        cr:set_source_rgba(0.0, 0.0, 0.0, 1.0)
        cr:fill()

        cr:restore()
    end
end

-- 5. Cyberpunk Future Bar & Active Window Perimeter Pulse Engine (Bio-Grid Cyberdeck):
-- Shared animation clock updated by a lightweight timer in cyber mode.
slime_shapes.cyber_pulse_time = 0

-- Helper: populates a linear Cairo pattern with a pulsing toxic-green (#55f736 -> #74ff2e -> #d8eb34)
-- bio-slime energy packet (tail at stop 0.0 -> glowing core at stop 0.84 -> leading shockfront at 1.0).
local function add_cyber_slime_pulse_stops(grad, pulse, alpha_scale)
    alpha_scale = alpha_scale or 1.0
    local p = pulse * alpha_scale
    grad:add_color_stop_rgba(0.00, 0.333, 0.969, 0.212, 0.00)                   -- Transparent wake
    grad:add_color_stop_rgba(0.20, 0.000, 0.941, 1.000, math.min(1.0, 0.22 * p)) -- #00f0ff Acid Cyan wake
    grad:add_color_stop_rgba(0.50, 0.333, 0.969, 0.212, math.min(1.0, 0.62 * p)) -- #55f736 Toxic Bio-Slime trail
    grad:add_color_stop_rgba(0.76, 0.455, 1.000, 0.180, math.min(1.0, 0.94 * p)) -- #74ff2e High-voltage Neon Green
    grad:add_color_stop_rgba(0.85, 0.847, 0.922, 0.204, math.min(1.0, 1.00 * alpha_scale)) -- #d8eb34 Hot Bioluminescent Core
    grad:add_color_stop_rgba(0.93, 0.333, 0.969, 0.212, math.min(1.0, 0.85 * p)) -- #55f736 Leading Green Front
    grad:add_color_stop_rgba(1.00, 0.333, 0.969, 0.212, 0.00)                   -- Transparent front
end

-- 5a. Cyberpunk Future Bar Background Renderer:
-- Draws an obsidian ink-violet surface (#090812 -> #161326) with an electric purple (#a855f7)
-- bottom rail and a pulsing toxic-green (#55f736) light that sweeps continuously across the bar.
function slime_shapes.render_cyber_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Obsidian #090812 -> #161326 vertical gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.035, 0.031, 0.071, 0.96) -- #090812
        pat:add_color_stop_rgba(1.0, 0.086, 0.075, 0.149, 0.96) -- #161326
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- Base 1px bottom border in Electric Purple (#a855f7) with Acid Cyan (#00f0ff) side conduits
        local rim = cairo.Pattern.create_linear(0, 0, w, 0)
        rim:add_color_stop_rgba(0.00, 0.659, 0.333, 0.969, 0.92) -- #a855f7 (Electric Purple)
        rim:add_color_stop_rgba(0.30, 0.475, 0.157, 0.792, 0.85) -- #7928ca (Neon Violet)
        rim:add_color_stop_rgba(0.50, 0.659, 0.333, 0.969, 0.92) -- #a855f7 (Electric Purple)
        rim:add_color_stop_rgba(0.70, 0.475, 0.157, 0.792, 0.85) -- #7928ca (Neon Violet)
        rim:add_color_stop_rgba(1.00, 0.659, 0.333, 0.969, 0.92) -- #a855f7 (Electric Purple)
        cr:rectangle(0, h - 1, w, 1)
        cr:set_source(rim)
        cr:fill()

        -- Pulsing toxic-green light sweeping continuously across the bar
        local t = slime_shapes.cyber_pulse_time or 0
        local pulse = 0.68 + 0.32 * (0.5 + 0.5 * math.sin(t * 7.2))
        local phase = (t * 0.26) % 1.0
        local head_x = phase * w
        local tail_len = math.max(180, w * 0.22)
        local lead_len = math.max(36, w * 0.04)

        for k = -1, 1 do
            local hx = head_x + k * w
            local x0 = hx - tail_len
            local x1 = hx + lead_len
            if x1 > 0 and x0 < w then
                -- Soft upward bio-slime glow along the bottom 6px of the bar
                local glow = cairo.Pattern.create_linear(x0, 0, x1, 0)
                add_cyber_slime_pulse_stops(glow, pulse, 0.30)
                cr:rectangle(math.max(0, x0), h - 6, math.min(w, x1) - math.max(0, x0), 5)
                cr:set_source(glow)
                cr:fill()

                -- Crisp 2px toxic-green energy core riding along the bottom edge of the bar
                local rail = cairo.Pattern.create_linear(x0, 0, x1, 0)
                add_cyber_slime_pulse_stops(rail, pulse, 1.00)
                cr:rectangle(math.max(0, x0), h - 2, math.min(w, x1) - math.max(0, x0), 2)
                cr:set_source(rail)
                cr:fill()
            end
        end

        cr:restore()
    end
end

-- 5b. Cyberpunk Active Window Perimeter Renderer:
-- Renders the 4 outer edges ("top", "right", "bottom", "left") of a client window in cyber mode.
-- When unfocused: draws a deep indigo trench (#090812) with a razor-sharp 1px Neon Violet (#7928ca) outer edge.
-- When focused: draws an Electric Purple (#a855f7) outer rail and a pulsing toxic-green (#55f736 / #74ff2e)
-- bio-slime light that circles clockwise around the entire perimeter of the active window!
function slime_shapes.render_cyber_window_edge(c, side)
    return function(_, cr, w, h)
        if not c or not c.valid then return end
        cr:save()
        ensure_best_antialias(cr)

        local focused = (client.focus == c)

        -- Base trench fill
        if focused then
            cr:set_source_rgba(0.055, 0.047, 0.110, 0.96) -- #0e0c1c
        else
            cr:set_source_rgba(0.035, 0.031, 0.071, 0.92) -- #090812
        end
        cr:rectangle(0, 0, w, h)
        cr:fill()

        -- Base 1px outer cyberdeck border line (#a855f7 when focused, #7928ca when unfocused)
        if focused then
            cr:set_source_rgba(0.659, 0.333, 0.969, 0.92) -- #a855f7 (Electric Purple)
        else
            cr:set_source_rgba(0.475, 0.157, 0.792, 0.85) -- #7928ca (Neon Violet)
        end

        if side == "top" then
            cr:rectangle(0, 0, w, 1)
            cr:rectangle(0, 0, 1, h)
            cr:rectangle(w - 1, 0, 1, h)
        elseif side == "bottom" then
            cr:rectangle(0, h - 1, w, 1)
            cr:rectangle(0, 0, 1, h)
            cr:rectangle(w - 1, 0, 1, h)
        elseif side == "left" then
            cr:rectangle(0, 0, 1, h)
        elseif side == "right" then
            cr:rectangle(w - 1, 0, 1, h)
        end
        cr:fill()

        -- If focused, draw the pulsing toxic-green light circling clockwise around the window perimeter
        if focused then
            local t = slime_shapes.cyber_pulse_time or 0
            local pulse = 0.68 + 0.32 * (0.5 + 0.5 * math.sin(t * 7.5))

            local is_horiz = (side == "top" or side == "bottom")
            local W = is_horiz and w or math.max(1, c.width or w)
            local H_side = is_horiz and math.max(1, (c.height or h) - 2 * h) or h
            local P = 2 * (W + H_side)

            if P > 8 then
                local edge_len = is_horiz and W or H_side
                local s_start
                if side == "top" then
                    s_start = 0
                elseif side == "right" then
                    s_start = W
                elseif side == "bottom" then
                    s_start = W + H_side
                else -- "left"
                    s_start = 2 * W + H_side
                end

                local orbit_phase = (t * 0.32) % 1.0
                local s_head = orbit_phase * P
                local tail_len = math.min(340, math.max(140, P * 0.22))
                local lead_len = math.min(56, math.max(24, P * 0.04))

                for k = -1, 1 do
                    local sk = s_head + k * P
                    local s_tail = sk - tail_len
                    local s_lead = sk + lead_len

                    if s_lead > s_start and s_tail < (s_start + edge_len) then
                        local grad
                        if side == "top" then
                            grad = cairo.Pattern.create_linear(s_tail, 0, s_lead, 0)
                        elseif side == "right" then
                            grad = cairo.Pattern.create_linear(0, s_tail - s_start, 0, s_lead - s_start)
                        elseif side == "bottom" then
                            grad = cairo.Pattern.create_linear(W - (s_tail - s_start), 0, W - (s_lead - s_start), 0)
                        else -- "left"
                            grad = cairo.Pattern.create_linear(0, H_side - (s_tail - s_start), 0, H_side - (s_lead - s_start))
                        end

                        -- Inner bio-slime glow across the full 3px conduit strip
                        add_cyber_slime_pulse_stops(grad, pulse, 0.48)
                        cr:rectangle(0, 0, w, h)
                        cr:set_source(grad)
                        cr:fill()

                        -- Bright 2px outer toxic-green light along the outside edge
                        local core_grad
                        if side == "top" then
                            core_grad = cairo.Pattern.create_linear(s_tail, 0, s_lead, 0)
                            add_cyber_slime_pulse_stops(core_grad, pulse, 1.0)
                            cr:rectangle(0, 0, w, math.min(2, h))
                        elseif side == "right" then
                            core_grad = cairo.Pattern.create_linear(0, s_tail - s_start, 0, s_lead - s_start)
                            add_cyber_slime_pulse_stops(core_grad, pulse, 1.0)
                            cr:rectangle(math.max(0, w - 2), 0, math.min(2, w), h)
                        elseif side == "bottom" then
                            core_grad = cairo.Pattern.create_linear(W - (s_tail - s_start), 0, W - (s_lead - s_start), 0)
                            add_cyber_slime_pulse_stops(core_grad, pulse, 1.0)
                            cr:rectangle(0, math.max(0, h - 2), w, math.min(2, h))
                        else -- "left"
                            core_grad = cairo.Pattern.create_linear(0, H_side - (s_tail - s_start), 0, H_side - (s_lead - s_start))
                            add_cyber_slime_pulse_stops(core_grad, pulse, 1.0)
                            cr:rectangle(0, 0, math.min(2, w), h)
                        end
                        cr:set_source(core_grad)
                        cr:fill()
                    end
                end
            end
        end

        cr:restore()
    end
end

-- ==============================================================================
-- 6. Act 0 Specimen Origin / Deep Wood — Procedural Rocky Outcroppings Engine
-- ==============================================================================
-- Evaluates a craggy, faceted stone outcropping / stalactite shelf at horizontal coordinate t.
local function eval_rock_edge(t, width, base_y, max_jut, seed)
    seed = seed or 1.0

    -- Angular triangle-wave / stepped stone fracture baseline (chiseled rock shelf)
    local p1 = (t * 0.022 + seed) % (2 * math.pi)
    local tri1 = (2 / math.pi) * math.asin(math.sin(p1))
    local p2 = (t * 0.053 - seed * 1.7) % (2 * math.pi)
    local tri2 = (2 / math.pi) * math.asin(math.sin(p2))
    local dy = 1.6 * tri1 + 1.0 * tri2

    if max_jut and max_jut > 3 then
        local spacing = 92
        local num_buckets = math.floor(width / spacing)
        local b = math.floor(t / spacing) + 1
        local i_start = math.max(1, b - 1)
        local i_end = math.min(num_buckets, b + 1)

        for i = i_start, i_end do
            local h1 = math.sin(i * 17.371 + seed * 61.13) * 43758.5453
            local r1 = h1 - math.floor(h1)
            local h2 = math.sin(i * 83.419 + seed * 29.71) * 24634.6345
            local r2 = h2 - math.floor(h2)
            local h3 = math.sin(i * 51.923 + seed * 43.17) * 15937.1357
            local r3 = h3 - math.floor(h3)

            local center = (i - 0.5 + (r1 - 0.5) * 0.52) * spacing
            if center > 28 and center < (width - 28) then
                local depth_factor
                if r2 > 0.58 then
                    depth_factor = 0.74 + 0.26 * ((r2 - 0.58) / 0.42)
                elseif r2 > 0.25 then
                    depth_factor = 0.42 + 0.28 * ((r2 - 0.25) / 0.33)
                else
                    depth_factor = 0.22 + 0.18 * (r2 / 0.25)
                end

                local amp = max_jut * depth_factor
                -- Wide, craggy rock formation width
                local half_w = (depth_factor > 0.65) and (14.0 + r3 * 8.0) or (18.0 + r3 * 9.0)

                -- Asymmetric left/right rock slopes for natural fractured crag look
                local skew = (r1 - 0.5) * 0.35
                local dist = t - center
                local slope_w = (dist < 0) and (half_w * (1.0 - skew)) or (half_w * (1.0 + skew))
                local u = math.abs(dist) / slope_w

                if u < 1.0 then
                    -- Angular crag profile with a stepped rock ledge plateau near the middle
                    local linear_cone = 1.0 - u
                    -- Quantize/step part of the slope into a chiseled rock terrace
                    local stepped = math.floor(linear_cone * 4.5 + 0.35) / 4.5
                    local crag = 0.62 * linear_cone + 0.38 * math.min(1.0, stepped)
                    dy = math.max(dy, amp * crag + 0.8 * tri2)
                end

                -- Secondary jagged rock spur / stalactite tooth beside major outcroppings
                if depth_factor > 0.55 then
                    local side = (r3 > 0.5) and 1 or -1
                    local c2 = center + side * (half_w * 0.82)
                    local hw2 = half_w * 0.52
                    local u2 = math.abs(t - c2) / hw2
                    if u2 < 1.0 then
                        local spur = (1.0 - u2) * (amp * 0.58)
                        dy = math.max(dy, spur)
                    end
                end
            end
        end
    end

    -- Linear chiseled taper near left and right corners (within 26px)
    local edge_dist = math.min(t, width - t)
    local taper = 1.0
    if edge_dist < 26 then
        taper = math.max(0, edge_dist / 26)
    end

    -- Quantize vertical coordinate slightly (0.5px steps) for crisp chiseled stone facets
    local raw_y = base_y + math.max(-1.5, math.min(max_jut, dy * taper))
    local final_y = math.floor(raw_y * 2.0 + 0.5) / 2.0
    return t, final_y
end

local function get_rock_points(width, base_h, max_jut, seed, step)
    step = step or 5.0
    local key = string.format("rock_%d_%d_%.1f_%.2f_%.2f", math.floor(width), math.floor(base_h), max_jut, seed, step)
    local pts = edge_cache[key]
    if pts then
        return pts
    end

    if edge_cache_count > 120 then
        edge_cache = {}
        edge_cache_count = 0
    end

    pts = {}
    local n = 0
    local t = width - 6
    while t >= 6 do
        local x, y = eval_rock_edge(t, width, base_h, max_jut, seed)
        pts[n + 1] = x
        pts[n + 2] = y
        n = n + 2
        t = t - step
    end

    edge_cache[key] = pts
    edge_cache_count = edge_cache_count + 1
    return pts
end

-- 6a. Jagged Rocky Outcropping Wibar Shape:
function slime_shapes.rocky_bar(rock_height, seed)
    rock_height = rock_height or 20
    seed = seed or 4.1
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local base_h = math.max(10, h - rock_height)
        local pts = get_rock_points(w, base_h, rock_height - 2.0, seed, 5.0)

        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w, 0)
        cr:line_to(w, base_h - 4)
        cr:line_to(w - 6, base_h)

        for i = 1, #pts, 2 do
            cr:line_to(pts[i], pts[i + 1])
        end

        cr:line_to(6, base_h)
        cr:line_to(0, base_h - 4)
        cr:close_path()
    end
end

-- 6b. Custom Cairo Renderer for the Act 0 Wibar Background:
-- Draws Deep Forest Soil (#141712) to Bark & Monolith Stone (#241e17), a Lichen Moss (#5a784d)
-- inner stone bevel, and a Bioluminescent Spore (#9ece6a) + Weathered Amber (#d08770) craggy rim!
function slime_shapes.render_origin_bar_bg(rock_height, seed)
    rock_height = rock_height or 20
    seed = seed or 4.1
    local shape_fn = slime_shapes.rocky_bar(rock_height, seed)
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)
        shape_fn(cr, w, h)

        -- Deep Forest Soil (#141712) -> Bark & Obsidian Stone (#241e17 -> #2e261d) vertical gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.078, 0.090, 0.071, 0.96)  -- #141712 (Deep Forest Soil)
        pat:add_color_stop_rgba(0.65, 0.141, 0.118, 0.090, 0.96) -- #241e17 (Bark & Timber)
        pat:add_color_stop_rgba(1.0, 0.180, 0.149, 0.114, 0.98)  -- #2e261d (Weathered Outcropping Stone)
        cr:set_source(pat)
        cr:fill_preserve()

        cr:clip_preserve()

        -- Wide inner damp moss & bark strata shadow/glow along the rocky ledges
        cr:set_line_width(5.0)
        cr:set_source_rgba(0.353, 0.471, 0.302, 0.38) -- #5a784d (Lichen / Damp Moss)
        cr:stroke_preserve()

        -- Chiseled outer stone rim transitioning from Lichen Moss (#5a784d) to Bioluminescent Spore (#9ece6a) at crag tips
        local rim = cairo.Pattern.create_linear(0, h - rock_height - 2, 0, h)
        rim:add_color_stop_rgba(0.0, 0.353, 0.471, 0.302, 0.95)  -- #5a784d (Lichen / Damp Moss)
        rim:add_color_stop_rgba(0.60, 0.620, 0.808, 0.416, 1.00) -- #9ece6a (Bioluminescent Spore)
        rim:add_color_stop_rgba(1.0, 0.816, 0.529, 0.439, 1.00)  -- #d08770 (Weathered Amber Spore Tip)
        cr:set_line_width(2.2)
        cr:set_source(rim)
        cr:stroke()

        cr:restore()
    end
end

-- 6c. Chiseled Monolith Window Shape with Rocky Outcroppings at the Bottom:
function slime_shapes.rocky_window(corner_bevel, rock_height, seed)
    corner_bevel = corner_bevel or 10
    rock_height = rock_height or 18
    seed = seed or 1.9
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local b = math.min(corner_bevel, w / 4, h / 4)
        local base_h = math.max(b * 2 + 4, h - rock_height)
        local pts = get_rock_points(w, base_h, rock_height - 2.0, seed, 5.0)

        cr:new_path()
        -- Top-left chiseled stone bevel
        cr:move_to(b, 0)
        cr:line_to(w - b, 0)
        -- Top-right chiseled stone bevel
        cr:line_to(w, b)
        -- Straight right stone edge down to bottom rocky outcropping shelf
        cr:line_to(w, base_h - 4)
        cr:line_to(w - 6, base_h)

        -- Jagged rocky outcroppings along the bottom edge from right to left
        for i = 1, #pts, 2 do
            cr:line_to(pts[i], pts[i + 1])
        end

        -- Bottom-left chiseled transition back up to left stone edge
        cr:line_to(6, base_h)
        cr:line_to(0, base_h - 4)
        cr:line_to(0, b)
        cr:close_path()
    end
end

-- 6d. Custom Cairo Renderer for the Bottom Rocky Outcroppings of Client Windows:
function slime_shapes.render_window_bottom_rocks(c, corner_bevel, rock_height, seed)
    corner_bevel = corner_bevel or 10
    rock_height = rock_height or 18
    seed = seed or 1.9
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)
        local base_h = math.max(1, h - rock_height)
        local pts = get_rock_points(w, base_h, rock_height - 2.0, seed, 5.0)

        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w, 0)
        cr:line_to(w, base_h - 4)
        cr:line_to(w - 6, base_h)

        for i = 1, #pts, 2 do
            cr:line_to(pts[i], pts[i + 1])
        end
        cr:line_to(6, base_h)
        cr:line_to(0, base_h - 4)
        cr:close_path()

        local focused = (client.focus == c)
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.078, 0.090, 0.071, 0.92) -- #141712 (Deep Forest Soil)
        pat:add_color_stop_rgba(1.0, 0.141, 0.118, 0.090, 0.96) -- #241e17 (Bark & Timber Stone)
        cr:set_source(pat)
        cr:fill_preserve()
        cr:clip_preserve()

        if focused then
            -- Inner Lichen Moss strata bevel
            cr:set_line_width(4.5)
            cr:set_source_rgba(0.353, 0.471, 0.302, 0.32) -- #5a784d
            cr:stroke_preserve()

            -- Glowing Bioluminescent Spore & Weathered Amber rim along the rocky crags
            local rim = cairo.Pattern.create_linear(0, base_h, 0, h)
            rim:add_color_stop_rgba(0.0, 0.353, 0.471, 0.302, 0.75) -- #5a784d (Lichen Moss)
            rim:add_color_stop_rgba(0.6, 0.620, 0.808, 0.416, 0.90) -- #9ece6a (Bioluminescent Spore)
            rim:add_color_stop_rgba(1.0, 0.816, 0.529, 0.439, 0.95) -- #d08770 (Weathered Amber)
            cr:set_line_width(2.0)
            cr:set_source(rim)
            cr:stroke()
        else
            -- Unfocused muted bark & moss stone edge
            cr:set_line_width(1.6)
            cr:set_source_rgba(0.353, 0.471, 0.302, 0.45)
            cr:stroke()
        end

        cr:restore()
    end
end

-- 6e. Chiseled Stone Tablet Pill Shape (for Act 0 bar pills & tasklist items):
function slime_shapes.rocky_pill(bevel, seed)
    bevel = bevel or 6
    seed = seed or 2.7
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local b = math.min(bevel, w / 3, h / 3)
        local pad = 1.0
        local step = 8.0

        cr:new_path()
        cr:move_to(b, pad)

        local x = b + step
        while x < w - b do
            local dy = 0.7 * math.sin(x * 0.11 + seed)
            cr:line_to(x, pad + math.floor(dy * 2 + 0.5) / 2)
            x = x + step
        end
        cr:line_to(w - b, pad)
        cr:line_to(w - pad, b)
        cr:line_to(w - pad, h - b)
        cr:line_to(w - b, h - pad)

        x = w - b - step
        while x > b do
            local dy = 0.8 * math.cos(x * 0.09 - seed)
            cr:line_to(x, h - pad + math.floor(dy * 2 + 0.5) / 2)
            x = x - step
        end
        cr:line_to(b, h - pad)
        cr:line_to(pad, h - b)
        cr:line_to(pad, b)
        cr:close_path()
    end
end

-- ==============================================================================
-- 7. Act IV Orbital Containment / Deep Space Vessel — Optical HUD & Solar Glint
-- ==============================================================================
slime_shapes.space_time = 0

-- Orbital Solar Sweep timing: every 12 seconds, a high-speed angled white/solar
-- glint sweeps across the flight-deck glass in ~1.65 seconds.
local SPACE_SOLAR_PERIOD   = 12.0
local SPACE_SOLAR_DURATION = 1.65

-- Helper: populates an angled linear Cairo pattern with a sharp white/solar specular glint
-- (#ffffff00 -> #ffffff99 -> #ffffffeb -> #e5950044 -> #0088cc22 -> #ffffff00).
local function add_space_solar_glint_stops(grad, intensity)
    intensity = intensity or 1.0
    grad:add_color_stop_rgba(0.00, 1.000, 1.000, 1.000, 0.00)
    grad:add_color_stop_rgba(0.32, 1.000, 1.000, 1.000, math.min(1.0, 0.45 * intensity)) -- #ffffff73 leading glare
    grad:add_color_stop_rgba(0.48, 1.000, 1.000, 1.000, math.min(1.0, 0.85 * intensity)) -- #ffffffd9 bright white specular core
    grad:add_color_stop_rgba(0.62, 0.898, 0.584, 0.000, math.min(1.0, 0.42 * intensity)) -- #e595006b Solar Flare Gold refraction
    grad:add_color_stop_rgba(0.78, 0.000, 0.533, 0.800, math.min(1.0, 0.22 * intensity)) -- #0088cc38 Thruster Cyan dispersion
    grad:add_color_stop_rgba(1.00, 1.000, 1.000, 1.000, 0.00)
end

-- 7a. Act IV Orbital Flight Deck Wibar Background Renderer:
-- Renders Hull White (#f5f6f9) -> Airframe Grey (#e1e4ea) frosted pressure glass,
-- a Double-Pencil top/bottom refraction border, laser-etched viewport brackets,
-- and a periodic high-speed angled Orbital Solar Glint Sweep.
function slime_shapes.render_space_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Hull White (#f5f6f9) -> Airframe Grey (#e1e4ea) vertical gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.961, 0.965, 0.976, 0.97) -- #f5f6f9
        pat:add_color_stop_rgba(1.0, 0.882, 0.894, 0.918, 0.98) -- #e1e4ea
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- Top 1px bright specular glass edge (#ffffff)
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(1.0, 1.0, 1.0, 0.95)
        cr:fill()

        -- Inner 1px Double-Pencil HUD refraction line (#0088cc44) just above the bottom rim
        cr:rectangle(0, h - 3, w, 1)
        cr:set_source_rgba(0.000, 0.533, 0.800, 0.28)
        cr:fill()

        -- Orbital Flight Deck 2px bottom rim: Deep Nav Slate (#1b2028), Solar Flare Gold (#e59500) & Thruster Cyan (#0088cc)
        local rim = cairo.Pattern.create_linear(0, 0, w, 0)
        rim:add_color_stop_rgba(0.00, 0.106, 0.125, 0.157, 1.0) -- #1b2028 (Deep Nav Slate)
        rim:add_color_stop_rgba(0.25, 0.898, 0.584, 0.000, 1.0) -- #e59500 (Solar Flare Gold)
        rim:add_color_stop_rgba(0.50, 0.000, 0.533, 0.800, 1.0) -- #0088cc (Thruster Cyan)
        rim:add_color_stop_rgba(0.75, 0.898, 0.584, 0.000, 1.0) -- #e59500 (Solar Flare Gold)
        rim:add_color_stop_rgba(1.00, 0.106, 0.125, 0.157, 1.0) -- #1b2028 (Deep Nav Slate)
        cr:rectangle(0, h - 2, w, 2)
        cr:set_source(rim)
        cr:fill()

        -- Laser-etched viewport corner brackets & 45° angle ticks at left/right ends of the Wibar
        cr:set_line_width(1.2)
        cr:set_source_rgba(0.000, 0.533, 0.800, 0.65) -- #0088cc Thruster Cyan HUD etching
        -- Left viewport reticle
        cr:move_to(2, h - 5)
        cr:line_to(2, 6)
        cr:line_to(7, 1)
        cr:line_to(20, 1)
        -- Right viewport reticle
        cr:move_to(w - 2, h - 5)
        cr:line_to(w - 2, 6)
        cr:line_to(w - 7, 1)
        cr:line_to(w - 20, 1)
        cr:stroke()

        -- High-speed Orbital Solar Glint Sweep across the Wibar every 12 seconds
        local t = slime_shapes.space_time or 0
        local cycle_t = t % SPACE_SOLAR_PERIOD
        if cycle_t < SPACE_SOLAR_DURATION then
            local progress = cycle_t / SPACE_SOLAR_DURATION
            local band_w = math.max(130, w * 0.11)
            local slant  = 42
            local gx = -band_w + progress * (w + 2 * band_w + slant)

            -- Angled diagonal solar glare across the frosted bar surface
            local glint = cairo.Pattern.create_linear(gx - band_w, 0, gx + band_w - slant, h)
            add_space_solar_glint_stops(glint, 0.88)
            cr:rectangle(0, 0, w, h)
            cr:set_source(glint)
            cr:fill()

            -- Intense specular flare catching the top 1px and bottom 2px glass lips
            local lip_glint = cairo.Pattern.create_linear(gx - band_w * 0.7, 0, gx + band_w * 0.7, 0)
            add_space_solar_glint_stops(lip_glint, 1.35)
            cr:rectangle(0, 0, w, 2)
            cr:rectangle(0, h - 3, w, 3)
            cr:set_source(lip_glint)
            cr:fill()
        end

        cr:restore()
    end
end

-- 7b. Act IV Orbital Containment Active Window HUD Edge Renderer:
-- Renders the 4 outer edges ("top", "right", "bottom", "left", size = 4) of client windows in space mode:
-- 1. Multi-Layered Frosted Glass / Double-Pencil Edge Border:
--    - Top & Left: 1px bright specular white (#ffffff) outer line + Airframe Grey bevel + 1px inner cyan refraction line (#0088cc55)
--    - Bottom & Right: 1px Thruster Cyan refraction (#0088cc66) / Airframe Slate outer line + 1px inner specular white line (#ffffffb8)
-- 2. Laser-Etched Viewport Corner Brackets & 45° Angle Ticks with faint cyan bloom (#0088cc) & solar gold (#e59500) fiducials
-- 3. Passive Cryo-Breath Fog: slow 3-4% opacity pulse + cryo-frost vignette along the bottom border
-- 4. Specular Solar Sweep: high-speed angled white/solar glint across the top lip of the active window every 12 seconds
function slime_shapes.render_space_window_edge(c, side)
    return function(_, cr, w, h)
        if not c or not c.valid then return end
        cr:save()
        ensure_best_antialias(cr)

        local focused = (client.focus == c)
        local t = slime_shapes.space_time or 0
        -- Very slow cryo-stasis breathing wave (~5.5s period) for 3-4% opacity modulation
        local breath = 0.5 + 0.5 * math.sin(t * 1.15)

        if not focused then
            -- Unfocused recessed spacecraft bulkhead bevel (2-tone Double-Pencil in muted airframe grey)
            cr:set_source_rgba(0.882, 0.894, 0.918, 0.94) -- #e1e4ea Airframe Grey body
            cr:rectangle(0, 0, w, h)
            cr:fill()

            if side == "top" then
                cr:set_source_rgba(1.000, 1.000, 1.000, 0.82) -- Top specular highlight
                cr:rectangle(0, 0, w, 1)
                cr:fill()
                cr:set_source_rgba(0.720, 0.755, 0.805, 0.70) -- Inner hairline
                cr:rectangle(0, h - 1, w, 1)
                cr:fill()
            elseif side == "left" then
                cr:set_source_rgba(1.000, 1.000, 1.000, 0.82) -- Left specular highlight
                cr:rectangle(0, 0, 1, h)
                cr:fill()
                cr:set_source_rgba(0.720, 0.755, 0.805, 0.70)
                cr:rectangle(w - 1, 0, 1, h)
                cr:fill()
            elseif side == "bottom" then
                cr:set_source_rgba(0.680, 0.720, 0.780, 0.88) -- Bottom refraction shadow
                cr:rectangle(0, h - 1, w, 1)
                cr:fill()
            elseif side == "right" then
                cr:set_source_rgba(0.680, 0.720, 0.780, 0.88) -- Right refraction shadow
                cr:rectangle(w - 1, 0, 1, h)
                cr:fill()
            end

            cr:restore()
            return
        end

        -- ====================================================================
        -- Focused Window: Floating Frosted Glass HUD Pane + Double-Pencil Edge
        -- ====================================================================
        local corner_len = 22

        if side == "top" then
            -- Frosted Hull White body
            cr:set_source_rgba(0.945, 0.955, 0.973, 0.96) -- #f1f4f8
            cr:rectangle(0, 0, w, h)
            cr:fill()

            -- Outer 1px bright specular line (#ffffff)
            cr:set_source_rgba(1.000, 1.000, 1.000, 0.98)
            cr:rectangle(0, 0, w, 1)
            cr:rectangle(0, 0, 1, h)
            cr:fill()

            -- Right corner outer refraction cap
            cr:set_source_rgba(0.000, 0.533, 0.800, 0.42) -- #0088cc6b
            cr:rectangle(w - 1, 0, 1, h)
            cr:fill()

            -- Inner 1px Double-Pencil refraction line (#0088cc55)
            cr:set_source_rgba(0.000, 0.533, 0.800, 0.34)
            cr:rectangle(1, h - 1, math.max(0, w - 2), 1)
            cr:fill()

            -- Laser-Etched Viewport Corner Brackets & 45° Angle Ticks (Top-Left & Top-Right)
            local bl = math.min(corner_len, math.floor(w * 0.25))
            if bl >= 8 then
                -- Faint Thruster Cyan bloom (#0088cc) in the 4 corners
                cr:set_source_rgba(0.000, 0.533, 0.800, 0.22)
                cr:rectangle(0, 0, bl + 4, h)
                cr:rectangle(w - bl - 4, 0, bl + 4, h)
                cr:fill()

                -- Crisp 1px Thruster Cyan (#0088cc) corner brackets + 45° chamfer ticks
                cr:set_line_width(1.2)
                cr:set_source_rgba(0.000, 0.533, 0.800, 0.92)
                -- Top-left bracket + 45° angle tick
                cr:move_to(0, h)
                cr:line_to(0, 1)
                cr:line_to(bl, 1)
                cr:move_to(1, h)
                cr:line_to(h + 1, 0)
                -- Top-right bracket + 45° angle tick
                cr:move_to(w, h)
                cr:line_to(w, 1)
                cr:line_to(w - bl, 1)
                cr:move_to(w - 1, h)
                cr:line_to(w - h - 1, 0)
                cr:stroke()

                -- Solar Flare Gold (#e59500) fiducial micro-ticks at bracket ends
                cr:set_source_rgba(0.898, 0.584, 0.000, 0.95)
                cr:rectangle(bl + 1, 0, 3, 2)
                cr:rectangle(w - bl - 4, 0, 3, 2)
                cr:fill()
            end

            -- High-Speed Orbital Solar Glint Sweep across the top lip of the active window
            -- (offset by +0.35s from the Wibar sweep so the sunlight cascades down from the bar)
            local cycle_t = (t - 0.35) % SPACE_SOLAR_PERIOD
            if cycle_t < SPACE_SOLAR_DURATION then
                local progress = cycle_t / SPACE_SOLAR_DURATION
                local band_w = math.max(110, w * 0.14)
                local gx = -band_w + progress * (w + 2 * band_w)
                local glint = cairo.Pattern.create_linear(gx - band_w, 0, gx + band_w, h * 2)
                add_space_solar_glint_stops(glint, 1.25)
                cr:rectangle(0, 0, w, h)
                cr:set_source(glint)
                cr:fill()
            end

        elseif side == "left" then
            -- Frosted Hull White body
            cr:set_source_rgba(0.945, 0.955, 0.973, 0.96)
            cr:rectangle(0, 0, w, h)
            cr:fill()

            -- Outer 1px bright specular line (#ffffff) on Left edge
            cr:set_source_rgba(1.000, 1.000, 1.000, 0.98)
            cr:rectangle(0, 0, 1, h)
            cr:fill()

            -- Inner 1px Double-Pencil refraction line (#0088cc55)
            cr:set_source_rgba(0.000, 0.533, 0.800, 0.34)
            cr:rectangle(w - 1, 0, 1, h)
            cr:fill()

            -- Vertical arms of Laser-Etched Viewport Corner Brackets (Top-Left & Bottom-Left)
            local vl = math.min(corner_len - 4, math.floor(h * 0.25))
            if vl >= 6 then
                cr:set_source_rgba(0.000, 0.533, 0.800, 0.22)
                cr:rectangle(0, 0, w, vl + 3)
                cr:rectangle(0, h - vl - 3, w, vl + 3)
                cr:fill()

                cr:set_source_rgba(0.000, 0.533, 0.800, 0.92)
                cr:rectangle(0, 0, 1.5, vl)
                cr:rectangle(0, h - vl, 1.5, vl)
                cr:fill()

                -- 45° technical reticle ticks near corners
                cr:set_line_width(1.1)
                cr:move_to(0, vl)
                cr:line_to(w, vl - w)
                cr:move_to(0, h - vl)
                cr:line_to(w, h - vl + w)
                cr:stroke()

                -- Solar Flare Gold (#e59500) fiducial micro-ticks
                cr:set_source_rgba(0.898, 0.584, 0.000, 0.95)
                cr:rectangle(0, vl + 1, 2, 3)
                cr:rectangle(0, h - vl - 4, 2, 3)
                cr:fill()
            end

        elseif side == "right" then
            -- Frosted Airframe Grey refraction body
            cr:set_source_rgba(0.882, 0.894, 0.918, 0.96) -- #e1e4ea
            cr:rectangle(0, 0, w, h)
            cr:fill()

            -- Inner 1px bright specular pencil line (#ffffffb8)
            cr:set_source_rgba(1.000, 1.000, 1.000, 0.78)
            cr:rectangle(0, 0, 1, h)
            cr:fill()

            -- Outer 1px dimmer Thruster Cyan refraction line (#0088cc66) on Right edge
            cr:set_source_rgba(0.000, 0.533, 0.800, 0.44)
            cr:rectangle(w - 1, 0, 1, h)
            cr:fill()

            -- Vertical arms of Laser-Etched Viewport Corner Brackets (Top-Right & Bottom-Right)
            local vl = math.min(corner_len - 4, math.floor(h * 0.25))
            if vl >= 6 then
                cr:set_source_rgba(0.000, 0.533, 0.800, 0.22)
                cr:rectangle(0, 0, w, vl + 3)
                cr:rectangle(0, h - vl - 3, w, vl + 3)
                cr:fill()

                cr:set_source_rgba(0.000, 0.533, 0.800, 0.92)
                cr:rectangle(w - 1.5, 0, 1.5, vl)
                cr:rectangle(w - 1.5, h - vl, 1.5, vl)
                cr:fill()

                -- 45° technical reticle ticks near corners
                cr:set_line_width(1.1)
                cr:move_to(w, vl)
                cr:line_to(0, vl - w)
                cr:move_to(w, h - vl)
                cr:line_to(0, h - vl + w)
                cr:stroke()

                -- Solar Flare Gold (#e59500) fiducial micro-ticks
                cr:set_source_rgba(0.898, 0.584, 0.000, 0.95)
                cr:rectangle(w - 2, vl + 1, 2, 3)
                cr:rectangle(w - 2, h - vl - 4, 2, 3)
                cr:fill()
            end

        elseif side == "bottom" then
            -- Passive Cryo-Breath Fog: slow 3-4% opacity modulation on the bottom border
            local base_alpha = 0.93 + 0.04 * breath
            cr:set_source_rgba(0.882, 0.894, 0.918, base_alpha) -- #e1e4ea Airframe Grey
            cr:rectangle(0, 0, w, h)
            cr:fill()

            -- Cryo-Stasis Frost Vignette along the bottom border (mirroring the frosted cryo core in the deck floor)
            local cryo = cairo.Pattern.create_linear(0, 0, w, 0)
            local frost_alpha = 0.14 + 0.04 * breath
            local core_alpha  = 0.18 + 0.04 * breath
            cryo:add_color_stop_rgba(0.00, 0.000, 0.533, 0.800, frost_alpha)       -- #0088cc Cryo Cyan vignette
            cryo:add_color_stop_rgba(0.35, 1.000, 1.000, 1.000, frost_alpha * 1.2) -- Frosted white ice mist
            cryo:add_color_stop_rgba(0.50, 0.333, 0.969, 0.212, core_alpha)        -- #55f736 Dormant Cryo-Slime Core reflection
            cryo:add_color_stop_rgba(0.65, 1.000, 1.000, 1.000, frost_alpha * 1.2) -- Frosted white ice mist
            cryo:add_color_stop_rgba(1.00, 0.000, 0.533, 0.800, frost_alpha)       -- #0088cc Cryo Cyan vignette
            cr:rectangle(0, 0, w, h)
            cr:set_source(cryo)
            cr:fill()

            -- Inner 1px bright specular Double-Pencil line (#ffffffb8)
            cr:set_source_rgba(1.000, 1.000, 1.000, 0.76 + 0.04 * breath)
            cr:rectangle(1, 0, math.max(0, w - 2), 1)
            cr:fill()

            -- Left specular corner cap
            cr:set_source_rgba(1.000, 1.000, 1.000, 0.95)
            cr:rectangle(0, 0, 1, h)
            cr:fill()

            -- Outer 1px dimmer Thruster Cyan refraction line (#0088cc66) on Bottom edge
            cr:set_source_rgba(0.000, 0.533, 0.800, 0.42 + 0.04 * breath)
            cr:rectangle(0, h - 1, w, 1)
            cr:rectangle(w - 1, 0, 1, h)
            cr:fill()

            -- Laser-Etched Viewport Corner Brackets & 45° Angle Ticks (Bottom-Left & Bottom-Right)
            local bl = math.min(corner_len, math.floor(w * 0.25))
            if bl >= 8 then
                -- Faint Thruster Cyan bloom (#0088cc) in bottom corners
                cr:set_source_rgba(0.000, 0.533, 0.800, 0.22 + 0.03 * breath)
                cr:rectangle(0, 0, bl + 4, h)
                cr:rectangle(w - bl - 4, 0, bl + 4, h)
                cr:fill()

                -- Crisp 1px Thruster Cyan (#0088cc) corner brackets + 45° chamfer ticks
                cr:set_line_width(1.2)
                cr:set_source_rgba(0.000, 0.533, 0.800, 0.92)
                -- Bottom-left bracket + 45° angle tick
                cr:move_to(0, 0)
                cr:line_to(0, h - 1)
                cr:line_to(bl, h - 1)
                cr:move_to(1, 0)
                cr:line_to(h + 1, h)
                -- Bottom-right bracket + 45° angle tick
                cr:move_to(w, 0)
                cr:line_to(w, h - 1)
                cr:line_to(w - bl, h - 1)
                cr:move_to(w - 1, 0)
                cr:line_to(w - h - 1, h)
                cr:stroke()

                -- Solar Flare Gold (#e59500) fiducial micro-ticks at bracket ends
                cr:set_source_rgba(0.898, 0.584, 0.000, 0.95)
                cr:rectangle(bl + 1, h - 2, 3, 2)
                cr:rectangle(w - bl - 4, h - 2, 3, 2)
                cr:fill()
            end
        end

        cr:restore()
    end
end

-- ==============================================================================
-- 8. Standalone: The Shredder — Precision Gunmetal, Razor Chamfers & Sharp Angles
-- ==============================================================================

-- 8a. Precision-Machined Flat Gunmetal Bar with Sharp 45° Corner Chamfers:
function slime_shapes.shred_bar(chamfer)
    chamfer = chamfer or 8
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local c = math.min(chamfer, w / 4, h / 2)
        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w, 0)
        cr:line_to(w, h - c)
        cr:line_to(w - c, h)
        cr:line_to(c, h)
        cr:line_to(0, h - c)
        cr:close_path()
    end
end

-- 8b. Custom Cairo Renderer for The Shredder Wibar Background:
-- Draws Oiled Cast-Iron (#0b0c0e) to Machined Gunmetal (#14171c -> #222730),
-- 45° diagonal CNC-machined shear grooves, a razor-honed 2px specular steel bottom rail (#c8d0dc -> #ffffff),
-- and sharp 45° chamfered corner fiducials in Friction Spark Red (#ff2a2a).
function slime_shapes.render_shred_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Oiled Cast Iron (#0b0c0e) -> Machined Gunmetal (#14171c -> #20252e) vertical gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.043, 0.047, 0.055, 0.97)  -- #0b0c0e (Abyssal Chute)
        pat:add_color_stop_rgba(0.70, 0.078, 0.090, 0.110, 0.97) -- #14171c (Machined Gunmetal)
        pat:add_color_stop_rgba(1.0, 0.125, 0.145, 0.180, 0.99)  -- #20252e (Hardened Steel Plate)
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill_preserve()

        cr:clip_preserve()

        -- 45° diagonal CNC-machined shear lines across the bar
        cr:set_line_width(1.0)
        cr:set_source_rgba(0.290, 0.322, 0.376, 0.24) -- #4a52603d subtle tungsten score lines
        local gx = -h
        while gx < w + h do
            cr:move_to(gx, 0)
            cr:line_to(gx + h, h)
            gx = gx + 18
        end
        cr:stroke()

        -- Top 1px subtle tungsten bevel
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(0.290, 0.322, 0.376, 0.70)
        cr:fill()

        -- Razor-honed 2px specular steel bottom rail (#8b95a5 -> #e2e8f0 -> #ffffff)
        local rim = cairo.Pattern.create_linear(0, 0, w, 0)
        rim:add_color_stop_rgba(0.00, 0.545, 0.584, 0.647, 0.90) -- #8b95a5 (Titanium)
        rim:add_color_stop_rgba(0.20, 0.886, 0.910, 0.941, 1.00) -- #e2e8f0 (Honed Razor Steel)
        rim:add_color_stop_rgba(0.50, 1.000, 1.000, 1.000, 1.00) -- #ffffff (Specular Core)
        rim:add_color_stop_rgba(0.80, 0.886, 0.910, 0.941, 1.00) -- #e2e8f0 (Honed Razor Steel)
        rim:add_color_stop_rgba(1.00, 0.545, 0.584, 0.647, 0.90) -- #8b95a5 (Titanium)
        cr:rectangle(0, h - 2, w, 2)
        cr:set_source(rim)
        cr:fill()

        -- Sharp 45° angular corner brackets and friction-spark red (#ff2a2a) fiducial ticks
        cr:set_line_width(1.5)
        cr:set_source_rgba(1.000, 0.165, 0.165, 0.95) -- #ff2a2a Friction Spark Red
        -- Left 45° corner notch tick
        cr:move_to(2, h - 8)
        cr:line_to(8, h - 2)
        cr:line_to(22, h - 2)
        -- Right 45° corner notch tick
        cr:move_to(w - 2, h - 8)
        cr:line_to(w - 8, h - 2)
        cr:line_to(w - 22, h - 2)
        cr:stroke()

        cr:restore()
    end
end

-- 8c. Sharp 45° Faceted Stealth Window Shape (Clean planar edges, sharp geometric corner chamfers, ZERO jagged teeth):
function slime_shapes.shred_window(chamfer)
    chamfer = chamfer or 12
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local c = math.min(chamfer, w / 4, h / 4)
        cr:new_path()
        cr:move_to(c, 0)
        cr:line_to(w - c, 0)
        cr:line_to(w, c)
        cr:line_to(w, h - c)
        cr:line_to(w - c, h)
        cr:line_to(c, h)
        cr:line_to(0, h - c)
        cr:line_to(0, c)
        cr:close_path()
    end
end

-- 8d. Razor-Pointed Kunai / Hex-Blade Pill Shape (for The Shredder bar pills & tasklist items):
function slime_shapes.shred_pill(slant, seed)
    slant = slant or 7
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local s = math.min(slant, w / 3, h / 2)
        local pad = 1.0

        cr:new_path()
        -- Double-pointed angular blade polygon (<===>) with sharp 45°/60° tips
        cr:move_to(s, pad)
        cr:line_to(w - s, pad)
        cr:line_to(w - pad, h * 0.5)
        cr:line_to(w - s, h - pad)
        cr:line_to(s, h - pad)
        cr:line_to(pad, h * 0.5)
        cr:close_path()
    end
end

-- ==============================================================================
-- 9. Standalone: "Larry the Haxor" / LARRY_0x_MUSKRAT Cyber-Swamp Brutalist Theme
-- ==============================================================================

-- 9a. Chamfered Sensor Frame (Top-left & Bottom-right 45° chamfers, sharp 90° corners):
function slime_shapes.larry_widget_pod(chamfer)
    chamfer = chamfer or 6
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local c = math.min(chamfer, w / 4, h / 2)
        cr:new_path()
        cr:move_to(c, 0)
        cr:line_to(w, 0)
        cr:line_to(w, h - c)
        cr:line_to(w - c, h)
        cr:line_to(0, h)
        cr:line_to(0, c)
        cr:close_path()
    end
end

-- 9b. Industrial 45° Parallelogram / Chamfered Block for Workspace Tags:
function slime_shapes.larry_tag_wedge(slant, chamfer)
    slant = slant or 8
    chamfer = chamfer or 4
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local s = math.min(slant, w / 3)
        local c = math.min(chamfer, h / 3)
        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w - s, 0)
        cr:line_to(w, h - c)
        cr:line_to(w - c, h)
        cr:line_to(s, h)
        cr:line_to(0, h - c)
        cr:close_path()
    end
end

-- 9c. Chamfered / Sharp Angular Window Shape (Zero rounded corners):
function slime_shapes.larry_window(chamfer)
    chamfer = chamfer or 6
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local c = math.min(chamfer, w / 4, h / 4)
        cr:new_path()
        cr:move_to(c, 0)
        cr:line_to(w - c, 0)
        cr:line_to(w, c)
        cr:line_to(w, h - c)
        cr:line_to(w - c, h)
        cr:line_to(c, h)
        cr:line_to(0, h - c)
        cr:line_to(0, c)
        cr:close_path()
    end
end

-- 9d. Inverted Trapezoid Console Pod for Center Muskrat Mascot Widget:
function slime_shapes.larry_mascot_pod(chamfer)
    chamfer = chamfer or 10
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local c = math.min(chamfer, w / 3, h)
        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w, 0)
        cr:line_to(w - c, h)
        cr:line_to(c, h)
        cr:close_path()
    end
end

-- 9e. Custom Cairo Renderer for Larry Wibar Background:
-- Draws Heavy Matte Dark Chassis (#151718) to Marsh Teal (#0d2e27),
-- sharp toxic green (#39ff14) laser baseline, subtle 45° cybernetic grid traces,
-- and the centered inverted trapezoid console pod outline.
function slime_shapes.render_larry_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Matte Dark Chassis (#151718)
        cr:rectangle(0, 0, w, h)
        cr:set_source_rgba(0.082, 0.090, 0.094, 0.98) -- #151718
        cr:fill_preserve()
        cr:clip_preserve()

        -- Subtle 45° diagonal cybernetic sensor lines
        cr:set_line_width(1.0)
        cr:set_source_rgba(0.224, 1.000, 0.078, 0.04) -- #39ff14 at 4%
        local gx = -h
        while gx < w + h do
            cr:move_to(gx, 0)
            cr:line_to(gx + h, h)
            gx = gx + 24
        end
        cr:stroke()

        -- Center Inverted Trapezoid Console Notch where the Muskrat Mascot rests
        local pod_w = 90
        local pod_cx = w * 0.5
        local pod_x1 = pod_cx - pod_w * 0.5
        local pod_x2 = pod_cx + pod_w * 0.5
        local pod_chamfer = 12

        cr:new_path()
        cr:move_to(pod_x1, 0)
        cr:line_to(pod_x2, 0)
        cr:line_to(pod_x2 - pod_chamfer, h)
        cr:line_to(pod_x1 + pod_chamfer, h)
        cr:close_path()
        cr:set_source_rgba(0.051, 0.180, 0.153, 0.95) -- #0d2e27 Deep marsh-water teal
        cr:fill_preserve()

        -- 1.5px Toxic Green Pod Outline
        cr:set_line_width(1.5)
        cr:set_source_rgba(0.224, 1.000, 0.078, 0.95) -- #39ff14
        cr:stroke()

        -- Bottom sharp laser rail: Deep swamp teal (#0d2e27) with high-voltage toxic green (#39ff14) core
        local laser = cairo.Pattern.create_linear(0, 0, w, 0)
        laser:add_color_stop_rgba(0.00, 0.051, 0.180, 0.153, 0.8) -- #0d2e27
        laser:add_color_stop_rgba(0.15, 0.224, 1.000, 0.078, 0.95) -- #39ff14
        laser:add_color_stop_rgba(0.50, 0.224, 1.000, 0.078, 1.0)  -- #39ff14
        laser:add_color_stop_rgba(0.85, 0.224, 1.000, 0.078, 0.95) -- #39ff14
        laser:add_color_stop_rgba(1.00, 0.051, 0.180, 0.153, 0.8) -- #0d2e27
        cr:rectangle(0, h - 1.5, w, 1.5)
        cr:set_source(laser)
        cr:fill()

        cr:restore()
    end
end

return slime_shapes

