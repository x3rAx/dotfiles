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
