-- Standard Awesome WM modular entry point

-- If LuaRocks is installed, make sure that packages installed through it are found
pcall(require, "luarocks.loader")

-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to another config
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Theme initialization
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
-- }}}

-- {{{ Load modular configuration
-- Default applications, modkey, and layout definitions
require("config.apps")

-- Context menus and launcher
require("ui.menu")

-- Top bar, wallpaper, and per-screen widgets
require("ui.bar")

-- Notification styling
require("ui.notifications")

-- Keybindings and mouse bindings
require("config.keys")

-- Window rules
require("config.rules")

-- Client signals (focus, borders, titlebars)
require("config.signals")

-- Autostart background processes
require("config.autostart")

-- Periodic Lua garbage collection to purge cached Cairo surfaces and bound memory
gears.timer {
    timeout   = 180,
    autostart = true,
    callback  = function()
        collectgarbage("collect")
    end,
}
-- }}}

