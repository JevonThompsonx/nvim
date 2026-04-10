vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local local_bin = vim.fn.expand("~/.local/bin")
if not vim.env.PATH:find(vim.pesc(local_bin), 1, true) then
  vim.env.PATH = local_bin .. ":" .. vim.env.PATH
end

local juliaup_bin = vim.fn.expand("~/.juliaup/bin")
if not vim.env.PATH:find(vim.pesc(juliaup_bin), 1, true) then
  vim.env.PATH = juliaup_bin .. ":" .. vim.env.PATH
end

-- Bridge older LazyVim treesitter requires to the newer textobjects module path.
local textobjects_modules = {
  move = true,
  select = true,
  swap = true,
  repeatable_move = true,
  shared = true,
  config = true,
  ["_range"] = true,
}

for module in pairs(textobjects_modules) do
  package.preload["nvim-treesitter.textobjects." .. module] = function()
    return require("nvim-treesitter-textobjects." .. module)
  end
end
