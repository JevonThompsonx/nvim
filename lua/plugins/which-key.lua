return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.plugins = opts.plugins or {}
      opts.plugins.presets = vim.tbl_deep_extend("force", opts.plugins.presets or {}, {
        g = false,
        text_objects = false,
      })

      if opts.spec then
        opts.spec = vim.tbl_filter(function(item)
          return not (type(item) == "table" and item[1] == "g" and item.group == "goto")
        end, opts.spec)
      end
    end,
  },
}
