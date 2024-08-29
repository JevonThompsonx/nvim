local plugins = {
  -- Install through mason
  {
    "williamboman/mason.nvim",
  opts = {
      ensure_installed = {
      "autopep8", "biome", "black", "emmet-ls", "eslint-lsp", "eslint_d", "flake8", "isort", "jedi-language-server", "js-debug-adapter", "mypy", "prettier", "prettierd", "pyflakes", "pylint", "pyright", "python-lsp-server", "typescript-language-server", "yapf", "rust-analyzer"
      }
    }
  },
  --lspconfig points to configs.lspconfig
  {
  "neovim/nvim-lspconfig",
    config = function ()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end
  },
  --rust auto format on save
  {
  "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
  },
  --working w/ crate toml files
  {
    "saecki/crates.nvim",
    ft = {"rust", "toml"},
    config = function ()
      local crates = require("crates")
      crates.setup(opts)
      crates.show()
    end
  },
  -- supports above 
  {
    "hrsh7th/nvim-cmp",
    opts = function ()
      local M = require "plugins.configs.cmp"
      table.insert(M.sources, {name = "crates"})
      return M
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function ()
      require("plugins.configs.treesitter")
      require("custom.configs.treesitter")
    end
  }
}

return plugins