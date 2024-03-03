{
  description = "Noel's home configuration";

  inputs = {
    # This currently points to 23.11 to line up with my previous non-flake configuration.
    # Might later switch to unstable completely.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ncrandr = {
      url = "path:./ncrandr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    afmt = {
      url = "path:./afmt";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    sql = {
      url = "sourcehut:~nilium/sql";
      # Required for Go 1.22, which isn't available in 23.11 yet.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ncrandr,
    afmt,
    sql,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    overlayFlake = flake: removeAttrs flake.packages.${system} ["default"];
    overlayFlakes = flakes:
      builtins.foldl' (acc: flake: acc // overlayFlake flake) {}
      flakes;

    unstable = nixpkgs-unstable.legacyPackages.${system};

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          inherit unstable;
          ncower =
            (prev.ncower or {})
            // overlayFlakes [
              sql
            ];
        })
      ];
    };
  in {
    homeConfigurations."ncower" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        afmt.homeManagerModules.afmt
        ncrandr.homeManagerModules.ncrandr
        {
          imports = [
            ./modules/pbcopy.nix
            ./fish/default.nix
          ];
        }
        ./home/git.nix
        ./home/scr.nix
        ./home/tmux.nix
        ./home.nix
      ];
    };
  };
}
