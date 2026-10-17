-- Cyberpunk Future Colorscheme for Neovim (Bio-Grid Cyberdeck)
-- Palette: Obsidian #090812, Electric Purple #a855f7, Neon Violet #7928ca,
--          Acid Cyan #00f0ff, Hot Magenta #ff007f, and Toxic Slime #55f736 power accents.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "cyber"

local c = {
    none            = "NONE",
    bg_deep         = "#090812",
    bg_dark         = "#161326",
    bg_mid          = "#1f1a36",
    bg_sel          = "#2d234e",
    border          = "#7928ca",
    fg              = "#e0d8f6",
    fg_bright       = "#ffffff",
    fg_muted        = "#6e5f9e",
    fg_gutter       = "#4c3f78",
    electric_purple = "#a855f7",
    neon_violet     = "#7928ca",
    acid_cyan       = "#00f0ff",
    hot_magenta     = "#ff007f",
    toxic_slime     = "#55f736",
    bright_slime    = "#74ff2e",
}

local highlights = {
    -- Core Editor UI (Transparent background to blend with Kitty blur)
    Normal         = { fg = c.fg, bg = c.none },
    NormalNC       = { fg = c.fg, bg = c.none },
    NormalFloat    = { fg = c.fg, bg = c.bg_dark },
    FloatBorder    = { fg = c.electric_purple, bg = c.bg_dark },
    Cursor         = { fg = c.bg_deep, bg = c.acid_cyan },
    CursorLine     = { bg = c.bg_dark },
    CursorColumn   = { bg = c.bg_dark },
    ColorColumn    = { bg = c.bg_dark },
    LineNr         = { fg = c.fg_gutter },
    CursorLineNr   = { fg = c.acid_cyan, bold = true },
    SignColumn     = { fg = c.fg_gutter, bg = c.none },
    VertSplit      = { fg = c.border, bg = c.none },
    WinSeparator   = { fg = c.border, bg = c.none },
    StatusLine     = { fg = c.fg_bright, bg = c.bg_dark, bold = true },
    StatusLineNC   = { fg = c.fg_muted, bg = "#120f24" },
    Pmenu          = { fg = c.fg, bg = c.bg_dark },
    PmenuSel       = { fg = c.bg_deep, bg = c.acid_cyan, bold = true },
    PmenuSbar      = { bg = c.bg_mid },
    PmenuThumb     = { bg = c.electric_purple },
    Visual         = { bg = c.bg_sel },
    Search         = { fg = c.bg_deep, bg = c.acid_cyan, bold = true },
    IncSearch      = { fg = c.bg_deep, bg = c.toxic_slime, bold = true },
    CurSearch      = { fg = c.bg_deep, bg = c.toxic_slime, bold = true },
    MatchParen     = { fg = c.toxic_slime, bg = c.bg_sel, bold = true },
    Folded         = { fg = c.fg_muted, bg = c.bg_dark },
    FoldColumn     = { fg = c.fg_gutter, bg = c.none },
    Directory      = { fg = c.acid_cyan, bold = true },
    Title          = { fg = c.electric_purple, bold = true },
    NonText        = { fg = c.fg_gutter },
    SpecialKey     = { fg = c.fg_gutter },

    -- Standard Syntax
    Comment        = { fg = c.fg_muted, italic = true },
    Constant       = { fg = c.toxic_slime },
    String         = { fg = c.acid_cyan },
    Character      = { fg = c.acid_cyan },
    Number         = { fg = c.toxic_slime },
    Boolean        = { fg = c.toxic_slime, bold = true },
    Float          = { fg = c.toxic_slime },
    Identifier     = { fg = c.fg },
    Function       = { fg = c.toxic_slime, bold = true },
    Statement      = { fg = c.electric_purple, bold = true },
    Conditional    = { fg = c.electric_purple, bold = true },
    Repeat         = { fg = c.electric_purple, bold = true },
    Label          = { fg = c.acid_cyan },
    Operator       = { fg = c.acid_cyan },
    Keyword        = { fg = c.electric_purple, bold = true },
    PreProc        = { fg = c.neon_violet },
    Include        = { fg = c.electric_purple },
    Define         = { fg = c.neon_violet },
    Macro          = { fg = c.neon_violet },
    Type           = { fg = c.acid_cyan, bold = true },
    StorageClass   = { fg = c.electric_purple },
    Structure      = { fg = c.acid_cyan },
    Typedef        = { fg = c.acid_cyan },
    Special        = { fg = c.hot_magenta },
    SpecialChar    = { fg = c.toxic_slime },
    Delimiter      = { fg = c.fg },
    Todo           = { fg = c.bg_deep, bg = c.toxic_slime, bold = true },

    -- Errors, Warnings & Breakpoints (Hot Magenta #ff007f)
    Error             = { fg = c.hot_magenta, bg = c.none, bold = true },
    ErrorMsg          = { fg = c.hot_magenta, bg = c.none, bold = true },
    WarningMsg        = { fg = c.hot_magenta, bold = true },
    Exception         = { fg = c.hot_magenta, bold = true },
    DiagnosticError   = { fg = c.hot_magenta, bold = true },
    DiagnosticWarn    = { fg = c.hot_magenta },
    DiagnosticInfo    = { fg = c.acid_cyan },
    DiagnosticHint    = { fg = c.toxic_slime },
    DiagnosticUnderlineError = { sp = c.hot_magenta, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.hot_magenta, undercurl = true },

    -- Diffs (Toxic Slime additions, Electric Purple changes, Hot Magenta deletions)
    DiffAdd        = { fg = c.toxic_slime, bg = "#0f2418" },
    DiffChange     = { fg = c.acid_cyan, bg = "#161326" },
    DiffDelete     = { fg = c.hot_magenta, bg = "#2a091d", bold = true },
    DiffText       = { fg = c.electric_purple, bg = "#2d234e", bold = true },
}

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
