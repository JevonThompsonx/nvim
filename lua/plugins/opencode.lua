return {
  {
    "nickjvandyke/opencode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      local opencode_cmd = "opencode"
      ---@type snacks.terminal.Opts
      local snacks_terminal_opts = {
        win = {
          position = "right",
          enter = false,
        },
      }

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
          end,
        },
      }

      -- Toggle OpenCode with Ctrl+Shift+O
      vim.keymap.set({ "n", "t" }, "<C-S-o>", function()
        require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
      end, { desc = "Toggle OpenCode" })

      -- Also keep the default toggle
      vim.keymap.set({ "n", "t" }, "<C-.>", function()
        require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
      end, { desc = "Toggle OpenCode" })
    end,
  },
}