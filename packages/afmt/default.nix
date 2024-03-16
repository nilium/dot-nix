{
  self,
  nixpkgs,
  flake-utils,
  ...
}:
{
  homeManagerModules.afmt = import ./module.nix self;
  lib.generators.cmtPackages = import ./cmt.nix self;
}
// flake-utils.lib.eachDefaultSystem (system: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  packages.afmt = pkgs.callPackage ./package.nix {};
})
