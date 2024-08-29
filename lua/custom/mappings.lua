local M = {}

M.crates = {
  n = {
    ["<leader>rcu"] = {
      function ()
        require("crates").update_all_crates()
      end,
      "upgrade crates"
    }
  }
}

return M
