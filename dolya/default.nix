{
  self,
  nixpkgs,
  home-manager,
  jujutsu,
  ...
}: let
  system = "aarch64-darwin";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  homeConfigurations."ncower@dolya" = home-manager.lib.homeManagerConfiguration {
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

      # Testing jj.
      ({pkgs, ...}: let
        jj = jujutsu.packages.${pkgs.system}.jujutsu;
      in {
        home.packages = [
          jj
        ];
      })

      # Shells
      self'.fish
      self'.nushell

      # Git scripts
      (self'.git {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmtTpCpIeFSE+nz8+mOD4+C3rpQtYCGCEIEBRRh9h+D";
      })
      self'.git-tools

      # Helix build and configuration
      self'.editors

      # tmux configuration
      self'.tmux
    ];
  };
}
