return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
      },
      formatters = {
        alejandra = {
          command = "alejandra",
          --args = { "$FILENAME" },
          stdin = true,
        },
      },
    },
  },
}
