local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

-- Enable snippet support for autocompletion
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Common servers
-- Add "gopls" to the list of common servers
local servers = {"html", "cssls", "clangd", "gopls"}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- TypeScript
lspconfig.ts_ls.setup {
  on_attach = on_attach, -- Added on_attach for consistency
  capabilities = capabilities, -- Added capabilities for consistency
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
  on_attach = on_attach, -- Added on_attach for consistency
  capabilities = capabilities, -- Added capabilities for consistency
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
  on_attach = on_attach, -- Added on_attach for consistency
  capabilities = capabilities, -- Added capabilities for consistency
  filetypes = {
    "html", "css", "javascript", "typescript",
    "javascriptreact", "typescriptreact", "vue", "go" -- Added go for tailwind in go templates if needed
  },
  init_options = {
    userLanguages = {
      html = "html",
      css = "css",
      javascript = "javascript",
      typescript = "typescript",
      vue = "vue",
      go = "gohtml" -- Or "gohtml", "tmpl" depending on your go template filetypes
    }
  }
}

-- Vue
lspconfig.volar.setup({
  on_attach = on_attach, -- Added on_attach for consistency
  capabilities = capabilities, -- Added capabilities for consistency
  filetypes = { "vue" },
})

-- Emmet
lspconfig.emmet_ls.setup({
  on_attach = on_attach, -- Added on_attach for consistency
  capabilities = capabilities, -- Added capabilities for consistency
  filetypes = {
    "html", "css", "sass", "scss", "less",
    "vue", "javascriptreact", "typescriptreact"
  },
  init_options = {
    html = { options = { ["bem.enabled"] = true } },
  },
})

-- Go (gopls)
-- gopls is already added to the common servers list above,
-- so it will be set up with on_attach and capabilities.
-- If you need specific settings for gopls, you can configure it separately like this:
-- lspconfig.gopls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     gopls = {
--       -- Example: enable staticcheck
--       -- staticcheck = true,
--       -- Example: to run gofumpt when formatting
--       -- gofumpt = true,
--       -- For more settings, see:
--       -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
--     }
--   },
--   root_dir = util.root_pattern("go.work", "go.mod", ".git"),
--   filetypes = { "go", "gomod", "gowork", "gotmpl" }
-- }

-- Java (jdtls)
-- IMPORTANT: For a richer Java development experience (debugging, testing, advanced refactoring),
-- consider using the nvim-jdtls plugin: https://github.com/mfussenegger/nvim-jdtls
-- The setup below is a basic lspconfig setup for jdtls.
-- You will need to have jdtls installed and ensure the paths in the `cmd` are correct.
-- You might need to install it via a plugin manager like mason.nvim or manually.
lspconfig.jdtls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "java" },
  -- cmd is crucial and depends on your jdtls installation.
  -- If you use mason.nvim, it often handles this automatically.
  -- Otherwise, you'll need to point to the jdtls launcher script and specify
  -- the jar, configuration, and data directories.
  --
  -- Example (paths will likely need to be adjusted for your system):
  -- cmd = {
  --   'java', -- or the full path to your java executable
  --   '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  --   '-Dosgi.bundles.defaultStartLevel=4',
  --   '-Declipse.product=org.eclipse.jdt.ls.core.product',
  --   '-Dlog.protocol=true',
  --   '-Dlog.level=ALL',
  --   '-Xms1g',
  --   '--add-modules=ALL-SYSTEM',
  --   '--add-opens', 'java.base/java.util=ALL-UNNAMED',
  --   '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
  --   '-jar', vim.fn.glob('path/to/your/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'), -- Adjust this path
  --   '-configuration', vim.fn.glob('path/to/your/jdtls/config_linux'), -- Adjust this path (or config_mac or config_win)
  --   '-data', vim.fn.expand('~/.cache/jdtls-workspace/') .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t') -- Unique workspace per project
  -- },
  --
  -- A simpler cmd might work if jdtls is in your PATH and configured globally,
  -- but the explicit cmd above is often needed for custom setups or specific versions.
  --
  -- If using nvim-jdtls, this lspconfig.jdtls.setup might not be needed or could conflict.
  -- Refer to nvim-jdtls documentation for its specific setup.
  root_dir = util.root_pattern("pom.xml", "build.gradle", ".git"), -- Common Java project markers
  -- init_options can be used to pass bundles for features like debugging or extensions.
  -- init_options = {
  --   bundles = {}
  -- }
}
