-- 90s Neon Windbreaker Colorscheme for Neovim (Light Theme)
-- Palette: Crisp light nylon off-white, deep indigo ink, neon hot pink, electric cyan, neon lime, and solar yellow.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "windbreaker"

local c = {
    none          = "NONE",
    bg_deep       = "#ffffff",
    bg_dark       = "#f4f6fa",
    bg_mid        = "#e2e8f0",
    bg_sel        = "#ffd6ea",
    border        = "#ff007f",
    fg            = "#151324",
    fg_bright     = "#000000",
    fg_muted      = "#625c7e",
    fg_gutter     = "#94a3b8",
    neon_pink     = "#d6006c",
    bright_pink   = "#ff007f",
    neon_lime     = "#05993f",
    bright_lime   = "#10e862",
    electric_cyan = "#0077cc",
    bright_cyan   = "#00d2ff",
    cyber_yellow  = "#9e7c00",
    bright_yellow = "#ffe600",
    royal_purple  = "#7000ff",
    alert_red     = "#ff2a5f",
}

local highlights = {
    -- Core Editor UI (Transparent background to blend with Kitty light background)
    Normal         = { fg = c.fg, bg = c.none },
    NormalNC       = { fg = c.fg, bg = c.none },
    NormalFloat    = { fg = c.fg, bg = c.bg_deep },
    FloatBorder    = { fg = c.border, bg = c.bg_deep },
    Cursor         = { fg = c.bg_deep, bg = c.bright_pink },
    CursorLine     = { bg = c.bg_dark },
    CursorColumn   = { bg = c.bg_dark },
    ColorColumn    = { bg = c.bg_dark },
    LineNr         = { fg = c.fg_gutter },
    CursorLineNr   = { fg = c.neon_pink, bold = true },
    SignColumn     = { fg = c.fg_gutter, bg = c.none },
    VertSplit      = { fg = c.bg_mid, bg = c.none },
    WinSeparator   = { fg = c.bg_mid, bg = c.none },
    StatusLine     = { fg = "#ffffff", bg = c.bright_pink, bold = true },
    StatusLineNC   = { fg = c.fg_muted, bg = c.bg_mid },
    Pmenu          = { fg = c.fg, bg = c.bg_dark },
    PmenuSel       = { fg = "#ffffff", bg = c.bright_pink, bold = true },
    PmenuSbar      = { bg = c.bg_mid },
    PmenuThumb     = { bg = c.bright_pink },
    Visual         = { bg = c.bg_sel },
    Search         = { fg = "#ffffff", bg = c.electric_cyan, bold = true },
    IncSearch      = { fg = "#ffffff", bg = c.bright_pink, bold = true },
    CurSearch      = { fg = "#ffffff", bg = c.bright_pink, bold = true },
    MatchParen     = { fg = "#ffffff", bg = c.bright_pink, bold = true },
    Folded         = { fg = c.fg_muted, bg = c.bg_dark },
    FoldColumn     = { fg = c.fg_gutter, bg = c.none },
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
    Todo           = { fg = "#ffffff", bg = c.bright_pink, bold = true },

    -- Errors & Diagnostics
    Error             = { fg = c.alert_red, bg = c.none, bold = true },
    ErrorMsg          = { fg = c.alert_red, bg = c.none, bold = true },
    WarningMsg        = { fg = c.cyber_yellow, bold = true },
    Exception         = { fg = c.alert_red, bold = true },
    DiagnosticError   = { fg = c.alert_red, bold = true },
    DiagnosticWarn    = { fg = c.cyber_yellow },
    DiagnosticInfo    = { fg = c.electric_cyan },
    DiagnosticHint    = { fg = c.fg_muted },
    DiagnosticUnderlineError = { sp = c.alert_red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.cyber_yellow, undercurl = true },

    -- Diffs
    DiffAdd        = { fg = "#05993f", bg = "#d1fae5" },
    DiffChange     = { fg = "#0077cc", bg = "#e0f2fe" },
    DiffDelete     = { fg = c.alert_red, bg = "#fee2e2", bold = true },
    DiffText       = { fg = "#151324", bg = "#ffd6ea", bold = true },
}

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
