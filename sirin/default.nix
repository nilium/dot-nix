{
  self,
  nixpkgs,
  nix-hardware,
  home-manager,
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
            "steam-unwrapped"
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

  homeConfigurations."ncower@sirin" = let
    pkgs' = pkgs.extend (final: prev: {
      herbstluftwm = prev.herbstluftwm.overrideAttrs (old: {doCheck = false;});
    });
  in
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs';

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = let
        self' = self.homeManagerModules;
      in [
        # Use updated nix because of command deprecations.
        self'.unstable-nix

        self'.ncrandr
        self'.pact

        self'.packages-common
        self'.packages-linux
        self'.packages-local

        self'.afmt
        self'.fmt
        self'.git-tools
        self'.kitty
        (options @ {pkgs, ...}:
          self'.git (options
            // {
              signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJMs/x7sWSkjVY5tNBHlLOF6puCPljTWbbyUTL6rpnF";
            }))
        self'.scr
        self'.tmux
        self'.pueue
        self'.pbcopy
        self'.editors
        self'.nushell
        self'.fish
        self'.ssh
        {
          imports = [self'.hlwm];
          xsession.enable = true;
          programs.herbstluftwm.xsession = true;
        }

        ./home.nix
      ];
    };
}
