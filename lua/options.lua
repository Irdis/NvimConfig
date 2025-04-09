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

vim.opt.eol = false

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        vim.opt_local.cindent = true
        vim.opt_local.cinoptions = "(s,m1,J1,j1"
    end,
})

vim.opt.colorcolumn = "120"

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_exec('language en_US', true)

vim.opt.signcolumn = "yes"
vim.opt.guifont = { "Fira Code", "h12" }

-- vim.opt.foldmethod = "syntax"

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

vim.keymap.set("n", "-", "<Cmd>Oil<CR>")

vim.keymap.set("n", "<Leader>cc", ":bd<CR>")
vim.keymap.set("n", "<Leader>cC", ":bd!<CR>")
vim.keymap.set("n", "<Leader>co", function() 
    vim.cmd("wa");
    require("bufferline").close_others()
end, { noremap = true })

vim.keymap.set('n', '<Leader>a{', 'a<CR>{<CR><CR>}<ESC>kcc')
vim.keymap.set('n', '<Leader>A{', 'a<CR>{<CR><CR>}<ESC>kcc')

vim.keymap.set('n', '<Leader>sq', ':copen<CR>')
vim.keymap.set('n', '<Leader>b', ':wa | make<CR>')

vim.keymap.set('n', '<Leader>ca', ':lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<Leader>sh', ':lua vim.lsp.buf.hover()<CR>')
vim.keymap.set("n", "<Leader>sm", vim.diagnostic.open_float, { noremap = true, silent = true })

vim.g.loc = "sqlserver://localhost"
vim.keymap.set('v', '<Leader>es', ':DB g:loc<CR>')
vim.keymap.set('n', '<Leader>es', ':%DB g:loc<CR>')

vim.keymap.set('v', '<Leader>el', ':lua<CR>')
vim.keymap.set('n', '<Leader>el', ':%lua<CR>')

vim.keymap.set('n', '<Leader>gl', ':diffget \\2<CR>')
vim.keymap.set('n', '<Leader>gr', ':diffget \\3<CR>')

vim.keymap.set('n', '<Leader>ya', ':let @+ = expand("%:p")<CR>')
vim.keymap.set('n', '<Leader>yr', ':let @+ = expand("%")<CR>')
vim.keymap.set('n', '<Leader>yp', ':let @+ = expand("%:p:h")<CR>')
vim.keymap.set('n', '<Leader>yw', ':let @+ = getcwd()<CR>')

vim.keymap.set('n', '<Leader>ld', ':G log -2000 --all --decorate --oneline --graph<CR>')
vim.keymap.set('n', '<Leader>lf', ':G log -2000 --all --decorate --oneline --graph --first-parent<CR>')

vim.keymap.set('n', '<Leader>is', ':set filetype=sql<CR>iSET ANSI_NULLS, QUOTED_IDENTIFIER ON;<CR>GO<CR><ESC>')

local grep_targets = { "", "-tcs" }
local grep_target = 1

vim.keymap.set('n', '<Leader>gt',function()
    grep_target = math.fmod(grep_target, table.getn(grep_targets)) + 1
    print(grep_target .. " " .. grep_targets[grep_target])
end, { noremap = true})

vim.keymap.set('n', '<Leader>gw', function()
    local cmd = 'Rg \\b' .. vim.fn.expand('<cword>') .. '\\b';
    if grep_target ~= 1 then
        cmd = cmd .. " ".. grep_targets[grep_target]
    end
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
    if grep_target ~= 1 then
        cmd = cmd .. " ".. grep_targets[grep_target]
    end
    local cmd = 'Rg "' .. escaped .. '"';
    print(cmd)
    vim.cmd(cmd)
end, { noremap = true })

vim.keymap.set('n', '<Leader>sf', function()
      vim.opt_local.foldmethod = "syntax"
end, { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.opt_local.commentstring = "-- %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(arg)
      local lang = nil
      if arg.match == 'typescript' then
          lang =  'typescript'
      elseif arg.match == 'csharp' then
          lang =  'c\\#'
      end
      if lang ~= nil then
          vim.keymap.set('n', '<F2>', ':!ctags -R --languages=' .. lang .. '<CR>')
      end
  end,
})

vim.g.spelunker_disable_auto_group = 0
vim.api.nvim_create_augroup("spelunker", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
  group = "spelunker",
  pattern = { "*.vim", "*.js", "*.jsx", "*.json", "*.md", "*.cs", "*.sql", "*.ts" },
  callback = function()
    vim.fn["spelunker#check"]()
  end,
})

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })


vim.keymap.set("n", "<Leader>sd", vim.diagnostic.setqflist)
vim.diagnostic.config({ virtual_text = true })
