local root_pattern = require("lspconfig.util").root_pattern

local function is_deno_exe_file(fname)
  local file = io.open(fname)
  if not file then
    return false
  end

  -- local lines = file:lines()
  -- local first_line = lines()
  local first_line = file:read("*l")

  -- Test if shebang matches deno
  return first_line:match("^#!/usr/bin/env deno") or first_line:match("^#!/usr/bin/env %-S deno")
end

local function get_deno_root_dir(fname)
  -- Root pattern from: https://github.com/neovim/nvim-lspconfig/blob/fd49d586/doc/configs.md?plain=1#L2986
  local root = root_pattern("deno.json", "deno.jsonc", ".git")(fname)
  if root then
    return root
  end

  -- Single-file support --

  -- Test if shebang matches deno
  if not is_deno_exe_file(fname) then
    return nil
  end

  -- Get a directory with a deno.json for single-file LSP support
  local dir = vim.fn.stdpath("config") .. "/deno-single-file-lsp-root/"
  -- Get the directory of the current file
  -- local dir = vim.fn.fnamemodify(fname, ":h")

  -- vim.notify("Deno LPS single-file enabled")

  return dir
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

        -- Disable vtsls when deno is detected
        vtsls = {
          on_attach = function(client, bufnr)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if get_deno_root_dir(fname) then
              vim.lsp.stop_client(client.id)
            end
          end,
        },
      },
    },
  },
}
