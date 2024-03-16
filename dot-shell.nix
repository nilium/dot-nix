{
  self,
  nixpkgs,
  flake-utils,
  ...
}:
flake-utils.lib.eachDefaultSystem (
  system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.default = pkgs.mkShell {
      buildInputs =
        [
          pkgs.alejandra
          pkgs.nil
          pkgs.just
          self.packages.${system}.afmt
        ]
        ++ self.lib.generators.cmtPackages {inherit pkgs;};
    };
  }
)
