{
  description = "Noel's home configuration";

  inputs = {
    # This currently points to 23.11 to line up with my previous non-flake configuration.
    # Might later switch to unstable completely.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs-unstable";

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

    pact = {
      url = "path:./pact";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    sql = {
      url = "sourcehut:~nilium/sql";
      # Required for Go 1.22, which isn't available in 23.11 yet.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };

    helix = {
      url = "github:nilium/helix/nil-23.10";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
      inputs.crane.follows = "crane";
    };

    typst = {
      url = "github:typst/typst";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.systems.follows = "systems";
      inputs.crane.follows = "crane";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ncrandr,
    afmt,
    pact,
    sql,
    helix,
    typst,
    ...
  }: let
    system = "x86_64-linux";

    flakePackages = flake: flake.packages.${system};
    overlayFlake = flake: removeAttrs (flakePackages flake) ["default"];
    overlayFlakes = flakes:
      builtins.foldl' (acc: flake: acc // overlayFlake flake) {}
      flakes;

    overlay-unstable = final: prev: {
      inherit (flakePackages helix) helix;
      typst = (flakePackages typst).default;

      ncower = (prev.ncower or {}) // overlayFlakes [sql];
    };

    unstable = import nixpkgs-unstable {
      inherit system;
      overlays = [overlay-unstable];
    };

    overlay-stable = final: prev: {
      inherit unstable;
      inherit (overlayFlake pact) pact;
    };

    pkgs = import nixpkgs {
      inherit system;
      overlays = [overlay-stable];
    };
  in {
    homeConfigurations."ncower" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        afmt.homeManagerModules.afmt
        ncrandr.homeManagerModules.ncrandr
        pact.homeManagerModules.pact
        {
          imports = [
            ./modules/pbcopy.nix
            ./fish/default.nix
          ];
        }
        ./git-tools/git-tools.nix
        ./home/kitty.nix
        ./home/git.nix
        ./home/scr.nix
        ./home/tmux.nix
        ./home/pueue.nix
        ./home/nushell.nix
        ./home/fish.nix
        (import ./home/hlwm (overlayFlakes [ncrandr]))
        ./home.nix
      ];
    };
  };
}
