{
  config,
  pkgs,
  lib,
  mkUnstable,
  ...
}: let
  nixpkgs-config = {};
  unstable = mkUnstable {config = nixpkgs-config;};

  nvim-ld-libraries = with pkgs; [
    #icu
    #stdenv.cc.cc.lib
    #zlib
  ];
  vscode-ld = pkgs.symlinkJoin {
    name = "vscode-ld";
    paths = [pkgs.vscode];
    nativeBuildInputs = [pkgs.makeBinaryWrapper];
    #postBuild = ''
    #  wrapProgram "$out/bin/code" \
    #    --set NIX_LD `cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker'` \
    #    #--set NIX_LD_LIBRARY_PATH '${lib.makeLibraryPath nvim-ld-libraries}'
    #'';
  };
in {
  programs.vscode = {
    enable = true;
    package = vscode-ld;
  };

  # --- Below is an incomplete config for VsCode with extensions ---
  #
  #programs.vscode = {
  #  enable = true;
  #
  #  # Use latest VSCode
  #  #package = unstable.vscode;
  #
  #  # Do not allow VSCode to manage extensions
  #  mutableExtensionsDir = false;
  #
  #  # NOTE: Have a look at https://github.com/nix-community/nix-vscode-extensions if extensions provided by nixpkgs are not uptodate
  #  extensions = with pkgs.vscode-extensions; [
  #    vscodevim.vim
  #    #nvarner.typst-lsp # Installed via `estensionsFromVscodeMarketplace` below
  #    golang.go
  #  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  #    { name = "typst-lsp"; publisher = "nvarner"; version = "0.12.0"; sha256 = "sha256-9v6zJyeUBj0TOpK2otLqZ0ksjmzExKTJYRF+9akvuuo="; }
  #    #{ name="codeium"; publisher="Codeium"; version="1.2.11"; sha256="sha256-n2fCfrI0wzwXeaDr7zkehIOJBrWUMtJdBRwOwUb5RsY="; }
  #    #{ name = "codeium"; publisher = "Codeium"; version = "1.7.13"; sha256 = "1287bf6xxgyhm03sb5gh2in1z4x6mlb7xqvdb04wrplcv2b2f8bz"; }
  #    #{ publisher="ahmadawais"; name="emoji-log-vscode"; version="1.3.0"; sha256="sha256-3do8Yiua7LYtJxA81IBtGxPxsTQB1xNcxx2R13VRRJA="; }
  #  ] ++ (let buildVscodeMarketplaceExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension; in [
  #    #(
  #    #  let
  #    #    name = "codeium";
  #    #    publisher = "Codeium";
  #    #    version = "1.2.11";
  #    #
  #    #    lspZip = pkgs.fetchurl {
  #    #      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_linux_x64.gz";
  #    #      sha256 = "sha256-TyIeVNeDDSgP2UWtA++G6+Ybq+9AmaXNaZOCVmuKt4s=";
  #    #    };
  #    #  in
  #    #    buildVscodeMarketplaceExtension {
  #    #      mktplcRef = {
  #    #        inherit name publisher version;
  #    #        sha256 = "sha256-n2fCfrI0wzwXeaDr7zkehIOJBrWUMtJdBRwOwUb5RsY=";
  #    #      };
  #    #      postInstall =
  #    #        let
  #    #          serverName = "language_server_linux_x64";
  #    #          lspOutDir = "$out/share/vscode/extensions/Codeium.codeium/dist/b43caa7661bde4411c6c11d3b938890bc1ea0d08";
  #    #        in ''
  #    #          mkdir "${lspOutDir}"
  #    #          cp "${lspZip}" "${lspOutDir}/${serverName}.gz"
  #    #          gunzip "${lspOutDir}/${serverName}.gz"
  #    #          chmod 755 "${lspOutDir}/${serverName}"
  #    #        '';
  #    #    }
  #    #)
  #  ]) ++ (with vscode-extensions.vscode-marketplace; [
  #    # Git
  #    ahmadawais.emoji-log-vscode
  #    mhutchie.git-graph
  #
  #    # Copilot
  #    github.copilot
  #
  #    # Rust
  #    rust-lang.rust-analyzer
  #    serayuzgur.crates
  #    tamasfe.even-better-toml
  #    jedeop.crates-completer
  #
  #    #nvarner.typst-lsp
  #    #codeium.codeium
  #
  #  ]);
  #};
}
