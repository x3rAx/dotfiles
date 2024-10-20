-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local wo = vim.wo

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

--- Configure line wrapping ---
wo.wrap = true
wo.breakindent = true
wo.breakindentopt = "shift:0,min:20"
opt.showbreak = "↪ "

-------------------------------------------------------------------------------
--- Custom commands

-- `CD` to change directory to current file
vim.cmd([[ command! -nargs=0 CD :cd %:p:h ]])

vim.cmd([[ command! -nargs=* Chmod :!chmod <args> % ]])
vim.cmd([[ command! -nargs=0 ChmodX :!chmod +x % ]])

-- Use "Obsidian" command to write into the Obsidian directory in ~/Sync/Obsidian/
vim.cmd([[ command! -nargs=1 Obsidian :w ~/Syncthing/Obsidian/Brain 🧠/<args>.md ]])

-- Sort packages in a Nix file
vim.api.nvim_create_user_command("SortNixPackages", require("lib.nix-sort-packages"), { nargs = 0, range = true })

-- vim.cmd([[ command! -nargs=* Shebang :normal ggO#!/usr/bin/env <args><Esc> ]])
vim.api.nvim_create_user_command("Shebang", function(args)
  vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, { "#!/usr/bin/env " .. args.args, "", "" })

  local interpreter = args.fargs[1] == "-S" and args.fargs[2] or args.fargs[1]

  local interpreters = {
    "bash",
    "python",
    "sh",
    ["deno"] = "typescript",
    ["python3"] = "python",
  }

  vim.notify(interpreter or "nil")
  if vim.tbl_contains(interpreters, interpreter) then
    vim.o.filetype = interpreter
  elseif interpreters[interpreter] ~= nil then
    vim.o.filetype = interpreters[interpreter]
  end
end, { nargs = "*" })

vim.api.nvim_create_user_command("ShebangDeno", function()
  vim.cmd("Shebang -S deno run")
  vim.api.nvim_buf_set_text(0, 1, 0, 1, 0, { "// vi: ft=typescript", "" })
end, { nargs = 0 })
