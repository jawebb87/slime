-- Slime Colorscheme for Neovim
-- Palette: Shades of radioactive green & toxic yellow; vivid red strictly for errors.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.g.colors_name = "slime"

local c = {
    none         = "NONE",
    bg_deep      = "#0c140d",
    bg_dark      = "#122015",
    bg_mid       = "#1a331e",
    bg_sel       = "#24492b",
    border       = "#396b3f",
    fg           = "#c6f582",
    fg_bright    = "#f0ffcd",
    fg_muted     = "#527a58",
    fg_gutter    = "#38573d",
    neon_lime    = "#55f736",
    bright_green = "#74ff2e",
    slime_green  = "#4ee24e",
    seafoam      = "#36e385",
    mint         = "#55ffaa",
    olive        = "#8db600",
    toxic_yellow = "#d8eb34",
    acid_yellow  = "#f3ff47",
    hazard_red   = "#ff4343",
    bright_red   = "#ff6666",
}

local highlights = {
    -- Core Editor UI (Transparent background to blend with Kitty blur)
    Normal         = { fg = c.fg, bg = c.none },
    NormalNC       = { fg = c.fg, bg = c.none },
    NormalFloat    = { fg = c.fg, bg = c.bg_dark },
    FloatBorder    = { fg = c.neon_lime, bg = c.bg_dark },
    Cursor         = { fg = c.bg_deep, bg = c.neon_lime },
    CursorLine     = { bg = c.bg_dark },
    CursorColumn   = { bg = c.bg_dark },
    ColorColumn    = { bg = c.bg_dark },
    LineNr         = { fg = c.fg_gutter },
    CursorLineNr   = { fg = c.toxic_yellow, bold = true },
    SignColumn     = { fg = c.fg_gutter, bg = c.none },
    VertSplit      = { fg = c.border, bg = c.none },
    WinSeparator   = { fg = c.border, bg = c.none },
    StatusLine     = { fg = c.fg_bright, bg = c.bg_mid, bold = true },
    StatusLineNC   = { fg = c.fg_muted, bg = c.bg_dark },
    Pmenu          = { fg = c.fg, bg = c.bg_dark },
    PmenuSel       = { fg = c.bg_deep, bg = c.neon_lime, bold = true },
    PmenuSbar      = { bg = c.bg_mid },
    PmenuThumb     = { bg = c.slime_green },
    Visual         = { bg = c.bg_sel },
    Search         = { fg = c.bg_deep, bg = c.toxic_yellow, bold = true },
    IncSearch      = { fg = c.bg_deep, bg = c.acid_yellow, bold = true },
    CurSearch      = { fg = c.bg_deep, bg = c.acid_yellow, bold = true },
    MatchParen     = { fg = c.acid_yellow, bg = c.bg_sel, bold = true },
    Folded         = { fg = c.fg_muted, bg = c.bg_dark },
    FoldColumn     = { fg = c.fg_gutter, bg = c.none },
    Directory      = { fg = c.bright_green, bold = true },
    Title          = { fg = c.toxic_yellow, bold = true },
    NonText        = { fg = c.fg_gutter },
    SpecialKey     = { fg = c.fg_gutter },

    -- Standard Syntax (Shades of Green & Yellow)
    Comment        = { fg = c.fg_muted, italic = true },
    Constant       = { fg = c.acid_yellow },
    String         = { fg = c.toxic_yellow },
    Character      = { fg = c.toxic_yellow },
    Number         = { fg = c.acid_yellow },
    Boolean        = { fg = c.acid_yellow, bold = true },
    Float          = { fg = c.acid_yellow },
    Identifier     = { fg = c.fg },
    Function       = { fg = c.bright_green, bold = true },
    Statement      = { fg = c.neon_lime, bold = true },
    Conditional    = { fg = c.neon_lime, bold = true },
    Repeat         = { fg = c.neon_lime, bold = true },
    Label          = { fg = c.toxic_yellow },
    Operator       = { fg = c.seafoam },
    Keyword        = { fg = c.neon_lime, bold = true },
    PreProc        = { fg = c.seafoam },
    Include        = { fg = c.neon_lime },
    Define         = { fg = c.seafoam },
    Macro          = { fg = c.seafoam },
    Type           = { fg = c.mint, bold = true },
    StorageClass   = { fg = c.seafoam },
    Structure      = { fg = c.mint },
    Typedef        = { fg = c.mint },
    Special        = { fg = c.toxic_yellow },
    SpecialChar    = { fg = c.acid_yellow },
    Delimiter      = { fg = c.fg },
    Todo           = { fg = c.bg_deep, bg = c.toxic_yellow, bold = true },

    -- Errors & Diagnostics (Stand-out Hazard Red!)
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
    DiffAdd        = { fg = c.neon_lime, bg = "#142b18" },
    DiffChange     = { fg = c.toxic_yellow, bg = "#242912" },
    DiffDelete     = { fg = c.hazard_red, bg = "#2b1111", bold = true },
    DiffText       = { fg = c.acid_yellow, bg = "#343b16", bold = true },
}

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
