local root_pattern = require("lspconfig.util").root_pattern

local function get_deno_root_dir(fname)
  -- Root pattern from: https://github.com/neovim/nvim-lspconfig/blob/fd49d5863e873891be37afac79b1f56fb34bb5d3/doc/configs.md?plain=1#L2986
  local root = root_pattern("deno.json", "deno.jsonc", ".git")(fname)
  if root then
    return root
  end

  -- Single-file support --

  local file = io.open(fname)
  if file == nil then
    return nil
  end

  local lines = file:lines()
  local first_line = lines()

  -- Test if shebang matches deno
  if first_line:match("^#!/usr/bin/env deno") or first_line:match("^#!/usr/bin/env %-S deno") then
    -- Get the directory of the current file
    -- local dir = vim.fn.fnamemodify(fname, ":h")

    -- Get a directory with a deno.json for single-file LSP support
    local dir = vim.fn.stdpath("config") .. "/deno-single-file-lsp-root/"

    -- HACK: Disable conflicting "vtsls". Maybe this should be done in the `config` function?
    LazyVim.lsp.disable("vtsls", function()
      return true
    end)

    return dir
  end

  return nil
end

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    opts = {
      servers = {
        denols = {
          root_dir = get_deno_root_dir,
        },
      },
    },
  },
}
