-- lua/custom/configs/conform_config.lua
local M = {}

function M.setup()
  require("conform").setup({
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
      sh = { "shfmt" }, -- shfmt for formatting shell scripts
      java = { "google-java-format" } -- if you install google-java-format via mason
      -- Or rely on LSP formatting for Java by ensuring lsp_fallback = true
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true,
    },
    -- formatters = {
    --   ["google-java-format"] = {
    --     cmd = {"google-java-format"},
    --     args = {"-"},
    --     stdin = true,
    --   }
    -- }
  })

  vim.keymap.set({"n", "v"}, "<leader>f", function()
    require("conform").format({ async = true, lsp_fallback = 'always' }) -- 'always' or true
  end, { desc = "Format buffer with conform.nvim" })
end

return M
