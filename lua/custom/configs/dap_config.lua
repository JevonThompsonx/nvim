-- lua/custom/configs/dap_config.lua
local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  -- Setup nvim-dap-ui
  dapui.setup({
    -- Your dapui configurations here (see its documentation)
    -- For example, to customize the layout:
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.35 },
          { id = "breakpoints", size = 0.15 },
          { id = "stacks", size = 0.15 },
          { id = "watches", size = 0.35 },
        },
        size = 40,
        position = "left",
      },
      {
        elements = { { id = "repl", size = 0.6 }, { id = "console", size = 0.4 } },
        size = 0.25, -- Height of the bottom panel
        position = "bottom",
      },
    },
    controls = { enabled = true, icons = { pause = "⏸", play = "▶", step_into = "⏎", step_over = "⏭", step_out = "⏮", disconnect = "⏏", terminate = "⏹" } },
    floating = { max_height = nil, max_width = nil, border = "rounded" },
    render = { indent = 1 }
  })

  -- Open/Close DAP UI automatically
  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  -- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  -- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end


  -- Go DAP configuration (delegated to nvim-dap-go)
  -- nvim-dap-go should handle delve setup if delve is in your path or mason installed.

  -- Java DAP configuration (delegated to nvim-jdtls)
  -- nvim-jdtls will set up DAP configurations for Java.
  -- Ensure 'java-debug-adapter' and 'java-test' are installed via Mason.

  -- Basic DAP keymaps (customize as needed)
  vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
  vim.keymap.set("n", "<F6>", function() dapui.toggle() end, { desc = "DAP UI Toggle" })
  vim.keymap.set("n", "<F7>", function() dap.step_over() end, { desc = "DAP Step Over" })
  vim.keymap.set("n", "<F8>", function() dap.step_into() end, { desc = "DAP Step Into" })
  vim.keymap.set("n", "<F9>", function() dap.step_out() end, { desc = "DAP Step Out" })
  vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
  vim.keymap.set("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "DAP Set Conditional Breakpoint" })
  vim.keymap.set("n", "<leader>lp", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, { desc = "DAP Set Log Point" })
  vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "DAP REPL Open" })

end

return M
