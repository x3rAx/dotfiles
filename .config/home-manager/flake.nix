{
  description = "Home Manager configuration of x3ro";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { nixpkgs, unstable, home-manager, nix-vscode-extensions, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Create Nixpkgs with config from a custom input
      mkNixpkgs = custom_nixpkgs: config:
        import custom_nixpkgs ({ inherit system; } // config);
      mkUnstable = config: mkNixpkgs unstable config;
      vscode-extensions = nix-vscode-extensions.extensions.${system};

      extraSpecialArgs = {
        inherit inputs;
        inherit system;
        inherit mkNixpkgs;
        inherit mkUnstable;
        inherit vscode-extensions;
      };
    in {
      homeConfigurations."x3ro@K1STE" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home-k1ste.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        inherit extraSpecialArgs;
      };
      homeConfigurations."x3ro@jehuty" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit extraSpecialArgs;

        modules = [ ./home-jehuty.nix ];
      };
    };
}
