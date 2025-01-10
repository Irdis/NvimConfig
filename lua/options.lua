vim.opt.number = true
vim.opt.history = 200
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.clipboard = "unnamedplus"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.virtualedit = "block"

vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

vim.opt.swapfile = false
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_exec('language en_US', true)

vim.opt.signcolumn = "yes"
vim.opt.guifont = { "Fira Code", "h12" }

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "-", "<Cmd>Oil<CR>")

vim.keymap.set("n", "<Leader>cc", ":bd<CR>")


vim.cmd [[
set maxmempattern=2000000
set wildignore=*/node_modules/*,*/bin/*,*/obj/*,*/packages/*,*/dist/*
]]
