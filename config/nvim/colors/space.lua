-- =============================================================================
-- Neovim Colorscheme: Act IV — Orbital Containment / Deep Space Vessel (space.lua)
-- =============================================================================

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.background = "light"
vim.g.colors_name = "space"

local c = {
    bg          = "#f5f6f9", -- Hull White
    bg_surface  = "#e1e4ea", -- Airframe Grey
    bg_select   = "#d2d7e0", -- Bulkhead Selection
    fg          = "#1b2028", -- Deep Nav Slate
    fg_muted    = "#5a6578", -- Pressurized Cabin Muted Slate
    solar_gold  = "#e59500", -- Solar Flare Gold
    seal_amber  = "#c25d00", -- Hull Seal Amber
    thruster    = "#0088cc", -- Thruster Cyan
    deep_cyan   = "#006699", -- Deep Orbit Telemetry Blue
    airlock_red = "#d32f2f", -- Airlock Red
    cryo_green  = "#0d8a52", -- Cryo-Containment Stasis Green
    violet      = "#6b46c1", -- Starlight Relay Violet
}

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hl("Normal",       { fg = c.fg, bg = c.bg })
hl("NormalFloat",  { fg = c.fg, bg = c.bg_surface })
hl("FloatBorder",  { fg = c.thruster, bg = c.bg_surface })
hl("CursorLine",   { bg = c.bg_surface })
hl("CursorLineNr", { fg = c.seal_amber, bold = true })
hl("LineNr",       { fg = c.fg_muted })
hl("Visual",       { bg = c.bg_select })
hl("Search",       { fg = c.fg, bg = "#f7d794", bold = true })
hl("IncSearch",    { fg = c.bg, bg = c.seal_amber, bold = true })
hl("StatusLine",   { fg = c.fg, bg = c.bg_surface, bold = true })
hl("StatusLineNC", { fg = c.fg_muted, bg = c.bg_surface })
hl("WinSeparator", { fg = c.bg_select, bg = c.bg })
hl("Pmenu",        { fg = c.fg, bg = c.bg_surface })
hl("PmenuSel",     { fg = c.bg, bg = c.thruster, bold = true })
hl("MatchParen",   { fg = c.airlock_red, bold = true, underline = true })

-- Syntax (Flight Navigation & Vector Telemetry)
hl("Comment",      { fg = c.fg_muted, italic = true })
hl("Constant",     { fg = c.seal_amber, bold = true })
hl("String",       { fg = c.cryo_green })
hl("Character",    { fg = c.cryo_green })
hl("Number",       { fg = c.seal_amber })
hl("Boolean",      { fg = c.seal_amber, bold = true })
hl("Identifier",   { fg = c.fg })
hl("Function",     { fg = c.thruster, bold = true })
hl("Statement",    { fg = c.deep_cyan, bold = true })
hl("Conditional",  { fg = c.deep_cyan, bold = true })
hl("Repeat",       { fg = c.deep_cyan, bold = true })
hl("Operator",     { fg = c.seal_amber })
hl("Keyword",      { fg = c.deep_cyan, bold = true })
hl("PreProc",      { fg = c.violet })
hl("Type",         { fg = c.seal_amber, bold = true })
hl("Special",      { fg = c.thruster })
hl("Error",        { fg = c.airlock_red, bold = true })
hl("Todo",         { fg = c.fg, bg = c.solar_gold, bold = true })

-- Diagnostics & Git Diff
hl("DiagnosticError", { fg = c.airlock_red })
hl("DiagnosticWarn",  { fg = c.seal_amber })
hl("DiagnosticInfo",  { fg = c.thruster })
hl("DiagnosticHint",  { fg = c.cryo_green })
hl("DiffAdd",         { fg = c.cryo_green, bg = "#e3f5ec" })
hl("DiffChange",      { fg = c.seal_amber, bg = "#fdf3e6" })
hl("DiffDelete",      { fg = c.airlock_red, bg = "#fbe9e9" })
