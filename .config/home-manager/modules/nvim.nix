{ config, pkgs, lib, mkUnstable, ... }:

let
  nixpkgs-config = { };
  unstable = mkUnstable { config = nixpkgs-config; };

  nvim-ld-libraries = with pkgs; [
    stdenv.cc.cc.lib
    icu
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
        gcc # For nvim-treesitter
    ];

    plugins = with pkgs.vimPlugins; [
    ];
  };
}
