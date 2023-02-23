return {
  init = {
    -- You can disable default plugins as follows:
    -- ["goolord/alpha-nvim"] = { disable = true },

    -- You can also add new plugins here as well:
    -- Add plugins, the packer syntax without the "use"
    -- { "andweeb/presence.nvim" },
    -- {
    --   "ray-x/lsp_signature.nvim",
    --   event = "BufRead",
    --   config = function()
    --     require("lsp_signature").setup()
    --   end,
    -- },

    -- We also support a key value style plugin definition similar to NvChad:
    -- ["ray-x/lsp_signature.nvim"] = {
    --   event = "BufRead",
    --   config = function()
    --     require("lsp_signature").setup()
    --   end,
    -- },

    {
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
          --keymaps =       -- Defines plugin keymaps,
          --surrounds =     -- Defines surround keys and behavior,
          --aliases =       -- Defines aliases,
          --highlight =     -- Defines highlight behavior,
          --move_cursor =   -- Defines cursor behavior,
        })
      end,
    },

    ["mg979/vim-visual-multi"] = {
      branch = 'master',
      setup = function()
        -- TODO: Why do changes to this only take effect after reinstalling the plugin?
        vim.g.VM_theme = 'nord' -- See: https://github.com/mg979/vim-visual-multi/wiki/Highlight-colors#selecting-a-theme
        vim.g.VM_maps = {
          ['Find Under'] = '<M-C-L>',
          ['Add Cursor Up'] = '<M-C-K>',
          ['Add Cursor Down'] = '<M-C-J>',
        }
      end,
    },

    ["~/Projects/x3ro/nvim-qalc"] = {},

    ['NoahTheDuke/vim-just'] = {},
  },

  --
  -- Override the require("<key>").setup({...}) call for default plugins below
  --

  ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
    -- config variable is the default configuration table for the setup function call
    -- local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
    }
    return config -- return final config table
  end,

  ["treesitter"] = { -- overrides `require("treesitter").setup(...)`
    -- ensure_installed = { "lua" },
  },

  -- use mason-lspconfig to configure LSP installations
  ["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
    -- ensure_installed = { "sumneko_lua" },
  },

  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  ["mason-null-ls"] = { -- overrides `require("mason-null-ls").setup(...)`
    -- ensure_installed = { "prettier", "stylua" },
  },

  ["mason-nvim-dap"] = { -- overrides `require("mason-nvim-dap").setup(...)`
    -- ensure_installed = { "python" },
  },

  ["telescope"] = {
    defaults = {
      cache_picker = {
        -- Number of pickers that should be kept active in the background for later use.
        -- A high number can impact performance.
        num_pickers = 50
      }
    }
  },

  ["Comment"] = {
    padding = false, -- Do not add a space between comment and line
  },

  ["neo-tree"] = {
    window = {
      mappings = {
        ["g/"] = "fuzzy_finder",
        ["gf"] = "fuzzy_finder",
        ["/"] = false,
        ["Q"] = 'close_window',
        ["q"] = 'clear_filter',
        ["l"] = { "toggle_preview", config = { use_float = true } }, -- Also prevents moving cursor to the right
        --[":"] = 'run_file_command',
      },
    },
    filesystem = {
      hijack_netrw_behavior = "open_default",
    },
  },

  ["better_escape"] = {
    timeout = 300,
  },
}
