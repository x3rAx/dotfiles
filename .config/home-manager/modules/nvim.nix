{
  config,
  pkgs,
  lib,
  ...
}: let
  nvim-ld-libraries = with pkgs; [
    icu
    stdenv.cc.cc.lib
    zlib
  ];
  nvim-ld = let
    neovim-pkg = pkgs.unstable.neovim-unwrapped;
  in pkgs.symlinkJoin {
    name = "nvim-ld";
    paths = [neovim-pkg];
    nativeBuildInputs = [pkgs.makeBinaryWrapper];
    postBuild = ''
      mkdir -p "$out/bin/.wrapped"
      mv "$out/bin/nvim" "$out/bin/.wrapped/nvim"

      # NOTE: Do not use `wrapProgram` here. It results in the actual binary
      # being renamed to `.nvim-wrapped`. This causes a problem where
      # `vim-tmux-navigator` does not detect that the nvim process is running
      # inside a pane.
      makeWrapper "$out/bin/.wrapped/nvim" "$out/bin/nvim" \
        --set NIX_LD `cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker'` \
        --set NIX_LD_LIBRARY_PATH '${lib.makeLibraryPath nvim-ld-libraries}'
    '';
    # Inherit interpreter from neovim
    lua = neovim-pkg.lua;
    # Inherit meta from neovim
    meta = {
      inherit (neovim-pkg.meta)
        description
        longDescription
        homepage
        mainProgram
        license
        maintainers
        platforms;
    };
  };
in {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Use latest neovim
    #package = pkgs.unstable.neovim-unwrapped;
    package = nvim-ld;

    extraPackages = with pkgs; [
      clang
      clang-tools
      gcc # For nvim-treesitter
      #rust-analyzer cargo # For Rust support; `rust-analyzer` is not installed by Mason since it does not play well with `cargo` installed through Nix # TODO: It is best installed through a nix shell using rust-overlay. See `~/Code/x3ro/git-age/`
    ];

    plugins = with pkgs.vimPlugins; [
    ];
  };
}
