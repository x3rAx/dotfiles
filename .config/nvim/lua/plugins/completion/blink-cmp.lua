return {
  {
    "saghen/blink.cmp",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-e: Hide menu
      -- C-k: Toggle signature help
      --
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "super-tab" },

      completion = {
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", "label_detail", gap = 1 }, { "label_description" } },

            components = {
              label = {
                text = function(ctx)
                  return ctx.label
                end,
              },
              label_detail = {
                text = function(ctx)
                  return ctx.label_detail
                end,
              },

              label_description = {
                highlight = "LspCodeLens",
              },
            },
          },
        },
      },
    },
  },
}
