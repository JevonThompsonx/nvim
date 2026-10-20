-- Compatibility shims that must run before lazy.nvim/plugin setup.

-- Providers we don't use. Disabling them saves a bit of startup time.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

---Prepend a directory to $PATH if it isn't there already.
---@param dir string
local function prepend_path(dir)
  dir = vim.fn.expand(dir)
  if dir == "" then
    return
  end
  local path = vim.env.PATH or ""
  for entry in path:gmatch("[^:]+") do
    if entry == dir then
      return
    end
  end
  vim.env.PATH = dir .. ":" .. path
end

prepend_path("~/.local/bin")
prepend_path("~/.local/share/nvim/mason/bin")
prepend_path("~/.juliaup/bin")

-- NOTE: do NOT shim `vim.validate` here.
-- Neovim 0.11 keeps the positional form `vim.validate(name, value, validator, optional, message)`
-- as the canonical API and only deprecates the table form (`vim.validate({ name = { ... } })`).
-- Wrapping it the other way around converts every valid call into a deprecated one, which
-- spams `:checkhealth vim.deprecated` and needlessly captures a traceback on every call.
