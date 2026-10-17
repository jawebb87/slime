-- "Larry the Haxor" / LARRY_0x_MUSKRAT Cyber-Swamp Colorscheme for Neovim
-- Palette: Heavy Matte Chassis #151718, Deep Marsh Teal #0d2e27,
--          Toxic Neon Green #39ff14, Alert Amber #ffb000, and Cyber Blue-Gray #a5b4fc.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "larry"

local c = {
    none        = "NONE",
    bg_deep     = "#151718",
    bg_dark     = "#0d2e27",
    bg_mid      = "#142220",
    bg_sel      = "#1a4036",
    border      = "#39ff14",
    fg          = "#a5b4fc",
    fg_bright   = "#f0f4f8",
    fg_muted    = "#526078",
    fg_gutter   = "#1f3e37",
    toxic_green = "#39ff14",
    bright_lime = "#55ff33",
    alert_amber = "#ffb000",
    swamp_teal  = "#0d2e27",
    laser_cyan  = "#00ffcc",
    alert_red   = "#ff0055",
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
    VertSplit      = { fg = c.bg_dark, bg = c.none },
    WinSeparator   = { fg = c.bg_dark, bg = c.none },
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
    Directory      = { fg = c.toxic_green, bold = true },

    -- Standard Syntax Highlighting
    Comment        = { fg = c.fg_gutter, italic = true },
    Constant       = { fg = c.alert_amber },
    String         = { fg = c.toxic_green },
    Character      = { fg = c.toxic_green },
    Number         = { fg = c.laser_cyan },
    Boolean        = { fg = c.alert_amber, bold = true },
    Float          = { fg = c.laser_cyan },
    Identifier     = { fg = c.fg_bright },
    Function       = { fg = c.toxic_green, bold = true },
    Statement      = { fg = c.fg, bold = true },
    Conditional    = { fg = c.fg, bold = true },
    Repeat         = { fg = c.fg, bold = true },
    Label          = { fg = c.alert_amber },
    Operator       = { fg = c.toxic_green },
    Keyword        = { fg = c.fg, bold = true },
    Exception      = { fg = c.alert_red, bold = true },
    PreProc        = { fg = c.laser_cyan },
    Include        = { fg = c.toxic_green },
    Define         = { fg = c.toxic_green },
    Macro          = { fg = c.laser_cyan },
    Type           = { fg = c.laser_cyan, bold = true },
    StorageClass   = { fg = c.fg },
    Structure      = { fg = c.laser_cyan },
    Typedef        = { fg = c.laser_cyan },
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
