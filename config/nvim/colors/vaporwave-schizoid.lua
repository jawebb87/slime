vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.o.background = "dark"
vim.g.colors_name = "vaporwave-schizoid"

local c = {
    bg = "#110c27", surface = "#21163f", selection = "#4a276a",
    fg = "#f0ddff", brass = "#ff55c8", copper = "#ff719f",
    patina = "#61e5f5", green = "#61e5f5", steel = "#73b8ff",
    muted = "#a99bcc", border = "#68518e", bright = "#fff0fd",
}
local groups = {
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.surface },
    FloatBorder = { fg = c.brass, bg = c.surface },
    CursorLine = { bg = c.surface },
    CursorLineNr = { fg = c.brass, bold = true },
    LineNr = { fg = c.muted },
    SignColumn = { bg = c.bg },
    WinSeparator = { fg = c.border },
    StatusLine = { fg = c.brass, bg = c.surface, bold = true },
    StatusLineNC = { fg = c.muted, bg = c.bg },
    Pmenu = { fg = c.fg, bg = c.surface },
    PmenuSel = { fg = c.bg, bg = c.brass },
    Visual = { bg = c.selection },
    Search = { fg = c.bg, bg = c.brass },
    IncSearch = { fg = c.bg, bg = c.copper },
    MatchParen = { fg = c.patina, bold = true },
    Directory = { fg = c.steel },
    Title = { fg = c.brass, bold = true },
    Comment = { fg = c.muted, italic = true },
    Constant = { fg = c.copper },
    String = { fg = c.green },
    Number = { fg = c.copper },
    Boolean = { fg = c.copper, bold = true },
    Identifier = { fg = c.fg },
    Function = { fg = c.brass },
    Statement = { fg = c.brass, bold = true },
    Operator = { fg = c.patina },
    Keyword = { fg = c.brass, bold = true },
    PreProc = { fg = c.steel },
    Type = { fg = c.patina },
    Special = { fg = c.copper },
    Delimiter = { fg = c.muted },
    Todo = { fg = c.bg, bg = c.brass, bold = true },
    DiagnosticError = { fg = c.copper },
    DiagnosticWarn = { fg = c.brass },
    DiagnosticInfo = { fg = c.steel },
    DiagnosticHint = { fg = c.patina },
    DiffAdd = { bg = "#163d42" },
    DiffChange = { bg = "#303a34" },
    DiffDelete = { fg = c.copper, bg = "#402827" },
}
for group, spec in pairs(groups) do vim.api.nvim_set_hl(0, group, spec) end
