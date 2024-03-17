{
  self,
  lib',
  ...
}:
lib'.mkFlake' {
  outputs.homeManagerModules.afmt = import ./module.nix self;
  outputs.lib.generators.cmtPackages = import ./cmt.nix self;

  perSystem = {pkgs', ...}: {
    packages.afmt = pkgs'.callPackage ./package.nix {};
  };
}
