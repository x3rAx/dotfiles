-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    signcolumn = "yes", -- Always show sign column
    wrap = false, -- Configure line wrap
    wildmode = { "longest:full", "full" }, -- Autocomplete to the longes common match, then cycle through each full match
    clipboard = "", -- Disable system clipboard connection
    timeoutlen = 1000,
    colorcolumn = { 81, 101, 121, 122 },

    -- Line wrapping
    breakindent = true, -- Indent wrapped lines
    breakindentopt = {
      "shift:4", -- Indent wrapped lines by N chars
      "min:40", -- Leave at least N chars for the line when indenting
      "sbr", -- Show the `showbreak` symbol at the beginning of wrapped lines
    },
    showbreak = "", -- Show this at the beginning of wrapped lines
  },
  g = {
    mapleader = " ", -- sets vim.g.mapleader
    --icons_enabled = false, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    --autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    --diagnostics_enabled = true, -- enable diagnostics at start
    --status_diagnostics_enabled = true, -- enable diagnostics in statusline
    --ui_notifications_enabled = false, -- disable notifications when toggling UI elements
    -- heirline_bufferline = true, -- enable new heirline based bufferline (requires :PackerSync after changing)
  },
}
