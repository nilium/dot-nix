{
  description = "Comment-formatting wrapper for GNU fmt";

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
      homeManagerModules.afmt = {pkgs, ...}: {
        imports = [
          (import ./module.nix {
            inherit (self.packages.${pkgs.system}) afmt;
          })
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib crystal coreutils;

        afmt = crystal.buildCrystalPackage {
          pname = "afmt";
          version = "0.1.0";
          src = lib.sources.sourceByRegex (lib.sources.cleanSource ./.) [
            "^src$"
            ".*\.cr$"
            "(^|/)shard\.(lock|yml)$"
          ];
          format = "shards";
          crystalBinaries.afmt.src = "src/afmt.cr";
          fmt_bin = "${coreutils}/bin/fmt";
          propagatedBuildInputs = [coreutils];
        };
      in {
        packages = {
          default = afmt;
          inherit afmt;
        };
      }
    );
}
