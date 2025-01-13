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

vim.cmd [[
set maxmempattern=2000000
set wildignore=*/node_modules/*,*/bin/*,*/obj/*,*/packages/*,*/dist/*

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
]]
--
	-- let dotnet_errors_only = v:true
vim.cmd [[
	let dotnet_show_project_file = v:false
]]

vim.cmd [[
	let dotnet_show_project_file = v:false
]]


vim.api.nvim_create_autocmd('BufRead', {
    pattern = { "*.cs" },
    callback = function()
        vim.cmd [[
            compiler dotnet
        ]]
    end
});

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "-", "<Cmd>Oil<CR>")

vim.keymap.set("n", "<Leader>cc", ":bd<CR>")

vim.keymap.set("n", "<Leader>sw", ":set list!<CR>")
vim.keymap.set("n", "<Leader>wl", ":set wrap!<CR>")

vim.keymap.set('n', '<Leader>a{', 'a<CR>{<CR><CR>}<ESC>kcc')
vim.keymap.set('n', '<Leader>A{', 'a<CR>{<CR><CR>}<ESC>kcc')

vim.keymap.set('n', '<F5>', ':!ctags -R --languages=c\\#<CR>')
vim.keymap.set('n', '<Leader>ne', ':cnext<CR>')
vim.keymap.set('n', '<Leader>pe', ':cprev<CR>')
vim.keymap.set('n', '<Leader>se', ':copen<CR>')
vim.keymap.set('n', '<Leader>b', ':wa | make<CR>')


vim.g.loc = "sqlserver://localhost"
vim.keymap.set('v', '<Leader>ev', ':DB g:loc<CR>')
vim.keymap.set('n', '<Leader>ef', function() 
    return ':DB g:loc < ' .. vim.fn.expand("%") ..'<CR>'
end, { expr = true })
