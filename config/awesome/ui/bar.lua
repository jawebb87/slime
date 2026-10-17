local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("config.apps")
local scratchpad = require("config.scratchpad")
local slime_shapes = require("theme.slime_shapes")

local modkey = apps.modkey
local python_bench = os.getenv("HOME") .. "/Projects/qtile_bench/"

-- {{{ Wallpaper
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Helper: Wobbly slime pill widget wrapper
local pill_seed = 1.1
local function pill_container(widget, bg_color, fg_color)
    pill_seed = pill_seed + 1.37
    return wibox.widget {
        {
            widget,
            left   = 10,
            right  = 10,
            top    = 3,
            bottom = 3,
            widget = wibox.container.margin,
        },
        bg                 = bg_color or "#122015",
        fg                 = fg_color or beautiful.fg_normal,
        shape              = slime_shapes.wobbly_pill(7, pill_seed),
        shape_border_width = 1,
        shape_border_color = "#24492b",
        widget             = wibox.container.background,
    }
end

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    return content and content:gsub("^%s*(.-)%s*$", "%1") or nil
end
-- }}}

-- {{{ Discover sysfs hwmon paths for k10temp (CPU) and amdgpu (GPU)
local cpu_temp_path = nil
local gpu_temp_path = nil
for i = 0, 12 do
    local base = "/sys/class/hwmon/hwmon" .. i
    local name = read_file(base .. "/name")
    if name == "k10temp" then
        if read_file(base .. "/temp1_input") then
            cpu_temp_path = base .. "/temp1_input"
        end
    elseif name == "amdgpu" then
        local val = read_file(base .. "/temp1_input")
        if val and val ~= "" then
            gpu_temp_path = base .. "/temp1_input"
        end
    end
end
-- }}}

-- {{{ Live Telemetry Widgets

-- 1. CPU Usage + Temperature Pill (click -> btop)
local cpu_textbox = wibox.widget {
    markup = "<span foreground='#d8eb34'> 0%</span>",
    widget = wibox.widget.textbox,
}
local prev_total, prev_idle = 0, 0
gears.timer {
    timeout   = 2,
    call_now  = true,
    autostart = true,
    callback  = function()
        local stat = read_file("/proc/stat")
        local usage = 0
        if stat then
            local u, n, s, id, io, irq, sirq, st = stat:match("^cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
            if u then
                local idle = tonumber(id) + tonumber(io)
                local total = tonumber(u) + tonumber(n) + tonumber(s) + idle + tonumber(irq) + tonumber(sirq) + tonumber(st)
                local diff_total = total - prev_total
                local diff_idle = idle - prev_idle
                if diff_total > 0 and prev_total > 0 then
                    usage = math.floor(((diff_total - diff_idle) / diff_total) * 100 + 0.5)
                end
                prev_total, prev_idle = total, idle
            end
        end

        local temp_str = ""
        local temp_color = "#d8eb34"
        if cpu_temp_path then
            local raw = tonumber(read_file(cpu_temp_path) or "")
            if raw then
                local c = math.floor(raw / 1000 + 0.5)
                temp_str = string.format("   %d°C", c)
                if c >= 75 then
                    temp_color = "#ff4343"
                end
            end
        end
        cpu_textbox.markup = string.format(
            "<span foreground='#d8eb34'> %d%%</span><span foreground='%s'>%s</span>",
            usage, temp_color, temp_str
        )
    end,
}
local cpu_pill = pill_container(cpu_textbox, "#142417")
cpu_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("kitty --class btop-float -e btop", "btop-float")
    end)
))

-- 2. GPU Temp + RAM + Disk Pill (click -> btop)
local sys_textbox = wibox.widget {
    markup = "<span foreground='#c6f582'> --G</span>",
    widget = wibox.widget.textbox,
}
local disk_free_str = ""
gears.timer {
    timeout   = 30,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async_with_shell("df -BG --output=avail / | tail -n 1", function(stdout)
            local avail = stdout:match("(%d+G)")
            if avail then
                disk_free_str = "   " .. avail
            end
        end)
    end,
}
gears.timer {
    timeout   = 2,
    call_now  = true,
    autostart = true,
    callback  = function()
        local meminfo = read_file("/proc/meminfo")
        local ram_str = " --G"
        if meminfo then
            local total = tonumber(meminfo:match("MemTotal:%s+(%d+)"))
            local avail = tonumber(meminfo:match("MemAvailable:%s+(%d+)"))
            if total and avail then
                local used_gb = (total - avail) / (1024 * 1024)
                ram_str = string.format(" %.1fG", used_gb)
            end
        end

        local gpu_str = ""
        if gpu_temp_path then
            local raw = tonumber(read_file(gpu_temp_path) or "")
            if raw then
                gpu_str = string.format(" %d°C  ", math.floor(raw / 1000 + 0.5))
            end
        end
        sys_textbox.markup = string.format(
            "<span foreground='#55ffaa'>%s</span><span foreground='#c6f582'>%s%s</span>",
            gpu_str, ram_str, disk_free_str
        )
    end,
}
local sys_pill = pill_container(sys_textbox, "#122015")
sys_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("kitty --class btop-float -e btop", "btop-float")
    end)
))

-- 3. Network Status Pill (Wi-Fi or Wired Ethernet, click -> wifi_pad.py)
local wifi_textbox = wibox.widget {
    markup = "<span foreground='#74ff2e'> Net</span>",
    widget = wibox.widget.textbox,
}
gears.timer {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async_with_shell(
            "nmcli -t -f TYPE,STATE,CONNECTION dev status 2>/dev/null | grep ':connected:' | head -n 1",
            function(stdout)
                local net_type, _, conn = stdout:match("^([^:]+):([^:]+):([^\r\n]+)")
                if net_type == "wifi" and conn and conn ~= "" then
                    wifi_textbox.markup = string.format("<span foreground='#74ff2e'> %s</span>", gears.string.xml_escape(conn))
                elseif net_type == "ethernet" then
                    wifi_textbox.markup = "<span foreground='#74ff2e'> Wired</span>"
                else
                    wifi_textbox.markup = "<span foreground='#ff4343'> Offline</span>"
                end
            end
        )
    end,
}
local wifi_pill = pill_container(wifi_textbox, "#142417")
wifi_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("python3 " .. python_bench .. "wifi_pad.py", "wifi-pad")
    end)
))

-- 4. PipeWire / WirePlumber Volume Pill (click -> audio_pad.py, right-click -> mute, scroll -> +/-5%)
local vol_textbox = wibox.widget {
    markup = "<span foreground='#c6f582'> --%</span>",
    widget = wibox.widget.textbox,
}
local function update_volume()
    awful.spawn.easy_async("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
        local vol_num = tonumber(stdout:match("([%d%.]+)"))
        local muted = stdout:find("MUTED", 1, true) ~= nil
        if vol_num then
            local pct = math.floor(vol_num * 100 + 0.5)
            if muted then
                vol_textbox.markup = string.format("<span foreground='#ff4343' weight='bold'> %d%%</span>", pct)
            else
                vol_textbox.markup = string.format("<span foreground='#c6f582'> %d%%</span>", pct)
            end
        end
    end)
end
gears.timer {
    timeout   = 2,
    call_now  = true,
    autostart = true,
    callback  = update_volume,
}
awesome.connect_signal("volume::update", update_volume)

local vol_pill = pill_container(vol_textbox, "#16281a")
vol_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("python3 " .. python_bench .. "audio_pad.py", "audio-pad")
    end),
    awful.button({}, 3, function()
        awful.spawn.easy_async("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", function()
            update_volume()
        end)
    end),
    awful.button({}, 4, function()
        awful.spawn.easy_async("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+", function()
            update_volume()
        end)
    end),
    awful.button({}, 5, function()
        awful.spawn.easy_async("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", function()
            update_volume()
        end)
    end)
))

-- 5. Battery Pill
local bat_textbox = wibox.widget {
    markup = "<span foreground='#55f736'> 100%</span>",
    widget = wibox.widget.textbox,
}
local function update_battery()
    local cap = tonumber(read_file("/sys/class/power_supply/BAT0/capacity") or "100") or 100
    local status = read_file("/sys/class/power_supply/BAT0/status") or "Full"
    local ac = read_file("/sys/class/power_supply/AC0/online")
    local icon = ""
    local color = "#55f736"

    if status == "Charging" or ac == "1" then
        icon = ""
        color = "#d8eb34"
    elseif cap <= 20 then
        icon = ""
        color = "#ff4343"
    elseif cap <= 50 then
        icon = ""
        color = "#d8eb34"
    end
    local thresh = tonumber(read_file("/sys/class/power_supply/BAT0/charge_control_end_threshold") or "100") or 100
    local thresh_badge = ""
    if thresh < 100 then
        thresh_badge = string.format(" <span foreground='#36e385' size='small'>[%d%%]</span>", thresh)
    end
    bat_textbox.markup = string.format("<span foreground='%s'>%s %d%%</span>%s", color, icon, cap, thresh_badge)
end
gears.timer {
    timeout   = 10,
    call_now  = true,
    autostart = true,
    callback  = update_battery,
}
local bat_pill = pill_container(bat_textbox, "#142417")
bat_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.easy_async_with_shell("~/.local/bin/powerprofilesctl get", function(stdout)
            local curr = stdout:gsub("%s+", "")
            local next_prof = (curr == "power-saver") and "balanced" or "power-saver"
            awful.spawn.easy_async_with_shell("~/.local/bin/powerprofilesctl set " .. next_prof, function()
                update_battery()
                local naughty = require("naughty")
                naughty.notify({
                    title = "Power Profile",
                    text = "Mode: " .. next_prof,
                    timeout = 3,
                })
            end)
        end)
    end),
    awful.button({}, 3, function()
        awful.spawn.easy_async_with_shell("~/.local/bin/battery-threshold toggle", function(stdout)
            update_battery()
            local cap = stdout:gsub("%s+", "")
            local naughty = require("naughty")
            naughty.notify({
                title = "Battery Charge Limit",
                text = "Charge cap set to " .. cap .. "%",
                timeout = 3,
            })
        end)
    end)
))

-- 6. Clock Pill (left-click -> weather_pad.py, right-click -> zodiac_pad.py)
local mytextclock = wibox.widget.textclock("  %a %b %d   %I:%M %p ")
local clock_pill = pill_container(mytextclock, "#16281a")
clock_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("python3 " .. python_bench .. "weather_pad.py", "weather-pad")
    end),
    awful.button({}, 3, function()
        scratchpad.toggle("python3 " .. python_bench .. "zodiac_pad.py", "zodiac-pad")
    end)
))
-- }}}

-- {{{ Buttons for taglist and tasklist
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)
-- }}}

-- Create a wibox for each screen
awful.screen.connect_for_each_screen(function(s)
    -- Set screen wallpaper
    set_wallpaper(s)

    -- Tags (1 through 9)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Dedicated Special Scratchpad Tag (hidden from pager & tag switcher)
    s.scratch_tag = scratchpad.get_scratch_tag(s)

    -- Promptbox
    s.mypromptbox = awful.widget.prompt()

    -- Layoutbox
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Taglist (strictly excludes hidden scratchpad tags)
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = function(t) return not t.hide and t.name ~= "scratchpad" end,
        buttons = taglist_buttons,
    }

    -- Tasklist
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout  = {
            spacing = 4,
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    top    = 3,
                    bottom = 3,
                    left   = 4,
                    right  = 4,
                    widget = wibox.container.margin,
                },
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            id     = "background_role",
            widget = wibox.container.background,
            shape  = slime_shapes.wobbly_pill(6, 4.2),
        },
    }

    local bar_drip_height = 22
    local bar_drip_shape = slime_shapes.dripping_bar(bar_drip_height, 3.7)

    -- Create top wibar with Cairo dripping shape mask
    s.mywibox = awful.wibar({
        position = "top",
        screen   = s,
        height   = 52,
        ontop    = true,
        bg       = "#00000000",
        fg       = beautiful.fg_normal,
        shape    = bar_drip_shape,
    })

    -- Reserve 34px at the top so the longest slime drips hang organically over the top gap
    s.mywibox:struts({ top = 34, bottom = 0, left = 0, right = 0 })

    -- Add widgets to the wibar inside the Cairo-rendered slime container
    s.mywibox:setup {
        {
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 8,
                    wibox.widget {
                        pill_container(s.mytaglist),
                        left = 8,
                        widget = wibox.container.margin,
                    },
                    s.mypromptbox,
                },
                { -- Middle widget
                    s.mytasklist,
                    left = 12,
                    right = 12,
                    top = 2,
                    bottom = 2,
                    widget = wibox.container.margin,
                },
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 6,
                    cpu_pill,
                    sys_pill,
                    wifi_pill,
                    vol_pill,
                    bat_pill,
                    wibox.widget.systray(),
                    clock_pill,
                    wibox.widget {
                        s.mylayoutbox,
                        top = 2,
                        bottom = 2,
                        right = 8,
                        widget = wibox.container.margin,
                    },
                },
            },
            top    = 3,
            bottom = bar_drip_height + 1,
            widget = wibox.container.margin,
        },
        bgimage = slime_shapes.render_bar_bg(bar_drip_height, 3.7),
        widget  = wibox.container.background,
    }
end)
