{
  self,
  lib',
  ...
}:
lib'.mkFlake' {
  perSystem = {
    pkgs',
    self',
    ...
  }: {
    devShells.default = pkgs'.mkShell {
      buildInputs =
        [
          pkgs'.alejandra
          pkgs'.jq
          pkgs'.just
          pkgs'.nil
          pkgs'.git
          pkgs'.helix
          self'.packages.afmt
        ]
        ++ self.lib.generators.cmtPackages {pkgs = pkgs';};
    };
  };
}
