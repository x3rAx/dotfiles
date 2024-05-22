local function get_hlgroup_color(group, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

local function get_mode_seperator_color(attr)
  return function(_)
    return { [attr] = get_hlgroup_color("PmenuSel", "bg") }
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        --component_separators = { left = "", right = "" },
        --component_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },

        disabled_filetypes = {
          statusline = {},
          winbar = { "neo-tree", "dashboard", "toggleterm" },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
            separator = "",
          },
          -- Mode-Separator part 1 --
          {
            function()
              return ""
            end,
            padding = 0,
            separator = "",
            color = get_mode_seperator_color("fg"),
          },
          -- Mode-Separator part 2 --
          {
            function()
              return ""
            end,
            draw_empty = true,
            padding = 0,
            separator = { right = "" },
            color = get_mode_seperator_color("bg"),
          },
        },
      },
      winbar = {
        lualine_b = { "filename" },
      },
      inactive_winbar = {
        lualine_a = { "filename" },
      },
      ignore_focus = { "neo-tree" },
    },
  },
}
