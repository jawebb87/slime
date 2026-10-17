-- Neovim Configuration - Dual Theme (Slime / Laboratory White)

-- General Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"

-- Apply active theme based on ~/.config/awesome/theme_mode
local mode = "slime"
local f = io.open(os.getenv("HOME") .. "/.config/awesome/theme_mode", "r")
if f then
    local content = f:read("*all")
    f:close()
    if content then
        content = content:gsub("%s+", "")
        if content == "origin" or content == "lab" or content == "slime" or content == "cyber" or content == "space" or content == "shred" then
            mode = content
        end
    end
end
vim.cmd.colorscheme(mode)
