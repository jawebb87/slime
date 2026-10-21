-- ==============================================================================
-- AwesomeWM Dynamic Theme Engine & Registry
-- ==============================================================================
-- Decouples themes into modular drop-in definitions in `~/.config/awesome/themes/`.
-- To add a new theme, simply drop `<theme_name>.lua` into `themes/` and reload.
-- ==============================================================================

local gfs = require("gears.filesystem")
local gears = require("gears")
local gcolor = require("gears.color")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- 1. Start from AwesomeWM default base theme
local themes_path = gfs.get_themes_dir()
local theme = dofile(themes_path .. "default/theme.lua")
theme.useless_gap = nil -- Clear default theme's 0 value so themes or fallbacks take effect

local config_dir = gfs.get_configuration_dir()
local themes_dir = config_dir .. "themes/"

-- 2. Dynamically scan and discover all themes in ~/.config/awesome/themes/
local available_themes = {}
local p = io.popen("find '" .. themes_dir .. "' -maxdepth 1 -name '*.lua' -not -name 'template.lua' -exec basename {} .lua \\; 2>/dev/null")
if p then
    for name in p:lines() do
        local clean = name:gsub("%s+", "")
        if clean ~= "" and not clean:match("^_") then
            table.insert(available_themes, clean)
        end
    end
    p:close()
end
local canonical = { "origin", "lab", "slime", "cyber", "space", "shred", "chomp", "red", "windbreaker", "clay", "void", "gill", "mothgomery", "rable", "tov", "dino", "crust", "tunes", "mystery", "darkwing", "tmnt", "muppet", "jon", "bake", "foundry", "sketchbook", "jaws", "bamboo-corsair", "eeyore", "halfpipe", "punk-show", "sugar-rush", "crayon-chomp", "satanic-panic", "vaporwave-schizoid", "moonlit-well", "scp-facility" }
table.sort(available_themes)
local ordered = {}
local seen = {}
for _, name in ipairs(canonical) do
    for _, t in ipairs(available_themes) do
        if t == name then
            table.insert(ordered, t)
            seen[t] = true
            break
        end
    end
end
for _, t in ipairs(available_themes) do
    if not seen[t] then
        table.insert(ordered, t)
    end
end
theme.available_themes = ordered

-- 3. Read current active mode from ~/.config/awesome/theme_mode
local mode_file = config_dir .. "theme_mode"
local mode = "slime"
do
    local f = io.open(mode_file, "r")
    if f then
        local content = f:read("*all")
        f:close()
        if content then
            local clean = content:gsub("%s+", "")
            if clean ~= "" then
                mode = clean
            end
        end
    end
end

-- 4. Locate and load the selected theme module
local theme_file = themes_dir .. mode .. ".lua"
if not gfs.file_readable(theme_file) then
    -- Fallback to slime or first available theme
    theme_file = themes_dir .. "slime.lua"
    if not gfs.file_readable(theme_file) and #available_themes > 0 then
        theme_file = themes_dir .. available_themes[1] .. ".lua"
    end
end

local ok, mode_def = pcall(dofile, theme_file)
if ok and type(mode_def) == "table" then
    for k, v in pairs(mode_def) do
        theme[k] = v
    end
    theme.mode = mode_def.name or mode
else
    theme.mode = mode
end

-- A theme may ship before its optional wallpaper asset is available.
-- Keep startup working using an installed default, or a solid background.
if type(theme.wallpaper) == "string" and not gfs.file_readable(theme.wallpaper) then
    local fallback = os.getenv("HOME") .. "/Pictures/wallpaper/slime.jpg"
    theme.wallpaper = gfs.file_readable(fallback) and fallback or nil
end

-- 5. Standard Fallbacks for any omitted properties
theme.font_family = theme.font_family or "JetBrainsMono Nerd Font"
theme.font_size   = theme.font_size or "10"
theme.font                     = theme.font_family .. " " .. theme.font_size
theme.hotkeys_font             = theme.font_family .. " Bold " .. theme.font_size
theme.hotkeys_description_font = theme.font_family .. " " .. theme.font_size
-- Window Gaps (per-theme useless_gap or gap, defaulting to dpi(6))
local raw_gap = theme.useless_gap
if raw_gap == nil and theme.gap ~= nil then
    raw_gap = theme.gap
end
if raw_gap == nil then
    theme.useless_gap = dpi(6)
elseif type(raw_gap) == "number" then
    theme.useless_gap = dpi(raw_gap)
else
    theme.useless_gap = raw_gap
end

-- Fallback Telemetry Palette
theme.palette = theme.palette or {
    cpu        = theme.fg_focus or "#55f736",
    temp_ok    = theme.fg_focus or "#55f736",
    temp_hot   = theme.border_marked or "#ff4343",
    gpu        = theme.fg_focus or "#55f736",
    sys        = theme.fg_normal or "#c6f582",
    net_ok     = theme.fg_focus or "#55f736",
    net_off    = theme.border_marked or "#ff4343",
    vol_ok     = theme.fg_normal or "#c6f582",
    vol_mute   = theme.border_marked or "#ff4343",
    bat_ok     = theme.fg_focus or "#55f736",
    bat_chg    = theme.fg_focus or "#d8eb34",
    bat_warn   = "#d8eb34",
    bat_crit   = theme.border_marked or "#ff4343",
    bat_badge  = theme.bg_focus or "#1b351e",
    pill_bg1   = theme.bg_focus or "#142417",
    pill_bg2   = theme.bg_normal or "#16281a",
    pill_fg    = theme.fg_normal or "#c6f582",
    pill_bdr   = theme.border_focus or "#55f736",
    pill_bw    = 1,
}

theme.bar_height      = theme.bar_height or dpi(36)
theme.bar_strut_top   = theme.bar_strut_top or theme.bar_height
if theme.is_flat == nil then
    theme.is_flat = (theme.bar_shape == nil)
end
theme.bar_drip_height = theme.bar_drip_height or (theme.is_flat and 0 or 22)
theme.clock_format    = theme.clock_format or "  %a %b %d   %I:%M %p "
theme.tag_names       = theme.tag_names or { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
theme.telemetry_style = theme.telemetry_style or "icon"

theme.pill_shape_fn = theme.pill_shape_fn or function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 4)
end

theme.task_shape = theme.task_shape or function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 4)
end

theme.task_border_w   = theme.task_border_w or 1
theme.task_border_col = theme.task_border_col or theme.border_focus or "#55f736"

theme.notification_shape = theme.notification_shape or function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 4)
end

-- 6. Recolor layout icons to match the active theme
local layout_color = theme.layout_color or theme.fg_focus or "#55f736"
for _, l in ipairs({
    "fairh", "fairv", "floating", "magnifier", "max", "fullscreen",
    "tilebottom", "tileleft", "tile", "tiletop", "spiral", "dwindle",
    "cornernw", "cornerne", "cornersw", "cornerse"
}) do
    local key = "layout_" .. l
    if theme[key] then
        theme[key] = gcolor.recolor_image(theme[key], layout_color)
    end
end

return theme
