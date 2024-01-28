-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("x3ro_" .. name, { clear = true })
end

--- Fix for LazyVim autocommand to go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local buf = event.buf
    if not vim.b[buf].lazyvim_last_loc or vim.b[buf].x3ro_last_loc then
      return
    end

    vim.b[buf].x3ro_last_loc = true

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)

    -- The actual fix: If the mark line is greater than the number of lines in
    -- the buffer, go to the last line
    if mark[1] > lcount then
      mark[1] = lcount
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--- Change directory if a directory is provided as an argument to nvim
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("change_dir"),
  pattern = "*",
  callback = function()
    local args = vim.v.argv
    if #args < 1 then
      return
    end

    -- Find the first positional argument
    local dir = nil
    local stop_parsing = false
    for _, arg in ipairs(args) do
      if arg == "--" then
        stop_parsing = true
        break
      end
      if (stop_parsing or arg:sub(1, 1) ~= "-") and vim.fn.isdirectory(arg) == 1 then
        dir = arg
        break
      end
    end

    if dir then
      vim.cmd("cd " .. dir)
    end
  end,
})
