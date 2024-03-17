{
  self,
  lib',
  ...
}:
lib'.mkFlake' {
  outputs.homeManagerModules.ncrandr = import ./module.nix self;

  perSystem = {pkgs', ...}: {
    packages.ncrandr = pkgs'.callPackage ./package.nix {};
  };
}
