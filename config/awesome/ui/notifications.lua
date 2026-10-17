local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local slime_shapes = require("theme.slime_shapes")

local mode = beautiful.mode or "slime"

-- Default notification appearance
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = 48
naughty.config.defaults.timeout = 5
naughty.config.defaults.margin = 15

if mode == "origin" then
    naughty.config.defaults.shape = slime_shapes.rocky_window(8, 10, 2.9)
    naughty.config.defaults.border_width = 2
    naughty.config.defaults.border_color = "#9ece6a"
    naughty.config.defaults.bg = "#141712f5"
    naughty.config.defaults.fg = "#d8dee9"

    naughty.config.presets.normal = {
        bg = "#141712f5",
        fg = "#d8dee9",
        border_color = "#9ece6a",
        border_width = 2,
        timeout = 5,
    }

    naughty.config.presets.critical = {
        bg = "#241e17f8",
        fg = "#d8dee9",
        border_color = "#d08770",
        border_width = 2,
        timeout = 0,
    }

    naughty.config.presets.low = {
        bg = "#141712f2",
        fg = "#9ece6a",
        border_color = "#5a784d",
        border_width = 1,
        timeout = 4,
    }
elseif mode == "shred" then
    naughty.config.defaults.shape = slime_shapes.shred_window(10)
    naughty.config.defaults.border_width = 2
    naughty.config.defaults.border_color = "#c8d0dc"
    naughty.config.defaults.bg = "#0b0c0ef6"
    naughty.config.defaults.fg = "#e2e8f0"

    naughty.config.presets.normal = {
        bg = "#0b0c0ef6",
        fg = "#e2e8f0",
        border_color = "#c8d0dc",
        border_width = 2,
        timeout = 5,
    }

    naughty.config.presets.critical = {
        bg = "#1c2129f8",
        fg = "#ffffff",
        border_color = "#ff2a2a",
        border_width = 2,
        timeout = 0,
    }

    naughty.config.presets.low = {
        bg = "#0b0c0ef2",
        fg = "#8b95a5",
        border_color = "#4a5260",
        border_width = 1,
        timeout = 4,
    }
elseif mode == "lab" then
    naughty.config.defaults.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 4)
    end
    naughty.config.defaults.border_width = 2
    naughty.config.defaults.border_color = "#000000"
    naughty.config.defaults.bg = "#ffffff"
    naughty.config.defaults.fg = "#0a0c0e"

    naughty.config.presets.normal = {
        bg = "#ffffff",
        fg = "#0a0c0e",
        border_color = "#000000",
        border_width = 2,
        timeout = 5,
    }

    naughty.config.presets.critical = {
        bg = "#fef2f2",
        fg = "#991b1b",
        border_color = "#dc2626",
        border_width = 3,
        timeout = 0,
    }

    naughty.config.presets.low = {
        bg = "#f8fafc",
        fg = "#334155",
        border_color = "#475569",
        border_width = 2,
        timeout = 4,
    }
elseif mode == "cyber" then
    naughty.config.defaults.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 2)
    end
    naughty.config.defaults.border_width = 1
    naughty.config.defaults.border_color = "#a855f7"
    naughty.config.defaults.bg = "#090812f8"
    naughty.config.defaults.fg = "#e0d8f6"

    naughty.config.presets.normal = {
        bg = "#090812f8",
        fg = "#e0d8f6",
        border_color = "#a855f7",
        border_width = 1,
        timeout = 5,
    }

    -- Critical alerts: Hot Magenta #ff007f
    naughty.config.presets.critical = {
        bg = "#161326f8",
        fg = "#ffffff",
        border_color = "#ff007f",
        border_width = 1,
        timeout = 0,
    }

    naughty.config.presets.low = {
        bg = "#120f24f8",
        fg = "#00f0ff",
        border_color = "#7928ca",
        border_width = 1,
        timeout = 4,
    }
elseif mode == "space" then
    naughty.config.defaults.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 4)
    end
    naughty.config.defaults.border_width = 2
    naughty.config.defaults.border_color = "#e59500"
    naughty.config.defaults.bg = "#f5f6f9f8"
    naughty.config.defaults.fg = "#1b2028"

    naughty.config.presets.normal = {
        bg = "#f5f6f9f8",
        fg = "#1b2028",
        border_color = "#e59500",
        border_width = 2,
        timeout = 5,
    }

    -- Critical alerts: Airlock Red #d32f2f
    naughty.config.presets.critical = {
        bg = "#fbe9e9",
        fg = "#1b2028",
        border_color = "#d32f2f",
        border_width = 3,
        timeout = 0,
    }

    naughty.config.presets.low = {
        bg = "#e1e4ea",
        fg = "#0088cc",
        border_color = "#0088cc",
        border_width = 2,
        timeout = 4,
    }
else
    naughty.config.defaults.shape = slime_shapes.dripping_window(10, 9, 2.9)
    naughty.config.defaults.border_width = 2
    naughty.config.defaults.border_color = "#55f736"
    naughty.config.defaults.bg = "#0c140df2"
    naughty.config.defaults.fg = "#c6f582"

    naughty.config.presets.normal = {
        bg = "#0c140df2",
        fg = "#c6f582",
        border_color = "#55f736",
        border_width = 2,
        timeout = 5,
    }

    -- Critical errors / alerts: stand-out red
    naughty.config.presets.critical = {
        bg = "#1f0909f8",
        fg = "#ffdddd",
        border_color = "#ff4343",
        border_width = 2,
        timeout = 0,
    }

    naughty.config.presets.low = {
        bg = "#0a120cf2",
        fg = "#97bd85",
        border_color = "#2c4c30",
        border_width = 1,
        timeout = 4,
    }
end
