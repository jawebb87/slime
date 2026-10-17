-- =============================================================================
-- Neovim Colorscheme: Act 0 — The Specimen Origin / Deep Wood (origin.lua)
-- =============================================================================

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "origin"

local c = {
    bg          = "#141712", -- Deep Forest Soil
    bg_surface  = "#241e17", -- Bark & Timber
    bg_bark_hi  = "#2e261d", -- Raised Timber / Selection
    fg          = "#d8dee9", -- Spore White
    fg_muted    = "#7c8574", -- Lichen Grey-Moss
    spore       = "#9ece6a", -- Bioluminescent Spore
    moss        = "#5a784d", -- Lichen / Damp Moss
    canopy      = "#7fa96b", -- Fresh Canopy Leaf
    amber       = "#d08770", -- Weathered Amber
    honey       = "#ebcb8b", -- Golden Mycelium
    berry       = "#bf616a", -- Rust Berry
    orchid      = "#b48ead", -- Wild Forest Orchid
    dew         = "#8fbcbb", -- Morning Dew
}

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hl("Normal",       { fg = c.fg, bg = c.bg })
hl("NormalFloat",  { fg = c.fg, bg = c.bg_surface })
hl("FloatBorder",  { fg = c.spore, bg = c.bg_surface })
hl("CursorLine",   { bg = c.bg_surface })
hl("CursorLineNr", { fg = c.spore, bold = true })
hl("LineNr",       { fg = c.moss })
hl("Visual",       { bg = c.bg_bark_hi })
hl("Search",       { fg = c.bg, bg = c.spore, bold = true })
hl("IncSearch",    { fg = c.bg, bg = c.amber, bold = true })
hl("StatusLine",   { fg = c.fg, bg = c.bg_surface })
hl("StatusLineNC", { fg = c.fg_muted, bg = c.bg })
hl("WinSeparator", { fg = c.bg_surface, bg = c.bg })
hl("Pmenu",        { fg = c.fg, bg = c.bg_surface })
hl("PmenuSel",     { fg = c.bg, bg = c.spore, bold = true })
hl("MatchParen",   { fg = c.amber, bold = true, underline = true })

-- Syntax (with cursive script italics for naturalist field-journal feel)
hl("Comment",      { fg = c.fg_muted, italic = true })
hl("Constant",     { fg = c.amber })
hl("String",       { fg = c.canopy })
hl("Character",    { fg = c.canopy })
hl("Number",       { fg = c.amber })
hl("Boolean",      { fg = c.amber, bold = true })
hl("Identifier",   { fg = c.fg })
hl("Function",     { fg = c.spore, bold = true })
hl("Statement",    { fg = c.moss, bold = true, italic = true })
hl("Conditional",  { fg = c.moss, bold = true, italic = true })
hl("Repeat",       { fg = c.moss, bold = true, italic = true })
hl("Operator",     { fg = c.dew })
hl("Keyword",      { fg = c.spore, italic = true })
hl("PreProc",      { fg = c.amber })
hl("Type",         { fg = c.honey, bold = true })
hl("Special",      { fg = c.dew })
hl("Error",        { fg = c.berry, bold = true })
hl("Todo",         { fg = c.bg, bg = c.spore, bold = true })

-- Diagnostics & Git Diff
hl("DiagnosticError", { fg = c.berry })
hl("DiagnosticWarn",  { fg = c.amber })
hl("DiagnosticInfo",  { fg = c.dew })
hl("DiagnosticHint",  { fg = c.spore })
hl("DiffAdd",         { fg = c.spore, bg = "#1c2418" })
hl("DiffChange",      { fg = c.honey, bg = "#242017" })
hl("DiffDelete",      { fg = c.berry, bg = "#26181a" })
