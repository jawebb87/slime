local awful = require("awful")
local beautiful = require("beautiful")
local keys = require("config.keys")

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = keys.clientkeys,
          buttons = keys.clientbuttons,
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap + awful.placement.no_offscreen,
          size_hints_honor = false,
          titlebars_enabled = true,
          maximized = false,
          maximized_horizontal = false,
          maximized_vertical = false,
      }
    },

    -- Floating clients
    { rule_any = {
        instance = {
            "DTA",      -- Firefox addon DownThemAll
            "copyq",    -- Includes session name in class
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin",  -- kalarm
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting
            "Wpa_gui",
            "veromix",
            "xtightvncviewer",
            "Pavucontrol",
            "Nm-connection-editor",
        },
        name = {
            "Event Tester",  -- xev
        },
        role = {
            "AlarmWindow",    -- Thunderbird's calendar
            "ConfigManager",  -- Thunderbird's about:config
            "pop-up",         -- Chrome detached DevTools
        }
      },
      properties = { floating = true }
    },

    -- Rofi Application Launcher (floating centered on top)
    { rule = { class = "Rofi" },
      properties = {
          floating = true,
          ontop = true,
          sticky = true,
          placement = awful.placement.centered,
      }
    },

    -- Python GUI Dropdowns & Terminal Scratchpads
    { rule_any = {
        instance = {
            "audio-pad", "wifi-pad", "clip-pad", "docker-pad", "emoji-pad",
            "key-cheat", "log-pad", "vim-cheat", "weather-pad", "zodiac-pad",
            "btop-float", "term-scratch", "notes-pad", "fzf-pad", "lazygit-pad",
            "ranger-pad", "ipython-pad", "agy-pad", "limusic-app", "limusic",
            "font-pad", "chomp-pad", "chomp-fetch-pad", "larry-pad", "larry-fetch-pad",
        },
        class = {
            "Audio-pad", "Wifi-pad", "Clip-pad", "Docker-pad", "Emoji-pad",
            "Key-cheat", "Log-pad", "Vim-cheat", "Weather-pad", "Zodiac-pad",
            "Btop-float", "Term-scratch", "Notes-pad", "Fzf-pad", "Lazygit-pad",
            "Ranger-pad", "Ipython-pad", "Agy-pad", "limusic-app", "Limusic-app",
            "limusic", "Limusic", "Font-pad", "font-pad",
            "Chomp-pad", "chomp-pad", "Chomp-fetch-pad", "chomp-fetch-pad",
            "Larry-pad", "larry-pad", "Larry-fetch-pad", "larry-fetch-pad",
        },
      },
      properties = {
          floating = true,
          ontop = true,
          placement = awful.placement.centered,
      }
    },

    -- Chomp the Haxor Interactive Console Dropdown (custom dimensions)
    { rule_any = {
        instance = { "chomp-pad", "chomp-fetch-pad", "larry-pad", "larry-fetch-pad" },
        class = { "chomp-pad", "Chomp-pad", "chomp-fetch-pad", "Chomp-fetch-pad", "larry-pad", "Larry-pad", "larry-fetch-pad", "Larry-fetch-pad" },
      },
      properties = {
          floating = true,
          ontop = true,
          placement = awful.placement.centered,
          width = 920,
          height = 600,
      }
    },
}
