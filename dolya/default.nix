{
  self,
  nixpkgs,
  home-manager,
  afmt,
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

      # afmt / cmt$Width
      afmt.homeManagerModules.afmt
      {
        programs.afmt.enable = true;
        programs.afmt.cmt.enable = true;
      }

      self'.fmt
      self'.packages-common

      # Shells
      self'.fish
      self'.nushell

      # Git scripts
      (self'.git {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmtTpCpIeFSE+nz8+mOD4+C3rpQtYCGCEIEBRRh9h+D";
      })
      self'.git-tools

      # Helix build and configuration
      self'.helix

      # tmux configuration
      self'.tmux
    ];
  };
}
