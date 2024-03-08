{ config, pkgs, lib, mkUnstable, ... }:

let
  nixpkgs-config = { };
  unstable = mkUnstable { config = nixpkgs-config; };

  nvim-ld-libraries = with pkgs; [
    icu
    stdenv.cc.cc.lib
    zlib
  ];
  nvim-ld = pkgs.symlinkJoin {
    name = "nvim-ld";
    paths = [ pkgs.neovim-unwrapped ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/nvim" \
        --set NIX_LD `cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker'` \
        --set NIX_LD_LIBRARY_PATH '${lib.makeLibraryPath nvim-ld-libraries}'
    '';
  };
in {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Use latest neovim
    #package = unstable.neovim-unwrapped;
    package = nvim-ld;

    extraPackages = with pkgs; [
        clang clang-tools
        gcc # For nvim-treesitter
        rust-analyzer cargo # For Rust support; `rust-analyzer` is not installed by Mason since it does not play well with `cargo` installed through Nix
    ];

    plugins = with pkgs.vimPlugins; [
    ];
  };
}
