local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local slime_shapes = require("theme.slime_shapes")

local is_lab = (beautiful.mode == "lab")

-- Default notification appearance
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = 48
naughty.config.defaults.timeout = 5
naughty.config.defaults.margin = 15

if is_lab then
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
