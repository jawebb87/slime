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

-- 5. Cyberpunk Future Bar Background Renderer (Bio-Grid Cyberdeck):
-- Static, zero-CPU background with an obsidian ink-violet surface (#090812 -> #161326),
-- an electric purple (#a855f7) bottom conduit rail, and a rich toxic-green (#39ff14 / #74ff2e)
-- upward blooming neon gradient baked directly into the bottom rim.
function slime_shapes.render_cyber_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Obsidian #090812 -> #161326 vertical surface gradient
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

        -- Static Upward Blooming Toxic-Green Neon Glow Gradient (16px high)
        local glow_h = 16
        local glow = cairo.Pattern.create_linear(0, h - glow_h, 0, h)
        glow:add_color_stop_rgba(0.00, 0.224, 0.969, 0.078, 0.00) -- Transparent top
        glow:add_color_stop_rgba(0.30, 0.000, 0.941, 1.000, 0.18) -- Soft cyan/emerald ambient wash (#00f0ff)
        glow:add_color_stop_rgba(0.60, 0.224, 0.969, 0.078, 0.50) -- Rich toxic green (#39ff14)
        glow:add_color_stop_rgba(0.85, 0.455, 1.000, 0.180, 0.80) -- High-voltage Neon Green (#74ff2e)
        glow:add_color_stop_rgba(1.00, 0.850, 0.980, 0.250, 0.95) -- Hot lime bioluminescent core

        cr:rectangle(0, h - glow_h, w, glow_h)
        cr:set_source(glow)
        cr:fill()

        -- Crisp 2px toxic-green / hot lime energy rail along the bottom edge
        local rail = cairo.Pattern.create_linear(0, 0, w, 0)
        rail:add_color_stop_rgba(0.00, 0.455, 1.000, 0.180, 0.80)
        rail:add_color_stop_rgba(0.25, 0.847, 0.922, 0.204, 0.95)
        rail:add_color_stop_rgba(0.50, 0.950, 1.000, 0.350, 1.00)
        rail:add_color_stop_rgba(0.75, 0.847, 0.922, 0.204, 0.95)
        rail:add_color_stop_rgba(1.00, 0.455, 1.000, 0.180, 0.80)
        cr:rectangle(0, h - 2, w, 2)
        cr:set_source(rail)
        cr:fill()

        cr:restore()
    end
end

-- 5b. Cyberpunk Active Window Perimeter Renderer:
-- Renders the 4 outer edges ("top", "right", "bottom", "left") of a client window in cyber mode.
-- When unfocused: dark obsidian base (#090812) with a razor-sharp 1px Neon Violet (#7928ca) outer edge (standby).
-- When focused: 100% BOOSTED powered-on active reactor state with a 6px perimeter green neon glow pulsing in sync with desktop audio!
function slime_shapes.render_cyber_window_edge(c, side)
    return function(_, cr, w, h)
        if not c or not c.valid then return end
        cr:save()
        ensure_best_antialias(cr)

        local focused = (client.focus == c)

        if not focused then
            -- Unfocused window: standby state (dark obsidian + 1px subtle neon violet edge)
            cr:set_source_rgba(0.035, 0.031, 0.071, 0.92) -- #090812
            cr:rectangle(0, 0, w, h)
            cr:fill()

            cr:set_source_rgba(0.475, 0.157, 0.792, 0.85) -- #7928ca (Neon Violet)
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
            cr:restore()
            return
        end

        -- Focused window: 100% BOOSTED "Powered on" reactor glow pulsing with desktop audio!
        local audio = slime_shapes.cyber_audio_level or 0.0
        local idle_t = slime_shapes.cyber_pulse_time or 0
        local idle_breath = 0.36 + 0.12 * math.sin(idle_t * 2.4)
        local pulse = math.min(1.0, math.max(idle_breath, audio * 1.25))

        -- Base trench fill (#0e0c1c deep reactor obsidian)
        cr:set_source_rgba(0.055, 0.047, 0.110, 0.98)
        cr:rectangle(0, 0, w, h)
        cr:fill()

        -- Multi-pass Boosted Audio-Reactive Glow:
        -- Pass 1: Full-edge glowing neon plasma conduit
        local grad
        if side == "top" then
            grad = cairo.Pattern.create_linear(0, 0, 0, h)
        elseif side == "bottom" then
            grad = cairo.Pattern.create_linear(0, h, 0, 0)
        elseif side == "left" then
            grad = cairo.Pattern.create_linear(0, 0, w, 0)
        else -- "right"
            grad = cairo.Pattern.create_linear(w, 0, 0, 0)
        end

        -- Stop 0.0 is outer edge, Stop 1.0 is inner edge towards client window
        local p_alpha = math.min(1.0, 0.65 + 0.35 * pulse)
        grad:add_color_stop_rgba(0.00, 0.900, 1.000, 0.300, 1.00)                 -- Hot lime/white outer boundary
        grad:add_color_stop_rgba(0.30, 0.455, 1.000, 0.180, p_alpha)             -- #74ff2e High-voltage neon
        grad:add_color_stop_rgba(0.65, 0.224, 0.969, 0.078, p_alpha * 0.95)      -- #39ff14 Rich toxic green
        grad:add_color_stop_rgba(1.00, 0.000, 0.850, 0.650, math.max(0.25, 0.55 * pulse)) -- #00cca0 cyan-green conduit bleed

        cr:rectangle(0, 0, w, h)
        cr:set_source(grad)
        cr:fill()

        -- Pass 2: Blinding 2px outer hot neon rail with lime-white core
        local core_r = 0.45 + 0.50 * pulse
        local core_g = 1.00
        local core_b = 0.20 + 0.70 * (1.0 - pulse)
        local core_a = 1.00
        cr:set_source_rgba(core_r, core_g, core_b, core_a)

        local rail_thick = math.min(2, math.floor(h > w and w or h))
        if side == "top" then
            cr:rectangle(0, 0, w, rail_thick)
            cr:rectangle(0, 0, rail_thick, h)
            cr:rectangle(w - rail_thick, 0, rail_thick, h)
        elseif side == "bottom" then
            cr:rectangle(0, h - rail_thick, w, rail_thick)
            cr:rectangle(0, 0, rail_thick, h)
            cr:rectangle(w - rail_thick, 0, rail_thick, h)
        elseif side == "left" then
            cr:rectangle(0, 0, rail_thick, h)
        elseif side == "right" then
            cr:rectangle(w - rail_thick, 0, rail_thick, h)
        end
        cr:fill()

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
-- 7. Act IV Orbital Containment / Deep Space Vessel (Flight Deck & Hull Plating)
-- ==============================================================================
-- 7a. Act IV Orbital Flight Deck Wibar Background Renderer:
-- Renders Hull White (#f5f6f9) -> Airframe Grey (#e1e4ea) frosted pressure glass,
-- a Double-Pencil top/bottom refraction border, laser-etched viewport brackets,
-- and a 2px bottom rim in Deep Nav Slate (#1b2028), Solar Flare Gold (#e59500) & Thruster Cyan (#0088cc).
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
            -- Recessed spacecraft bulkhead bevel & frosted cryo vignette (static)
            cr:set_source_rgba(0.882, 0.894, 0.918, 0.95) -- #e1e4ea Airframe Grey
            cr:rectangle(0, 0, w, h)
            cr:fill()

            -- Cryo-Stasis Frost Vignette along the bottom border (mirroring the frosted cryo core in the deck floor)
            local cryo = cairo.Pattern.create_linear(0, 0, w, 0)
            local frost_alpha = 0.16
            local core_alpha  = 0.20
            cryo:add_color_stop_rgba(0.00, 0.000, 0.533, 0.800, frost_alpha)       -- #0088cc Cryo Cyan vignette
            cryo:add_color_stop_rgba(0.35, 1.000, 1.000, 1.000, frost_alpha * 1.2) -- Frosted white ice mist
            cryo:add_color_stop_rgba(0.50, 0.333, 0.969, 0.212, core_alpha)        -- #55f736 Dormant Cryo-Slime Core reflection
            cryo:add_color_stop_rgba(0.65, 1.000, 1.000, 1.000, frost_alpha * 1.2) -- Frosted white ice mist
            cryo:add_color_stop_rgba(1.00, 0.000, 0.533, 0.800, frost_alpha)       -- #0088cc Cryo Cyan vignette
            cr:rectangle(0, 0, w, h)
            cr:set_source(cryo)
            cr:fill()

            -- Inner 1px bright specular Double-Pencil line (#ffffffb8)
            cr:set_source_rgba(1.000, 1.000, 1.000, 0.78)
            cr:rectangle(1, 0, math.max(0, w - 2), 1)
            cr:fill()

            -- Left specular corner cap
            cr:set_source_rgba(1.000, 1.000, 1.000, 0.95)
            cr:rectangle(0, 0, 1, h)
            cr:fill()

            -- Outer 1px dimmer Thruster Cyan refraction line (#0088cc66) on Bottom edge
            cr:set_source_rgba(0.000, 0.533, 0.800, 0.44)
            cr:rectangle(0, h - 1, w, 1)
            cr:rectangle(w - 1, 0, 1, h)
            cr:fill()

            -- Laser-Etched Viewport Corner Brackets & 45° Angle Ticks (Bottom-Left & Bottom-Right)
            local bl = math.min(corner_len, math.floor(w * 0.25))
            if bl >= 8 then
                -- Faint Thruster Cyan bloom (#0088cc) in bottom corners
                cr:set_source_rgba(0.000, 0.533, 0.800, 0.23)
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
-- 9. Standalone: "Chomp the Haxor" / CHOMP_0x Cyber-Swamp Brutalist Theme
-- ==============================================================================

-- 9a. Chamfered Sensor Frame (Top-left & Bottom-right 45° chamfers, sharp 90° corners):
function slime_shapes.chomp_widget_pod(chamfer)
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
slime_shapes.larry_widget_pod = slime_shapes.chomp_widget_pod

-- 9b. Industrial 45° Parallelogram / Chamfered Block for Workspace Tags:
function slime_shapes.chomp_tag_wedge(slant, chamfer)
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
slime_shapes.larry_tag_wedge = slime_shapes.chomp_tag_wedge

-- 9c. Chamfered / Sharp Angular Window Shape (Zero rounded corners):
function slime_shapes.chomp_window(chamfer)
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
slime_shapes.larry_window = slime_shapes.chomp_window

-- 9d. Inverted Trapezoid Console Pod for Center Muskrat Mascot Widget:
function slime_shapes.chomp_mascot_pod(chamfer)
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
slime_shapes.larry_mascot_pod = slime_shapes.chomp_mascot_pod

-- 9e. Custom Cairo Renderer for Chomp Wibar Background:
-- Draws Heavy Matte Dark Chassis (#111415) to Marsh Teal (#0d2822),
-- sharp toxic green (#39ff14) laser baseline, subtle 45° cybernetic grid traces,
-- and the centered inverted trapezoid console pod outline.
function slime_shapes.render_chomp_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Matte Dark Chassis (#111415)
        cr:rectangle(0, 0, w, h)
        cr:set_source_rgba(0.067, 0.078, 0.082, 0.98) -- #111415
        cr:fill_preserve()
        cr:clip_preserve()

        -- Subtle 45° diagonal cybernetic sensor lines
        cr:set_line_width(1.0)
        cr:set_source_rgba(0.224, 1.000, 0.078, 0.05) -- #39ff14 at 5%
        local gx = -h
        while gx < w + h do
            cr:move_to(gx, 0)
            cr:line_to(gx + h, h)
            gx = gx + 24
        end
        cr:stroke()

        -- Center Inverted Trapezoid Console Notch where the Chomp Mascot rests
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
        cr:set_source_rgba(0.051, 0.157, 0.133, 0.95) -- #0d2822 Deep marsh-water teal
        cr:fill_preserve()

        -- 1.5px Toxic Green Pod Outline
        cr:set_line_width(1.5)
        cr:set_source_rgba(0.224, 1.000, 0.078, 0.95) -- #39ff14
        cr:stroke()

        -- Bottom sharp laser rail: Deep swamp teal (#0d2822) with high-voltage toxic green (#39ff14) core
        local laser = cairo.Pattern.create_linear(0, 0, w, 0)
        laser:add_color_stop_rgba(0.00, 0.051, 0.157, 0.133, 0.8) -- #0d2822
        laser:add_color_stop_rgba(0.15, 0.224, 1.000, 0.078, 0.95) -- #39ff14
        laser:add_color_stop_rgba(0.50, 0.224, 1.000, 0.078, 1.0)  -- #39ff14
        laser:add_color_stop_rgba(0.85, 0.224, 1.000, 0.078, 0.95) -- #39ff14
        laser:add_color_stop_rgba(1.00, 0.051, 0.157, 0.133, 0.8) -- #0d2822
        cr:rectangle(0, h - 1.5, w, 1.5)
        cr:set_source(laser)
        cr:fill()

        cr:restore()
    end
end
slime_shapes.render_larry_bar_bg = slime_shapes.render_chomp_bar_bg

-- =============================================================================
-- 10. Heavy Physical Rust-Red & Gold Bulkhead Wibar (Dual Command Pods & Bridge)
-- =============================================================================
-- Profile:
-- |                 ___________________________________________________________________                  |
-- \________________/                                                                   \________________/
-- Features:
-- - Geometric wibar shape clipping matching ASCII art with dual command pods and recessed bridge
-- - Rust-red industrial plate gradients (#240a0d -> #52171f -> #7a242e -> #9e2e38)
-- - Dual heavy command pods with 45° chamfered wings on left (tags) and right (telemetry)
-- - Recessed elevated bridge in center for window tasks
-- - 3D depth bevels and ambient occlusion
-- - Precision machined gold accent contour rail (#ffd638 / #ffaa00 / #c08014)
-- - Heavy gold corner reinforcement brackets on all 4 chamfers
-- - 3D tactile gold hex fasteners / rivets and gold status waveguide insets
-- =============================================================================

function slime_shapes.red_bar_shape(pod_l_w, pod_r_w, pod_h, mid_h, chamfer)
    return function(cr, w, h)
        ensure_best_antialias(cr)
        local pl = pod_l_w or beautiful.bar_pod_left_width or 210
        local pr = pod_r_w or beautiful.bar_pod_right_width or 880
        local yp = pod_h or beautiful.bar_pod_height or h
        local ym = mid_h or beautiful.bar_mid_height or (h - 20)
        local ch = chamfer or beautiful.bar_chamfer or 12

        cr:new_path()
        cr:move_to(0, 0)
        cr:line_to(w, 0)
        cr:line_to(w, yp - ch)
        cr:line_to(w - ch, yp)
        cr:line_to(w - pr + ch, yp)
        cr:line_to(w - pr, ym)
        cr:line_to(pl, ym)
        cr:line_to(pl - ch, yp)
        cr:line_to(ch, yp)
        cr:line_to(0, yp - ch)
        cr:close_path()
    end
end

function slime_shapes.render_red_bar_bg(pod_l_w, pod_r_w, pod_h, mid_h, chamfer)
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        local pl = pod_l_w or beautiful.bar_pod_left_width or 210
        local pr = pod_r_w or beautiful.bar_pod_right_width or 880
        local yp = pod_h or beautiful.bar_pod_height or h
        local ym = mid_h or beautiful.bar_mid_height or (h - 20)
        local ch = chamfer or beautiful.bar_chamfer or 12

        local function bar_contour(c)
            c:new_path()
            c:move_to(0, yp - ch)
            c:line_to(ch, yp)
            c:line_to(pl - ch, yp)
            c:line_to(pl, ym)
            c:line_to(w - pr, ym)
            c:line_to(w - pr + ch, yp)
            c:line_to(w - ch, yp)
            c:line_to(w, yp - ch)
        end

        local function bar_polygon(c)
            c:new_path()
            c:move_to(0, 0)
            c:line_to(w, 0)
            c:line_to(w, yp - ch)
            c:line_to(w - ch, yp)
            c:line_to(w - pr + ch, yp)
            c:line_to(w - pr, ym)
            c:line_to(pl, ym)
            c:line_to(pl - ch, yp)
            c:line_to(ch, yp)
            c:line_to(0, yp - ch)
            c:close_path()
        end

        -- 1. Base Plate Fill: Rust-Red Industrial Heavy Bulkhead Gradient
        bar_polygon(cr)
        local pat = cairo.Pattern.create_linear(0, 0, 0, yp)
        pat:add_color_stop_rgba(0.00, 0.14, 0.04, 0.05, 0.99) -- #240a0d Dark scorched iron
        pat:add_color_stop_rgba(0.35, 0.32, 0.09, 0.12, 0.99) -- #52171f Deep oxidized rust
        pat:add_color_stop_rgba(0.70, 0.48, 0.14, 0.18, 0.99) -- #7a242e Rich rust red
        pat:add_color_stop_rgba(1.00, 0.62, 0.18, 0.22, 1.00) -- #9e2e38 Warm rust carmine
        cr:set_source(pat)
        cr:fill_preserve()

        -- Clip to plate for inner texture, panel seams, 3D bevels, and fasteners
        cr:save()
        cr:clip()

        -- Subtle 45° CNC diagonal machine grain
        cr:set_line_width(1.0)
        cr:set_source_rgba(1.0, 0.78, 0.25, 0.035)
        local gx = -h
        while gx < w + h do
            cr:move_to(gx, 0)
            cr:line_to(gx + h, h)
            gx = gx + 16
        end
        cr:stroke()

        -- Vertical panel expansion seams between command pods and center bridge
        for _, sx in ipairs({ pl, w - pr }) do
            -- Dark groove shadow
            cr:set_line_width(2.0)
            cr:set_source_rgba(0.06, 0.01, 0.02, 0.90)
            cr:move_to(sx - 1.0, 0)
            cr:line_to(sx - 1.0, ym)
            cr:stroke()
            -- Gold seam specular highlight
            cr:set_line_width(1.2)
            cr:set_source_rgba(1.0, 0.84, 0.22, 0.70)
            cr:move_to(sx + 0.6, 0)
            cr:line_to(sx + 0.6, ym)
            cr:stroke()
        end

        -- Top specular edge reflection in warm gold
        cr:set_line_width(1.5)
        cr:set_source_rgba(1.0, 0.85, 0.35, 0.65)
        cr:move_to(0, 0.75)
        cr:line_to(w, 0.75)
        cr:stroke()

        -- 3D Bottom plate inner extrusion depth (shadow bevel above gold rail)
        bar_contour(cr)
        cr:set_line_width(5.0)
        cr:set_source_rgba(0.04, 0.01, 0.01, 0.60)
        cr:stroke()

        -- 3D Hex Rivets / Gold Fasteners
        local function draw_rivet(rx, ry)
            cr:arc(rx, ry + 1.2, 3.5, 0, 2 * math.pi)
            cr:set_source_rgba(0, 0, 0, 0.7)
            cr:fill()
            cr:arc(rx, ry, 3.2, 0, 2 * math.pi)
            cr:set_source_rgba(0.75, 0.50, 0.08, 0.98)
            cr:fill()
            cr:arc(rx, ry, 2.0, 0, 2 * math.pi)
            cr:set_source_rgba(1.0, 0.86, 0.25, 1.0)
            cr:fill()
            cr:arc(rx - 0.7, ry - 0.7, 0.9, 0, 2 * math.pi)
            cr:set_source_rgba(1.0, 1.0, 1.0, 0.98)
            cr:fill()
        end

        -- Gold waveguide status slits
        local function draw_inset_slit(sx, sy, sw)
            cr:rectangle(sx, sy, sw, 2.5)
            cr:set_source_rgba(0.08, 0.02, 0.02, 0.95)
            cr:fill()
            cr:rectangle(sx + 1, sy + 0.5, sw - 2, 1.5)
            cr:set_source_rgba(1.0, 0.78, 0.15, 0.90)
            cr:fill()
        end

        -- Tactile gold hardware rivets placed on lower pod deck
        draw_rivet(18, yp - 10)
        draw_inset_slit(28, yp - 11, 24)
        draw_rivet(pl - 18, yp - 10)

        draw_rivet(w - pr + 18, yp - 10)
        draw_inset_slit(w - pr + 30, yp - 11, 28)
        draw_rivet(w - 18, yp - 10)

        -- Upper anchor rivets on chamfer transition
        draw_rivet(pl - ch - 4, ym - 8)
        draw_rivet(w - pr + ch + 4, ym - 8)

        cr:restore() -- End clip

        -- 2. Precision Machined Gold Accent Contour Rail
        local trim = cairo.Pattern.create_linear(0, 0, w, 0)
        trim:add_color_stop_rgba(0.00, 0.82, 0.58, 0.12, 0.98) -- Burnished gold
        trim:add_color_stop_rgba(0.12, 1.00, 0.86, 0.25, 1.00) -- Specular bright gold #ffd638
        trim:add_color_stop_rgba(0.50, 0.92, 0.68, 0.16, 0.98) -- Rich crucible gold
        trim:add_color_stop_rgba(0.88, 1.00, 0.86, 0.25, 1.00) -- Specular bright gold
        trim:add_color_stop_rgba(1.00, 0.82, 0.58, 0.12, 0.98) -- Burnished gold

        bar_contour(cr)
        cr:set_line_width(2.6)
        cr:set_source(trim)
        cr:stroke()

        -- 3. Heavy Gold Chamfer Accent Brackets (reinforced heavy brackets)
        cr:set_line_width(3.6)
        cr:set_source_rgba(1.0, 0.90, 0.38, 1.0)
        -- Left pod outer chamfer
        cr:move_to(0, yp - ch - 4)
        cr:line_to(0, yp - ch)
        cr:line_to(ch, yp)
        cr:line_to(ch + 8, yp)
        cr:stroke()

        -- Left pod inner chamfer accent
        cr:move_to(pl - ch - 8, yp)
        cr:line_to(pl - ch, yp)
        cr:line_to(pl, ym)
        cr:line_to(pl + 8, ym)
        cr:stroke()

        -- Right pod inner chamfer accent
        cr:move_to(w - pr - 8, ym)
        cr:line_to(w - pr, ym)
        cr:line_to(w - pr + ch, yp)
        cr:line_to(w - pr + ch + 8, yp)
        cr:stroke()

        -- Right pod outer chamfer
        cr:move_to(w - ch - 8, yp)
        cr:line_to(w - ch, yp)
        cr:line_to(w, yp - ch)
        cr:line_to(w, yp - ch - 4)
        cr:stroke()

        cr:restore()
    end
end

-- 11. 90s Windbreaker Bar Background Renderer:
-- Crisp light athletic nylon fabric surface (#fcfdff -> #edf1f7) with an authentic
-- high-voltage 90s color-block racing stripe running along the bottom rim (Neon Pink,
-- Solar Yellow, Electric Lime, Cyan, and Deep Royal Purple).
function slime_shapes.render_windbreaker_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- Crisp nylon white/silver gradient surface
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.0, 0.988, 0.992, 1.000, 0.96) -- #fcfdff
        pat:add_color_stop_rgba(1.0, 0.929, 0.945, 0.968, 0.97) -- #edf1f7
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- Deep dark retro indigo bounding border line
        cr:rectangle(0, h - 3, w, 1)
        cr:set_source_rgba(0.082, 0.075, 0.145, 0.90) -- #151324
        cr:fill()

        -- 90s Neon Color-Blocked Racing Stripe (Pink -> Yellow -> Lime -> Cyan -> Purple)
        local stripe = cairo.Pattern.create_linear(0, 0, w, 0)
        stripe:add_color_stop_rgba(0.00, 1.000, 0.000, 0.498, 1.0) -- #ff007f (Hot Pink)
        stripe:add_color_stop_rgba(0.20, 1.000, 0.902, 0.000, 1.0) -- #ffe600 (Cyber Yellow)
        stripe:add_color_stop_rgba(0.40, 0.063, 0.910, 0.384, 1.0) -- #10e862 (Neon Lime)
        stripe:add_color_stop_rgba(0.60, 0.000, 0.824, 1.000, 1.0) -- #00d2ff (Electric Cyan)
        stripe:add_color_stop_rgba(0.80, 0.439, 0.000, 1.000, 1.0) -- #7000ff (Royal Purple)
        stripe:add_color_stop_rgba(1.00, 1.000, 0.000, 0.498, 1.0) -- #ff007f (Hot Pink)
        cr:rectangle(0, h - 2, w, 2)
        cr:set_source(stripe)
        cr:fill()

        cr:restore()
    end
end

-- ==============================================================================
-- 11. "Clay Tablet" Ancient Sun-Baked Terracotta & Mesopotamian Cuneiform
-- ==============================================================================

-- 11a. Tactile 3D Clay Tablet Shape (soft pillow bevel & extruded depth):
function slime_shapes.clay_tablet_pod(radius, bevel)
    radius = radius or 4
    bevel = bevel or 3
    return function(cr, w, h)
        ensure_best_antialias(cr)
        gears.shape.rounded_rect(cr, w, h, radius)
    end
end

-- 11b. Clay Tablet Custom Bar Background Renderer:
-- Paints an authentic carved sun-baked clay tablet slab:
-- - Warm terracotta / slate-clay gradient (#504a4b -> #585153 -> #504a4b)
-- - Scribe ruling incision lines (dual score lines pressed with reed stylus)
-- - Subtle earthenware micro-porosity / porous clay sediment grain
-- - 3D extruded clay bottom shelf (#383233 shadow bevel with drop shadow)
-- - Specular sandstone top rim highlight (#d1c4af / #b6a994)
-- - Incised Cuneiform Stylus Wedges stamped into the clay margins (left & right)
function slime_shapes.render_clay_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Base Clay Slab Gradient (warm earthy slate-clay)
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.314, 0.290, 0.294, 0.99) -- #504a4b Top edge
        pat:add_color_stop_rgba(0.35, 0.345, 0.318, 0.325, 0.99) -- #585153 Main slab body
        pat:add_color_stop_rgba(0.85, 0.320, 0.294, 0.302, 0.99) -- #524b4d Lower shelf
        pat:add_color_stop_rgba(1.00, 0.220, 0.196, 0.200, 1.00) -- #383233 3D bottom extrusion base
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Fine earthen porous clay texture (subtle micro-stippling along the bar)
        cr:set_line_width(1.0)
        cr:set_source_rgba(0.82, 0.77, 0.69, 0.04) -- #d1c4af fine sediment specks
        local step = 37
        local px = 12
        while px < w do
            cr:arc(px, (px * 7) % (h - 8) + 4, 1.2, 0, 2 * math.pi)
            cr:fill()
            px = px + step
        end

        -- 3. Top Specular Sandstone Chamfer Rim (#d1c4af with soft falloff)
        cr:rectangle(0, 0, w, 1.2)
        cr:set_source_rgba(0.820, 0.769, 0.686, 0.40) -- #d1c4af
        cr:fill()

        -- 4. Scribe Ruling Guidelines (horizontal incision grooves pressed by reed stylus)
        -- Upper guideline
        cr:set_line_width(1.0)
        cr:set_source_rgba(0.18, 0.16, 0.17, 0.45) -- Dark carved shadow
        cr:move_to(10, 4)
        cr:line_to(w - 10, 4)
        cr:stroke()
        cr:set_source_rgba(0.85, 0.80, 0.72, 0.20) -- Subtle light lip
        cr:move_to(10, 5)
        cr:line_to(w - 10, 5)
        cr:stroke()

        -- Lower guideline
        cr:set_source_rgba(0.18, 0.16, 0.17, 0.45)
        cr:move_to(10, h - 7)
        cr:line_to(w - 10, h - 7)
        cr:stroke()
        cr:set_source_rgba(0.85, 0.80, 0.72, 0.20)
        cr:move_to(10, h - 6)
        cr:line_to(w - 10, h - 6)
        cr:stroke()

        -- 5. 3D Bottom Tablet Depth / Extrusion Shelf (3-4px dark clay shelf)
        cr:rectangle(0, h - 4, w, 4)
        cr:set_source_rgba(0.220, 0.196, 0.200, 0.95) -- #383233 dark clay extrusion
        cr:fill()

        -- Deep under-shadow at the very bottom edge
        cr:rectangle(0, h - 1, w, 1)
        cr:set_source_rgba(0.13, 0.11, 0.12, 0.80) -- #211c1e deep cast shadow
        cr:fill()

        -- 6. Incised Cuneiform Stylus Wedges (authentic Sumerian/Akkadian reed stylus wedge impressions)
        local function draw_cuneiform_vertical_wedge(x, y, len, width)
            cr:new_path()
            cr:move_to(x, y)
            cr:line_to(x + width * 0.5, y + width * 0.6)
            cr:line_to(x + width * 0.15, y + len)
            cr:line_to(x - width * 0.15, y + len)
            cr:line_to(x - width * 0.5, y + width * 0.6)
            cr:close_path()
            cr:set_source_rgba(0.16, 0.14, 0.15, 0.75)
            cr:fill_preserve()
            cr:set_line_width(0.7)
            cr:set_source_rgba(0.85, 0.78, 0.70, 0.35)
            cr:stroke()
        end

        local function draw_cuneiform_corner_wedge(x, y, size)
            cr:new_path()
            cr:move_to(x, y)
            cr:line_to(x + size, y + size * 0.5)
            cr:line_to(x, y + size)
            cr:line_to(x - size * 0.5, y + size * 0.7)
            cr:close_path()
            cr:set_source_rgba(0.16, 0.14, 0.15, 0.75)
            cr:fill_preserve()
            cr:set_line_width(0.7)
            cr:set_source_rgba(0.85, 0.78, 0.70, 0.35)
            cr:stroke()
        end

        -- Left margin cuneiform scribe mark
        draw_cuneiform_vertical_wedge(16, 12, 14, 5)
        draw_cuneiform_corner_wedge(24, 13, 7)
        draw_cuneiform_vertical_wedge(33, 14, 11, 4.5)

        -- Right margin cuneiform scribe mark
        draw_cuneiform_corner_wedge(w - 36, 13, 7)
        draw_cuneiform_vertical_wedge(w - 26, 12, 14, 5)
        draw_cuneiform_vertical_wedge(w - 18, 14, 11, 4.5)

        cr:restore()
    end
end

-- ==============================================================================
-- 12. "Looney Tunes" Golden Age Animation Light Theme Bar Renderer
-- ==============================================================================
-- Paints a warm vintage animation paper / cel surface (#fdfbf7 -> #f5edd8) with
-- an authentic concentric cartoon title-ring bottom border (Acme Red, Carrot Orange,
-- and Tweety Golden Yellow) and subtle corner target arcs.
function slime_shapes.render_tunes_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Warm vintage cartoon cel parchment gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.992, 0.984, 0.968, 0.97) -- #fdfbf7
        pat:add_color_stop_rgba(0.70, 0.980, 0.960, 0.925, 0.98) -- #faf5ec
        pat:add_color_stop_rgba(1.00, 0.953, 0.925, 0.875, 0.99) -- #f3ecdf
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Top crisp specular highlight
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(1.0, 1.0, 1.0, 0.95)
        cr:fill()

        -- 3. Concentric cartoon bullseye corner watermark accents (subtle WB rings)
        local function draw_bullseye_rings(cx, cy)
            local rings = {
                { r = 18, col = { 0.85, 0.08, 0.18, 0.12 } }, -- Red
                { r = 14, col = { 1.00, 0.42, 0.00, 0.14 } }, -- Orange
                { r = 10, col = { 1.00, 0.82, 0.00, 0.16 } }, -- Yellow
                { r =  6, col = { 0.00, 0.36, 0.73, 0.15 } }, -- Blue core
            }
            for _, ring in ipairs(rings) do
                cr:set_line_width(2.2)
                cr:set_source_rgba(ring.col[1], ring.col[2], ring.col[3], ring.col[4])
                cr:arc(cx, cy, ring.r, 0, 2 * math.pi)
                cr:stroke()
            end
        end

        draw_bullseye_rings(18, h * 0.5)
        draw_bullseye_rings(w - 18, h * 0.5)

        -- 4. Cartoon Ink Guideline
        cr:rectangle(0, h - 5, w, 1)
        cr:set_source_rgba(0.110, 0.086, 0.071, 0.85) -- #1c1612 deep cartoon ink
        cr:fill()

        -- 5. Looney Tunes Concentric Title Striping along bottom rim:
        -- Tweety Golden Yellow (1px)
        cr:rectangle(0, h - 4, w, 1)
        cr:set_source_rgba(1.000, 0.816, 0.000, 1.0) -- #ffd000
        cr:fill()

        -- Carrot Orange (1.5px)
        cr:rectangle(0, h - 3, w, 1.5)
        cr:set_source_rgba(1.000, 0.420, 0.000, 1.0) -- #ff6b00
        cr:fill()

        -- Acme Dynamite Red (1.5px bottom rail)
        cr:rectangle(0, h - 1.5, w, 1.5)
        cr:set_source_rgba(0.851, 0.078, 0.141, 1.0) -- #d91424
        cr:fill()

        cr:restore()
    end
end

-- ==============================================================================
-- 18. Mystery Machine Bar Background Renderer (Dark Spooky Night + Flower Power Trim)
-- ==============================================================================
function slime_shapes.render_mystery_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Deep spooky midnight teal-black gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.063, 0.082, 0.114, 0.98) -- #10151d
        pat:add_color_stop_rgba(0.60, 0.082, 0.114, 0.157, 0.98) -- #151d28
        pat:add_color_stop_rgba(1.00, 0.098, 0.137, 0.188, 0.99) -- #192330
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Top subtle eerie mist cyan specular highlight
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(0.110, 0.820, 0.745, 0.40) -- #1cd1be40
        cr:fill()

        -- 3. Retro 5-petal flower power daisy watermark accents on the sides
        local function draw_flower_power(cx, cy, radius)
            local petals = 5
            for i = 0, petals - 1 do
                local angle = (i * 2 * math.pi) / petals
                local px = cx + math.cos(angle) * (radius * 0.6)
                local py = cy + math.sin(angle) * (radius * 0.6)
                cr:arc(px, py, radius * 0.45, 0, 2 * math.pi)
                cr:set_source_rgba(1.000, 0.467, 0.000, 0.18) -- Flower Orange
                cr:fill()
            end
            -- Center disk
            cr:arc(cx, cy, radius * 0.35, 0, 2 * math.pi)
            cr:set_source_rgba(0.533, 0.886, 0.173, 0.22) -- Lime Green center
            cr:fill()
        end

        draw_flower_power(18, h * 0.5, 9)
        draw_flower_power(w - 18, h * 0.5, 9)

        -- 4. Deep ink guideline
        cr:rectangle(0, h - 5, w, 1)
        cr:set_source_rgba(0.04, 0.05, 0.08, 0.95)
        cr:fill()

        -- 5. The iconic Mystery Machine triple-trim along bottom rail:
        -- Groovy Lime Green (1.5px)
        cr:rectangle(0, h - 4, w, 1.2)
        cr:set_source_rgba(0.533, 0.886, 0.173, 1.0) -- #88e22c
        cr:fill()

        -- Mystery Machine Turquoise Aqua (1.5px)
        cr:rectangle(0, h - 2.8, w, 1.5)
        cr:set_source_rgba(0.110, 0.820, 0.745, 1.0) -- #1cd1be
        cr:fill()

        -- Flower Power Orange (1.3px bottom rail)
        cr:rectangle(0, h - 1.3, w, 1.3)
        cr:set_source_rgba(1.000, 0.467, 0.000, 1.0) -- #ff7700
        cr:fill()

        cr:restore()
    end
end

-- ==============================================================================
-- 19. Darkwing Duck Bar Background Renderer (Midnight Purple & Heroic Trim)
-- ==============================================================================
function slime_shapes.render_darkwing_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Deep midnight purple / shadow plum gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.071, 0.047, 0.122, 0.98) -- #120c1f
        pat:add_color_stop_rgba(0.60, 0.094, 0.063, 0.161, 0.98) -- #181029
        pat:add_color_stop_rgba(1.00, 0.110, 0.075, 0.188, 0.99) -- #1c1330
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Top subtle electric cyan gas mist highlight
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(0.000, 0.898, 1.000, 0.35) -- #00e5ff
        cr:fill()

        -- 3. Double-breasted cape button watermark accents on corners
        local function draw_cape_badge(cx, cy, r)
            -- Subtle fedora shadow arc
            cr:arc(cx, cy - 2, r * 1.5, -math.pi * 0.8, -math.pi * 0.2)
            cr:set_line_width(2.0)
            cr:set_source_rgba(0.616, 0.306, 0.867, 0.20) -- Fedora purple
            cr:stroke()

            -- Large round golden button
            cr:arc(cx, cy, r, 0, 2 * math.pi)
            cr:set_source_rgba(1.000, 0.843, 0.000, 0.25) -- Cape button gold
            cr:fill()

            -- Inner button rim
            cr:arc(cx, cy, r * 0.6, 0, 2 * math.pi)
            cr:set_line_width(1.2)
            cr:set_source_rgba(1.000, 0.420, 0.000, 0.30) -- Orange rim
            cr:stroke()
        end

        draw_cape_badge(18, h * 0.5, 7)
        draw_cape_badge(w - 18, h * 0.5, 7)

        -- 4. Deep ink guideline
        cr:rectangle(0, h - 5, w, 1)
        cr:set_source_rgba(0.04, 0.02, 0.08, 0.95)
        cr:fill()

        -- 5. Darkwing Superhero Triple-Trim along bottom rail:
        -- Fedora Purple (1.5px)
        cr:rectangle(0, h - 4, w, 1.2)
        cr:set_source_rgba(0.616, 0.306, 0.867, 1.0) -- #9d4edd
        cr:fill()

        -- Electric Cyan / Gas Mist (1.5px)
        cr:rectangle(0, h - 2.8, w, 1.5)
        cr:set_source_rgba(0.000, 0.898, 1.000, 1.0) -- #00e5ff
        cr:fill()

        -- Cape Button Gold (1.3px bottom rail)
        cr:rectangle(0, h - 1.3, w, 1.3)
        cr:set_source_rgba(1.000, 0.843, 0.000, 1.0) -- #ffd700
        cr:fill()

        cr:restore()
    end
end

-- ==============================================================================
-- 20. Teenage Mutant Ninja Turtles (TMNT) Bar Background Renderer
-- ==============================================================================
-- Dark sewer brick / mossy slate canvas with NYC manhole iron medallions,
-- the four iconic turtle bandana gems (Leo blue, Raph red, Donnie purple, Mikey orange),
-- and a radioactive mutagen ooze neon green glow along the bottom rail.
-- ==============================================================================
function slime_shapes.render_tmnt_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Deep sewer slate & mossy brick canvas gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.055, 0.082, 0.063, 0.98) -- #0e1510
        pat:add_color_stop_rgba(0.50, 0.075, 0.114, 0.078, 0.98) -- #131d14
        pat:add_color_stop_rgba(1.00, 0.094, 0.145, 0.102, 0.99) -- #18251a
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Top subtle mutagen ooze vapor highlight
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(0.224, 1.000, 0.078, 0.25) -- #39ff14
        cr:fill()

        -- 3. Subtle sewer brick masonry mortar grid lines across baseline
        cr:set_line_width(1.0)
        cr:set_source_rgba(0.18, 0.28, 0.20, 0.20)
        cr:move_to(0, h * 0.45)
        cr:line_to(w, h * 0.45)
        cr:stroke()

        -- 4. Four Turtle Bandana Accent Gems (Leo, Raph, Donnie, Mikey)
        local function draw_turtle_gems(start_x, cy)
            local colors = {
                { 0.000, 0.667, 1.000 }, -- Leonardo Blue   (#00aaff)
                { 1.000, 0.165, 0.294 }, -- Raphael Red     (#ff2a4b)
                { 0.616, 0.306, 0.867 }, -- Donatello Purple(#9d4edd)
                { 1.000, 0.533, 0.000 }, -- Michelangelo Orange(#ff8800)
            }
            local spacing = 11
            for i, col in ipairs(colors) do
                local gx = start_x + (i - 1) * spacing
                -- Outer dark rim
                cr:arc(gx, cy, 3.8, 0, 2 * math.pi)
                cr:set_source_rgba(0.04, 0.06, 0.04, 0.8)
                cr:fill()

                -- Vibrant bandana color dot
                cr:arc(gx, cy, 2.5, 0, 2 * math.pi)
                cr:set_source_rgba(col[1], col[2], col[3], 0.95)
                cr:fill()

                -- Specular highlight
                cr:arc(gx - 0.7, cy - 0.7, 0.8, 0, 2 * math.pi)
                cr:set_source_rgba(1.0, 1.0, 1.0, 0.8)
                cr:fill()
            end
        end

        draw_turtle_gems(18, h * 0.5)
        draw_turtle_gems(w - 56, h * 0.5)

        -- 5. Deep sewer ink guideline
        cr:rectangle(0, h - 5, w, 1)
        cr:set_source_rgba(0.02, 0.04, 0.02, 0.95)
        cr:fill()

        -- 6. TMNT Triple-Trim along bottom rail:
        -- Shell Dark Green (1.2px)
        cr:rectangle(0, h - 4, w, 1.2)
        cr:set_source_rgba(0.180, 0.490, 0.196, 1.0) -- #2e7d32
        cr:fill()

        -- Glowing Mutagen Slime Green (1.6px)
        cr:rectangle(0, h - 2.8, w, 1.6)
        cr:set_source_rgba(0.224, 1.000, 0.078, 1.0) -- #39ff14
        cr:fill()

        -- Pizza Crust Gold (1.2px bottom rail)
        cr:rectangle(0, h - 1.2, w, 1.2)
        cr:set_source_rgba(1.000, 0.843, 0.000, 0.9) -- #ffd700
        cr:fill()

        cr:restore()
    end
end

-- ==============================================================================
-- 21. Muppet Babies Bar Background Renderer (Pastel Vaporwave & Dream Trim)
-- ==============================================================================
-- Twilight nursery violet canvas with subtle vaporwave perspective grid seams,
-- floating pastel star badges, Kermit mint, Piggy bubblegum pink, and Gonzo periwinkle trim.
-- ==============================================================================
function slime_shapes.render_muppet_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Deep pastel twilight violet / nursery dream gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.102, 0.082, 0.157, 0.98) -- #1a1528
        pat:add_color_stop_rgba(0.50, 0.133, 0.102, 0.212, 0.98) -- #221a36
        pat:add_color_stop_rgba(1.00, 0.165, 0.122, 0.259, 0.99) -- #2a1f42
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Top subtle pastel bubblegum pink dream mist highlight
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(1.000, 0.439, 0.651, 0.30) -- #ff70a6
        cr:fill()

        -- 3. Subtle vaporwave perspective grid lines across baseline
        cr:set_line_width(1.0)
        cr:set_source_rgba(0.439, 0.839, 1.000, 0.15) -- Periwinkle grid
        cr:move_to(0, h * 0.48)
        cr:line_to(w, h * 0.48)
        cr:stroke()

        -- 4. Floating Pastel Vaporwave Stars (Piggy Pink, Kermit Mint, Gonzo Blue)
        local function draw_dream_stars(start_x, cy)
            local stars = {
                { 1.000, 0.439, 0.651, 4.0 }, -- Baby Piggy Pink   (#ff70a6)
                { 0.502, 0.929, 0.600, 3.2 }, -- Baby Kermit Mint  (#80ed99)
                { 0.439, 0.839, 1.000, 3.6 }, -- Baby Gonzo Cyan   (#70d6ff)
                { 1.000, 0.820, 0.400, 3.0 }, -- Baby Fozzie Peach (#ffd166)
            }
            local spacing = 12
            for i, st in ipairs(stars) do
                local sx = start_x + (i - 1) * spacing
                local r = st[4]
                cr:new_path()
                cr:move_to(sx, cy - r)
                cr:curve_to(sx, cy - r * 0.2, sx + r * 0.2, cy, sx + r, cy)
                cr:curve_to(sx + r * 0.2, cy, sx, cy + r * 0.2, sx, cy + r)
                cr:curve_to(sx, cy + r * 0.2, sx - r * 0.2, cy, sx - r, cy)
                cr:curve_to(sx - r * 0.2, cy, sx, cy - r * 0.2, sx, cy - r)
                cr:close_path()
                cr:set_source_rgba(st[1], st[2], st[3], 0.85)
                cr:fill()
            end
        end

        draw_dream_stars(18, h * 0.5)
        draw_dream_stars(w - 56, h * 0.5)

        -- 5. Deep twilight guide line
        cr:rectangle(0, h - 5, w, 1)
        cr:set_source_rgba(0.06, 0.04, 0.10, 0.95)
        cr:fill()

        -- 6. Muppet Babies Pastel Vaporwave Triple-Trim along bottom rail:
        -- Kermit Mint Green (1.2px)
        cr:rectangle(0, h - 4, w, 1.2)
        cr:set_source_rgba(0.502, 0.929, 0.600, 1.0) -- #80ed99
        cr:fill()

        -- Piggy Bubblegum Pink (1.6px)
        cr:rectangle(0, h - 2.8, w, 1.6)
        cr:set_source_rgba(1.000, 0.439, 0.651, 1.0) -- #ff70a6
        cr:fill()

        -- Gonzo Periwinkle Cyan (1.2px bottom rail)
        cr:rectangle(0, h - 1.2, w, 1.2)
        cr:set_source_rgba(0.439, 0.839, 1.000, 0.95) -- #70d6ff
        cr:fill()

        cr:restore()
    end
end

-- ==============================================================================
-- 22. I'm Sorry Jon Bar Background Renderer (Cosmic Horror & Eldritch Amber)
-- ==============================================================================
-- Abyssal kitchen shadow canvas (#0f0c0b to #1e1513) with subtle eldritch tendril shadows,
-- hanging lamp amber warmth, and a burnt lasagna orange and blood-crimson bottom rail.
-- ==============================================================================
function slime_shapes.render_jon_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Abyssal shadowy kitchen gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.059, 0.047, 0.043, 0.98) -- #0f0c0b
        pat:add_color_stop_rgba(0.50, 0.086, 0.063, 0.059, 0.98) -- #16100f
        pat:add_color_stop_rgba(1.00, 0.118, 0.082, 0.075, 0.99) -- #1e1513
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Top subtle hanging lamp warm amber highlight
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(0.878, 0.337, 0.180, 0.35) -- #e0562e
        cr:fill()

        -- 3. Subtle eldritch tendril shadow arcs across the bar
        local function draw_tendril_accent(cx, cy)
            cr:arc(cx, cy, 8, 0, math.pi * 1.5)
            cr:set_line_width(1.2)
            cr:set_source_rgba(0.04, 0.02, 0.02, 0.70)
            cr:stroke()

            -- Glowing eldritch ember dot
            cr:arc(cx + 4, cy - 2, 2.0, 0, 2 * math.pi)
            cr:set_source_rgba(0.878, 0.337, 0.180, 0.75) -- Burnt orange
            cr:fill()
        end

        draw_tendril_accent(24, h * 0.5)
        draw_tendril_accent(w - 24, h * 0.5)

        -- 4. Deep ink guideline
        cr:rectangle(0, h - 5, w, 1)
        cr:set_source_rgba(0.02, 0.01, 0.01, 0.95)
        cr:fill()

        -- 5. Eldritch Lasagna Triple-Trim along bottom rail:
        -- Blood Red (1.2px)
        cr:rectangle(0, h - 4, w, 1.2)
        cr:set_source_rgba(0.820, 0.220, 0.141, 1.0) -- #d13824
        cr:fill()

        -- Burnt Lasagna Orange (1.6px)
        cr:rectangle(0, h - 2.8, w, 1.6)
        cr:set_source_rgba(0.878, 0.337, 0.180, 1.0) -- #e0562e
        cr:fill()

        -- Hanging Lamp Amber Gold (1.2px bottom rail)
        cr:rectangle(0, h - 1.2, w, 1.2)
        cr:set_source_rgba(0.898, 0.663, 0.235, 0.95) -- #e5a93c
        cr:fill()

        cr:restore()
    end
end

-- ==============================================================================
-- 23. Wake & Bake (420 Special) Bar Background Renderer
-- ==============================================================================
-- Cozy stoner den midnight noir canvas (#101617 to #16201e) with soft billowing
-- smoke haze gradients, ambient TV/bong cyan glow, and an herbal trichome green
-- and golden munchies bottom rail trim.
-- ==============================================================================
function slime_shapes.render_bake_bar_bg()
    return function(_, cr, w, h)
        cr:save()
        ensure_best_antialias(cr)

        -- 1. Deep herbal stoner den noir gradient
        local pat = cairo.Pattern.create_linear(0, 0, 0, h)
        pat:add_color_stop_rgba(0.00, 0.063, 0.086, 0.090, 0.98) -- #101617
        pat:add_color_stop_rgba(0.50, 0.078, 0.106, 0.110, 0.98) -- #141b1c
        pat:add_color_stop_rgba(1.00, 0.086, 0.125, 0.118, 0.99) -- #16201e
        cr:rectangle(0, 0, w, h)
        cr:set_source(pat)
        cr:fill()

        -- 2. Top subtle TV / bong water glow highlight (pale cyan / trichome tint)
        cr:rectangle(0, 0, w, 1)
        cr:set_source_rgba(0.306, 0.886, 0.925, 0.35) -- #4ee2ec
        cr:fill()

        -- 3. Billowing smoke rings / weed leaf accents at ends
        local function draw_smoke_accent(cx, cy)
            -- Outer soft smoke ring
            cr:arc(cx, cy, 7, 0, 2 * math.pi)
            cr:set_line_width(1.2)
            cr:set_source_rgba(0.60, 0.85, 0.75, 0.25)
            cr:stroke()

            -- Inner glowing resin amber ember
            cr:arc(cx + 2, cy - 1, 2.0, 0, 2 * math.pi)
            cr:set_source_rgba(0.957, 0.635, 0.149, 0.85) -- #f4a226 ember
            cr:fill()

            -- Subtle herbal trichome spark
            cr:arc(cx - 3, cy + 2, 1.5, 0, 2 * math.pi)
            cr:set_source_rgba(0.282, 0.722, 0.322, 0.80) -- #48b852 green
            cr:fill()
        end

        draw_smoke_accent(24, h * 0.5)
        draw_smoke_accent(w - 24, h * 0.5)

        -- 4. Deep shadow boundary
        cr:rectangle(0, h - 5, w, 1)
        cr:set_source_rgba(0.02, 0.03, 0.03, 0.95)
        cr:fill()

        -- 5. 420 Triple-Trim Bottom Rail:
        -- Crunchy Munchies Red (1.2px)
        cr:rectangle(0, h - 4, w, 1.2)
        cr:set_source_rgba(0.902, 0.224, 0.275, 0.90) -- #e63946
        cr:fill()

        -- Cheesy Doritos Gold (1.5px)
        cr:rectangle(0, h - 2.8, w, 1.5)
        cr:set_source_rgba(0.957, 0.635, 0.149, 0.95) -- #f4a226
        cr:fill()

        -- Pure Emerald Cannabis Green (1.3px bottom edge)
        cr:rectangle(0, h - 1.3, w, 1.3)
        cr:set_source_rgba(0.282, 0.722, 0.322, 1.00) -- #48b852
        cr:fill()

        cr:restore()
    end
end

return slime_shapes




