programs.neovim = {
  enable = true;
  plugins = with pkgs.vimPlugins; [

    {
      plugin = oxocarbon-nvim;
      type = "lua";
      config = ''
          vim.cmd.colorscheme("oxocarbon")
          vim.api.nvim_set_hl(0, "Normal", { bg = "#161616" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#161616" })
      '';
    }
    gruvbox-nvim
    onedark-nvim
    nightfox-nvim

    dressing-nvim
    presence-nvim
    {
      plugin = toggleterm-nvim;
      type = "lua";
      config = ''
      require('toggleterm').setup{
          size = 20,
          highlights = {
              Normal = { guibg = "#161616" },
              NormalFloat = { link = "Normal" },
              FloatBorder = { guifg = "#ee5396", guibg = "#161616" },
          },
          hide_numbers = true,
          start_in_insert = true,
          direction = "float",
          close_on_exit = true,
          float_opts = { border = "curved" },
      }
      vim.keymap.set({"n", "v", "i", "t"}, "<A-i>", function() require('toggleterm').toggle() end)
      '';
    }

    {
      plugin = mini-nvim;
      type = "lua";
      config = ''
        require('mini.basics').setup({ options = { extra_ui = true }})
        require('mini.comment').setup()
        require('mini.pairs').setup()
        require('mini.trailspace').setup()
      '';
    }

    {
      plugin = nvim-web-devicons;
      type = "lua";
      config = ''
        require('nvim-web-devicons').setup{}
      '';
    }

    {
      plugin = bufferline-nvim;
      type = "lua";
      config = ''
        require('bufferline').setup{}
        vim.keymap.set("n", "<Tab>", vim.cmd.bn)
        vim.keymap.set("n", "<S-Tab>", vim.cmd.bp)
      '';
    }

    {
      plugin = fzf-lua;
      type = "lua";
      config = ''
        vim.keymap.set("n", "<space><space>", "<cmd>FzfLua<cr>")
        vim.keymap.set("n", "<space>ff", function() require('fzf-lua').files() end)
        vim.keymap.set("n", "<space>fr", function() require('fzf-lua').oldfiles() end)
        vim.keymap.set("n", "<space>fg", function() require('fzf-lua').live_grep() end)
        vim.keymap.set("n", "<space>fb", function() require('fzf-lua').blines() end)
        vim.keymap.set("n", "<space>fs", function() require('fzf-lua').lsp_document_symbols() end)
        vim.keymap.set("n", "<space>ca", function() require('fzf-lua').lsp_code_actions() end)
      '';
    }

    {
      plugin = lazygit-nvim;
      type = "lua";
      config = ''
        vim.keymap.set("n", "<space>gg", function() require('lazygit').lazygit() end)
      '';
    }

    {
      plugin = gitsigns-nvim;
      type = "lua";
      config = ''
          require('gitsigns').setup{
              signs = {
                  add = { text = "┃" },
                  change = { text = "┃" },
                  delete = { text = "" },
                  topdelete = { text = "" },
                  changedelete = { text = "┃" },
                  untracked = { text = " " },
              }
          }
      '';
    }

    {
      plugin = git-conflict-nvim;
      type = "lua";
      config = ''
        require('git-conflict').setup({})
      '';
    }

    {
      plugin = lualine-nvim;
      type = "lua";
      config = ''
      require('lualine').setup {
          options = {
              section_separators = " ",
              component_separators = " "
          }
      }
      '';
    }

    nvim-lspconfig
    cmp-nvim-lsp
    cmp-path
    cmp-treesitter
    luasnip

    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_select = {behavior = cmp.SelectBehavior.Select}
        local kind_icons = {
            Copilot = " ",
            Text = "  ",
            Method = "  ",
            Function = "  ",
            Constructor = "  ",
            Field = "  ",
            Variable = "  ",
            Class = "  ",
            Interface = "  ",
            Module = "  ",
            Property = "  ",
            Unit = "  ",
            Value = "  ",
            Enum = "  ",
            Keyword = "  ",
            Snippet = "  ",
            Color = "  ",
            File = "  ",
            Reference = "  ",
            Folder = "  ",
            EnumMember = "  ",
            Constant = "  ",
            Struct = "  ",
            Event = "  ",
            Operator = "  ",
            TypeParameter = "  ",
        }

      local source_map = {}

        cmp.setup({
            sources = cmp.config.sources({
                {name = 'path'},
                {name = 'nvim_lsp'},
                {name = 'copilot'},
            }),

            border_opts = {
                border = "rounded",
                winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            },

            window = {
                completion = cmp.config.window.bordered(border_opts),
                documentation = cmp.config.window.bordered(border_opts),
            },

            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                    vim_item.menu = (source_map)[entry.source.name]
                    return vim_item
                end,
            },

            mapping = {
                ["<C-j>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-k>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-d>"]     = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                ["<C-u>"]     = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  elseif has_words_before() then
                    cmp.complete()
                  else
                    fallback()
                  end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
            },
        })

        vim.lsp.set_log_level("off")
      '';
    }

    {
      plugin = copilot-lua;
      type = "lua";
      config = ''
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
      '';
    }

    {
      plugin = copilot-cmp;
      type = "lua";
      config = "require('copilot_cmp').setup()";
    }

    {
      plugin = numb-nvim;
      type = "lua";
      config = "require('numb').setup()";
    }

    {
      plugin = undotree;
      type = "lua";
      config = "vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)";
    }

    {
      plugin = neo-tree-nvim;
      type = "lua";
      config = "vim.keymap.set('n', '<space>e', '<cmd>Neotree toggle<cr>')";
    }

    nvim-lspconfig
    mason-nvim
    mason-lspconfig-nvim

    {
      plugin = lsp-zero-nvim;
      type = "lua";
      config = ''
        local lsp = require("lsp-zero")
        lsp.preset("recommended")

        require('mason').setup({})
        require('mason-lspconfig').setup({
          ensure_installed = {
            'gopls',
            'rnix',
            'pyright',
            'rust_analyzer',
            'jdtls',
            'jsonls',
            'lua_ls',
            'marksman',
          },
          handlers = {
            lsp.default_setup,
            lua_ls = function()
              local lua_opts = lsp.nvim_lua_ls()
              require('lspconfig').lua_ls.setup(lua_opts)
            end,
          }
        })

        lsp.set_preferences({
        suggest_lsp_servers = false,
        sign_icons = {
            error = '󰅚 ',
            warn = ' ',
            hint = '󰌶 ',
            info = ' '
          }
        })

        lsp.on_attach(function(client, bufnr)
          local opts = {buffer = bufnr, remap = false}

          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "<leader>cws", function() vim.lsp.buf.workspace_symbol() end, opts)
          vim.keymap.set("n", "<leader>cd", function() vim.diagnostic.open_float() end, opts)
          vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
          vim.keymap.set("n", "<leader>crr", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
          vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

          vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
          vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
          vim.keymap.set("n", "<C-d>", "<C-d>zz")
          vim.keymap.set("n", "<C-u>", "<C-u>zz")
          vim.keymap.set("n", "n", "nzzzv")
          vim.keymap.set("n", "N", "Nzzzv")

          vim.keymap.set("v", "<", "<gv")
          vim.keymap.set("v", ">", ">gv")

          vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

          vim.keymap.set("n", "<leader>bd", vim.cmd.bd)
          vim.keymap.set("n", "<leader>x", vim.cmd.bd)

          vim.keymap.set("n", "<C-h>", "<C-w>h")
          vim.keymap.set("n", "<C-j>", "<C-w>j")
          vim.keymap.set("n", "<C-k>", "<C-w>k")
          vim.keymap.set("n", "<C-l>", "<C-w>l")
          vim.keymap.set("n", "<Left>", "<cmd>vertical resize +1<cr>")
          vim.keymap.set("n", "<Right>", "<cmd>vertical resize -1<cr>")
          vim.keymap.set("n", "<Up>", "<cmd>resize +1<cr>")
          vim.keymap.set("n", "<Down>", "<cmd>resize -1<cr>")

        end)

        lsp.setup()

        vim.diagnostic.config({
            virtual_text = true
        })
      '';
    }

    nvim-lspconfig
    vim-lastplace
    markdown-preview-nvim

    {
      plugin = hop-nvim;
      type = "lua";
      config = ''
        require('hop').setup()
          vim.keymap.set("n", "<leader>w", "<cmd>HopWord<cr>")
          vim.keymap.set("n", "s", "<cmd>HopChar1<cr>")
          vim.keymap.set("n", "<leader>j", "<cmd>HopLine<cr>")
          vim.keymap.set("n", "<leader>k", "<cmd>HopLine<cr>")
      '';
    }

    {
      plugin = harpoon;
      type = "lua";
      config = ''
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", mark.add_file)
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

        vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
        vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
        vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
        vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)
        vim.keymap.set("n", "<C-5>", function() ui.nav_file(5) end)
        vim.keymap.set("n", "<C-6>", function() ui.nav_file(6) end)
        vim.keymap.set("n", "<C-7>", function() ui.nav_file(7) end)
      '';
    }

  ];

  extraConfig = ''
    set clipboard=unnamedplus
    set nonumber

    " disable swp
    set noswapfile
    " persistent undo
    set nobackup
    set undodir = "~/.local/share/nvim/undo"
    set undofile

    set updatetime=50

    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set smartindent

    " helpful popup for shortcuts
    set timeoutlen=500
    set nohlsearch
    set incsearch

    set termguicolors

    set scrolloff=8

    " cant spell
    set spell
    set spelllang=en

    set listchars=tab:─\ ,trail:·,nbsp:␣,precedes:«,extends:»
    set guifont=Liga\ SFMono\ Nerd\ Font:h18
    let g:neovide_padding = {'top': 45, 'bottom': 20, 'left': 38, 'right': 38}
  '';
};
