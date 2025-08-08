-- ============================================================================
-- Modern Neovim Configuration in Lua
-- ============================================================================

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
vim.opt.showmode = true
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
vim.opt.smarttab = true

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
keymap("n", "Y", "y$")
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
  -- Essential plugins
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = {
          dotfiles = false,
          custom = { "^\\.git$", "^\\.DS_Store$" },
        },
        git = {
          enable = true,
          ignore = false,
        },
        hijack_netrw = true,
        disable_netrw = true,
        actions = {
          open_file = { quit_on_open = false },
        },
      })

      -- Key mappings
      keymap("n", "<Leader>N", ":NvimTreeToggle<CR>")
      keymap("n", "<Leader>nf", ":NvimTreeFindFile<CR>")
    end,
  },

  -- Telescope (modern fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { ".git/", "node_modules/" },
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
      keymap("n", "<Leader>fg", builtin.live_grep, {})
      keymap("n", "<Leader>fb", builtin.buffers, {})
      keymap("n", "<Leader>fh", builtin.help_tags, {})
      keymap("n", "<Leader>fr", builtin.lsp_references, {})
      keymap("n", "<Leader>fs", builtin.lsp_document_symbols, {})
    end,
  },

  -- Editor enhancements
  "editorconfig/editorconfig-vim",
  "tpope/vim-unimpaired",
  "tpope/vim-repeat",
  "jlanzarotta/bufexplorer",

  -- Search and navigation
  {
    "mileszs/ack.vim",
    config = function()
      vim.g.ackprg = "ag --nogroup --nocolor --column"
      keymap("n", "<leader>f", ":Ack<Space>")
      keymap("n", "<leader>s", ":Ack <cword><CR>")
    end,
  },

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

  -- Formatting and linting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black", "isort" },
          javascript = { "biome" },
          typescript = { "biome" },
          javascriptreact = { "biome" },
          typescriptreact = { "biome" },
          json = { "biome" },
          html = { "prettier" },
          css = { "prettier" },
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
  {
    "pangloss/vim-javascript",
    ft = { "javascript", "javascriptreact" },
  },
  {
    "mxw/vim-jsx",
    ft = { "javascript", "javascriptreact" },
  },
  "othree/html5.vim",

  -- TypeScript
  {
    "peitalin/vim-jsx-typescript",
    ft = { "typescript", "typescriptreact" },
  },
  {
    "leafgarland/typescript-vim",
    ft = "typescript",
  },

  -- Go
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      vim.g.go_fmt_command = "goimports"
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_methods = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_structs = 1
      vim.g.go_highlight_types = 1
      vim.g.go_def_mode = "gopls"
      vim.g.go_rename_command = "gopls"
      vim.g.go_metalinter_autosave_enabled = { "typecheck", "golint" }

      -- Go key mappings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          keymap("n", "<leader>gr", "<Plug>(go-run)", { buffer = true })
          keymap("n", "<leader>gb", "<Plug>(go-build)", { buffer = true })
          keymap("n", "<leader>gt", "<Plug>(go-test)", { buffer = true })
          keymap("n", "<leader>gc", "<Plug>(go-coverage)", { buffer = true })
          keymap("n", "<Leader>ge", "<Plug>(go-rename)", { buffer = true })
          keymap("n", "<Leader>gdb", "<Plug>(go-doc-browser)", { buffer = true })
          keymap("n", "<Leader>gd", "<Plug>(go-doc)", { buffer = true })
          keymap("n", "<Leader>gv", "<Plug>(go-doc-vertical)", { buffer = true })
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
  {
    "tpope/vim-rails",
    ft = "ruby",
  },
  {
    "vim-ruby/vim-ruby",
    ft = "ruby",
  },

  -- Python
  {
    "vim-python/python-syntax",
    ft = "python",
  },

  -- Documentation and misc
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_markdown_css = "/home/erik/dev/dotfiles/gdocs.css"
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = { server = "http://erikbenoist.com:8181" },
        maid = {},
        disable_sync_scroll = 1,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
      }
      keymap("n", "<leader>m", "<Plug>MarkdownPreview", { buffer = true })
    end,
  },

  "hashivim/vim-terraform",
  "jparise/vim-graphql",
  "https://github.com/pimalaya/himalaya-vim",

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
    "gpanders/vim-medieval",
    config = function()
      vim.g.medieval_langs = { "bash", "ruby", "sh", "js=node-eval", "python" }
    end,
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-night")
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

-- Ruby-specific trailing whitespace removal
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rb", "*.haml" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- File type associations
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Gemfile", "Rakefile", "Capfile", "*.rake", "config.ru", "*.god" },
  callback = function()
    vim.bo.filetype = "ruby"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md", "*.mkd", "*.markdown" },
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.bo.filetype = "gitcommit"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "Tiltfile",
  callback = function()
    vim.bo.filetype = "python"
  end,
})

-- Terminal mappings
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    keymap("t", "<Esc>", "<C-\\><C-n>", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      keymap("t", "<Esc>", "<C-\\><C-n>", { buffer = true })
    end
  end,
})

-- Telescope exception for Esc mapping (if needed)
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "TelescopePrompt",
--   callback = function()
--     vim.keymap.del("t", "<Esc>", { buffer = true })
--   end,
-- })

-- ============================================================================
-- Clipboard and system integration
-- ============================================================================

-- vim.g.clipboard = "osc52"

-- Ruby operators highlighting
vim.g.ruby_operators = 1
