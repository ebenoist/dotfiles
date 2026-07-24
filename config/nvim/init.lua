-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Settings
-- ============================================================================

-- Load clipboard configuration
require('clipboard').setup()

-- essentials
vim.g.mapleader = ","
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.cmdheight = 2
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 3

-- tabs vs spaces
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- display
vim.opt.wrap = false
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.listchars = { trail = "·", tab = "→ ", eol = "↵" }
vim.opt.list = false

-- neovim
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- ============================================================================
-- Key Mappings
-- ============================================================================

local keymap = vim.keymap.set

-- General
keymap("i", "jj", "<Esc>")

-- Window navigation
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-l>", "<C-w>l")
keymap("n", "<C-x>", "<C-w>q")
keymap("n", "<BS>", "<C-W>h")

-- Search and navigation
keymap("n", "<Leader>h", ":set hlsearch! hlsearch?<CR>")
keymap("n", "<Leader>n", ":set number! number?<CR>")

-- File operations
keymap("n", "<Leader>cf", ":let @*=expand('%')<CR>")
keymap("n", "<Leader>cff", ":let @*=expand('%:p')<CR>")

-- Tags
keymap("n", "<Leader>rt", ":!bash -ic re-ctags<CR>")

-- ============================================================================
-- Plugin Specifications
-- ============================================================================

require("lazy").setup({
  "github/copilot.vim",

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          local opts = { buffer = ev.buf, silent = true }
          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "gD", vim.lsp.buf.declaration, opts)
          keymap("n", "gr", vim.lsp.buf.references, opts)
          keymap("n", "gi", vim.lsp.buf.implementation, opts)
          keymap("n", "K", vim.lsp.buf.hover, opts)
          keymap("n", "<Leader>rn", vim.lsp.buf.rename, opts)
          keymap("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
          keymap("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
          keymap("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
          keymap("n", "<Leader>e", vim.diagnostic.open_float, opts)
        end,
      })

      vim.lsp.enable({ "vtsls", "biome", "gopls", "ruby_lsp", "basedpyright", "ruff", "zls", "sourcekit" })
    end,
  },
  {
      -- main branch: master is archived and its query predicates crash on
      -- nvim 0.12. main has no indent module; built-in indent/*.vim handles it.
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,  -- main does not support lazy-loading
      build = ":TSUpdate",
      config = function()
          local langs = {
              "bash", "c", "css", "html", "javascript", "json", "markdown",
              "python", "regex", "rust", "vim", "ruby", "lua", "typescript",
              "tsx", "zig",
          }
          require("nvim-treesitter").install(langs)

          -- Neovim owns highlighting; start it per buffer when a parser exists.
          -- language.add returns nil (no throw) for a missing parser, so check
          -- its value, not just pcall success.
          vim.api.nvim_create_autocmd("FileType", {
              callback = function(ev)
                  local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
                  if not lang or lang == "latex" then return end
                  local ok, added = pcall(vim.treesitter.language.add, lang)
                  if ok and added then
                      vim.treesitter.start(ev.buf, lang)
                  end
              end,
          })
      end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        local opts = function(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        -- NERDTree-style m menu
        vim.keymap.set("n", "m", function()
          local node = api.tree.get_node_under_cursor()
          local choices = { "add", "rename", "move", "delete", "copy", "copy path", "copy absolute path" }
          vim.ui.select(choices, { prompt = "NvimTree > " }, function(choice)
            if not choice then return end
            if choice == "add"                then api.fs.create(node)
            elseif choice == "rename"         then api.fs.rename_basename(node)
            elseif choice == "move"           then api.fs.rename(node)
            elseif choice == "delete"         then api.fs.remove(node)
            elseif choice == "copy"           then api.fs.copy.node(node)
            elseif choice == "copy path"      then api.fs.copy.relative_path(node)
            elseif choice == "copy absolute path" then api.fs.copy.absolute_path(node)
            end
          end)
        end, opts("Modify"))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = {
          dotfiles = false,
          custom = { "^\\.git$", "^\\.DS_Store$" },
        },
        git = { enable = true, ignore = false },
        hijack_netrw = true,
        disable_netrw = true,
        actions = {
          open_file = { quit_on_open = false },
        },
      })

      keymap("n", "<Leader>N", ":NvimTreeToggle<CR>")
      keymap("n", "<Leader>nf", ":NvimTreeFindFile<CR>")
    end,
  },

  -- Telescope (modern fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { ".git/", "node_modules/", "vendor/" },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })

      local builtin = require("telescope.builtin")
      keymap("n", "<Leader>t", builtin.find_files, {})
      keymap("n", "<Leader>f", builtin.live_grep, {})
      keymap("n", "<Leader>s", builtin.grep_string, {})
      keymap("n", "<Leader>fb", builtin.buffers, {})
      keymap("n", "<Leader>fh", builtin.help_tags, {})
      keymap("n", "<Leader>fr", builtin.lsp_references, {})
      keymap("n", "<Leader>fs", builtin.lsp_document_symbols, {})
    end,
  },

  -- Editor enhancements
  "tpope/vim-unimpaired",
  "tpope/vim-repeat",

  -- Comments
  {
    "scrooloose/nerdcommenter",
    config = function()
      vim.g.NERDDefaultNesting = 0
      vim.g.NERDRemoveExtraSpaces = 1
      vim.g.NERDSpaceDelims = 1
    end,
  },

  -- Git integration
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 300,
          virt_text_pos = "eol",
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local opts = { buffer = bufnr, silent = true }
          keymap("n", "]c", gs.next_hunk, opts)
          keymap("n", "[c", gs.prev_hunk, opts)
          keymap("n", "<Leader>gb", gs.blame_line, opts)
          keymap("n", "<Leader>gB", gs.toggle_current_line_blame, opts)
          keymap("n", "<Leader>gp", gs.preview_hunk, opts)
          keymap("n", "<Leader>gs", gs.stage_hunk, opts)
          keymap("n", "<Leader>gR", gs.reset_hunk, opts)
        end,
      })
    end,
  },

  -- Formatting and linting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_fix", "ruff_format" },
          javascript = { "biome" },
          typescript = { "biome" },
          javascriptreact = { "biome" },
          typescriptreact = { "biome" },
          json = { "biome" },
          html = { "biome" },
          css = { "biome" },
          ruby = { "standardrb" },
          go = { "gofmt", "goimports" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      -- Manual format command
      keymap("n", "<leader>mp", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end)
    end,
  },

  -- Language-specific plugins

  -- Go
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      vim.g.go_fmt_autosave = 0
      vim.g.go_gopls_enabled = 0  -- lspconfig owns gopls
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_methods = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_structs = 1
      vim.g.go_highlight_types = 1

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          keymap("n", "<leader>gr", "<Plug>(go-run)", { buffer = true })
          keymap("n", "<leader>gb", "<Plug>(go-build)", { buffer = true })
          keymap("n", "<leader>gt", "<Plug>(go-test)", { buffer = true })
          keymap("n", "<leader>gc", "<Plug>(go-coverage)", { buffer = true })
        end,
      })
    end,
  },

  -- Ruby
  {
    "thoughtbot/vim-rspec",
    ft = "ruby",
  },
  {
    "tpope/vim-endwise",
    ft = "ruby",
  },

  "hashivim/vim-terraform",
  "jparise/vim-graphql",

  {
    "diepm/vim-rest-console",
    config = function()
      vim.g.vrc_output_buffer_name = "__VRC_OUTPUT.json"
      vim.g.vrc_auto_format_response_patterns = {
        json = "jq",
        xml = "xmllint --format -",
        html = "tidy -",
      }
      vim.g.vrc_response_default_content_type = "application/json"
    end,
  },

  {
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "zellij"
      vim.g.slime_default_config = { session_id = "current", relative_pane = "right" }
    end,
  },

  -- Colorscheme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa")
    end,
  },
})

-- ============================================================================
-- Autocommands
-- ============================================================================

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Float the diagnostic under the cursor on rest (updatetime); nvim 0.11+
-- shows no diagnostic text by default. source = true names the compiler/LSP.
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor", border = "rounded" })
  end,
})

-- File type associations
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Gemfile", "Rakefile", "Capfile", "*.rake", "config.ru", "*.god" },
  callback = function()
    vim.bo.filetype = "ruby"
  end,
})

-- Terminal mappings
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    keymap("t", "<Esc>", "<C-\\><C-n>", { buffer = true })
  end,
})

vim.g.ruby_operators = 1
