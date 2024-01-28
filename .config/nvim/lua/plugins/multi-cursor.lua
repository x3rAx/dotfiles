return {
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_theme = "nord" -- See: https://l.x3ro.net/Ftobnk4inu (selecting a theme)
      vim.g.VM_set_statusline = 0 -- Do not set statusline
      vim.g.VM_silent_exit = 1 -- Do not print "Exited Visual-Multi."

      vim.g.VM_maps = {
        ["Find Under"] = "<M-C-L>",
        ["Find Subword Under"] = "<M-C-L>",
        ["Add Cursor Up"] = "<M-C-K>",
        ["Add Cursor Down"] = "<M-C-J>",
      }
    end,
  },

  -- TODO: This is a proof of concept. Now the lualine config has to be extended.
  --{
  --  "nvim-lualine/lualine.nvim",
  --  opts = function(_, opts)
  --    return {
  --      sections = {
  --        lualine_a = {
  --          {
  --            "mode",
  --            fmt = function(res)
  --              if vim.fn.VMInfos and not vim.tbl_isempty(vim.fn.VMInfos()) then
  --                return "MULTI"
  --              end
  --              return res
  --            end,
  --          },
  --        },
  --      },
  --    }
  --  end,
  --},
}
