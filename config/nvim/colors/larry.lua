-- "Chomp the Haxor" / CHOMP_0x Cyber-Swamp Colorscheme for Neovim
-- High-Readability Monolithic Cyber Palette

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "chomp"

local c = {
    none        = "NONE",
    bg_deep     = "#111415",
    bg_dark     = "#0d2822",
    bg_mid      = "#17221e",
    bg_sel      = "#1d473b",
    border      = "#39ff14",
    fg          = "#e2f5ec",
    fg_bright   = "#ffffff",
    fg_muted    = "#789187",
    fg_gutter   = "#5c776c",
    toxic_green = "#39ff14",
    bright_lime = "#55ff38",
    mint_green  = "#6ee7b7",
    alert_amber = "#ffb000",
    swamp_teal  = "#0d2822",
    laser_cyan  = "#00ffcc",
    alert_red   = "#ff3b5c",
}

local highlights = {
    -- Core Editor UI
    Normal         = { fg = c.fg, bg = c.none },
    NormalNC       = { fg = c.fg, bg = c.none },
    NormalFloat    = { fg = c.fg, bg = c.bg_deep },
    FloatBorder    = { fg = c.toxic_green, bg = c.bg_deep },
    Cursor         = { fg = c.bg_deep, bg = c.toxic_green },
    CursorLine     = { bg = c.bg_mid },
    CursorColumn   = { bg = c.bg_mid },
    ColorColumn    = { bg = c.bg_mid },
    LineNr         = { fg = c.fg_gutter },
    CursorLineNr   = { fg = c.toxic_green, bold = true },
    SignColumn     = { fg = c.fg_gutter, bg = c.none },
    VertSplit      = { fg = c.bg_mid, bg = c.none },
    WinSeparator   = { fg = c.bg_mid, bg = c.none },
    StatusLine     = { fg = c.toxic_green, bg = c.bg_dark, bold = true },
    StatusLineNC   = { fg = c.fg_muted, bg = c.bg_deep },
    Pmenu          = { fg = c.fg, bg = c.bg_deep },
    PmenuSel       = { fg = c.bg_deep, bg = c.toxic_green, bold = true },
    PmenuSbar      = { bg = c.bg_mid },
    PmenuThumb     = { bg = c.toxic_green },
    Visual         = { bg = c.bg_sel },
    Search         = { fg = c.bg_deep, bg = c.alert_amber, bold = true },
    IncSearch      = { fg = c.bg_deep, bg = c.toxic_green, bold = true },
    CurSearch      = { fg = c.bg_deep, bg = c.toxic_green, bold = true },
    MatchParen     = { fg = c.toxic_green, bg = c.bg_sel, bold = true },
    Folded         = { fg = c.fg_muted, bg = c.bg_mid },
    FoldColumn     = { fg = c.fg_gutter, bg = c.none },
    Directory      = { fg = c.laser_cyan, bold = true },

    -- Standard Syntax Highlighting
    Comment        = { fg = c.fg_gutter, italic = true },
    Constant       = { fg = c.alert_amber },
    String         = { fg = c.mint_green },
    Character      = { fg = c.mint_green },
    Number         = { fg = c.laser_cyan },
    Boolean        = { fg = c.alert_amber, bold = true },
    Float          = { fg = c.laser_cyan },
    Identifier     = { fg = c.fg_bright },
    Function       = { fg = c.toxic_green, bold = true },
    Statement      = { fg = c.toxic_green, bold = true },
    Conditional    = { fg = c.toxic_green, bold = true },
    Repeat         = { fg = c.toxic_green, bold = true },
    Label          = { fg = c.alert_amber },
    Operator       = { fg = c.mint_green },
    Keyword        = { fg = c.toxic_green, bold = true },
    Exception      = { fg = c.alert_red, bold = true },
    PreProc        = { fg = c.laser_cyan },
    Include        = { fg = c.laser_cyan },
    Define         = { fg = c.laser_cyan },
    Macro          = { fg = c.laser_cyan },
    Type           = { fg = c.alert_amber, bold = true },
    StorageClass   = { fg = c.alert_amber },
    Structure      = { fg = c.alert_amber },
    Typedef        = { fg = c.alert_amber },
    Special        = { fg = c.alert_amber },
    SpecialChar    = { fg = c.toxic_green },
    Tag            = { fg = c.toxic_green },
    Delimiter      = { fg = c.fg_muted },
    SpecialComment = { fg = c.fg_muted, italic = true },
    Debug          = { fg = c.alert_red },
    Underlined     = { underline = true },
    Error          = { fg = c.alert_red, bold = true },
    Todo           = { fg = c.bg_deep, bg = c.alert_amber, bold = true },

    -- Diagnostics
    DiagnosticError = { fg = c.alert_red },
    DiagnosticWarn  = { fg = c.alert_amber },
    DiagnosticInfo  = { fg = c.laser_cyan },
    DiagnosticHint  = { fg = c.toxic_green },

    -- Git Signs
    GitSignsAdd    = { fg = c.toxic_green },
    GitSignsChange = { fg = c.laser_cyan },
    GitSignsDelete = { fg = c.alert_red },
}

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
