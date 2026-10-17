local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local apps = require("config.apps")

local menu = {}

menu.myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", apps.terminal .. " -e man awesome" },
    { "edit config", apps.editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

menu.mymainmenu = awful.menu({
    items = {
        { "awesome", menu.myawesomemenu, beautiful.awesome_icon },
        { "open terminal", apps.terminal },
        { "web browser", apps.browser },
    }
})

menu.mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = menu.mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = apps.terminal

return menu
