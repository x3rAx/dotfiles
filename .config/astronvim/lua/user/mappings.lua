-- NOTE: Use `./which-key.lua` to configure the keymap popup

local quickSave = {
  n = { ["<C-s>"] = { ":silent update<CR>", desc = "Save File" } },
  i = { ["<C-s>"] = { "<C-o>:silent update<CR>", desc = "Save File" } },
  v = { ["<C-s>"] = { "<Esc>:silent update<CR>gv", desc = "Save File" } },
}

local astroMenu = {
  n = {
    ["<leader>Ar"] = { "<cmd>AstroReload<cr>", desc = "Reload Configuration" },
    ["<leader>Ac"] = { "<cmd>e " .. os.getenv("HOME") .. "/.config/nvim/lua/user/init.lua<cr>",
      desc = "Open user configuration" },
  }
}

local commentLines = {
  n = { ["<C-/>"] = { "<Esc><Cmd>lua require('Comment.api').toggle.linewise.current()<CR>", desc = "Comment line" }, },
  v = { ["<C-/>"] = { "<Esc><Cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    desc = "Toggle comment line" }, },
}

local recentTelescopePickers = {
  n = {
    -- Open recent Telescope picker(s)
    ["<leader>fr"] = { "<cmd>Telescope resume<cr>", desc = "Open recent Telescope picker" },
    ["<leader>fR"] = { "<cmd>Telescope pickers<cr>", desc = "Select recent Telescope pickers" },
  }
}

local pasteWithoutYankingSelection = {
  v = { ["p"] = { "\"_c<C-r>\"<Esc>", desc = "Paste without yanking" }, }
}

local general = {
  n = { -- Normal mode bindings
    --["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    --["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
    --["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
    --["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
  },
  i = { -- Insert mode bindings
  },
  v = { -- Visual mode bindings
  },
  t = { -- Terminal bindings
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}

return require('x3ro.merge-mappings')(
  quickSave,
  astroMenu,
  commentLines,
  recentTelescopePickers,
  pasteWithoutYankingSelection,
  general
)
