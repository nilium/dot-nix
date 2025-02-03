{
  self,
  nixpkgs,
  home-manager,
  ...
}: let
  system = "aarch64-darwin";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  homeConfigurations."ncower@zosim" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules = let
      self' = self.homeManagerModules;
    in [
      {
        home.username = "ncower";
        home.homeDirectory = "/Users/ncower";
        home.stateVersion = "23.11";
      }

      # Use updated nix because of command deprecations.
      self'.unstable-nix

      # afmt / cmt$Width / fmt$Width
      self'.afmt
      self'.fmt
      {
        programs.afmt.enable = true;
        programs.afmt.cmt.enable = true;
      }

      # Miscellaneous packages
      self'.packages-common
      self'.packages-local

      # Shells
      self'.fish
      {
        programs.rbenv = {
          enable = true;
          enableFishIntegration = true;
          plugins = [
            {
              name = "ruby-build";
              src = pkgs.fetchFromGitHub {
                owner = "rbenv";
                repo = "ruby-build";
                rev = "v20240727";
                hash = "sha256-OjTVSmJbf6ngRLS66+wLT8WscVwfYBxpXUP9X/RLbXs=";
              };
            }
          ];
        };
      }
      self'.nushell

      # Git scripts
      (options @ {pkgs, ...}:
        self'.git (options
          // {
            signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmtTpCpIeFSE+nz8+mOD4+C3rpQtYCGCEIEBRRh9h+D";
          }))
      self'.git-tools

      # Helix build and configuration
      self'.editors

      # tmux configuration
      self'.tmux
    ];
  };
}
