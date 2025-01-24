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
vim.opt.pumheight = 10

vim.opt.colorcolumn = "120"

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_exec('language en_US', true)

vim.opt.signcolumn = "yes"
vim.opt.guifont = { "Fira Code", "h12" }

vim.opt.foldmethod = "syntax"

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.opt.listchars = { eol='¬',tab='>·',trail='~',extends='>',precedes='<',space='␣' }

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "-", "<Cmd>Oil<CR>")

vim.keymap.set("n", "<Leader>cc", ":bd<CR>")
vim.keymap.set("n", "<Leader>cC", ":bd!<CR>")
vim.keymap.set("n", "<Leader>co", function() 
    require("bufferline").close_others()
end, { noremap = true })

vim.keymap.set("n", "<Leader>sw", ":set list!<CR>")
vim.keymap.set("n", "<Leader>wl", ":set wrap!<CR>")

vim.keymap.set('n', '<Leader>a{', 'a<CR>{<CR><CR>}<ESC>kcc')
vim.keymap.set('n', '<Leader>A{', 'a<CR>{<CR><CR>}<ESC>kcc')

vim.keymap.set('n', '<F5>', ':!ctags -R --languages=c\\#<CR>')
vim.keymap.set('n', '<Leader>ne', ':cnext<CR>')
vim.keymap.set('n', '<Leader>pe', ':cprev<CR>')
vim.keymap.set('n', '<Leader>se', ':copen<CR>')
vim.keymap.set('n', '<Leader>b', ':wa | make<CR>')

vim.keymap.set('n', '<Leader>ca', ':lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<Leader>sh', ':lua vim.lsp.buf.hover()<CR>')
vim.keymap.set("n", "<Leader>em", vim.diagnostic.open_float, { noremap = true, silent = true })

vim.g.loc = "sqlserver://localhost"
vim.keymap.set('v', '<Leader>es', ':DB g:loc<CR>')
vim.keymap.set('n', '<Leader>es', ':%DB g:loc<CR>')

vim.keymap.set('v', '<Leader>el', ':lua<CR>')
vim.keymap.set('n', '<Leader>el', ':%lua<CR>')

vim.keymap.set('n', '<Leader>gl', ':diffget \\2<CR>')
vim.keymap.set('n', '<Leader>gr', ':diffget \\3<CR>')

vim.keymap.set('n', '<Leader>gw', function()
    local cmd = 'Rg \\b' .. vim.fn.expand('<cword>') .. '\\b';
    print(cmd)
    vim.cmd(cmd)
end, { noremap = true })

vim.keymap.set('n', '<Leader>gW', function()
    local escaped = vim.fn.expand('<cWORD>')
        :gsub('%(','\\(')
        :gsub('%)','\\)')
        :gsub('%[','\\[')
        :gsub('%]','\\]')
        :gsub('%{','\\{')
        :gsub('%}','\\}')
        :gsub('%"','""')
        :gsub('%/','\\/')
        :gsub('%?','\\?')
    local cmd = 'Rg "' .. escaped .. '"';
    print(cmd)
    vim.cmd(cmd)
end, { noremap = true })

local timer = vim.loop.new_timer()
local blink = function()
    local cnt, blink_times = 0, 8

    timer:start(0, 100, vim.schedule_wrap(function()
        vim.cmd('set cursorcolumn! cursorline!')

        cnt = cnt + 1
        if cnt == blink_times then timer:stop() end
    end))
end

vim.keymap.set('n', '<Leader>cb', blink)
