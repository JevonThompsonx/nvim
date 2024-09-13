local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local servers = {"html", "cssls", "clangd", "pyright", "typescript"}

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
  filetypes = { "html","ejs", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue"},
  root_dir = lspconfig.util.root_pattern("tailwind.config.js", "package.json"),
}

-- Vue Language Server (Volar)
lspconfig.volar.setup({
  filetypes = { "vue" }, -- Ensure it's targeting .vue files
})

-- Optional: Set up Emmet for HTML autocompletion within .vue files
lspconfig.emmet_ls.setup({
  filetypes = { "html", "css", "vue" }, -- Enable Emmet for HTML and Vue files
})
