-- TODO: Integrate into statusline
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
}
