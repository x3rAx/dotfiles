return {
  plugins = require('user.plugins'), -- AstroNvim does not auto-load the `plugins.lua` file, only `plugins/*.lua`
  lsp = require('user.lsp'), -- AstroNvim does not auto-load the `lsp.lua` file, only `lsp/*.lua`
}
