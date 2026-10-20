---Find a usable sqlite3 shared library.
---`ffi.load("sqlite3")` (the snacks default) needs `libsqlite3.so`, which is only
---shipped by the `-dev` package on most distros. Probe the runtime library instead.
---@return string?
local function find_sqlite3()
  local candidates = {
    "/usr/lib/x86_64-linux-gnu/libsqlite3.so.0",
    "/usr/lib64/libsqlite3.so.0",
    "/usr/lib/libsqlite3.so.0",
    "/lib/x86_64-linux-gnu/libsqlite3.so.0",
    "/usr/lib/x86_64-linux-gnu/libsqlite3.so",
    "/usr/lib64/libsqlite3.so",
  }
  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
  return nil
end

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.explorer = opts.explorer or {}
      opts.explorer.trash = false

      opts.image = opts.image or {}
      opts.image.enabled = false

      opts.picker = opts.picker or {}
      opts.picker.db = opts.picker.db or {}
      local sqlite3_path = find_sqlite3()
      if sqlite3_path then
        opts.picker.db.sqlite3_path = sqlite3_path
      end
    end,
  },
}
