-- =============================================================================
-- Neovim Colorscheme: Doom (Rip & Tear / Infernal Crimson & High Contrast)
-- =============================================================================

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "red"

local c = {
    bg          = "#0e0708",
    bg_alt      = "#1c090c",
    bg_hi       = "#2e0d13",
    border      = "#8a2430",
    fg          = "#faebe8",
    fg_bright   = "#ffffff",
    crimson     = "#ff2a3f",
    scarlet     = "#ff6073",
    amber       = "#ffaa00",
    gold        = "#ffd033",
    plasma_blue = "#38bdf8",
    bfg_cyan    = "#00e5ff",
    violet      = "#e040fb",
    acid_green  = "#39ff14",
    muted       = "#ba6874",
}

local hl = vim.api.nvim_set_hl

-- Core Editor UI
hl(0, "Normal",       { fg = c.fg, bg = c.bg })
hl(0, "NormalFloat",  { fg = c.fg, bg = c.bg_alt })
hl(0, "FloatBorder",  { fg = c.crimson, bg = c.bg_alt })
hl(0, "CursorLine",   { bg = c.bg_alt })
hl(0, "CursorLineNr", { fg = c.crimson, bg = c.bg_alt, bold = true })
hl(0, "LineNr",       { fg = c.muted })
hl(0, "SignColumn",   { fg = c.muted, bg = c.bg })
hl(0, "VertSplit",    { fg = c.border, bg = c.bg })
hl(0, "WinSeparator", { fg = c.border, bg = c.bg })
hl(0, "StatusLine",   { fg = c.fg_bright, bg = c.bg_hi, bold = true })
hl(0, "StatusLineNC", { fg = c.muted, bg = c.bg_alt })
hl(0, "Pmenu",        { fg = c.fg, bg = c.bg_alt })
hl(0, "PmenuSel",     { fg = c.bg, bg = c.crimson, bold = true })
hl(0, "Visual",       { bg = "#5c141d" })
hl(0, "Search",       { fg = c.bg, bg = c.amber, bold = true })
hl(0, "IncSearch",    { fg = c.bg, bg = c.crimson, bold = true })
hl(0, "MatchParen",   { fg = c.crimson, bg = c.bg_hi, bold = true })
hl(0, "Directory",    { fg = c.plasma_blue, bold = true })
hl(0, "Title",        { fg = c.fg_bright, bold = true })
hl(0, "ErrorMsg",     { fg = c.acid_green, bold = true })
hl(0, "WarningMsg",   { fg = c.amber, bold = true })

-- Syntax Highlighting
hl(0, "Comment",      { fg = c.muted, italic = true })
hl(0, "Constant",     { fg = c.gold })
hl(0, "String",       { fg = c.amber })
hl(0, "Character",    { fg = c.amber })
hl(0, "Number",       { fg = c.gold })
hl(0, "Boolean",      { fg = c.crimson, bold = true })
hl(0, "Float",        { fg = c.gold })
hl(0, "Identifier",   { fg = c.fg })
hl(0, "Function",     { fg = c.plasma_blue, bold = true })
hl(0, "Statement",    { fg = c.crimson, bold = true })
hl(0, "Conditional",  { fg = c.crimson, bold = true })
hl(0, "Repeat",       { fg = c.crimson, bold = true })
hl(0, "Operator",     { fg = c.scarlet })
hl(0, "Keyword",      { fg = c.violet, bold = true })
hl(0, "Exception",    { fg = c.crimson, bold = true })
hl(0, "PreProc",      { fg = c.scarlet, bold = true })
hl(0, "Type",         { fg = c.bfg_cyan })
hl(0, "Special",      { fg = c.gold })
hl(0, "Delimiter",    { fg = c.muted })
hl(0, "Todo",         { fg = c.bg, bg = c.acid_green, bold = true })

-- Diagnostics
hl(0, "DiagnosticError", { fg = c.acid_green })
hl(0, "DiagnosticWarn",  { fg = c.amber })
hl(0, "DiagnosticInfo",  { fg = c.plasma_blue })
hl(0, "DiagnosticHint",  { fg = c.bfg_cyan })
