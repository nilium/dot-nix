{
  description = "Jamey Sharp's pact";

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
      homeManagerModules.pact = {pkgs, ...}: {
        imports = [
          (import ./module.nix {
            inherit (self.packages.${pkgs.system}) pact;
          })
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) stdenv fetchFromGitHub;

        pact = stdenv.mkDerivation {
          name = "pact"; # No version, so no pname / version.
          src = fetchFromGitHub {
            owner = "jameysharp";
            repo = "pact";
            rev = "533341958e3a4b6809b0a01ad74e921cdb570320";
            hash = "sha256-WhVq2ue1aGDt2g236565sDt9rlvHbHMH/F3isZCIgxk=";
          };

          installPhase = ''
            mkdir -p "$out/bin"
              install pact "$out/bin/pact"
          '';
        };
      in {
        packages = {
          inherit pact;
          default = pact;
        };
      }
    );
}
