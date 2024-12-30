-- List of all default plugins & their definitions
local default_plugins = {

  -- Dependencies
  "nvim-lua/plenary.nvim",

  -- Base configuration
  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  -- UI improvements
  {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
  },

  -- Terminal integration
  {
    "NvChad/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  -- Colorizer for color codes
  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
      require("colorizer").setup(opts)
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  -- Dev icons
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- File navigation and Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "David-Kunz/telescope-node-modules.nvim",
        config = function()
          require("telescope").load_extension("node_modules")
        end,
      },
    },
    cmd = "Telescope",
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- TypeScript and Import Management
  {
    "jose-elias-alvarez/typescript.nvim",
    event = "BufReadPre",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("typescript").setup {
        server = {
          on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "<leader>oi", require("typescript").actions.organizeImports, opts)
            vim.keymap.set("n", "<leader>fi", require("typescript").actions.fixAll, opts)
          end,
        },
      }
    end,
  },

  -- Autocomplete paths
  {
    "hrsh7th/cmp-path",
    dependencies = { "hrsh7th/nvim-cmp" },
  },
}

-- Load the plugins using lazy.nvim
local config = require("core.utils").load_config()
if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end
require("lazy").setup(default_plugins, config.lazy_nvim)

---

-- Example keymap for Telescope
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files { search_dirs = { "src" } }
end, { desc = "Find local files" })