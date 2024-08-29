require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end
-- set ejs files to html 
vim.cmd('autocmd BufNewFile,BufRead *.ejs set filetype=html')
-- Show diagnostics automatically when hovering over a symbol
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]
dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
vim.opt.shell = "/usr/bin/fish"
require "plugins"
