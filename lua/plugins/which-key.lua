return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      -- Disable which-key's built-in help for native `g` bindings and for
      -- text objects (they are noisy and not used here).
      opts.plugins = opts.plugins or {}
      opts.plugins.presets = vim.tbl_deep_extend("force", opts.plugins.presets or {}, {
        g = false,
        text_objects = false,
      })

      -- Remove the `g` / "goto" group from the which-key spec.
      --
      -- A which-key spec is either a flat list of entries, or a list of groups
      -- where a group is a table holding `mode`/`group` keys plus a nested list
      -- of entries. LazyVim uses the grouped form, so both shapes are handled
      -- here to stay compatible across LazyVim versions.
      local is_goto = function(entry)
        return type(entry) == "table" and entry[1] == "g" and entry.group == "goto"
      end

      if type(opts.spec) == "table" then
        local spec = {}
        for _, item in ipairs(opts.spec) do
          if type(item) == "table" and item.mode ~= nil and not is_goto(item) then
            -- a group: keep the group settings, filter its nested entries
            local group = {}
            for key, value in pairs(item) do
              if type(key) ~= "number" then
                group[key] = value
              end
            end
            for _, entry in ipairs(item) do
              if not is_goto(entry) then
                group[#group + 1] = entry
              end
            end
            spec[#spec + 1] = group
          elseif not is_goto(item) then
            spec[#spec + 1] = item
          end
        end
        opts.spec = spec
      end
    end,
  },
}
