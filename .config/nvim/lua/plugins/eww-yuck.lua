return {
  {
    "elkowar/yuck.vim",
    init = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "yuck" },
        callback = function()
          vim.opt.shiftwidth = 4
        end,
      })
    end,
  },

  {
    "eraserhd/parinfer-rust",
    build = "nix-shell --run 'cargo build --release'",
  },
}
