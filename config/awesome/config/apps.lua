local awful = require("awful")

local apps = {
    -- Default applications
    terminal = "kitty",
    editor = os.getenv("EDITOR") or "nvim",
    browser = "firefox",
    launcher = "rofi -normal-window -show drun",

    -- Default modkey (Mod4 is Super / Windows key)
    modkey = "Mod4",
}

apps.editor_cmd = apps.terminal .. " -e " .. apps.editor

-- Table of layouts to cover with awful.layout.inc (tile, tile.bottom, max)
awful.layout.layouts = {
    awful.layout.suit.tile,        -- Master on left, slave stack on right (1x1 for 2 windows, 1x2 for 3)
    awful.layout.suit.tile.bottom, -- Master on top, slave stack on bottom
    awful.layout.suit.max,         -- Monocle (single full window with gaps)
}

return apps
