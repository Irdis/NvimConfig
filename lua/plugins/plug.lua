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
    {
        "goolord/alpha-nvim",
        dependencies = 'kyazdani42/nvim-web-devicons',
        config = function ()
            local screen = require("screen");
            if not screen.too_small then
                require('alpha').setup(screen)
            end
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
                default = { 'lsp', 'path', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" }
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
        -- dir = "C:\\Repo\\NuNvim\\",
        -- dev = true,
        config = function()
            local config = {};
            local current_path = string.lower(vim.fn.getcwd())

            if current_path == const.ht_main or current_path == const.ht_white then
                config.nunitconsole = const.nunit_net46;
                vim.keymap.set('n', '<Leader>ur', ':lua require("nunvim").run_debug({ run_outside = true })<CR>')
            else
                config.nunitconsole = const.nunit_net6;
                vim.keymap.set('n', '<Leader>ur', ':lua require("nunvim").run_debug({ run_outside = true })<CR>')
            end
            vim.keymap.set('n', '<Leader>ua', ':lua require("nunvim").run_debug({ run_all = true, run_outside = true })<CR>')

            require("nunvim").setup(config)
        end
    },
    {
        "Irdis/JetInspectNvim",
        -- dir = "C:\\Repo\\JetInspectNvim\\",
        -- dev = true,
        config = function()
            require("jetinspect").setup({})
        end
    },
    {
        "Irdis/NoogleNvim",
        -- dir = "C:\\Projects\\NoogleNvim\\",
        -- dev = true,
        build = function ()
            require("noogle").build()
        end,
        config = function()
            local paths = {}
            if at_work then
                paths = {
                    "C:\\Program Files\\dotnet\\shared\\Microsoft.NETCore.App\\9.0.10"
                }
            else
                paths = {
                    "C:\\Program Files\\dotnet\\shared\\Microsoft.NETCore.App\\9.0.8"
                }
            end
            require("noogle").setup({
                additional_locations = paths
            })

            vim.keymap.set('n', '<Leader>nt', function() vim.cmd('NoogleType ' .. vim.fn.expand('<cword>')) end)
            vim.keymap.set('n', '<Leader>nT', function() vim.cmd('NoogleTypeExt ' .. vim.fn.expand('<cword>')) end)
            vim.keymap.set('n', '<Leader>nm', function() vim.cmd('NoogleMethod ' .. vim.fn.expand('<cword>')) end)
            vim.keymap.set('n', '<Leader>nM', function() vim.cmd('NoogleMethodExt ' .. vim.fn.expand('<cword>')) end)
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
                    "Data Source=(local);Initial Catalog=AtlasCore;Integrated Security=SSPI;TrustServerCertificate=True;Command Timeout=120",
                    "Data Source=(local)\\s19;Initial Catalog=AtlasCore;Integrated Security=SSPI;TrustServerCertificate=True;Command Timeout=1200",
                    "Data Source=rls12;Initial Catalog=AtlasCore;Integrated Security=SSPI;TrustServerCertificate=True",
                    "Data Source=LAB-DB09\\DB02;Initial Catalog=AtlasCore;Integrated Security=SSPI;TrustServerCertificate=True"
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

            vim.keymap.set('v', '<Leader>eS', ':RSqlCmd -i<CR>')
            vim.keymap.set('n', '<Leader>eS', ':%RSqlCmd -i<CR>')
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
                columns = {
                    "icon",
                    "size",
                },
                keymaps = {
                    ['<Leader>yp'] = {
                        desc = 'Copy filepath to system clipboard',
                        callback = function ()
                            require('oil.actions').copy_entry_path.callback()
                            vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
                        end,
                    },
                    ['<Leader>ea'] = {
                        desc = 'Extract archive',
                        callback = function ()
                            require('oil.actions').copy_entry_path.callback()
                            local file_path = vim.fn.getreg(vim.v.register)
                            local folder = vim.fn.fnamemodify(file_path, ":h")
                            if string.find(file_path, " ") then
                                file_path = '"' .. file_path ..'"'
                            end
                            if string.find(folder, " ") then
                                folder = '"' .. folder ..'"'
                            end
                            local cmd = "!7z x -o" .. folder .. " " .. file_path
                            vim.cmd(cmd)
                        end,
                    },
                    ['<Leader>la'] = {
                        desc = 'List archive content',
                        callback = function ()
                            require('oil.actions').copy_entry_path.callback()
                            local file_path = vim.fn.getreg(vim.v.register)
                            if string.find(file_path, " ") then
                                file_path = '"' .. file_path ..'"'
                            end
                            local cmd = "!7z l " .. file_path
                            vim.cmd(cmd)
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
            local bufferline = require('bufferline')
            bufferline.setup({
                options = {
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                }
            })

            vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>")
            vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")
            -- vim.keymap.set("t", '<Tab>', '<C-\\><C-n>:BufferLineCycleNext<CR>')
            -- vim.keymap.set("t", "<S-Tab>", "<C-\\><C-n>:BufferLineCyclePrev<CR>")

            vim.keymap.set('n', '<Leader>pt', ':BufferLineTogglePin<CR>')
            vim.keymap.set('n', ']b', ':BufferLineMoveNext<CR>')
            vim.keymap.set('n', '[b', ':BufferLineMovePrev<CR>')

            vim.keymap.set('n', ']B', function ()
                local elements = bufferline.get_elements().elements;
                local buf = vim.api.nvim_get_current_buf();
                local target_index = -1;

                for index, item in ipairs(elements) do
                    if item.id == buf then
                        target_index = index
                    end
                end
                if target_index > 0 then
                    bufferline.cycle(#elements - target_index)
                end
            end, { noremap = true })

            vim.keymap.set('n', '[B', function ()
                local elements = bufferline.get_elements().elements;
                local buf = vim.api.nvim_get_current_buf();
                local target_index = -1;

                for index, item in ipairs(elements) do
                    if item.id == buf then
                        target_index = index
                    end
                end
                print(target_index)
                if target_index > 0 then
                    bufferline.cycle(-target_index + 1)
                end
            end, { noremap = true })

            vim.keymap.set("n", "<Leader>cl", ':BufferLineCloseLeft<CR>')
            vim.keymap.set("n", "<Leader>cr", ':BufferLineCloseRight<CR>')
            vim.keymap.set("n", "<Leader>co", ':BufferLineCloseOthers<CR>')

        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "c_sharp" },
                auto_install = true,
                highlight = {
                    enable = true,
                    -- disable = { "sql" }
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
                            ["]f"] = "@function.outer",
                        },
                        goto_previous_start = {
                            ["[a"] = "@parameter.inner",
                            ["[f"] = "@function.outer",
                        },
                    },
                },
            })
        end
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            picker = { enabled = true },
        },
        keys = {
            { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        }
    },
    {
      'dmtrKovalenko/fff.nvim',
      build = function()
        require("fff.download").download_or_build_binary()
      end,
      opts = {
          prompt = '',
          max_threads = 20,
          preview = {
              enabled = false,
          },
      },
      lazy = false,
      keys = {
        { "<Leader>ff", function() require('fff').find_files() end }
      }
    },
    {
        "ibhagwan/fzf-lua",
        opts = {},
        config = function()
            require("fzf-lua").setup({
                winopts = {
                    width = 0.95,
                    preview = {
                        hidden = true
                    }
                },
                defaults = {
                    formatter = "path.filename_first",
                    git_icons = false,
                },
            })
            local fzflua = require('fzf-lua')
            -- vim.keymap.set('n', '<leader>ff', fzflua.git_files, {})
            vim.keymap.set('n', '<leader>fF', fzflua.files, {})
            -- vim.keymap.set('n', '<leader>fb', fzflua.buffers, {})
            vim.keymap.set('n', '<leader>ft', fzflua.tags, {})
        end
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            vim.lsp.config('lua_ls', {
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
    },
    {
        "Irdis/tsql-vim-syntax",
        -- dir = "C:\\Projects\\tsql-vim-syntax",
        -- dev = true,
    },
}
