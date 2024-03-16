{
  self,
  nixpkgs,
  nix-hardware,
  home-manager,
  ncrandr,
  afmt,
  pact,
  typst,
  ...
}: let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  nixosConfigurations.sirin = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = let
      self' = self.nixosModules;
    in [
      nixpkgs.nixosModules.notDetected
      nix-hardware.nixosModules.framework-13th-gen-intel

      # Non-free packages
      ({pkgs, ...}: let
        inherit (pkgs) lib;
      in {
        nixpkgs.config.allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-original"
            "steam-run"
          ];
      })

      # Use updated nix because of command deprecations.
      self'.unstable-nix
      ./configuration.nix

      self'.user-ncower
      self'.xorg

      {
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true;
        };
      }
    ];
  };

  homeConfigurations."ncower@sirin" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    # Specify your home configuration modules here, for example,
    # the path to your home.nix.
    modules = let
      self' = self.homeManagerModules;
    in [
      # Use updated nix because of command deprecations.
      self'.unstable-nix

      afmt.homeManagerModules.afmt
      ncrandr.homeManagerModules.ncrandr
      pact.homeManagerModules.pact

      self'.packages-common
      self'.packages-linux
      self'.packages-local
      ({pkgs, ...}: {
        home.packages = [typst.packages.${system}.default];
      })

      self'.fmt
      self'.git-tools
      self'.kitty
      (self'.git {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJMs/x7sWSkjVY5tNBHlLOF6puCPljTWbbyUTL6rpnF";
      })
      self'.scr
      self'.tmux
      self'.pueue
      self'.pbcopy
      self'.helix
      self'.nushell
      self'.fish
      self'.ssh
      self'.hlwm

      ./home.nix
    ];
  };
}
