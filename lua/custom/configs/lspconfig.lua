local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local servers = {"html", "cssls", "clangd", "pyright"}

lspconfig.tsserver.setup {
  cmd = { "typescript-language-server", "--stdio" },  -- Command to start ts_ls
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },  -- Filetypes it will attach to
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
  settings = {
    typescript = {
      format = {
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterSemicolonInForStatements = true,
      }
    },
    javascript = {
      format = {
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterSemicolonInForStatements = true,
      }
    }
  }
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        -- Formatter options
        black = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        -- Linter options
        pylint = { enabled = true, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        -- Type checker
        pylsp_mypy = { enabled = true },
        -- Auto-completion options
        jedi_completion = { fuzzy = true },
        -- Import sorting
        pyls_isort = { enabled = true },
      }
    }
  }
}
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"rust"},
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})

lspconfig.tailwindcss.setup {
}

-- Vue Language Server (Volar)
lspconfig.volar.setup({
  filetypes = { "vue" }, -- Ensure it's targeting .vue files
})

-- Optional: Set up Emmet for HTML autocompletion within .vue files
lspconfig.emmet_ls.setup({
  filetypes = { "html", "css", "vue", "typescriptreact", "javascriptreact"}, -- Enable Emmet for HTML and Vue files
})
