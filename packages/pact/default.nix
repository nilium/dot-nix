{
  self,
  lib',
  ...
}:
lib'.mkFlake' {
  outputs.homeManagerModules.pact = import ./module.nix self;

  perSystem = {pkgs', ...}:
  # Don't build on macOS since it doesn't support sigwaitinfo.
    pkgs'.lib.ifEnable (!pkgs'.stdenv.isDarwin) {
      packages.pact = pkgs'.callPackage ./package.nix {};
    };
}
