local const = require("const")
local at_work = require("env").at_work()
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
    { "Irdis/vim-dadbod" },
    {
        "goolord/alpha-nvim",
        dependencies = 'kyazdani42/nvim-web-devicons',
        config = function ()
            local screen = require("screen");
            require('alpha').setup(screen)
        end
    },
    { "kamykn/spelunker.vim" },
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },

        version = '1.*',
        opts = {
            keymap = {
                ["<C-n>"] = { "show", "select_next" },
            },

            appearance = {
                nerd_font_variant = 'Nerd Font'
            },
            cmdline = { enabled = false },
            completion = {
                documentation = { auto_show = false },
                ghost_text = { enabled = true },
                menu = { auto_show = false, },

            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" }
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
        "Irdis/RSqlCmdNvim",
        -- dir = "C:\\Repo\\RSqlCmdNvim",
        -- dev = true,
        config = function()
            local connection_strings = nil
            if at_work then
                connection_strings = {
                    "Data Source=(local);Initial Catalog=AtlasCore;Integrated Security=SSPI;TrustServerCertificate=True"
                }
            else
                connection_strings = {
                    "Data Source=(local);Integrated Security=SSPI;TrustServerCertificate=True"
                }
            end
            require("rsqlcmd").setup({
                connection_strings = connection_strings
            })
            vim.keymap.set('n', '<Leader>st', function()
                require("rsqlcmd").next_target()
            end, { noremap = true })
            vim.keymap.set('n', '<Leader>sl', function()
                require("rsqlcmd").toggle_nnl()
            end, { noremap = true })

            vim.keymap.set('v', '<Leader>es', ':RSqlCmd<CR>')
            vim.keymap.set('n', '<Leader>es', ':%RSqlCmd<CR>')
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
            require("oil").setup({
                keymaps = {
                    ['<Leader>yp'] = {
                        desc = 'Copy filepath to system clipboard',
                        callback = function ()
                            require('oil.actions').copy_entry_path.callback()
                            vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
                        end,
                    },
                },
            })
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
        "Irdis/tree-sitter-noogle",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.noogle = {
                install_info = {
                    url = "https://github.com/Irdis/tree-sitter-noogle.git",
                    -- url = "C:\\Projects\\tree-sitter-noogle",
                    files = {"src/parser.c"},
                    branch = "main",
                    generate_requires_npm = true,
                },
                filetype = "noog",
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "c_sharp", "sql" },
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "sql" }
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                        },
                        selection_modes = {
                            ['@function.outer'] = 'V',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>sa"] = "@parameter.inner",
                            ["<leader>sf"] = "@function.outer",
                        },
                        swap_previous = {
                            ["<leader>Sa"] = "@parameter.inner",
                            ["<leader>Sf"] = "@function.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]a"] = "@parameter.inner",
                        },
                        goto_previous_start = {
                            ["[a"] = "@parameter.inner",
                        },
                    },
                },
            })
        end
    },
    {
        "ibhagwan/fzf-lua",
        opts = {},
        config = function()
            require("fzf-lua").setup({
                defaults = {
                    formatter = "path.filename_first",
                    -- path_shorten = 1,
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
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })
            require("mason-lspconfig").setup({})
        end,
    }
}
