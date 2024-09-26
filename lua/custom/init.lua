vim.cmd [[
  autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.vue lua vim.lsp.buf.format({ timeout_ms = 2000 })
]]
vim.wo.number = true
vim.wo.relativenumber = true