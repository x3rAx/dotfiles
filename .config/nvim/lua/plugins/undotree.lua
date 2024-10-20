return {
  {
    "mbbill/undotree",
    init = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SplitWidth = 40
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_TreeNodeShape = ''
      vim.g.undotree_DiffCommand = [[bash -c 'diff -u --color "$@" | grep -vE "^(---|\\+\\+\\+)"' -s]]
    end,
    keys = {
      {
        "<leader>uu",
        function()
          vim.cmd.UndotreeToggle()
        end,
        desc = "Show/hide undo tree",
      },
    },
  },
}
