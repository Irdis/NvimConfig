local const = require("const")

return
{
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("everforest")
        end
    },
    { "tpope/vim-unimpaired", },
    { "tpope/vim-fugitive" },
    { "jremmen/vim-ripgrep" },
    { "tpope/vim-surround" },
    { "tpope/vim-dadbod" },
    { "kamykn/spelunker.vim" },
    { 
        "xiyaowong/transparent.nvim",
        config = function()
            vim.cmd("TransparentEnable")
        end
    },
    { 
        "lukas-reineke/virt-column.nvim",
        config = function()
            require("virt-column").setup()
        end
    },
    { 
        "echasnovski/mini.nvim", 
        version = false,
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        config = function()
            require('mini.icons').setup()
        end
    },
    { 
        "Irdis/NuNvim",
        config = function()
            local config = {};
            local current_path = string.lower(vim.fn.getcwd())

            if current_path == const.ht_main or current_path == const.ht_white then
                config.nunitconsole = const.nunit_net46;
                vim.keymap.set('n', '<Leader>ur', ':lua require("nunvim").run_debug({ run_outside = true })<CR>')
            else
                config.nunitconsole = const.nunit_net6;
                vim.keymap.set('n', '<Leader>ur', ':lua require("nunvim").run_debug()<CR>')
                vim.keymap.set('n', '<Leader>ua', ':lua require("nunvim").run_debug({ run_all = true })<CR>')
            end

            require("nunvim").setup(config)
        end
    },
    { 
        "Irdis/NoogleNvim",
        -- dir = "C:\\Projects\\NoogleNvim\\",
        -- dev = true,
        config = function()
            require("noogle").setup({})

            vim.keymap.set('n', '<Leader>nt', function()
                local cmd = 'Noogle -t ' .. vim.fn.expand('<cword>');
                print(cmd)
                vim.cmd(cmd)
            end, { noremap = true })
            vim.keymap.set('n', '<Leader>nT', function()
                local cmd = 'Noogle -i -a -t ' .. vim.fn.expand('<cword>');
                print(cmd)
                vim.cmd(cmd)
            end, { noremap = true })
            vim.keymap.set('n', '<Leader>nm', function()
                local cmd = 'Noogle -m ' .. vim.fn.expand('<cword>');
                print(cmd)
                vim.cmd(cmd)
            end, { noremap = true })
            vim.keymap.set('n', '<Leader>nM', function()
                local cmd = 'Noogle -i -a -m ' .. vim.fn.expand('<cword>');
                print(cmd)
                vim.cmd(cmd)
            end, { noremap = true })
        end
    },
    { 
        "Irdis/Startup",
        -- dir = "c:\\Repo\\hazeltree\\startup\\",
        -- dev = true,
        config = function()
            local ht = require('startup.ht')
            require("startup").setup({
                apps = ht
            })
        end
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        opts = {
            suppressed_dirs = { '~/' },
        }
    },
    { "neovim/nvim-lspconfig", },
    {
        'stevearc/oil.nvim',
        opts = {},
        config = function()
            require("oil").setup({})
        end,
    },
    {
        'jinh0/eyeliner.nvim',
        config = function()
            require('eyeliner').setup({})
            vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg='#4287f5', bold = true, underline = true,  })
            vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg='#42b4f5', underline = true, italic = true  })
        end
    },
    {
        "akinsho/bufferline.nvim",
        config = function()
            require("bufferline").setup({
                options = {
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                }
            })
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                update_focused_file = { enable = true },
                git = { enable = false },
                view = { adaptive_size = true }
            })
            local api = require('nvim-tree.api');
            vim.keymap.set('n', '<Leader>ll', api.tree.toggle, {})
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "c_sharp", "sql" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
            })
        end,
    },
    {
        "ibhagwan/fzf-lua",
        opts = {},
        config = function()
            require("fzf-lua").setup({
                defaults = {
                    formatter = "path.filename_first", -- places file name first
                    path_shorten   = 1, 
                },
            })
            local fzflua = require('fzf-lua')
            vim.keymap.set('n', '<leader>ff', fzflua.files, {})
            vim.keymap.set('n', '<leader>fb', fzflua.buffers, {})
            vim.keymap.set('n', '<leader>gg', fzflua.grep, {})
            vim.keymap.set('n', '<leader>gl', fzflua.live_grep, {})
        end
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            local lspconfig = require("lspconfig");
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers({
                function (server_name)
                    lspconfig[server_name].setup({})
                end
            })
        end,
    }
}
