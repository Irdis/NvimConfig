return
{
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("everforest")
        end,
    },
    { "tpope/vim-unimpaired", },
    { "tpope/vim-fugitive" },
    { "jremmen/vim-ripgrep" },
    { "tpope/vim-surround" },
    { "tpope/vim-dadbod" },
    { 
        "Irdis/NuNvim",
        config = function()
            local config = {};
            local current_path = string.lower(vim.fn.getcwd())

            local net46 = "c:\\Distr\\NUnit.Console-3.19.0\\bin\\net462\\nunit3-console"
            local net6 = "c:\\Distr\\NUnit.Console-3.19.0\\bin\\net6.0\\nunit3-console"

            local htfs = "c:\\repo\\hazeltree\\main\\htfs"
            if current_path == htfs then
                config.nunitconsole = net46;
                vim.keymap.set('n', '<Leader>ur', ':lua require("nunvim").run_debug({ run_outside = true })<CR>')
            else
                config.nunitconsole = net6;
                vim.keymap.set('n', '<Leader>ur', ':lua require("nunvim").run_debug()<CR>')
                vim.keymap.set('n', '<Leader>ua', ':lua require("nunvim").run_debug({ run_all = true })<CR>')
            end

            require("nunvim").setup(config)
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
        dependencies = "nvim-tree/nvim-web-devicons",
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
        "vim-airline/vim-airline",
        dependencies = {
            "vim-airline/vim-airline-themes",
        }
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        config = function()
            require("fzf-lua").setup({
                defaults = {
                    formatter = "path.filename_first", -- places file name first
                },
            })
            local fzflua = require('fzf-lua')
            vim.keymap.set('n', '<leader>ff', fzflua.files, {})
            vim.keymap.set('n', '<leader>fb', fzflua.buffers, {})
            vim.keymap.set('n', '<leader>gg', fzflua.grep, {})
            vim.keymap.set('n', '<leader>gl', fzflua.live_grep, {})
            vim.keymap.set('n', '<leader>gw', fzflua.grep_cword, {})
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
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' }, 
                }, {
                    { name = 'buffer' },
                })
            })

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
                matching = { disallow_symbol_nonprefix_matching = false }
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require('lspconfig')['ts_ls'].setup({
                capabilities = capabilities
            })
        end
    }
}
