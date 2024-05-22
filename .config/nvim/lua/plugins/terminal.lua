return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        -- shade_terminals = false,
        -- add --login so ~/.zprofile is loaded
        -- https://vi.stackexchange.com/questions/16019/neovim-terminal-not-reading-bash-profile/16021#16021
        -- shell = "zsh --login",
        winbar = {
          enabled = true,
        },
      })
    end,
    keys = {
      { [[<C-\>]] },
      -- { "<leader>0", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
      -- {
      --   "<leader>td",
      --   "<cmd>ToggleTerm size=40 dir=~/Desktop direction=horizontal<cr>",
      --   desc = "Open a horizontal terminal at the Desktop directory",
      -- },
    },
  },
}
