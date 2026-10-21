-- Sketchbook: warm paper, graphite and watercolor accents.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "sketchbook"

local c = {
    none          = "NONE",
    bg_deep       = "#faf4e7",
    bg_dark       = "#f6efdf",
    bg_mid        = "#e9dfcd",
    bg_sel        = "#d2e6de",
    border        = "#276c67",
    fg            = "#343b39",
    fg_bright     = "#273331",
    fg_muted      = "#686b60",
    fg_gutter     = "#686b60",
    neon_pink     = "#276c67",
    bright_pink   = "#276c67",
    neon_lime     = "#486d45",
    bright_lime   = "#486d45",
    electric_cyan = "#2b666f",
    bright_cyan   = "#2b666f",
    cyber_yellow  = "#86591f",
    bright_yellow = "#86591f",
    royal_purple  = "#79506f",
    alert_red     = "#994b58",
}

local highlights = {
    -- Core Editor UI (Transparent background to blend with Kitty light background)
    Normal         = { fg = c.fg, bg = c.bg_deep },
    NormalNC       = { fg = c.fg, bg = c.bg_deep },
    NormalFloat    = { fg = c.fg, bg = c.bg_deep },
    FloatBorder    = { fg = c.border, bg = c.bg_deep },
    Cursor         = { fg = c.bg_deep, bg = c.bright_pink },
    CursorLine     = { bg = c.bg_dark },
    CursorColumn   = { bg = c.bg_dark },
    ColorColumn    = { bg = c.bg_dark },
    LineNr         = { fg = c.fg_gutter },
    CursorLineNr   = { fg = c.neon_pink, bold = true },
    SignColumn     = { fg = c.fg_gutter, bg = c.bg_deep },
    VertSplit      = { fg = c.bg_mid, bg = c.bg_deep },
    WinSeparator   = { fg = c.bg_mid, bg = c.bg_deep },
    StatusLine     = { fg = "#faf4e7", bg = c.bright_pink, bold = true },
    StatusLineNC   = { fg = c.fg_muted, bg = c.bg_mid },
    Pmenu          = { fg = c.fg, bg = c.bg_dark },
    PmenuSel       = { fg = "#faf4e7", bg = c.bright_pink, bold = true },
    PmenuSbar      = { bg = c.bg_mid },
    PmenuThumb     = { bg = c.bright_pink },
    Visual         = { bg = c.bg_sel },
    Search         = { fg = "#faf4e7", bg = c.electric_cyan, bold = true },
    IncSearch      = { fg = "#faf4e7", bg = c.bright_pink, bold = true },
    CurSearch      = { fg = "#faf4e7", bg = c.bright_pink, bold = true },
    MatchParen     = { fg = "#faf4e7", bg = c.bright_pink, bold = true },
    Folded         = { fg = c.fg_muted, bg = c.bg_dark },
    FoldColumn     = { fg = c.fg_gutter, bg = c.bg_deep },
    Directory      = { fg = c.electric_cyan, bold = true },
    Title          = { fg = c.neon_pink, bold = true },
    NonText        = { fg = c.fg_gutter },
    SpecialKey     = { fg = c.fg_gutter },

    -- Standard Syntax
    Comment        = { fg = c.fg_muted, italic = true },
    Constant       = { fg = c.cyber_yellow, bold = true },
    String         = { fg = c.neon_lime },
    Character      = { fg = c.neon_lime },
    Number         = { fg = c.cyber_yellow },
    Boolean        = { fg = c.cyber_yellow, bold = true },
    Float          = { fg = c.cyber_yellow },
    Identifier     = { fg = c.fg },
    Function       = { fg = c.royal_purple, bold = true },
    Statement      = { fg = c.neon_pink, bold = true },
    Conditional    = { fg = c.neon_pink, bold = true },
    Repeat         = { fg = c.neon_pink, bold = true },
    Label          = { fg = c.electric_cyan },
    Operator       = { fg = c.royal_purple },
    Keyword        = { fg = c.neon_pink, bold = true },
    PreProc        = { fg = c.royal_purple },
    Include        = { fg = c.neon_pink, bold = true },
    Define         = { fg = c.royal_purple },
    Macro          = { fg = c.royal_purple },
    Type           = { fg = c.electric_cyan, bold = true },
    StorageClass   = { fg = c.royal_purple },
    Structure      = { fg = c.electric_cyan },
    Typedef        = { fg = c.electric_cyan },
    Special        = { fg = c.neon_pink },
    SpecialChar    = { fg = c.cyber_yellow },
    Delimiter      = { fg = c.fg },
    Todo           = { fg = "#faf4e7", bg = c.bright_pink, bold = true },

    -- Errors & Diagnostics
    Error             = { fg = c.alert_red, bg = c.bg_deep, bold = true },
    ErrorMsg          = { fg = c.alert_red, bg = c.bg_deep, bold = true },
    WarningMsg        = { fg = c.cyber_yellow, bold = true },
    Exception         = { fg = c.alert_red, bold = true },
    DiagnosticError   = { fg = c.alert_red, bold = true },
    DiagnosticWarn    = { fg = c.cyber_yellow },
    DiagnosticInfo    = { fg = c.electric_cyan },
    DiagnosticHint    = { fg = c.fg_muted },
    DiagnosticUnderlineError = { sp = c.alert_red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.cyber_yellow, undercurl = true },

    -- Diffs
    DiffAdd        = { fg = "#486d45", bg = "#d1fae5" },
    DiffChange     = { fg = "#2b666f", bg = "#e0f2fe" },
    DiffDelete     = { fg = c.alert_red, bg = "#fee2e2", bold = true },
    DiffText       = { fg = "#343b39", bg = "#d2e6de", bold = true },
}

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
