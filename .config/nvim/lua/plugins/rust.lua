return {
  {
    "Saecki/crates.nvim",
    opts = {
      popup = {
        autofocus = true,
        border = "rounded",
      },
    },
    keys = {
      {
        "<leader>CC",
        function()
          if require("crates").popup_available() then
            require("crates").show_crate_popup()
          end
        end,
        desc = "Show crate popup",
      },
      {
        "<leader>CV",
        function()
          if require("crates").popup_available() then
            require("crates").show_versions_popup()
          end
        end,
        desc = "Show versions popup",
      },
      {
        "<leader>CF",
        function()
          if require("crates").popup_available() then
            require("crates").show_features_popup()
          end
        end,
        desc = "Show features popup",
      },
      {
        "<leader>uR",
        function()
          require("crates").toggle()
        end,
        desc = "Toggle crates UI elements",
      },
      {
        "<leader>CR",
        function()
          require("crates").reload()
        end,
        desc = "Reload crates data (clears cache)",
      },
      {
        "<leader>CU",
        function()
          require("crates").update()
        end,
        desc = "Update crates data",
      },
      {
        "<leader>Cu",
        mode = "n",
        function()
          require("crates").upgrade_crate()
        end,
        desc = "Upgrade crate in current line",
      },
      {
        "<leader>Cu",
        mode = "v",
        function()
          require("crates").upgrade_crates()
        end,
        desc = "Upgrade selected crates",
      },
      {
        "<leader>Ca",
        function()
          require("crates").upgrade_all_crates()
        end,
        desc = "Upgrade all crates",
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>C", group = "crates", icon = "" },
      },
    },
  },
}
