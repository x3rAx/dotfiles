return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<M-h>",  "<cmd>TmuxNavigateLeft<cr>",     mode = { "n", "t" } },
      { "<M-j>",  "<cmd>TmuxNavigateDown<cr>",     mode = { "n", "t" } },
      { "<M-k>",  "<cmd>TmuxNavigateUp<cr>",       mode = { "n", "t" } },
      { "<M-l>",  "<cmd>TmuxNavigateRight<cr>",    mode = { "n", "t" } },
      { "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "t" } },
    },
    config = function()
      -- vim.g.tmux_navigator_no_mappings = 1
    end,
  }
}
