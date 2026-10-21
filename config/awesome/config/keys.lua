local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local apps = require("config.apps")
local menu = require("ui.menu")
local scratchpad = require("config.scratchpad")
local beautiful = require("beautiful")

local python_bench = os.getenv("HOME") .. "/Projects/qtile_bench/"

local modkey = apps.modkey
local keys = {}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () menu.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Global key bindings
keys.globalkeys = gears.table.join(
    awful.key({ modkey, "Control" }, "F1",     hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey, "Shift"   }, "w", function () menu.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(apps.terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Application Launchers
    awful.key({ modkey }, "d", function () awful.spawn(apps.launcher) end,
              {description = "open application launcher (rofi)", group = "launcher"}),
    awful.key({ modkey }, "b", function () awful.spawn(apps.browser) end,
              {description = "open web browser (firefox)", group = "launcher"}),

    -- Screenshots
    awful.key({ }, "Print", function ()
        awful.spawn(os.getenv("HOME") .. "/.local/bin/qtile-screenshot full")
    end, {description = "take full screenshot", group = "launcher"}),
    awful.key({ modkey }, "Print", function ()
        awful.spawn(os.getenv("HOME") .. "/.local/bin/qtile-screenshot window")
    end, {description = "take active window screenshot", group = "launcher"}),
    awful.key({ "Shift" }, "Print", function ()
        awful.spawn(os.getenv("HOME") .. "/.local/bin/qtile-screenshot region")
    end, {description = "take region screenshot", group = "launcher"}),

    -- Hardware Audio & Brightness Keys
    awful.key({ }, "XF86AudioRaiseVolume", function ()
        awful.spawn.easy_async("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+", function()
            awesome.emit_signal("volume::update")
        end)
    end, {description = "raise volume +5%", group = "media"}),
    awful.key({ }, "XF86AudioLowerVolume", function ()
        awful.spawn.easy_async("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", function()
            awesome.emit_signal("volume::update")
        end)
    end, {description = "lower volume -5%", group = "media"}),
    awful.key({ }, "XF86AudioMute", function ()
        awful.spawn.easy_async("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", function()
            awesome.emit_signal("volume::update")
        end)
    end, {description = "toggle audio mute", group = "media"}),
    awful.key({ }, "XF86AudioMicMute", function ()
        awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
    end, {description = "toggle mic mute", group = "media"}),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.spawn("brightnessctl set +10%")
    end, {description = "increase screen brightness", group = "media"}),
    awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.spawn("brightnessctl set 10%-")
    end, {description = "decrease screen brightness", group = "media"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey, "Shift"   }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- {{{ Python Dropdowns & Terminal Scratchpads
    -- Ephemeral (true): Killed on dismiss/close to immediately reclaim RAM
    -- Persistent (nil/false): Banished to hidden tag to preserve session state (agy, notes, chomp, limusic)

    awful.key({ modkey }, "a", function ()
        scratchpad.toggle("python3 " .. python_bench .. "audio_pad.py", "audio-pad", true)
    end, {description = "toggle audio mixer dropdown", group = "scratchpad"}),

    awful.key({ modkey }, "i", function ()
        scratchpad.toggle("python3 " .. python_bench .. "wifi_pad.py", "wifi-pad", true)
    end, {description = "toggle wifi manager dropdown", group = "scratchpad"}),

    awful.key({ modkey }, "x", function ()
        scratchpad.toggle("python3 " .. python_bench .. "clip_pad.py", "clip-pad", true)
    end, {description = "toggle clipboard history dropdown", group = "scratchpad"}),

    awful.key({ modkey }, "t", function ()
        scratchpad.toggle("alacritty --class btop-float,btop-float -T btop-float -e btop", "btop-float", true)
    end, {description = "toggle btop system monitor", group = "scratchpad"}),

    awful.key({ modkey }, "w", function ()
        scratchpad.toggle("python3 " .. python_bench .. "weather_pad.py", "weather-pad", true)
    end, {description = "toggle weather forecast dropdown", group = "scratchpad"}),

    awful.key({ modkey }, "n", function ()
        scratchpad.toggle("python3 " .. python_bench .. "log_pad.py", "log-pad", true)
    end, {description = "toggle system log viewer", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "d", function ()
        scratchpad.toggle("python3 " .. python_bench .. "docker_pad.py", "docker-pad", true)
    end, {description = "toggle docker services dashboard", group = "scratchpad"}),

    awful.key({ modkey }, "v", function ()
        scratchpad.toggle("python3 " .. python_bench .. "vim_cheat.py", "vim-cheat", true)
    end, {description = "toggle vim cheatsheet dropdown", group = "scratchpad"}),

    awful.key({ modkey }, "s", function ()
        scratchpad.toggle("alacritty --class notes-pad,notes-pad -T notes-pad -e " .. os.getenv("HOME") .. "/.local/bin/qtile-notes", "notes-pad")
    end, {description = "toggle notes scratchpad (persistent)", group = "scratchpad"}),

    awful.key({ modkey }, "F1", function ()
        scratchpad.toggle("python3 " .. python_bench .. "key_cheat.py", "key-cheat", true)
    end, {description = "toggle keybindings cheatsheet", group = "scratchpad"}),

    awful.key({ modkey }, "z", function ()
        scratchpad.toggle("python3 " .. python_bench .. "zodiac_pad.py", "zodiac-pad", true)
    end, {description = "toggle zodiac calendar dropdown", group = "scratchpad"}),

    awful.key({ modkey }, "m", function ()
        scratchpad.toggle("python3 " .. python_bench .. "emoji_pad.py", "emoji-pad", true)
    end, {description = "toggle emoji picker dropdown", group = "scratchpad"}),

    awful.key({ }, "F12", function ()
        if beautiful.mode == "mothgomery" then
            scratchpad.toggle("alacritty --class mothgomery-pad,mothgomery-pad -T mothgomery-pad -e " .. os.getenv("HOME") .. "/.local/bin/mothgomery-pad", "mothgomery-pad")
        elseif beautiful.mode == "gill" then
            scratchpad.toggle("alacritty --class gill-pad,gill-pad -T gill-pad -e " .. os.getenv("HOME") .. "/.local/bin/gill-pad", "gill-pad")
        elseif beautiful.mode == "rable" then
            scratchpad.toggle("alacritty --class rable-pad,rable-pad -T rable-pad -e " .. os.getenv("HOME") .. "/.local/bin/rable-pad", "rable-pad")
        elseif beautiful.mode == "tov" then
            scratchpad.toggle("alacritty --class tov-pad,tov-pad -T tov-pad -e " .. os.getenv("HOME") .. "/.local/bin/tov-pad", "tov-pad")
        elseif beautiful.mode == "dino" then
            scratchpad.toggle("alacritty --class dino-pad,dino-pad -T dino-pad -e " .. os.getenv("HOME") .. "/.local/bin/dino-pad", "dino-pad")
        elseif beautiful.mode == "crust" then
            scratchpad.toggle("alacritty --class crust-pad,crust-pad -T crust-pad -e " .. os.getenv("HOME") .. "/.local/bin/crust-pad", "crust-pad")
        elseif beautiful.mode == "tunes" then
            scratchpad.toggle("alacritty --class tunes-pad,tunes-pad -T tunes-pad -e " .. os.getenv("HOME") .. "/.local/bin/tunes-pad", "tunes-pad")
        elseif beautiful.mode == "mystery" then
            scratchpad.toggle("alacritty --class mystery-pad,mystery-pad -T mystery-pad -e " .. os.getenv("HOME") .. "/.local/bin/mystery-pad", "mystery-pad")
        elseif beautiful.mode == "darkwing" then
            scratchpad.toggle("alacritty --class darkwing-pad,darkwing-pad -T darkwing-pad -e " .. os.getenv("HOME") .. "/.local/bin/darkwing-pad", "darkwing-pad")
        elseif beautiful.mode == "tmnt" then
            scratchpad.toggle("alacritty --class tmnt-pad,tmnt-pad -T tmnt-pad -e " .. os.getenv("HOME") .. "/.local/bin/tmnt-pad", "tmnt-pad")
        elseif beautiful.mode == "muppet" then
            scratchpad.toggle("alacritty --class muppet-pad,muppet-pad -T muppet-pad -e " .. os.getenv("HOME") .. "/.local/bin/muppet-pad", "muppet-pad")
        elseif beautiful.mode == "jon" then
            scratchpad.toggle("alacritty --class jon-pad,jon-pad -T jon-pad -e " .. os.getenv("HOME") .. "/.local/bin/jon-pad", "jon-pad")
        elseif beautiful.mode == "bake" then
            scratchpad.toggle("alacritty --class bake-pad,bake-pad -T bake-pad -e " .. os.getenv("HOME") .. "/.local/bin/bake-pad", "bake-pad")
        elseif beautiful.mode == "chomp" or beautiful.mode == "larry" then
            scratchpad.toggle("alacritty --class chomp-pad,chomp-pad -T chomp-pad -e " .. os.getenv("HOME") .. "/.local/bin/chomp-pad", "chomp-pad")
        else
            scratchpad.toggle("alacritty --class theme-console,theme-console -T theme-console -e " .. os.getenv("HOME") .. "/.local/bin/theme-console", "theme-console")
        end
    end, {description = "toggle console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey }, "g", function ()
        scratchpad.toggle("alacritty --class agy-pad,agy-pad -T agy-pad -e " .. os.getenv("HOME") .. "/.local/bin/agy", "agy-pad")
    end, {description = "toggle antigravity assistant (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "g", function ()
        scratchpad.toggle("alacritty --class gill-pad,gill-pad -T gill-pad -e " .. os.getenv("HOME") .. "/.local/bin/gill-pad", "gill-pad")
    end, {description = "toggle baron von gill console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "r", function ()
        scratchpad.toggle("alacritty --class rable-pad,rable-pad -T rable-pad -e " .. os.getenv("HOME") .. "/.local/bin/rable-pad", "rable-pad")
    end, {description = "toggle miss rable console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "m", function ()
        scratchpad.toggle("alacritty --class tov-pad,tov-pad -T tov-pad -e " .. os.getenv("HOME") .. "/.local/bin/tov-pad", "tov-pad")
    end, {description = "toggle molly tov console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "b", function ()
        scratchpad.toggle("alacritty --class dino-pad,dino-pad -T dino-pad -e " .. os.getenv("HOME") .. "/.local/bin/dino-pad", "dino-pad")
    end, {description = "toggle dino might console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "u", function ()
        scratchpad.toggle("alacritty --class crust-pad,crust-pad -T crust-pad -e " .. os.getenv("HOME") .. "/.local/bin/crust-pad", "crust-pad")
    end, {description = "toggle crustpunk console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Control" }, "t", function ()
        scratchpad.toggle("alacritty --class tunes-pad,tunes-pad -T tunes-pad -e " .. os.getenv("HOME") .. "/.local/bin/tunes-pad", "tunes-pad")
    end, {description = "toggle looney tunes console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "v", function ()
        scratchpad.toggle("alacritty --class mystery-pad,mystery-pad -T mystery-pad -e " .. os.getenv("HOME") .. "/.local/bin/mystery-pad", "mystery-pad")
    end, {description = "toggle mystery machine console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "p", function ()
        scratchpad.toggle("alacritty --class darkwing-pad,darkwing-pad -T darkwing-pad -e " .. os.getenv("HOME") .. "/.local/bin/darkwing-pad", "darkwing-pad")
    end, {description = "toggle darkwing duck console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "s", function ()
        scratchpad.toggle("alacritty --class tmnt-pad,tmnt-pad -T tmnt-pad -e " .. os.getenv("HOME") .. "/.local/bin/tmnt-pad", "tmnt-pad")
    end, {description = "toggle ninja turtles console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "e", function ()
        scratchpad.toggle("alacritty --class muppet-pad,muppet-pad -T muppet-pad -e " .. os.getenv("HOME") .. "/.local/bin/muppet-pad", "muppet-pad")
    end, {description = "toggle muppet babies console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "i", function ()
        scratchpad.toggle("alacritty --class jon-pad,jon-pad -T jon-pad -e " .. os.getenv("HOME") .. "/.local/bin/jon-pad", "jon-pad")
    end, {description = "toggle i'm sorry jon console dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey }, "y", function ()
        scratchpad.toggle("limusic-app", "limusic")
    end, {description = "toggle limusic music player dropdown (persistent)", group = "scratchpad"}),

    awful.key({ modkey }, "/", function ()
        scratchpad.toggle("alacritty --class fzf-pad,fzf-pad -T fzf-pad -e " .. os.getenv("HOME") .. "/.local/bin/qtile-fzf", "fzf-pad", true)
    end, {description = "toggle fzf file finder dropdown", group = "scratchpad"}),

    awful.key({ modkey, "Shift" }, "f", function ()
        scratchpad.toggle("python3 " .. python_bench .. "font_pad.py", "font-pad", true)
    end, {description = "toggle desktop font selector dropdown", group = "scratchpad"}),

    awful.key({ modkey, "Control" }, "c", function ()
        scratchpad.toggle("alacritty --class chomp-pad,chomp-pad -T chomp-pad -e " .. os.getenv("HOME") .. "/.local/bin/chomp-pad", "chomp-pad")
    end, {description = "toggle chomp the haxor console dropdown (persistent)", group = "scratchpad"}),

    -- Lock Screen
    awful.key({ "Control", "Mod1" }, "l", function ()
        awful.spawn("slock")
    end, {description = "lock screen (slock)", group = "awesome"}),

    -- Theme Toggle: Super+o to cycle forward, Super+Shift+o to load a random theme
    awful.key({ modkey }, "o", function ()
        awful.spawn(os.getenv("HOME") .. "/.local/bin/theme-toggle")
    end, {description = "cycle next desktop theme", group = "awesome"}),

    awful.key({ modkey, "Shift" }, "o", function ()
        awful.spawn(os.getenv("HOME") .. "/.local/bin/theme-toggle random")
    end, {description = "load random desktop theme", group = "awesome"})
    -- }}}
)

-- {{{ Client key bindings
keys.clientkeys = gears.table.join(
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close active window", group = "client"}),
    awful.key({ "Mod1",           }, "F4",     function (c) c:kill()                         end,
              {description = "close active window (Alt+F4)", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close active window", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, "Control" }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, "Shift"   }, "n",
        function (c)
            c.minimized = true
        end ,
        {description = "minimize", group = "client"})
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- {{{ Client mouse buttons
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set root keys
root.keys(keys.globalkeys)

return keys
