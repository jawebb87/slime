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

    -- Any client that starts fullscreen should never tile, have no borders, and no titlebars
    { rule = { fullscreen = true },
      properties = {
          border_width = 0,
          titlebars_enabled = false,
          raise = true,
      }
    },

    -- Fullscreen games, Wine / Proton applications, launchers & emulators
    { rule_any = {
        class = {
            "^steam_app_",
            "steam_app_%d+",
            ".*%.exe$",
            ".*%.EXE$",
            "Wine",
            "wine",
            "gamescope",
            "retroarch",
            "RetroArch",
            "rpcs3",
            "RPCS3",
            "pcsx2",
            "PCSX2",
            "dolphin%-emu",
            "Dolphin",
            "yuzu",
            "Yuzu",
            "ryujinx",
            "Ryujinx",
            "cemu",
            "Cemu",
            "dosbox",
            "DOSBox",
            "scummvm",
            "ScummVM",
            "duckstation.*",
            "DuckStation",
            "ppsspp.*",
            "PPSSPP.*",
            "mame",
            "MAME",
            "itch",
            "Minecraft.*",
            "net%-runelite%-client%-RuneLite",
            "SuperTuxKart",
            "supertuxkart",
            "osu!",
            "GZDoom",
            "gzdoom",
        },
        instance = {
            "^steam_app_",
            "steam_app_%d+",
            ".*%.exe$",
            ".*%.EXE$",
            "wine",
            "Wine",
            "gamescope",
            "retroarch",
            "RetroArch",
        },
      },
      properties = {
          floating = true,
          fullscreen = true,
          size_hints_honor = false,
          titlebars_enabled = false,
          border_width = 0,
          raise = true,
          focus = true,
      }
    },

    -- Game launchers and setup/dialog windows should float instead of going fullscreen
    { rule_any = {
        type = { "dialog" },
        role = { "dialog", "Setup", "Config" },
        name = { "Setup", "Config", "Settings", "Configuration", "Launch Option.*" },
      },
      properties = {
          floating = true,
          fullscreen = false,
          titlebars_enabled = true,
          placement = awful.placement.centered,
      }
    },

    -- Steam client popups and dialogs (Friends List, Settings, Chat, etc.)
    { rule_any = {
        class = { "Steam", "steam" },
      },
      except_any = {
        name = { "Steam" },
      },
      properties = {
          floating = true,
          size_hints_honor = false,
      }
    },
    { rule = { class = "steam", name = "^notificationtoast_" },
      properties = {
          floating = true,
          ontop = true,
          focusable = false,
          border_width = 0,
          titlebars_enabled = false,
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

    -- Python GUI Dropdowns (Audio, Wifi, Clipboard, Weather, Emoji, etc.)
    { rule_any = {
        name = {
            "audio-pad", "wifi-pad", "clip-pad", "docker-pad", "emoji-pad",
            "key-cheat", "log-pad", "vim-cheat", "weather-pad", "zodiac-pad",
            "limusic-app", "limusic", "font-pad",
        },
        instance = {
            "audio-pad", "wifi-pad", "clip-pad", "docker-pad", "emoji-pad",
            "key-cheat", "log-pad", "vim-cheat", "weather-pad", "zodiac-pad",
            "limusic-app", "limusic", "font-pad",
        },
        class = {
            "Audio-pad", "Wifi-pad", "Clip-pad", "Docker-pad", "Emoji-pad",
            "Key-cheat", "Log-pad", "Vim-cheat", "Weather-pad", "Zodiac-pad",
            "limusic-app", "Limusic-app", "limusic", "Limusic", "Font-pad", "font-pad",
        },
      },
      properties = {
          floating = true,
          ontop = true,
          placement = awful.placement.centered,
      }
    },

    -- Terminal Scratchpads (Dynamically sized to >= 75% screen width x 60% screen height)
    { rule_any = {
        name = {
            "btop-float", "theme-console", "term-scratch", "notes-pad", "fzf-pad", "lazygit-pad",
            "ranger-pad", "ipython-pad", "agy-pad", "chomp-pad", "chomp-fetch-pad",
            "mothgomery-pad", "larry-pad", "larry-fetch-pad", "gill-pad", "gill-fetch-pad",
            "rable-pad", "rable-fetch-pad",
            "tov-pad", "tov-fetch-pad", "molly-pad",
            "dino-pad", "dino-fetch-pad",
            "crust-pad", "crust-fetch-pad",
            "tunes-pad", "tunes-fetch-pad",
            "mystery-pad", "mystery-fetch-pad", "scooby-pad",
            "darkwing-pad", "darkwing-fetch-pad", "duck-pad", "duck-fetch-pad",
            "tmnt-pad", "tmnt-fetch-pad", "turtle-pad", "turtle-fetch-pad",
            "muppet-pad", "muppet-fetch-pad", "babies-pad", "babies-fetch-pad",
            "jon-pad", "jon-fetch-pad", "garfield-pad", "garfield-fetch-pad",
            "bake-pad", "bake-fetch-pad", "wake-pad", "wake-fetch-pad", "weed-pad", "weed-fetch-pad", "sloth-pad", "sloth-fetch-pad",
        },
        instance = {
            "btop-float", "theme-console", "term-scratch", "notes-pad", "fzf-pad", "lazygit-pad",
            "ranger-pad", "ipython-pad", "agy-pad", "chomp-pad", "chomp-fetch-pad",
            "mothgomery-pad", "larry-pad", "larry-fetch-pad", "gill-pad", "gill-fetch-pad",
            "rable-pad", "rable-fetch-pad",
            "tov-pad", "tov-fetch-pad", "molly-pad",
            "dino-pad", "dino-fetch-pad",
            "crust-pad", "crust-fetch-pad",
            "tunes-pad", "tunes-fetch-pad",
            "mystery-pad", "mystery-fetch-pad", "scooby-pad",
            "darkwing-pad", "darkwing-fetch-pad", "duck-pad", "duck-fetch-pad",
            "tmnt-pad", "tmnt-fetch-pad", "turtle-pad", "turtle-fetch-pad",
            "muppet-pad", "muppet-fetch-pad", "babies-pad", "babies-fetch-pad",
            "jon-pad", "jon-fetch-pad", "garfield-pad", "garfield-fetch-pad",
            "bake-pad", "bake-fetch-pad", "wake-pad", "wake-fetch-pad", "weed-pad", "weed-fetch-pad", "sloth-pad", "sloth-fetch-pad",
        },
        class = {
            "Btop-float", "btop-float", "Term-scratch", "theme-console", "term-scratch", "Notes-pad", "notes-pad",
            "Fzf-pad", "fzf-pad", "Lazygit-pad", "lazygit-pad", "Ranger-pad", "ranger-pad",
            "Ipython-pad", "ipython-pad", "Agy-pad", "agy-pad",
            "Chomp-pad", "chomp-pad", "Chomp-fetch-pad", "chomp-fetch-pad",
            "Larry-pad", "larry-pad", "Larry-fetch-pad", "larry-fetch-pad",
            "Mothgomery-pad", "mothgomery-pad", "Gill-pad", "gill-pad", "Gill-fetch-pad", "gill-fetch-pad",
            "Rable-pad", "rable-pad", "Rable-fetch-pad", "rable-fetch-pad",
            "Tov-pad", "tov-pad", "Tov-fetch-pad", "tov-fetch-pad", "Molly-pad", "molly-pad",
            "Dino-pad", "dino-pad", "Dino-fetch-pad", "dino-fetch-pad",
            "Crust-pad", "crust-pad", "Crust-fetch-pad", "crust-fetch-pad",
            "Tunes-pad", "tunes-pad", "Tunes-fetch-pad", "tunes-fetch-pad",
            "Mystery-pad", "mystery-pad", "Mystery-fetch-pad", "mystery-fetch-pad", "Scooby-pad", "scooby-pad",
            "Darkwing-pad", "darkwing-pad", "Darkwing-fetch-pad", "darkwing-fetch-pad",
            "Duck-pad", "duck-pad", "Duck-fetch-pad", "duck-fetch-pad",
            "Tmnt-pad", "tmnt-pad", "Tmnt-fetch-pad", "tmnt-fetch-pad",
            "Turtle-pad", "turtle-pad", "Turtle-fetch-pad", "turtle-fetch-pad",
            "Muppet-pad", "muppet-pad", "Muppet-fetch-pad", "muppet-fetch-pad",
            "Babies-pad", "babies-pad", "Babies-fetch-pad", "babies-fetch-pad",
            "Jon-pad", "jon-pad", "Jon-fetch-pad", "jon-fetch-pad",
            "Garfield-pad", "garfield-pad", "Garfield-fetch-pad", "garfield-fetch-pad",
            "Bake-pad", "bake-pad", "Bake-fetch-pad", "bake-fetch-pad",
            "Wake-pad", "wake-pad", "Wake-fetch-pad", "wake-fetch-pad",
            "Weed-pad", "weed-pad", "Weed-fetch-pad", "weed-fetch-pad",
            "Sloth-pad", "sloth-pad", "Sloth-fetch-pad", "sloth-fetch-pad",
        },
      },
      properties = {
          floating = true,
          ontop = true,
      },
      callback = function(c)
          local s = c.screen or awful.screen.focused()
          local geo = s.workarea
          local w = math.max(c.width or 0, math.floor(geo.width * 0.75))
          local h = math.max(c.height or 0, math.floor(geo.height * 0.60))
          c:geometry({
              width  = w,
              height = h,
              x      = geo.x + math.floor((geo.width - w) / 2),
              y      = geo.y + math.floor((geo.height - h) / 2),
          })
      end
    },
}
