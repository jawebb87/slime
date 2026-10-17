-- Laboratory White Colorscheme for Neovim (Pre-Contamination)
-- Palette: Sterile white, stark jet-black ink, clinical blueprint blue, teal, and hazard red for errors.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "lab"

local c = {
    none         = "NONE",
    bg_deep      = "#ffffff",
    bg_dark      = "#f1f5f9",
    bg_mid       = "#e2e8f0",
    bg_sel       = "#cbd5e1",
    border       = "#000000",
    fg           = "#0a0c0e",
    fg_bright    = "#000000",
    fg_muted     = "#64748b",
    fg_gutter    = "#94a3b8",
    neon_lime    = "#0a0c0e",
    bright_green = "#0f766e",
    slime_green  = "#047857",
    seafoam      = "#0284c7",
    mint         = "#1d4ed8",
    olive        = "#334155",
    toxic_yellow = "#b45309",
    acid_yellow  = "#0369a1",
    hazard_red   = "#dc2626",
    bright_red   = "#ef4444",
}

local highlights = {
    -- Core Editor UI (Transparent background to blend with Kitty lab white)
    Normal         = { fg = c.fg, bg = c.none },
    NormalNC       = { fg = c.fg, bg = c.none },
    NormalFloat    = { fg = c.fg, bg = c.bg_deep },
    FloatBorder    = { fg = c.border, bg = c.bg_deep },
    Cursor         = { fg = c.bg_deep, bg = c.fg_bright },
    CursorLine     = { bg = c.bg_dark },
    CursorColumn   = { bg = c.bg_dark },
    ColorColumn    = { bg = c.bg_dark },
    LineNr         = { fg = c.fg_gutter },
    CursorLineNr   = { fg = c.fg_bright, bold = true },
    SignColumn     = { fg = c.fg_gutter, bg = c.none },
    VertSplit      = { fg = c.border, bg = c.none },
    WinSeparator   = { fg = c.border, bg = c.none },
    StatusLine     = { fg = "#ffffff", bg = "#0a0c0e", bold = true },
    StatusLineNC   = { fg = c.fg_muted, bg = c.bg_mid },
    Pmenu          = { fg = c.fg, bg = c.bg_dark },
    PmenuSel       = { fg = "#ffffff", bg = "#0a0c0e", bold = true },
    PmenuSbar      = { bg = c.bg_mid },
    PmenuThumb     = { bg = c.fg_bright },
    Visual         = { bg = c.bg_sel },
    Search         = { fg = "#ffffff", bg = "#0284c7", bold = true },
    IncSearch      = { fg = "#ffffff", bg = "#0a0c0e", bold = true },
    CurSearch      = { fg = "#ffffff", bg = "#0a0c0e", bold = true },
    MatchParen     = { fg = "#ffffff", bg = "#0a0c0e", bold = true },
    Folded         = { fg = c.fg_muted, bg = c.bg_dark },
    FoldColumn     = { fg = c.fg_gutter, bg = c.none },
    Directory      = { fg = c.seafoam, bold = true },
    Title          = { fg = c.fg_bright, bold = true },
    NonText        = { fg = c.fg_gutter },
    SpecialKey     = { fg = c.fg_gutter },

    -- Standard Syntax (Stark Black, Blueprint Blue, Sterile Teal & Amber)
    Comment        = { fg = c.fg_muted, italic = true },
    Constant       = { fg = c.acid_yellow, bold = true },
    String         = { fg = c.bright_green },
    Character      = { fg = c.bright_green },
    Number         = { fg = c.toxic_yellow },
    Boolean        = { fg = c.toxic_yellow, bold = true },
    Float          = { fg = c.toxic_yellow },
    Identifier     = { fg = c.fg },
    Function       = { fg = c.mint, bold = true },
    Statement      = { fg = c.fg_bright, bold = true },
    Conditional    = { fg = c.fg_bright, bold = true },
    Repeat         = { fg = c.fg_bright, bold = true },
    Label          = { fg = c.seafoam },
    Operator       = { fg = c.olive },
    Keyword        = { fg = c.fg_bright, bold = true },
    PreProc        = { fg = c.seafoam },
    Include        = { fg = c.fg_bright, bold = true },
    Define         = { fg = c.seafoam },
    Macro          = { fg = c.seafoam },
    Type           = { fg = c.seafoam, bold = true },
    StorageClass   = { fg = c.olive },
    Structure      = { fg = c.seafoam },
    Typedef        = { fg = c.seafoam },
    Special        = { fg = c.toxic_yellow },
    SpecialChar    = { fg = c.acid_yellow },
    Delimiter      = { fg = c.fg },
    Todo           = { fg = "#ffffff", bg = "#0a0c0e", bold = true },

    -- Errors & Diagnostics (Stand-out Hazard Red)
    Error             = { fg = c.hazard_red, bg = c.none, bold = true },
    ErrorMsg          = { fg = c.hazard_red, bg = c.none, bold = true },
    WarningMsg        = { fg = c.toxic_yellow, bold = true },
    Exception         = { fg = c.hazard_red, bold = true },
    DiagnosticError   = { fg = c.hazard_red, bold = true },
    DiagnosticWarn    = { fg = c.toxic_yellow },
    DiagnosticInfo    = { fg = c.seafoam },
    DiagnosticHint    = { fg = c.fg_muted },
    DiagnosticUnderlineError = { sp = c.hazard_red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.toxic_yellow, undercurl = true },

    -- Diffs
    DiffAdd        = { fg = "#047857", bg = "#d1fae5" },
    DiffChange     = { fg = "#0369a1", bg = "#e0f2fe" },
    DiffDelete     = { fg = c.hazard_red, bg = "#fee2e2", bold = true },
    DiffText       = { fg = "#0a0c0e", bg = "#bae6fd", bold = true },
}

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
