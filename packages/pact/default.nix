{
  self,
  nixpkgs,
  flake-utils,
  ...
}:
{
  homeManagerModules.pact = import ./module.nix self;
}
// flake-utils.lib.eachDefaultSystem (system: let
  pkgs = nixpkgs.legacyPackages.${system};
in
  # Don't build on macOS since it doesn't support sigwaitinfo.
  pkgs.lib.ifEnable (!pkgs.stdenv.isDarwin) {
    packages.pact = pkgs.callPackage ./package.nix {};
  })
