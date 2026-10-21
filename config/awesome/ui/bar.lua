local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("config.apps")
local scratchpad = require("config.scratchpad")
local slime_shapes = require("theme.slime_shapes")

local modkey = apps.modkey
local python_bench = os.getenv("HOME") .. "/Projects/qtile_bench/"
local P = beautiful.palette or {}
local use_label_telemetry = (beautiful.telemetry_style == "label")

-- {{{ Wallpaper
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    else
        gears.wallpaper.set(beautiful.bg_normal or "#0c140d", s)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Helper: Mode-aware pill widget wrapper
local pill_seed = 1.1

local function resolve_pill_shape(seed)
    local fn = beautiful.pill_shape_fn
    if type(fn) ~= "function" then
        return function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end
    end
    local ok, res = pcall(fn, seed)
    if ok and type(res) == "function" then
        return res
    end
    return fn
end

local function pill_container(widget, bg_color, fg_color)
    if beautiful.pill_wrapper then
        return beautiful.pill_wrapper(widget, bg_color, fg_color, P)
    end
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
        bg                 = bg_color or P.pill_bg1,
        fg                 = fg_color or P.pill_fg,
        shape              = resolve_pill_shape(pill_seed),
        shape_border_width = P.pill_bw or 1,
        shape_border_color = P.pill_bdr or beautiful.border_focus or "#55f736",
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
local cpu_textbox = beautiful.cpu_meter_widget and beautiful.cpu_meter_widget() or wibox.widget {
    markup = string.format("<span foreground='%s'> 0%%</span>", P.cpu),
    widget = wibox.widget.textbox,
}
local cpu_detail = "CPU: waiting for telemetry"
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
        cpu_detail = string.format("CPU: %d%%%s", usage, temp_str)
        if cpu_textbox.set_value then cpu_textbox:set_value(usage) end
        if use_label_telemetry or beautiful.bar_compact then
            cpu_textbox.markup = string.format(
                "<span foreground='%s' weight='bold'>CPU</span>  <span foreground='%s'>%d%%</span>",
                P.cpu or "#39ff14", P.pill_fg or "#f0f4f8", usage
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
        scratchpad.toggle("alacritty --class btop-float,btop-float -T btop-float -e btop", "btop-float", true)
    end)
))

awful.tooltip { objects = {cpu_pill}, timer_function = function() return cpu_detail end }

-- 2. GPU Temp + RAM + Disk Pill (click -> btop)
local sys_textbox = beautiful.memory_meter_widget and beautiful.memory_meter_widget() or wibox.widget {
    markup = string.format("<span foreground='%s'> --G</span>", P.sys),
    widget = wibox.widget.textbox,
}
local sys_detail = "System: waiting for telemetry"
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
                if sys_textbox.set_value and total > 0 then
                    sys_textbox:set_value((total - avail) / total * 100)
                end
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
        sys_detail = gpu_str .. ram_str .. disk_free_str
        if use_label_telemetry or beautiful.bar_compact then
            sys_textbox.markup = string.format(
                "<span foreground='%s' weight='bold'>MEM</span>  <span foreground='%s'>%.1fG</span>",
                P.cpu or "#39ff14", P.pill_fg or "#f0f4f8", used_gb
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
        scratchpad.toggle("alacritty --class btop-float,btop-float -T btop-float -e btop", "btop-float", true)
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
                if use_label_telemetry or beautiful.bar_compact then
                    local net_str = (net_type == "wifi" and conn and conn ~= "") and "ONLINE" or (net_type == "ethernet" and "ETH" or "OFFLINE")
                    local col = (net_str == "OFFLINE") and (P.net_off or "#ffb000") or (P.net_ok or "#39ff14")
                    wifi_textbox.markup = string.format("<span foreground='%s' weight='bold'>NET</span>  <span foreground='%s'>%s</span>", col, P.pill_fg or "#f0f4f8", net_str)
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
            if use_label_telemetry or beautiful.bar_compact then
                local col = muted and (P.vol_mute or "#ffb000") or (P.vol_ok or "#39ff14")
                local txt = muted and "MUTE" or string.format("%d%%", pct)
                vol_textbox.markup = string.format("<span foreground='%s' weight='bold'>VOL</span>  <span foreground='%s'>%s</span>", col, P.pill_fg or "#f0f4f8", txt)
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
    if use_label_telemetry or beautiful.bar_compact then
        local col = (cap <= 20) and (P.bat_crit or "#ff0055") or ((cap <= 50) and (P.bat_warn or "#ffb000") or (P.bat_ok or "#39ff14"))
        bat_textbox.markup = string.format("<span foreground='%s' weight='bold'>BAT</span>  <span foreground='%s'>%d%%%s</span>", col, P.pill_fg or "#f0f4f8", cap, (status == "Charging" or ac == "1") and " " or "")
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

awful.tooltip { objects = {sys_pill}, timer_function = function() return sys_detail end }

-- 6. Clock Pill (left-click -> weather_pad.py, right-click -> zodiac_pad.py)
local mytextclock = beautiful.clock_widget and beautiful.clock_widget() or
    wibox.widget.textclock(beautiful.clock_format or "  %a %b %d   %I:%M %p ")
if beautiful.clock_font then mytextclock.font = beautiful.clock_font end
local clock_pill = pill_container(mytextclock, P.pill_bg2)
awful.tooltip { objects = {clock_pill}, timer_function = function() return os.date("%A, %B %d, %Y") end }
if beautiful.telemetry_font then
    for _, textbox in ipairs({cpu_textbox, sys_textbox, wifi_textbox,
                               vol_textbox, bat_textbox}) do
        textbox.font = beautiful.telemetry_font
    end
end
if beautiful.clock_scoreboard then
    clock_pill.bg = "#101613"
    clock_pill.fg = "#9cdb45"
    clock_pill.shape_border_width = 1
    clock_pill.shape_border_color = "#617568"
end
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

    -- Tags
    local tag_names = beautiful.tag_names or { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    awful.tag(tag_names, s, awful.layout.layouts[1])
    for _, t in ipairs(s.tags) do
        t.gap = beautiful.useless_gap or 6
    end

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
        screen          = s,
        filter          = function(t) return not t.hide and t.name ~= "scratchpad" end,
        buttons         = taglist_buttons,
        widget_template = beautiful.taglist_template,
        layout          = beautiful.taglist_layout,
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
        widget_template = beautiful.tasklist_template or {
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
            shape              = beautiful.task_shape,
            shape_border_width = beautiful.task_border_w or 0,
            shape_border_color = beautiful.task_border_col or beautiful.border_focus or "#55f736",
        },
    }

    -- {{{ Modular Companion Widgets (Launcher Prompt Button & Mascot Pod)
    local function resolve_companion_widgets()
        local mode = beautiful.mode or "slime"
        local font = beautiful.font_family or "JetBrainsMono Nerd Font"

        local COMPANION_PROFILES = {
            chomp = {
                prompt_markup = "<span foreground='#39ff14' weight='bold'>&gt;_</span>",
                prompt_font   = (beautiful.font_family or "BigBlueTermPlus Nerd Font") .. " Bold 11",
                prompt_bg     = "#111415",
                prompt_border = "#39ff14",
                prompt_shape  = slime_shapes.chomp_widget_pod(5),
                mascot_image  = "chomp_head.png",
                mascot_bg     = "#0d2822",
                mascot_border = "#39ff14",
                mascot_shape  = slime_shapes.chomp_mascot_pod(12),
                mascot_margins = { top = 2, bottom = 2, left = 16, right = 16 },
                console       = "chomp-pad",
            },
            clay = {
                custom_prompt = function()
                    return wibox.widget {
                        {
                            {
                                {
                                    markup = "<span foreground='#2b2526' weight='bold'> 󰏚 CLAY </span>",
                                    font   = font .. " Bold 9",
                                    align  = "center",
                                    widget = wibox.widget.textbox,
                                },
                                left   = 8, right  = 8, top = 3, bottom = 3,
                                widget = wibox.container.margin,
                            },
                            bg                 = "#d1c4af",
                            shape              = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
                            shape_border_width = 1,
                            shape_border_color = "#e4dccf",
                            widget             = wibox.container.background,
                        },
                        bottom = 3,
                        widget = wibox.container.margin,
                        bg     = "#383233",
                        shape  = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 4) end,
                        widget = wibox.container.background,
                        buttons = gears.table.join(
                            awful.button({}, 1, function() awful.spawn("rofi -show drun") end)
                        ),
                    }
                end,
            },
            gill = {
                label = "GILL", icon = "󰈹 ", accent = "#00f5d4", bg = "#0c1520",
                image = "gill_head.png", console = "gill-pad",
            },
            rable = {
                label = "RABLE", icon = "󰊠 ", accent = "#ff2a85", bg = "#12101b",
                image = "rable_head.png", console = "rable-pad",
            },
            tov = {
                label = "TOV", icon = "󰈸 ", accent = "#f77f00", bg = "#1e1a1c",
                image = "tov_head.png", console = "tov-pad",
            },
            dino = {
                label = "DINO", icon = "󰈸 ", accent = "#76ff03", bg = "#16161a",
                image = "dino_head.png", console = "dino-pad",
            },
            crust = {
                label = "CRUST", icon = "󰈸 ", accent = "#f4d06f", bg = "#1a1716",
                image = "crust_head.png", console = "crust-pad",
            },
            tunes = {
                label = "TUNES", icon = "🥕 ", accent = "#d91424", bg = "#faf5eb",
                image = "tunes_head.png", console = "tunes-pad",
                mascot_bg = "#ffffffdd", mascot_border = "#d91424aa",
            },
            mystery = {
                label = "MYSTERY", icon = "🌸 ", accent = "#1cd1be", bg = "#151d28",
                image = "mystery_head.png", console = "mystery-pad",
            },
            darkwing = {
                label = "DANGEROUS", icon = "⚡ ", accent = "#00e5ff", bg = "#181029",
                image = "darkwing_head.png", console = "darkwing-pad",
            },
            tmnt = {
                label = "COWABUNGA", icon = "🐢 ", accent = "#39ff14", bg = "#131d14",
                image = "tmnt_head.png", console = "tmnt-pad",
            },
            muppet = {
                label = "DREAMS", icon = "✨ ", accent = "#ff70a6", bg = "#1f1830",
                image = "muppet_head.png", console = "muppet-pad",
            },
            jon = {
                prompt_markup = "<span foreground='#e0562e' weight='bold'>👁 [ IM//SORRY//JON ]</span>",
                accent = "#e0562e", bg = "#181211", image = "jon_head.png", console = "jon-pad",
            },
            bake = {
                prompt_markup = "<span foreground='#48b852' weight='bold'>󰌪 420 SPECIAL</span>",
                accent = "#48b852", bg = "#131a18", image = "bake_head.png", console = "bake-pad",
            },
            mothgomery = {
                label = "MOTH", icon = "󰈹 ", accent = "#e0a96d", bg = "#1c140d",
                image = "mothgomery_head.svg", console = "mothgomery-pad",
            },
        }

        local profile = COMPANION_PROFILES[mode] or {}
        local label = beautiful.companion_label or profile.label or mode:upper()
        local icon = beautiful.companion_icon or profile.icon or "󰈹 "
        local accent = beautiful.companion_accent or profile.accent or beautiful.border_focus or "#55f736"
        local bg = beautiful.companion_bg or profile.bg or beautiful.bg_normal or "#12101b"
        local image = beautiful.companion_image or profile.image
        local console = beautiful.companion_console or profile.console or (mode .. "-pad")

        -- Discover if prompt and mascot are requested
        local has_prompt = false
        if beautiful.has_prompt ~= nil then
            has_prompt = beautiful.has_prompt
        elseif beautiful["has_" .. mode .. "_prompt"] ~= nil then
            has_prompt = beautiful["has_" .. mode .. "_prompt"]
        elseif mode == "clay" and beautiful.has_clay_prompt then
            has_prompt = true
        elseif beautiful.has_gill_prompt then
            has_prompt = true
        elseif profile.prompt_markup or profile.custom_prompt or profile.label then
            has_prompt = (beautiful["has_" .. mode .. "_prompt"] ~= false)
        end
        if mode == "gill" and not beautiful.has_gill_prompt then has_prompt = false end

        local has_mascot = false
        if beautiful.has_mascot ~= nil then
            has_mascot = beautiful.has_mascot
        elseif beautiful["has_" .. mode .. "_mascot"] ~= nil then
            has_mascot = beautiful["has_" .. mode .. "_mascot"]
        elseif mode == "mothgomery" and beautiful.has_gill_mascot then
            has_mascot = true
        elseif beautiful.has_gill_mascot and beautiful.companion_image then
            has_mascot = true
        elseif profile.image then
            has_mascot = (beautiful["has_" .. mode .. "_mascot"] ~= false)
        end
        if mode == "gill" and not beautiful.has_gill_mascot then has_mascot = false end

        local prompt_btn = nil
        if has_prompt then
            if profile.custom_prompt then
                prompt_btn = profile.custom_prompt()
            else
                local markup = profile.prompt_markup or
                               ("<span foreground='" .. accent .. "' weight='bold'>" .. icon .. label .. "</span>")
                local p_font = profile.prompt_font or (font .. " Bold 10")
                local p_shape = profile.prompt_shape or function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 6) end
                local p_bg = profile.prompt_bg or bg
                local p_border = profile.prompt_border or accent

                prompt_btn = wibox.widget {
                    {
                        {
                            markup = markup,
                            font   = p_font,
                            align  = "center",
                            widget = wibox.widget.textbox,
                        },
                        left   = 10,
                        right  = 10,
                        top    = 3,
                        bottom = 3,
                        widget = wibox.container.margin,
                    },
                    bg                 = p_bg,
                    shape              = p_shape,
                    shape_border_width = 1,
                    shape_border_color = p_border,
                    widget             = wibox.container.background,
                    buttons            = gears.table.join(
                        awful.button({}, 1, function()
                            awful.spawn("rofi -show drun")
                        end)
                    ),
                }
            end
        end

        local mascot_widget = nil
        if has_mascot and image then
            local m_shape = profile.mascot_shape or function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end
            local m_bg = profile.mascot_bg or (bg .. (bg:len() <= 7 and "dd" or ""))
            local m_border = profile.mascot_border or (accent .. (accent:len() <= 7 and "aa" or ""))
            local margins = profile.mascot_margins or { top = 1, bottom = 1, left = 12, right = 12 }
            local img_path = os.getenv("HOME") .. "/.config/awesome/theme/" .. image

            mascot_widget = wibox.widget {
                {
                    {
                        image  = img_path,
                        resize = true,
                        widget = wibox.widget.imagebox,
                    },
                    top    = margins.top,
                    bottom = margins.bottom,
                    left   = margins.left,
                    right  = margins.right,
                    widget = wibox.container.margin,
                },
                shape              = m_shape,
                bg                 = m_bg,
                shape_border_width = 1,
                shape_border_color = m_border,
                widget             = wibox.container.background,
                buttons            = gears.table.join(
                    awful.button({}, 1, function()
                        scratchpad.toggle("alacritty --class " .. console .. "," .. console .. " -T " .. console .. " -e " .. os.getenv("HOME") .. "/.local/bin/" .. console, console)
                    end)
                ),
            }
        end

        return prompt_btn, mascot_widget
    end
    -- }}}

    local prompt_btn, mascot_widget = resolve_companion_widgets()

    -- Plain wibox overlays avoid awful.wibar reserving space for hidden bars.
    s.mywibox = wibox({
        screen   = s,
        height   = beautiful.bar_height or 36,
        ontop    = true,
        visible  = false,
        bg       = beautiful.bar_background or "#00000000",
        fg       = beautiful.fg_normal,
        shape    = beautiful.bar_shape,
    })

    local left_widgets
    if beautiful.bar_deck_tags then
        left_widgets = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 6,
            s.mytaglist,
            s.mypromptbox,
        }
    elseif prompt_btn then
        left_widgets = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 8,
            wibox.widget {
                prompt_btn,
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
    if mascot_widget then
        middle_widget = {
            layout = wibox.layout.align.horizontal,
            s.mytasklist,
            mascot_widget,
            nil,
        }
    else
        middle_widget = {
            s.mytasklist,
            left = 12,
            right = 12,
            top = 2,
            bottom = beautiful.tasklist_margin_bottom or 2,
            widget = wibox.container.margin,
        }
    end

    local systray_container
    if beautiful.bar_invisible then
        systray_container = pill_container(wibox.widget.systray(), P.pill_bg1)
    else
        systray_container = wibox.widget.systray()
    end

    local layoutbox_container
    if beautiful.bar_invisible then
        layoutbox_container = wibox.widget {
            pill_container(s.mylayoutbox, P.pill_bg2),
            right = 8,
            widget = wibox.container.margin,
        }
    else
        layoutbox_container = wibox.widget {
            s.mylayoutbox,
            top = 2,
            bottom = 2,
            right = 8,
            widget = wibox.container.margin,
        }
    end

    local right_widgets = {
        layout = wibox.layout.fixed.horizontal,
        spacing = 6,
    }
    -- Compact themes use short labels, but retain the same status and actions.
    table.insert(right_widgets, cpu_pill)
    table.insert(right_widgets, sys_pill)
    for _, widget in ipairs({wifi_pill, vol_pill, bat_pill, systray_container,
                              clock_pill, layoutbox_container}) do
        table.insert(right_widgets, widget)
    end

    -- Add widgets to the wibar
    local bar_bg_widget = wibox.widget {
        {
            {
                layout = wibox.layout.align.horizontal,
                left_widgets,
                middle_widget,
                right_widgets,
            },
            top    = beautiful.bar_margin_top or 3,
            bottom = beautiful.bar_margin_bottom or (beautiful.is_flat and 5 or ((beautiful.bar_drip_height or 22) + 1)),
            left   = beautiful.bar_padding_horizontal or 0,
            right  = beautiful.bar_padding_horizontal or 0,
            widget = wibox.container.margin,
        },
        bgimage = beautiful.bar_bgimage,
        widget  = wibox.container.background,
    }
    s._bar_bg_widget = bar_bg_widget
    s.mywibox:setup {
        bar_bg_widget,
        layout = wibox.layout.flex.horizontal,
    }
    s._bar_autohide = require("ui.bar_autohide").attach(s, s.mywibox, {
        floating = beautiful.bar_floating,
        height = beautiful.bar_height or 36,
        inset = beautiful.bar_inset or 20,
        offset = beautiful.bar_offset or 12,
        strip_height = require("beautiful.xresources").apply_dpi(2, s),
    })
end)



