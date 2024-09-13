local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Formatting with Biome for React (JSX/TSX) and Vue files
    null_ls.builtins.formatting.biome.with({
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }, -- Add Vue and React file types
    }),
    -- Linting with Biome for React (JSX/TSX) and Vue files
    null_ls.builtins.diagnostics.biome.with({
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
    }),
  },
})
