{
  description = "Home Manager configuration of x3ro";

  nixConfig = {
    extra-substituters = [
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flakify = {
      url = "github:x3rAx/flakify";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly/master";
    yazi.url = "github:sxyazi/yazi";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flakify,
    nix-vscode-extensions,
    firefox-nightly,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    nixpkgs-unstable-overlay = final: _prev: {
      unstable = import nixpkgs-unstable {
        inherit (final) system config;
      };
    };

    overlays = [
      nixpkgs-unstable-overlay
      flakify.overlays.default
    ];

    vscode-extensions = nix-vscode-extensions.extensions.${system};

    mkHome = home-module:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ({...}: {nixpkgs.overlays = overlays;})
          home-module
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
          inherit system;
          inherit vscode-extensions;
        };
      };
  in {
    homeConfigurations."x3ro@K1STE" = mkHome ./home-k1ste.nix;
    homeConfigurations."x3ro@Jehuty" = mkHome ./home-jehuty.nix;
  };
}
