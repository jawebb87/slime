local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("config.apps")
local scratchpad = require("config.scratchpad")
local slime_shapes = require("theme.slime_shapes")

local modkey = apps.modkey
local python_bench = os.getenv("HOME") .. "/Projects/qtile_bench/"
local mode = beautiful.mode or "slime"
local is_origin = (mode == "origin")
local is_lab = (mode == "lab")
local is_cyber = (mode == "cyber")
local is_space = (mode == "space")
local is_shred = (mode == "shred")
local is_chomp = (mode == "chomp" or mode == "larry")
local is_larry = is_chomp
local is_flat = (is_lab or is_cyber or is_space or is_shred or is_chomp)

-- Mode-aware telemetry color palette
local P
if is_origin then
    P = {
        cpu        = "#9ece6a",
        temp_ok    = "#5a784d",
        temp_hot   = "#d08770",
        gpu        = "#8fbcbb",
        sys        = "#d8dee9",
        net_ok     = "#9ece6a",
        net_off    = "#d08770",
        vol_ok     = "#d8dee9",
        vol_mute   = "#d08770",
        bat_ok     = "#9ece6a",
        bat_chg    = "#ebcb8b",
        bat_warn   = "#d08770",
        bat_crit   = "#bf616a",
        bat_badge  = "#5a784d",
        pill_bg1   = "#241e17",
        pill_bg2   = "#1c1914",
        pill_fg    = "#d8dee9",
        pill_bdr   = "#5a784d",
        pill_bw    = 1,
    }
elseif is_lab then
    P = {
        cpu        = "#0a0c0e",
        temp_ok    = "#0284c7",
        temp_hot   = "#dc2626",
        gpu        = "#0369a1",
        sys        = "#0a0c0e",
        net_ok     = "#0a0c0e",
        net_off    = "#dc2626",
        vol_ok     = "#0a0c0e",
        vol_mute   = "#dc2626",
        bat_ok     = "#0a0c0e",
        bat_chg    = "#0284c7",
        bat_warn   = "#b45309",
        bat_crit   = "#dc2626",
        bat_badge  = "#0284c7",
        pill_bg1   = "#ffffff",
        pill_bg2   = "#f8fafc",
        pill_fg    = "#0a0c0e",
        pill_bdr   = "#000000",
        pill_bw    = 2,
    }
elseif is_cyber then
    P = {
        cpu        = "#00f0ff",
        temp_ok    = "#a855f7",
        temp_hot   = "#ff007f",
        gpu        = "#55f736",
        sys        = "#e0d8f6",
        net_ok     = "#00f0ff",
        net_off    = "#ff007f",
        vol_ok     = "#a855f7",
        vol_mute   = "#ff007f",
        bat_ok     = "#55f736",
        bat_chg    = "#74ff2e",
        bat_warn   = "#ff007f",
        bat_crit   = "#ff007f",
        bat_badge  = "#00f0ff",
        pill_bg1   = "#161326",
        pill_bg2   = "#120f24",
        pill_fg    = "#e0d8f6",
        pill_bdr   = "#a855f7",
        pill_bw    = 1,
    }
elseif is_space then
    P = {
        cpu        = "#1b2028",
        temp_ok    = "#0088cc",
        temp_hot   = "#d32f2f",
        gpu        = "#0088cc",
        sys        = "#1b2028",
        net_ok     = "#0088cc",
        net_off    = "#d32f2f",
        vol_ok     = "#1b2028",
        vol_mute   = "#d32f2f",
        bat_ok     = "#0d8a52",
        bat_chg    = "#e59500",
        bat_warn   = "#c25d00",
        bat_crit   = "#d32f2f",
        bat_badge  = "#0088cc",
        pill_bg1   = "#f5f6f9",
        pill_bg2   = "#e1e4ea",
        pill_fg    = "#1b2028",
        pill_bdr   = "#e59500",
        pill_bw    = 1,
    }
elseif is_shred then
    P = {
        cpu        = "#e2e8f0",
        temp_ok    = "#8b95a5",
        temp_hot   = "#ff2a2a",
        gpu        = "#ff5500",
        sys        = "#c8d0dc",
        net_ok     = "#e2e8f0",
        net_off    = "#ff2a2a",
        vol_ok     = "#c8d0dc",
        vol_mute   = "#ff2a2a",
        bat_ok     = "#c8d0dc",
        bat_chg    = "#ff5500",
        bat_warn   = "#ff5500",
        bat_crit   = "#ff2a2a",
        bat_badge  = "#8b95a5",
        pill_bg1   = "#16191f",
        pill_bg2   = "#111318",
        pill_fg    = "#e2e8f0",
        pill_bdr   = "#4a5260",
        pill_bw    = 1,
    }
elseif is_chomp then
    P = {
        cpu        = "#39ff14",
        temp_ok    = "#39ff14",
        temp_hot   = "#ffb000",
        gpu        = "#39ff14",
        sys        = "#6ee7b7",
        net_ok     = "#39ff14",
        net_off    = "#ffb000",
        vol_ok     = "#39ff14",
        vol_mute   = "#ffb000",
        bat_ok     = "#39ff14",
        bat_chg    = "#39ff14",
        bat_warn   = "#ffb000",
        bat_crit   = "#ff3b5c",
        bat_badge  = "#0d2822",
        pill_bg1   = "#111415",
        pill_bg2   = "#111415",
        pill_fg    = "#e2f5ec",
        pill_bdr   = "#39ff14",
        pill_bw    = 1,
    }
else
    P = {
        cpu        = "#d8eb34",
        temp_ok    = "#d8eb34",
        temp_hot   = "#ff4343",
        gpu        = "#55ffaa",
        sys        = "#c6f582",
        net_ok     = "#74ff2e",
        net_off    = "#ff4343",
        vol_ok     = "#c6f582",
        vol_mute   = "#ff4343",
        bat_ok     = "#55f736",
        bat_chg    = "#d8eb34",
        bat_warn   = "#d8eb34",
        bat_crit   = "#ff4343",
        bat_badge  = "#36e385",
        pill_bg1   = "#142417",
        pill_bg2   = "#16281a",
        pill_fg    = beautiful.fg_normal,
        pill_bdr   = "#24492b",
        pill_bw    = 1,
    }
end

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

-- {{{ Helper: Mode-aware pill widget wrapper
local pill_seed = 1.1
local function pill_container(widget, bg_color, fg_color)
    pill_seed = pill_seed + 1.37
    local shape_fn
    if is_origin then
        shape_fn = slime_shapes.rocky_pill(6, pill_seed)
    elseif is_shred then
        shape_fn = slime_shapes.shred_pill(7, pill_seed)
    elseif is_larry then
        shape_fn = slime_shapes.larry_widget_pod(6)
    elseif is_cyber then
        shape_fn = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 2)
        end
    elseif is_lab or is_space then
        shape_fn = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 4)
        end
    else
        shape_fn = slime_shapes.wobbly_pill(7, pill_seed)
    end
    return wibox.widget {
        {
            widget,
            left   = 10,
            right  = 10,
            top    = 3,
            bottom = 3,
            widget = wibox.container.margin,
        },
        bg                 = is_lab and P.pill_bg1 or (bg_color or P.pill_bg1),
        fg                 = fg_color or P.pill_fg,
        shape              = shape_fn,
        shape_border_width = P.pill_bw,
        shape_border_color = P.pill_bdr,
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
    markup = string.format("<span foreground='%s'> 0%%</span>", P.cpu),
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
        local temp_color = P.temp_ok
        if cpu_temp_path then
            local raw = tonumber(read_file(cpu_temp_path) or "")
            if raw then
                local c = math.floor(raw / 1000 + 0.5)
                temp_str = string.format("   %d°C", c)
                if c >= 75 then
                    temp_color = P.temp_hot
                end
            end
        end
        if is_larry then
            cpu_textbox.markup = string.format(
                "<span foreground='#39ff14' weight='bold'>CPU</span>  <span foreground='#f0f4f8'>%d%%</span>",
                usage
            )
        else
            cpu_textbox.markup = string.format(
                "<span foreground='%s'> %d%%</span><span foreground='%s'>%s</span>",
                P.cpu, usage, temp_color, temp_str
            )
        end
    end,
}
local cpu_pill = pill_container(cpu_textbox, P.pill_bg1)
cpu_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("kitty --class btop-float -e btop", "btop-float")
    end)
))

-- 2. GPU Temp + RAM + Disk Pill (click -> btop)
local sys_textbox = wibox.widget {
    markup = string.format("<span foreground='%s'> --G</span>", P.sys),
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
        local used_gb = 0
        if meminfo then
            local total = tonumber(meminfo:match("MemTotal:%s+(%d+)"))
            local avail = tonumber(meminfo:match("MemAvailable:%s+(%d+)"))
            if total and avail then
                used_gb = (total - avail) / (1024 * 1024)
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
        if is_larry then
            sys_textbox.markup = string.format(
                "<span foreground='#39ff14' weight='bold'>MEM</span>  <span foreground='#f0f4f8'>%.1fG</span>",
                used_gb
            )
        else
            sys_textbox.markup = string.format(
                "<span foreground='%s'>%s</span><span foreground='%s'>%s%s</span>",
                P.gpu, gpu_str, P.sys, ram_str, disk_free_str
            )
        end
    end,
}
local sys_pill = pill_container(sys_textbox, P.pill_bg2)
sys_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("kitty --class btop-float -e btop", "btop-float")
    end)
))

-- 3. Network Status Pill (Wi-Fi or Wired Ethernet, click -> wifi_pad.py)
local wifi_textbox = wibox.widget {
    markup = string.format("<span foreground='%s'> Net</span>", P.net_ok),
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
                if is_larry then
                    local net_str = (net_type == "wifi" and conn and conn ~= "") and "ONLINE" or (net_type == "ethernet" and "ETH" or "OFFLINE")
                    local col = (net_str == "OFFLINE") and "#ffb000" or "#39ff14"
                    wifi_textbox.markup = string.format("<span foreground='%s' weight='bold'>NET</span>  <span foreground='#f0f4f8'>%s</span>", col, net_str)
                elseif net_type == "wifi" and conn and conn ~= "" then
                    wifi_textbox.markup = string.format("<span foreground='%s'> %s</span>", P.net_ok, gears.string.xml_escape(conn))
                elseif net_type == "ethernet" then
                    wifi_textbox.markup = string.format("<span foreground='%s'>󰈀 Wired</span>", P.net_ok)
                else
                    wifi_textbox.markup = string.format("<span foreground='%s'> Offline</span>", P.net_off)
                end
            end
        )
    end,
}
local wifi_pill = pill_container(wifi_textbox, P.pill_bg1)
wifi_pill:buttons(gears.table.join(
    awful.button({}, 1, function()
        scratchpad.toggle("python3 " .. python_bench .. "wifi_pad.py", "wifi-pad")
    end)
))

-- 4. PipeWire / WirePlumber Volume Pill (click -> audio_pad.py, right-click -> mute, scroll -> +/-5%)
local vol_textbox = wibox.widget {
    markup = string.format("<span foreground='%s'> --%%</span>", P.vol_ok),
    widget = wibox.widget.textbox,
}
local function update_volume()
    awful.spawn.easy_async("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
        local vol_num = tonumber(stdout:match("([%d%.]+)"))
        local muted = stdout:find("MUTED", 1, true) ~= nil
        if vol_num then
            local pct = math.floor(vol_num * 100 + 0.5)
            if is_larry then
                local col = muted and "#ffb000" or "#39ff14"
                local txt = muted and "MUTE" or string.format("%d%%", pct)
                vol_textbox.markup = string.format("<span foreground='%s' weight='bold'>VOL</span>  <span foreground='#f0f4f8'>%s</span>", col, txt)
            elseif muted then
                vol_textbox.markup = string.format("<span foreground='%s' weight='bold'> %d%%</span>", P.vol_mute, pct)
            else
                vol_textbox.markup = string.format("<span foreground='%s'> %d%%</span>", P.vol_ok, pct)
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

local vol_pill = pill_container(vol_textbox, P.pill_bg2)
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
    markup = string.format("<span foreground='%s'> 100%%</span>", P.bat_ok),
    widget = wibox.widget.textbox,
}
local function update_battery()
    local cap = tonumber(read_file("/sys/class/power_supply/BAT0/capacity") or "100") or 100
    local status = read_file("/sys/class/power_supply/BAT0/status") or "Full"
    local ac = read_file("/sys/class/power_supply/AC0/online")
    local icon = ""
    local color = P.bat_ok

    if status == "Charging" or ac == "1" then
        icon = ""
        color = P.bat_chg
    elseif cap <= 20 then
        icon = ""
        color = P.bat_crit
    elseif cap <= 50 then
        icon = ""
        color = P.bat_warn
    end
    local thresh = tonumber(read_file("/sys/class/power_supply/BAT0/charge_control_end_threshold") or "100") or 100
    local thresh_badge = ""
    if thresh < 100 then
        thresh_badge = string.format(" <span foreground='%s' size='small'>[%d%%]</span>", P.bat_badge, thresh)
    end
    if is_larry then
        local col = (cap <= 20) and "#ff0055" or ((cap <= 50) and "#ffb000" or "#39ff14")
        bat_textbox.markup = string.format("<span foreground='%s' weight='bold'>BAT</span>  <span foreground='#f0f4f8'>%d%%%s</span>", col, cap, (status == "Charging" or ac == "1") and " " or "")
    else
        bat_textbox.markup = string.format("<span foreground='%s'>%s %d%%</span>%s", color, icon, cap, thresh_badge)
    end
end
gears.timer {
    timeout   = 10,
    call_now  = true,
    autostart = true,
    callback  = update_battery,
}
local bat_pill = pill_container(bat_textbox, P.pill_bg1)
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
local mytextclock = wibox.widget.textclock(is_larry and "  %H:%M " or "  %a %b %d   %I:%M %p ")
local clock_pill = pill_container(mytextclock, P.pill_bg2)
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

    -- Tags (strictly SYS, DEV, SWAMP, ROOT, LOGS for Chomp theme)
    local tag_names = is_chomp and { "SYS", "DEV", "SWAMP", "ROOT", "LOGS" } or { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    awful.tag(tag_names, s, awful.layout.layouts[1])

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

    -- Taglist widget template for Chomp theme:
    local taglist_template = nil
    if is_chomp then
        taglist_template = {
            {
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                left   = 10,
                right  = 10,
                top    = 3,
                bottom = 3,
                widget = wibox.container.margin,
            },
            id                 = "background_role",
            widget             = wibox.container.background,
            shape              = slime_shapes.chomp_tag_wedge(8, 4),
            shape_border_width = 1,
            shape_border_color = "#39ff1444",
        }
    end

    -- Taglist (strictly excludes hidden scratchpad tags)
    s.mytaglist = awful.widget.taglist {
        screen          = s,
        filter          = function(t) return not t.hide and t.name ~= "scratchpad" end,
        buttons         = taglist_buttons,
        widget_template = taglist_template,
        layout          = is_chomp and {
            spacing = 4,
            layout  = wibox.layout.fixed.horizontal,
        } or nil,
    }

    -- Tasklist
    local task_shape
    if is_origin then
        task_shape = slime_shapes.rocky_pill(5, 4.2)
    elseif is_shred then
        task_shape = slime_shapes.shred_pill(6, 4.2)
    elseif is_chomp then
        task_shape = slime_shapes.chomp_widget_pod(6)
    elseif is_cyber then
        task_shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 2)
        end
    elseif is_lab or is_space then
        task_shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 4)
        end
    else
        task_shape = slime_shapes.wobbly_pill(6, 4.2)
    end

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
            id                 = "background_role",
            widget             = wibox.container.background,
            shape              = task_shape,
            shape_border_width = is_lab and 2 or ((is_cyber or is_origin or is_space or is_shred or is_chomp) and 1 or 0),
            shape_border_color = is_lab and "#000000" or (is_origin and "#5a784d" or (is_shred and "#4a5260" or (is_space and "#e59500" or (is_chomp and "#39ff14" or "#7928ca")))),
        },
    }

    local bar_drip_height = is_flat and 0 or (is_origin and 20 or 22)
    local bar_height      = is_flat and 36 or 52
    local bar_shape
    if is_flat then
        bar_shape = nil
    elseif is_origin then
        bar_shape = slime_shapes.rocky_bar(bar_drip_height, 4.1)
    else
        bar_shape = slime_shapes.dripping_bar(bar_drip_height, 3.7)
    end

    local bar_bgimage
    if is_origin then
        bar_bgimage = slime_shapes.render_origin_bar_bg(bar_drip_height, 4.1)
    elseif is_shred then
        bar_bgimage = slime_shapes.render_shred_bar_bg()
    elseif is_cyber then
        bar_bgimage = slime_shapes.render_cyber_bar_bg()
    elseif is_space then
        bar_bgimage = slime_shapes.render_space_bar_bg()
    elseif is_lab then
        bar_bgimage = slime_shapes.render_lab_bar_bg()
    elseif is_chomp then
        bar_bgimage = slime_shapes.render_chomp_bar_bg()
    else
        bar_bgimage = slime_shapes.render_bar_bg(bar_drip_height, 3.7)
    end

    -- Standalone Chomp widgets (Launcher Prompt >_ and Center Mascot Pod)
    local chomp_prompt_btn = nil
    local chomp_mascot_widget = nil
    if is_chomp then
        chomp_prompt_btn = wibox.widget {
            {
                {
                    markup = "<span foreground='#39ff14' weight='bold'>&gt;_</span>",
                    font   = "IosevkaTerm Nerd Font Bold 11",
                    align  = "center",
                    widget = wibox.widget.textbox,
                },
                left   = 10,
                right  = 10,
                top    = 3,
                bottom = 3,
                widget = wibox.container.margin,
            },
            bg                 = "#111415",
            shape              = slime_shapes.chomp_widget_pod(5),
            shape_border_width = 1,
            shape_border_color = "#39ff14",
            widget             = wibox.container.background,
            buttons            = gears.table.join(
                awful.button({}, 1, function()
                    awful.spawn("rofi -show drun")
                end)
            ),
        }

        chomp_mascot_widget = wibox.widget {
            {
                {
                    image  = os.getenv("HOME") .. "/.config/awesome/theme/chomp_head.png",
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                top    = 2,
                bottom = 2,
                left   = 16,
                right  = 16,
                widget = wibox.container.margin,
            },
            shape              = slime_shapes.chomp_mascot_pod(12),
            bg                 = "#0d2822",
            shape_border_width = 1,
            shape_border_color = "#39ff14",
            widget             = wibox.container.background,
            buttons            = gears.table.join(
                awful.button({}, 1, function()
                    scratchpad.toggle("kitty --class chomp-pad " .. os.getenv("HOME") .. "/.local/bin/chomp-pad", "chomp-pad")
                end)
            ),
        }
    end

    -- Create top wibar
    s.mywibox = awful.wibar({
        position = "top",
        screen   = s,
        height   = bar_height,
        ontop    = true,
        bg       = "#00000000",
        fg       = beautiful.fg_normal,
        shape    = bar_shape,
    })

    s.mywibox:struts({ top = is_flat and 36 or 34, bottom = 0, left = 0, right = 0 })

    local left_widgets
    if is_chomp then
        left_widgets = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 6,
            wibox.widget {
                chomp_prompt_btn,
                left = 6,
                widget = wibox.container.margin,
            },
            s.mytaglist,
            s.mypromptbox,
        }
    else
        left_widgets = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 8,
            wibox.widget {
                pill_container(s.mytaglist),
                left = 8,
                widget = wibox.container.margin,
            },
            s.mypromptbox,
        }
    end

    local middle_widget
    if is_chomp then
        middle_widget = {
            layout = wibox.layout.align.horizontal,
            s.mytasklist,
            chomp_mascot_widget,
            nil,
        }
    else
        middle_widget = {
            s.mytasklist,
            left = 12,
            right = 12,
            top = 2,
            bottom = 2,
            widget = wibox.container.margin,
        }
    end

    -- Add widgets to the wibar
    local bar_bg_widget = wibox.widget {
        {
            {
                layout = wibox.layout.align.horizontal,
                left_widgets,
                middle_widget,
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
            bottom = is_flat and 5 or (bar_drip_height + 1),
            widget = wibox.container.margin,
        },
        bgimage = bar_bgimage,
        widget  = wibox.container.background,
    }
    s._bar_bg_widget = bar_bg_widget
    s.mywibox:setup {
        bar_bg_widget,
        layout = wibox.layout.flex.horizontal,
    }
end)

-- In Cyberpunk mode, animate the pulsing toxic-green light across the top Wibar
-- and circling around the outside perimeter of the currently focused window.
if is_cyber then
    gears.timer {
        timeout   = 0.033,
        autostart = true,
        callback  = function()
            slime_shapes.cyber_pulse_time = (slime_shapes.cyber_pulse_time or 0) + 0.033
            for s in screen do
                if s._bar_bg_widget then
                    s._bar_bg_widget:emit_signal("widget::redraw_needed")
                end
            end
            local c = client.focus
            if c and c.valid and c._cyber_edge_widgets then
                for _, w in pairs(c._cyber_edge_widgets) do
                    w:emit_signal("widget::redraw_needed")
                end
            end
        end,
    }
elseif is_space then
    -- In Orbital Containment (space) mode:
    -- 1. Every 12s, sweep a high-speed angled solar glint across the Wibar and active window top lip (30 FPS during the ~2s sweep)
    -- 2. Continuously modulate the passive cryo-breath fog on the active window's bottom border (~5 FPS when not in solar sweep)
    local tick_count = 0
    gears.timer {
        timeout   = 0.033,
        autostart = true,
        callback  = function()
            local prev_t = slime_shapes.space_time or 0
            local next_t = prev_t + 0.033
            slime_shapes.space_time = next_t
            tick_count = tick_count + 1

            local bar_cycle = next_t % 12.0
            local prev_bar_cycle = prev_t % 12.0
            if bar_cycle < 1.75 or (prev_bar_cycle < 1.75 and bar_cycle >= 1.75) then
                for s in screen do
                    if s._bar_bg_widget then
                        s._bar_bg_widget:emit_signal("widget::redraw_needed")
                    end
                end
            end

            local c = client.focus
            if c and c.valid and c._space_edge_widgets then
                local win_cycle = (next_t - 0.35) % 12.0
                local prev_win_cycle = (prev_t - 0.35) % 12.0
                if win_cycle < 1.75 or (prev_win_cycle < 1.75 and win_cycle >= 1.75) then
                    if c._space_edge_widgets["top"] then
                        c._space_edge_widgets["top"]:emit_signal("widget::redraw_needed")
                    end
                end
                if tick_count % 6 == 0 and c._space_edge_widgets["bottom"] then
                    c._space_edge_widgets["bottom"]:emit_signal("widget::redraw_needed")
                end
            end
        end,
    }
end

