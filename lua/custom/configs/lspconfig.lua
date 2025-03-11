local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

-- Enable snippet support for autocompletion
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Common servers
local servers = {"html", "cssls", "clangd"}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- TypeScript
lspconfig.ts_ls.setup {
  root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
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

-- Python (pyright example)
lspconfig.pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      }
    }
  }
}

-- Rust
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = {
        command = "clippy",
        extraArgs = { "--no-deps" }
      }
    },
  },
})

-- TailwindCSS
lspconfig.tailwindcss.setup {
  filetypes = {
    "html", "css", "javascript", "typescript",
    "javascriptreact", "typescriptreact", "vue"
  },
  init_options = {
    userLanguages = {
      html = "html",
      css = "css",
      javascript = "javascript",
      typescript = "typescript",
      vue = "vue"
    }
  }
}

-- Vue
lspconfig.volar.setup({
  filetypes = { "vue" },
})

-- Emmet
lspconfig.emmet_ls.setup({
  filetypes = {
    "html", "css", "sass", "scss", "less",
    "vue", "javascriptreact", "typescriptreact"
  },
  init_options = {
    html = { options = { ["bem.enabled"] = true } },
  },
})
