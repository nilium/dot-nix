{
  description = "Noel's home configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";

    # TODO: swtich to flake-parts? Not sure it's decidedly better still.
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    fex = {
      url = "sourcehut:~nilium/go-fex";
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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    helix = {
      url = "github:nilium/helix/nil-23.10";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.crane.follows = "crane";
    };

    typst = {
      url = "github:typst/typst";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.crane.follows = "crane";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    home-manager,
    ncrandr,
    afmt,
    pact,
    sql,
    helix,
    fex,
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
        pkgs = nixpkgs.legacyPackages.${system};
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
