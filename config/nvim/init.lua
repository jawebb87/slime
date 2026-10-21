-- Neovim configuration shared by all desktop themes

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

-- Discover installed colorschemes instead of maintaining a second theme list.
local function apply_desktop_theme()
    local mode = "slime"
    local f = io.open(os.getenv("HOME") .. "/.config/awesome/theme_mode", "r")
    if f then
        local candidate = f:read("*all"):match("^%s*([%w_-]+)%s*$")
        f:close()
        if candidate and #vim.api.nvim_get_runtime_file("colors/" .. candidate .. ".lua", false) > 0 then
            mode = candidate
        end
    end
    if vim.g.colors_name ~= mode then
        local ok = pcall(vim.cmd.colorscheme, mode)
        if not ok then vim.cmd.colorscheme("slime") end
    end
end
apply_desktop_theme()
vim.api.nvim_create_autocmd("FocusGained", {
    group = vim.api.nvim_create_augroup("SlimeDesktopTheme", { clear = true }),
    callback = apply_desktop_theme,
})
