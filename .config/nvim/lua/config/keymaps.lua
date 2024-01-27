-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--- Undo / Redo
map({ "n", "i" }, "<C-z>", function()
  vim.cmd("undo")
end, { desc = "Undo" })
map({ "n", "i" }, "<C-S-z>", function()
  vim.cmd("redo")
end, { desc = "Redo" })

--- Copy to system clipboard
map({ "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })

--- Close Buffer / Window
map({ "n" }, "<leader>X", "<Space>bd", { desc = "Delete Buffer", remap = true })
map({ "n" }, "<leader>Q", "<C-W>c", { desc = "Delete Window" })

--- Comments
map({ "n" }, "<c-/>", "gcc", { desc = "Comment line", remap = true })
map({ "v" }, "<c-/>", "gc", { desc = "Comment selected lines", remap = true })
