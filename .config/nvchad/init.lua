local opt = vim.opt
local g = vim.g
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Numbers
opt.relativenumber = true

-- Copilot
g.copilot_assume_mapped = true -- Fix copilot complaining about <Tab> key being mapped already

-- Indenting
local indent = 4
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.tabstop = indent
opt.softtabstop = indent

-- Hint to help limit line length
opt.colorcolumn = "80,100,120,121"

-- Highlight on yank
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

-- Custom command `CD` to change directory to current file
vim.cmd [[ command! -nargs=0 CD :cd %:p:h ]]

-- Do not use system clipboard
opt.clipboard = ""

-- Fix NvChad status line
vim.cmd [[ command! -nargs=0 FixNvChadStatusLine :set statusline=%!v:lua.require('nvchad.statusline.default').run() ]]

