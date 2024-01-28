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
