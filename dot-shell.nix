{
  nixpkgs,
  flake-utils,
  afmt,
  ...
}:
flake-utils.lib.eachDefaultSystem (
  system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.default = pkgs.mkShell {
      buildInputs = [
        pkgs.alejandra
        pkgs.nil
        pkgs.just
        afmt.packages.${system}.default
      ];
    };
  }
)
