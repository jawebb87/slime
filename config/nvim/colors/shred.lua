-- =============================================================================
-- Neovim Colorscheme: Standalone — The Shredder (Gunmetal & Razor Angles)
-- Palette: Abyssal Chute (#0b0c0e), Gunmetal (#14171c), Brushed Tungsten (#4a5260),
--          Honed Razor Steel (#e2e8f0), Titanium (#8b95a5), Friction Spark (#ff2a2a / #ff5500)
-- =============================================================================

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "shred"

local c = {
    bg         = "#0b0c0e",
    bg_alt     = "#14171c",
    bg_hi      = "#1e232b",
    border     = "#4a5260",
    fg         = "#d8dee9",
    fg_bright  = "#ffffff",
    steel      = "#c8d0dc",
    titanium   = "#8b95a5",
    tungsten   = "#5c6e84",
    muted      = "#525b69",
    spark_red  = "#ff2a2a",
    spark_org  = "#ff5500",
    slag_gold  = "#ff8800",
}

local hl = vim.api.nvim_set_hl

-- Core Editor UI
hl(0, "Normal",       { fg = c.fg, bg = c.bg })
hl(0, "NormalFloat",  { fg = c.fg, bg = c.bg_alt })
hl(0, "FloatBorder",  { fg = c.steel, bg = c.bg_alt })
hl(0, "CursorLine",   { bg = c.bg_alt })
hl(0, "CursorLineNr", { fg = c.spark_red, bg = c.bg_alt, bold = true })
hl(0, "LineNr",       { fg = c.muted })
hl(0, "SignColumn",   { fg = c.muted, bg = c.bg })
hl(0, "VertSplit",    { fg = c.border, bg = c.bg })
hl(0, "WinSeparator", { fg = c.border, bg = c.bg })
hl(0, "StatusLine",   { fg = c.fg_bright, bg = c.bg_hi, bold = true })
hl(0, "StatusLineNC", { fg = c.muted, bg = c.bg_alt })
hl(0, "Pmenu",        { fg = c.fg, bg = c.bg_alt })
hl(0, "PmenuSel",     { fg = c.bg, bg = c.steel, bold = true })
hl(0, "Visual",       { bg = "#2a313d" })
hl(0, "Search",       { fg = c.bg, bg = c.spark_org, bold = true })
hl(0, "IncSearch",    { fg = c.bg, bg = c.spark_red, bold = true })
hl(0, "MatchParen",   { fg = c.spark_red, bg = c.bg_hi, bold = true })
hl(0, "Directory",    { fg = c.steel, bold = true })
hl(0, "Title",        { fg = c.fg_bright, bold = true })
hl(0, "ErrorMsg",     { fg = c.spark_red, bold = true })
hl(0, "WarningMsg",   { fg = c.spark_org, bold = true })

-- Syntax Highlighting (Stripped-Down Metallic Contrast + Spark Accents)
hl(0, "Comment",      { fg = c.muted, italic = true })
hl(0, "Constant",     { fg = c.spark_org })
hl(0, "String",       { fg = c.titanium })
hl(0, "Character",    { fg = c.titanium })
hl(0, "Number",       { fg = c.spark_org })
hl(0, "Boolean",      { fg = c.spark_red, bold = true })
hl(0, "Float",        { fg = c.spark_org })
hl(0, "Identifier",   { fg = c.fg })
hl(0, "Function",     { fg = c.fg_bright, bold = true })
hl(0, "Statement",    { fg = c.steel, bold = true })
hl(0, "Conditional",  { fg = c.steel, bold = true })
hl(0, "Repeat",       { fg = c.steel, bold = true })
hl(0, "Operator",     { fg = c.spark_red })
hl(0, "Keyword",      { fg = c.steel, bold = true })
hl(0, "Exception",    { fg = c.spark_red, bold = true })
hl(0, "PreProc",      { fg = c.tungsten, bold = true })
hl(0, "Type",         { fg = c.steel })
hl(0, "Special",      { fg = c.spark_org })
hl(0, "Delimiter",    { fg = c.titanium })
hl(0, "Todo",         { fg = c.bg, bg = c.spark_red, bold = true })

-- Diagnostics
hl(0, "DiagnosticError", { fg = c.spark_red })
hl(0, "DiagnosticWarn",  { fg = c.spark_org })
hl(0, "DiagnosticInfo",  { fg = c.steel })
hl(0, "DiagnosticHint",  { fg = c.titanium })
