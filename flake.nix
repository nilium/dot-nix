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

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    ncrandr,
    afmt,
    pact,
    sql,
    helix,
    typst,
    ...
  }: let
    flakePackages' = system: flake: flake.packages.${system};

    overlayFlake' = system: flake: removeAttrs (flakePackages' system flake) ["default"];
    overlayFlakes' = system: flakes:
      builtins.foldl' (acc: flake: acc // (overlayFlake' system flake)) {}
      flakes;

    lib' = system: {
      flakePackages = flakePackages' system;
      overlayFlake = overlayFlake' system;
      overlayFlakes = overlayFlakes' system;
    };

    forSystem = system: apply:
      apply {
        inherit system;
        lib = lib' system;
      };
  in
    (flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs-unstable.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.alejandra
            pkgs.just
            afmt.packages.${system}.default
          ];
        };
      }
    ))
    // (forSystem "x86_64-linux" (import ./sirin inputs));
}
