{
  self,
  flake-utils,
  nixpkgs,
  ...
}:
{
  homeManagerModules.packages-local = {pkgs, ...}: let
    inherit (pkgs) system;
    inherit (pkgs.lib.lists) unique;
    packages = unique (builtins.attrValues self.packages.${system});
  in {
    home = {inherit packages;};
  };
}
// flake-utils.lib.eachDefaultSystem (system: let
  maintainer = final: prev: {
    lib = prev.lib.attrsets.recursiveUpdate prev.lib {
      maintainers.nilium = {
        email = "ncower@nil.dev";
        github = "nilium";
        githubId = 44962;
        name = "Noel Cower";
      };
    };
  };
  pkgs = import nixpkgs {
    inherit system;
    overlays = [maintainer];
  };
  build = path: pkgs.callPackage path {};
  ifLinux = pkgs.lib.ifEnable pkgs.stdenv.isLinux;
in {
  packages =
    {
      urlcode = build ./urlcode.nix;
      urltool = build ./urltool.nix;
      regen = build ./regen.nix;
      timeto = build ./timeto.nix;
      mtar = build ./mtar.nix;
    }
    // ifLinux {
      petri = build ./petri.nix;
    };
})
