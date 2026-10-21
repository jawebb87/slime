-- Notification appearance and styling (Theme-Agnostic)
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

-- Default notification appearance
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = 48
naughty.config.defaults.timeout = 5
naughty.config.defaults.margin = 15

-- Apply theme shape and colors
naughty.config.defaults.shape = beautiful.notification_shape or function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 4)
end
naughty.config.defaults.border_width = beautiful.notification_border_width or beautiful.border_width or 2
naughty.config.defaults.border_color = beautiful.notification_border_color or beautiful.border_focus or "#55f736"
naughty.config.defaults.bg = beautiful.bg_normal or "#111415f8"
naughty.config.defaults.fg = beautiful.fg_normal or "#e2f5ec"

-- Load theme presets (normal, critical, low) if defined by active theme
if beautiful.notification_presets then
    if beautiful.notification_presets.normal then
        naughty.config.presets.normal = beautiful.notification_presets.normal
    end
    if beautiful.notification_presets.critical then
        naughty.config.presets.critical = beautiful.notification_presets.critical
    end
    if beautiful.notification_presets.low then
        naughty.config.presets.low = beautiful.notification_presets.low
    end
end
