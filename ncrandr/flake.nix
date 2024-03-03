{
  description = "Personal xrandr configuration script";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    {
      homeManagerModules.ncrandr = {pkgs, ...}: {
        imports = [
          (import ./module.nix {
            inherit (self.packages.${pkgs.system}) ncrandr;
          })
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib crystal xorg;
        inherit (xorg) xrandr;

        ncrandr = crystal.buildCrystalPackage {
          pname = "ncrandr";
          version = "0.1.0";
          src = lib.sources.sourceByRegex (lib.sources.cleanSource ./.) [
            "^src$"
            ".*\.cr$"
            "(^|/)shard\.(lock|yml)$"
          ];
          format = "shards";
          crystalBinaries.ncrandr.src = "src/ncrandr.cr";
          xrandr_bin = "${xrandr}/bin/xrandr";
          propagatedBuildInputs = [xrandr];
        };
      in {
        packages = {
          inherit ncrandr;
          default = ncrandr;
        };
      }
    );
}
