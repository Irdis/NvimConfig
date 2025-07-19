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
vim.opt.infercase = true
vim.opt.incsearch = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.pumheight = 10

vim.opt.eol = false
vim.opt.fixendofline = false

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

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.opt.listchars = { eol='¬',tab='>·',trail='~',extends='>',precedes='<',space='␣' }

vim.keymap.set('n', '<Space>', ':noh<CR>')
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<Leader>rl', 'i<Up><CR>')
vim.keymap.set('n', '<Leader>rl', 'i<Up><CR><C-\\><C-n>')

vim.keymap.set("n", "-", "<Cmd>Oil<CR>")

vim.keymap.set("n", "<Leader>cc", ":bd<CR>")
vim.keymap.set("n", "<Leader>cC", ":bd!<CR>")
vim.keymap.set("n", "<Leader>co", function()
    vim.cmd("wa");
    require("bufferline").close_others()
end, { noremap = true })

vim.keymap.set('n', '<Leader>sq', ':copen<CR>')
vim.keymap.set('n', '<Leader>b', ':wa | make<CR>')

vim.keymap.set('n', '<Leader>ca', ':lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<Leader>sh', ':lua vim.lsp.buf.hover()<CR>')
vim.keymap.set("n", "<Leader>sm", vim.diagnostic.open_float, { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>pp', ':let @p = @*<CR>')

vim.keymap.set('v', '<Leader>el', ':lua<CR>')
vim.keymap.set('n', '<Leader>el', ':%lua<CR>')

vim.keymap.set('n', '<Leader>gl', ':diffget \\2<CR>')
vim.keymap.set('n', '<Leader>gr', ':diffget \\3<CR>')

vim.keymap.set('n', '<C-q>', ':bnext<CR>')
vim.keymap.set('n', '<C-z>', ':bprev<CR>')
vim.keymap.set('n', '<C-x>', ':bd<CR>')

vim.keymap.set('n', '<Leader>ld', ':G log -2000 --all --decorate --oneline --graph --pretty=\'%h ~> %aN %as %ar%d ~> %B%-C()\'<CR>')
vim.keymap.set('n', '<Leader>lf', ':G log -2000 --all --decorate --oneline --graph --first-parent --pretty=\'%h ~> %aN %as %ar%d ~> %B%-C()\'<CR>')
vim.keymap.set('n', '<Leader>ll', ':r !git log -1 --pretty=\\%B\\%-C() --author=Novit<CR>')
vim.keymap.set('n', '<Leader>lL', ':r !git log -10 --pretty=\\%B\\%-C() --author=Novit<CR>')

vim.keymap.set('n', '<Leader>is', ':set filetype=tsql<CR>iSET ANSI_NULLS, QUOTED_IDENTIFIER ON;<CR>GO<CR><ESC>')
vim.keymap.set('n', '<Leader>il', 'iLorem Ipsum is simply dummy text of the printing and typesetting industry.<ESC>')
vim.keymap.set('n', '<Leader>iL', 'iLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<ESC>')

local grep_targets = { "", "-tcs" }
local grep_target = 1

vim.keymap.set('n', '<Leader>gt',function()
    grep_target = math.fmod(grep_target, #grep_targets) + 1
    print(grep_target .. " " .. grep_targets[grep_target])
end, { noremap = true })

vim.keymap.set('n', '<Leader>gw', function()
    local cmd = 'Rg \\b' .. vim.fn.expand('<cword>') .. '\\b';
    if grep_target ~= 1 then
        cmd = cmd .. " ".. grep_targets[grep_target]
    end
    print(cmd)
    vim.cmd(cmd)
end, { noremap = true })

vim.keymap.set('n', '<Leader>sf', function()
      vim.opt_local.foldmethod = "syntax"
end, { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "tsql" },
  callback = function()
      vim.opt_local.commentstring = "-- %s"
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(arg)
      local ts = ".ts"
      if arg.match:sub(-#ts) == ts then
          vim.keymap.set('n', '<F2>', ':!ctags -R --languages=typescript<CR>')
          vim.keymap.set('n', '<Leader>a{', 'a {<CR><CR>}<ESC>kcc')
          vim.keymap.set('n', '<Leader>A{', 'A {<CR><CR>}<ESC>kcc')
      else
          vim.keymap.set('n', '<F2>', ':!ctags -R --languages=c\\#<CR>')
          vim.keymap.set('n', '<Leader>a{', 'a<CR>{<CR><CR>}<ESC>kcc')
          vim.keymap.set('n', '<Leader>A{', 'A<CR>{<CR><CR>}<ESC>kcc')
      end
  end,
})

vim.g.spelunker_disable_auto_group = 0
vim.api.nvim_create_augroup("spelunker", { clear = true })

vim.keymap.set('n', '<Leader>sc', function()
    vim.fn["spelunker#check"]()
end, { noremap = true })

vim.keymap.set("n", "<Leader>rw", [[:%s/\s\+$//e<CR>]])

local match_id = nil
vim.api.nvim_set_hl(0, "ExtraWhitespace", { ctermbg = "red", bg = "red" })
vim.keymap.set('n', '<Leader>ew',function()
    if match_id == nil then
        match_id = vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
    else
        vim.fn.matchdelete(match_id)
        match_id = nil;
    end
end, { noremap = true })

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })


vim.keymap.set("n", "<Leader>sd", vim.diagnostic.setqflist)
vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_user_command("FixShada", function()
    local data_dir = vim.fn.stdpath("data")
    vim.cmd("!rmrf -p " .. data_dir .. "\\shada -ascii -na");
end, {})
