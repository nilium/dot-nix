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
          pkgs.jq
          pkgs.just
          pkgs.nil
          self.packages.${system}.afmt
        ]
        ++ self.lib.generators.cmtPackages {inherit pkgs;};
    };
  }
)
