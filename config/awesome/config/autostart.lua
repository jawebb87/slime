local awful = require("awful")

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        local findme = cmd
        local firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace - 1)
        end
        awful.spawn.easy_async_with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end

-- Commands and daemons to run on startup
run_once({
    -- "nm-applet",
    "picom -b",
    "xsettingsd",
    -- "blueman-applet",
    -- "xss-lock -- slock",
})

-- Ensure XDG desktop portal services are running for Firefox theme integration
awful.spawn.with_shell("systemctl --user start xdg-desktop-portal xdg-desktop-portal-gtk")

-- Run Downloads organizer once per session startup
awful.spawn.with_shell("~/.local/bin/sorted --once --notify")

-- Ensure background clipboard history daemon is running
awful.spawn.with_shell("pgrep -u $USER -f '^python3 .*/clip_pad\\.py --daemon' > /dev/null || python3 ~/Projects/qtile_bench/clip_pad.py --daemon")

