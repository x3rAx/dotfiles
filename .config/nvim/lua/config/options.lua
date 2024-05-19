-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- TODO: Maybe set this to "" (empty) to completely disable automatic clipboard sync
opt.clipboard = "unnamed" -- Sync with 'primary' clipboard (selection / middle-mouse clipboard)

--- Indenting
local indent = 4
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.tabstop = indent
opt.softtabstop = indent

--- Hint to help limit line length
opt.colorcolumn = "80,100,120,121"

--- Show more lines below / above cursor when reaching window border
opt.scrolloff = 10

--- Autocomplete to the longes common match, then cycle through each full match
opt.wildmode = { "longest:full", "full" }

-------------------------------------------------------------------------------
--- Custom commands

-- `CD` to change directory to current file
vim.cmd([[ command! -nargs=0 CD :cd %:p:h ]])
