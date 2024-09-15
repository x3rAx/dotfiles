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
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    unstable,
    home-manager,
    nix-vscode-extensions,
    firefox-nightly,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Create Nixpkgs with config from a custom input
    mkNixpkgs = custom_nixpkgs: config:
      import custom_nixpkgs ({inherit system;} // config);
    mkUnstable = config: mkNixpkgs unstable config;
    vscode-extensions = nix-vscode-extensions.extensions.${system};

    mkHome = home-module:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [home-module];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
          inherit system;
          inherit mkNixpkgs;
          inherit mkUnstable;
          inherit vscode-extensions;
        };
      };
  in {
    homeConfigurations."x3ro@K1STE" = mkHome ./home-k1ste.nix;
    homeConfigurations."x3ro@Jehuty" = mkHome ./home-jehuty.nix;
  };
}
