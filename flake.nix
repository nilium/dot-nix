{
  description = "Noel's home configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-hardware.url = "github:nixos/nixos-hardware";

    ntk = {
      url = "github:nilium/dot-nix/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fex = {
      url = "sourcehut:~nilium/go-fex";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sql = {
      url = "sourcehut:~nilium/sql";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:nilium/helix/nil-23.10";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };

    typst = {
      url = "github:typst/typst";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
  };

  outputs = inputs @ {ntk, ...}: (
    ntk.lib.merge inputs [
      # Modules
      ./packages # Shared packages
      ./nixos # Most NixOS modules
      ./home # Most home-manager modules

      # Machines
      ./sirin # sirin, x86_64-linux
      ./dolya # dolya, aarch64-darwin

      # Common outputs
      ./dot-shell.nix # devShells
      ./formatter.nix # Formatter
    ]
  );
}
