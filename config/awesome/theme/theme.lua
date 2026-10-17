local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Start from default theme
local theme = dofile(themes_path .. "default/theme.lua")

-- ==========================================
-- Slime Theme Aesthetics
-- ==========================================

-- Typography
theme.font                     = "MartianMono Nerd Font 9"
theme.hotkeys_font             = "MartianMono Nerd Font Bold 9"
theme.hotkeys_description_font = "MartianMono Nerd Font 9"

-- Window Gaps & Borders
theme.useless_gap   = dpi(6)
theme.border_width  = dpi(2)
theme.border_normal = "#15241777"
theme.border_focus  = "#55f73677"
theme.border_marked = "#ff434399"

-- Core Color Palette (Semi-transparent murky dark slime & vibrant neon accents)
theme.bg_normal   = "#0c140df0"
theme.bg_focus    = "#1b351e"
theme.bg_urgent   = "#ff4343"
theme.bg_minimize = "#101d12"
theme.bg_systray  = theme.bg_normal

theme.fg_normal   = "#b9e69c"
theme.fg_focus    = "#f0ffcd"
theme.fg_urgent   = "#ffffff"
theme.fg_minimize = "#476b4e"

-- Taglist Theming
theme.taglist_bg_focus    = "#1f3d23"
theme.taglist_fg_focus    = "#74ff2e"
theme.taglist_bg_urgent   = "#ff4343"
theme.taglist_fg_urgent   = "#ffffff"
theme.taglist_bg_occupied = "#101d12"
theme.taglist_fg_occupied = "#c6f582"
theme.taglist_bg_empty    = "#0c140df0"
theme.taglist_fg_empty    = "#3a563f"

-- Tasklist Theming
theme.tasklist_bg_normal   = "#0c140df0"
theme.tasklist_fg_normal   = "#98c481"
theme.tasklist_bg_focus    = "#1c3820"
theme.tasklist_fg_focus    = "#64f830"
theme.tasklist_bg_urgent   = "#ff4343"
theme.tasklist_fg_urgent   = "#ffffff"
theme.tasklist_bg_minimize = "#101a11"
theme.tasklist_fg_minimize = "#476b4e"

-- Context Menu Theming
theme.menu_bg_normal    = "#0c140df6"
theme.menu_bg_focus     = "#1f3f24"
theme.menu_fg_normal    = "#c6f582"
theme.menu_fg_focus     = "#f0ffcd"
theme.menu_border_color = "#396b3f"
theme.menu_border_width = dpi(2)
theme.menu_height       = dpi(26)
theme.menu_width        = dpi(140)

-- Hotkeys Popup / Help Modal
theme.hotkeys_bg              = "#0c140df6"
theme.hotkeys_fg              = "#c6f582"
theme.hotkeys_border_color    = "#55f736"
theme.hotkeys_border_width    = dpi(2)
theme.hotkeys_modifiers_fg    = "#d8eb34" -- Toxic Yellow
theme.hotkeys_label_bg        = "#1b351e"
theme.hotkeys_label_fg        = "#f0ffcd"
theme.hotkeys_group_margin    = dpi(16)

-- Titlebars
theme.titlebar_bg_normal = "#0c140d"
theme.titlebar_bg_focus  = "#152618"
theme.titlebar_fg_normal = "#6d9c74"
theme.titlebar_fg_focus  = "#c6f582"

-- Wibar Height
theme.wibar_height = dpi(28)

-- Wallpaper
theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper/slime.jpg"

return theme
