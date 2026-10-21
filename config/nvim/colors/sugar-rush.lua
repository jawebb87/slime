vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.o.background = "light"
vim.g.colors_name = "sugar-rush"

local c = {
    bg = "#fff1fb", surface = "#f4e3fa", selection = "#e4d5ef",
    fg = "#603575", brass = "#a33c83", copper = "#b74c85",
    patina = "#45836b", green = "#45836b", steel = "#527e97",
    muted = "#8b7197", border = "#ae8dbd", bright = "#4c285e",
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
    DiffAdd = { bg = "#e2eee6" },
    DiffChange = { bg = "#e4e8f1" },
    DiffDelete = { fg = c.copper, bg = "#f6dbe8" },
}
for group, spec in pairs(groups) do vim.api.nvim_set_hl(0, group, spec) end
