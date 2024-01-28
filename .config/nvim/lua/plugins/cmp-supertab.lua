--- Use <tab> for accepting completion and snippets (alternative supertab)
return {
  --- Disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = {
      { "<Tab>", false },
      { "<S-Tab>", false },
    },
  },

  --- Setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cursor_is_left_of_text = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        -- Test if text left of cursor is only whitespace
        return vim.api.nvim_get_current_line():sub(0, col):match("^%s*$") ~= nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.config.disable, -- Disable accept completion with <CR>

        -- Tab accepts completion if the popup is visible,
        -- otherwise it jumps to the next snippet placeholder.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- TODO: Call the method(s) directly instead of using the mapping.confirm method
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            })(fallback)
            return
          end

          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            return
          end

          fallback()
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- TODO: Call the method(s) directly instead of using the mapping.confirm method
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            })(fallback)
            return
          end

          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
            return
          end

          if cursor_is_left_of_text() then
            -- De-indent
            vim.cmd("normal a")
            return
          end

          -- Fix indentation
          vim.cmd("normal a")
        end, { "i", "s" }),

        --- Close cmp on Shift+Esc
        ["<S-Esc>"] = cmp.mapping.close(),
      })
    end,
  },
}
