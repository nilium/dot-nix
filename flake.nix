{
  description = "Noel's dotfiles flake library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable?dir=lib";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    lib = import ./lib.nix {
      inherit nixpkgs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-linux"
      ];
    };
  in
    lib.mkFlake {
      inherit inputs;

      outputs.lib = lib;

      # Add formatter.
      perSystem = {pkgs', ...}: {
        formatter = pkgs'.alejandra;
      };
    };
}
