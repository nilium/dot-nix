{
  self,
  nixpkgs,
  flake-utils,
  ...
}:
{
  homeManagerModules.ncrandr = import ./module.nix self;
}
// flake-utils.lib.eachDefaultSystem (system: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  packages.ncrandr = pkgs.callPackage ./package.nix {};
})
