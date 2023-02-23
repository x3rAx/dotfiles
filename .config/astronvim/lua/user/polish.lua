do -- Load lua globals
  require('x3ro.globals')
  require('x3ro.type-extensions')
end

do -- Re-enable netrw
  -- Doing this through the AstroNvim option `options.g.<key>` does not work.
  vim.g.loaded_netrwFileHandlers = nil
  vim.g.loaded_netrwPlugin = nil
  vim.g.loaded_netrwSettngs = nil
end


do -- Change directory when opening vim with a folder as argument
  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Change directory when opening vim with a folder as argument",
    pattern = "*",
    -- command = "silent! cd %:p:h",
    callback = function()
      local bufname = vim.fn.expand('%')
      if vim.fn.isdirectory(bufname) == 1 then
        vim.cmd("silent! cd " .. bufname)
      end
    end
  })
end


do
  -- TODO: This should fix some weird behavior with auto-indenting comments in yaml files.
  --       Maybe it was this but I can't reproduce it: https://unix.stackexchange.com/q/609612
  --vim.cmd [[ "autocmd FileType yaml set indentkeys-=0# ]]
end


do -- Shortcut to enter normal mode in terminal
  --vim.cmd [[ tnoremap jk <C-\><C-n> ]]
  vim.cmd [[ tnoremap <C-\><C-\> <C-\><C-n> ]]
end


do -- Prevent opening the command history on "q:"
  --vim.cmd [[ nnoremap q <nop> ]]
end

--
--vim.g.VM_maps = {
--  ['Find Under'] = '<M-C-L>',
--  ['Add Cursor Up'] = '<M-C-K>',
--  ['Add Cursor Down'] = '<M-C-J>',
--}
