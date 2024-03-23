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
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
          },
        },
      },
    },
  },
}
