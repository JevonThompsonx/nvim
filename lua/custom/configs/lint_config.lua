-- lua/custom/configs/lint_config.lua
local M = {}

function M.setup()
  local lint = require("lint")
  lint.linters_by_ft = {
    python = { "flake8", "pylint", "mypy" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    go = { "golangci-lint" }, -- Ensure golangci-lint is installed (e.g., via Mason or system package manager)
    sh = { "shellcheck" },
    lua = { "selene" }, -- if you install selene via mason
    yaml = { "yamllint" } -- if you install yamllint via mason
    -- Add other filetypes and linters
  }

  local lint_augroup = vim.api.nvim_create_augroup("nvim-lint-autosave", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
    group = lint_augroup,
    callback = function(args)
      -- Avoid linting for non-file buffers or specific buffer types
      if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= "" then
        return
      end
      require("lint").try_lint()
    end,
  })
end

return M
