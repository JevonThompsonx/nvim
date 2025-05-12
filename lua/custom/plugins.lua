local plugins = {
  -- Essential: Plenary, often a dependency
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Install tools through Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs
        "lua-language-server",
        "rust-analyzer",
        "gopls",
        "jdtls",
        "pyright",
        "typescript-language-server",
        "tailwindcss-language-server",
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        "eslint-lsp", -- Or use eslint_d via nvim-lint

        -- Formatters (for conform.nvim)
        "prettier",
        "prettierd",
        "stylua",
        "black",
        "autopep8",
        "isort",
        "gofumpt",
        "goimports",
        "shfmt", -- Shell script formatter
        "google-java-format", -- Java formatter
        "biome",

        -- Linters (for nvim-lint)
        "eslint_d",
        "flake8",
        "pylint",
        "mypy",
        "shellcheck",
        "golangci-lint", -- Go linter (ensure it's installable/installed)
        "selene", -- Lua linter
        "yamllint", -- YAML linter

        -- Debug Adapters (for nvim-dap)
        "delve",
        "java-debug-adapter",
        "java-test",
      },
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      -- require("plugins.configs.lspconfig") -- If you have a base lspconfig
      require "custom.configs.lspconfig" -- Your custom LSP setups
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "roobert/tailwindcss-colorizer-cmp.nvim",
      "saecki/crates.nvim",
    },
    opts = function()
      local M = require "plugins.configs.cmp" -- Assuming this file exists
      local has_source = function(name)
        for _, source in ipairs(M.sources) do
          if source.name == name then
            return true
          end
        end
        return false
      end
      if not has_source "tailwindcss_colorizer_cmp" then
        table.insert(M.sources, { name = "tailwindcss_colorizer_cmp" })
      end
      if not has_source "crates" then
        table.insert(M.sources, { name = "crates" })
      end
      return M
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },
  { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
  { "rafamadriz/friendly-snippets" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- require("plugins.configs.treesitter") -- If you have a base treesitter config
      require "custom.configs.treesitter" -- Your custom treesitter config
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        go = { "gofumpt", "goimports" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        sh = { "shfmt" },
        java = { "google-java-format" }, -- Ensure google-java-format is in Mason
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format { async = true, lsp_fallback = "always" }
      end, { desc = "Format buffer with conform.nvim" })
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        python = { "flake8", "pylint", "mypy" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        go = { "golangci-lint" },
        sh = { "shellcheck" },
        lua = { "selene" },
        yaml = { "yamllint" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint-autosave", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        group = lint_augroup,
        callback = function(args)
          if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= "" then
            return
          end
          require("lint").try_lint()
        end,
      })
    end,
  },

  -- Rust
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup {}
    end,
  },

  -- DAP (Debugging)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      -- "nvim-dap-python", -- Example: If you want python specific dap config
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui" -- dapui is required by dap_config

      -- nvim-dap-ui setup (integrated here for simplicity)
      dapui.setup {
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.15 },
              { id = "watches", size = 0.35 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = { { id = "repl", size = 0.6 }, { id = "console", size = 0.4 } },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            disconnect = "⏏",
            terminate = "⏹",
          },
        },
        floating = { max_height = nil, max_width = nil, border = "rounded" },
        render = { indent = 1 },
      }

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- DAP Keymaps
      vim.keymap.set("n", "<F5>", function()
        dap.continue()
      end, { desc = "DAP Continue" })
      vim.keymap.set("n", "<F6>", function()
        dapui.toggle()
      end, { desc = "DAP UI Toggle" })
      vim.keymap.set("n", "<F7>", function()
        dap.step_over()
      end, { desc = "DAP Step Over" })
      vim.keymap.set("n", "<F8>", function()
        dap.step_into()
      end, { desc = "DAP Step Into" })
      vim.keymap.set("n", "<F9>", function()
        dap.step_out()
      end, { desc = "DAP Step Out" })
      vim.keymap.set("n", "<leader>b", function()
        dap.toggle_breakpoint()
      end, { desc = "DAP Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end, { desc = "DAP Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>lp", function()
        dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
      end, { desc = "DAP Set Log Point" })
      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.open()
      end, { desc = "DAP REPL Open" })

      -- Setup language-specific DAP configurations
      require("dap-go").setup() -- nvim-dap-go
      -- For Java, nvim-jdtls typically handles DAP registration.
      -- Ensure its ftplugin/java.lua calls require("jdtls").setup_dap_main_class_configs() or similar.
    end,
  },
  -- nvim-dap-ui is now configured as part of nvim-dap's config for simplicity,
  -- but keeping its entry ensures it's loaded as a dependency.
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
  {
    "leoluz/nvim-dap-go",
    ft = "go", -- Ensure this is loaded for Go files
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- The main setup is called from the nvim-dap config block above.
      -- Specific ft-plugin like behavior for Go can be added here if necessary,
      -- but dap-go.setup() is generally sufficient.
    end,
  },

  -- Java (nvim-jdtls)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    config = function()
      vim.notify(
        "nvim-jdtls is loaded. Crucial: For full Java support, ensure you have a correctly configured ftplugin/java.lua file. See previous instructions for a template.",
        vim.log.levels.INFO,
        { title = "nvim-jdtls" }
      )
      -- The detailed setup for nvim-jdtls (cmd, root_dir, bundles, on_attach with jdtls specific keymaps)
      -- MUST go into ~/.config/nvim/ftplugin/java.lua
      -- Example: require('custom.configs.jdtls_ftplugin_setup').setup() if you abstract it.
    end,
  },

  "roobert/tailwindcss-colorizer-cmp.nvim",
  { "leafOfTree/vim-vue-plugin" },
  { "jose-elias-alvarez/typescript.nvim" },
  { "maxmellon/vim-jsx-pretty" },
}

return plugins
