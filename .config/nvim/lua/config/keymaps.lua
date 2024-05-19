-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

local map = vim.keymap.set

-------------------------------------------------------------------------------
--- Undo / Redo
---
map({ "n", "i" }, "<C-z>", function()
  vim.cmd("undo")
end, { desc = "Undo" })
map({ "n", "i" }, "<C-S-z>", function()
  vim.cmd("redo")
end, { desc = "Redo" })

-------------------------------------------------------------------------------
--- Copy to system clipboard
---
map({ "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })

-------------------------------------------------------------------------------
--- Close Buffer
---
map({ "n" }, "ZX", "<leader>bd", { desc = "Delete Buffer", remap = true })

-------------------------------------------------------------------------------
--- Comments
---
map({ "n" }, "<c-/>", "gcc", { desc = "Comment line", remap = true })
map({ "v" }, "<c-/>", "gcgv", { desc = "Comment selected lines", remap = true })

-------------------------------------------------------------------------------
--- Floating Terminal
---
local lazyterm = function()
  Util.terminal(nil, { cwd = Util.root() })
end
map("n", "<m-`>", lazyterm, { desc = "Terminal (root dir)" })
map("t", "<m-`>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-------------------------------------------------------------------------------
--- Run current buffer with vim-lua
---
-- NOTE: This must be a vimscript mapping because otherwise only the last
--       `print` statement of the executed buffer is shown
map({ "n" }, "<leader>rl", ':lua require("lib.exec-lua-buf")()<CR>', { desc = "Run current buffer with vim-lua" })

-------------------------------------------------------------------------------
--- Misc
---
map({ "i" }, "<C-BS>", "<C-w>", { desc = "Delete word to the left" })
