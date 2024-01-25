{ config, pkgs, lib, mkUnstable, ... }:

let
  nixpkgs-config = { };
  unstable = mkUnstable { config = nixpkgs-config; };
in {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Use latest neovim
    #package = unstable.neovim-unwrapped;

    extraPackages = with pkgs; [
      #nixd # Nix LS - Links to official Nix library and should also have support for home-manager bug I couldn't get it to work
      #rnix-lsp

      # TODO: Re-enable packages as needed during LazyVim setup
      #gnumake gcc # Required to build telescope-fzf-native plugin # TODO: Try to install through home-manager?
      #lldb # For rust debugging
      #nil # Nix LS - Supports home-manager out of the box
      #nodePackages.pyright # Python LS
      #nodePackages.vim-language-server # Vimscript LS
      #nodejs # Copilot
      #python3Packages.black # Python formatter
      #ruff-lsp # Python LS
      #rust-analyzer # Rust LS
      #sumneko-lua-language-server # Lua LS
      #tree-sitter # For nvim-treesitter command `:TSInstallFromGrammar`
      #unixtools.xxd # `xxd` for Hex extension
      gcc # For nvim-treesitter
      stylua # Opinionated Lua code formatter
      sumneko-lua-language-server # Lua LS
    ];

    plugins = with pkgs.vimPlugins; [
      #telescope-fzf-native-nvim # Adding this here does not prevent lazy.nvim to build it anyways...
      #parinfer-rust # TODO: maybe this must be `pkgs.parinfer` (without `vimPlugins`)?
      #lazy-nvim
      #nvim-tree-lua
      #{
      #  plugin = pkgs.vimPlugins.vim-startify;
      #  config = "let g:startify_change_to_vcs_root = 0";
      #}
      # coc-sumneko-lua # Lua language server
    ];
  };
}
