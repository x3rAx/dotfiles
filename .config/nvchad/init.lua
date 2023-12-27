local opt = vim.opt
local g = vim.g

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

