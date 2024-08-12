{
  self,
  nixpkgs,
  home-manager,
  nixgl,
  ...
}: let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    overlays = [nixgl.overlay];
  };

  inherit (nixpkgs) lib;

  unfreePackages = [
    "1password-gui"
    "1password-cli"
    "1password"
    "discord"
  ];

  allowUnfreePackages = pkg: builtins.elem (lib.getName pkg) unfreePackages;
in {
  homeConfigurations."ncower@veles" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules = let
      self' = self.homeManagerModules;
    in [
      ({pkgs, ...}: {
        nixpkgs.config.allowUnfreePredicate = allowUnfreePackages;

        home.username = "ncower";
        home.homeDirectory = "/home/ncower";
        home.stateVersion = "23.11";

        programs.firefox.enable = true;

        home.packages = [
          pkgs.nixgl.auto.nixGLDefault
          pkgs.herbstluftwm
        ];

        home.keyboard.options = [
          "caps:escape"
        ];
      })

      self'.unstable-nix

      {
        imports = [
          self'.afmt
          self'.fmt
        ];
        programs.afmt.enable = true;
        programs.afmt.cmt.enable = true;
      }

      self'.ncrandr
      self'.pact

      # Miscellaneous packages
      self'.packages-common
      self'.packages-linux
      self'.packages-local

      self'.scr
      {
        imports = [self'.pbcopy];
        programs.pbcopy.enable = true;
      }

      # Shells
      self'.nushell
      self'.fish

      # Git scripts
      (self'.git {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzRhuWCCAdX/4cYxS44BoILW0Frwpkf8R32yoMg068f";
      })
      self'.git-tools

      # Helix build and configuration
      self'.editors

      # tmux configuration
      self'.tmux

      self'.ssh
      self'.kitty

      ({pkgs, ...}: {
        imports = [
          self'.hlwm
        ];

        programs.rofi = {
          enable = true;
          theme = "Arc-Dark";
        };

        # Use startx.
        # Use systemctl to disable display manager on Ubuntu.
        # $ systemctl set-default multi-user.target
        xsession.enable = true;
        programs.herbstluftwm = {
          xsession = true;
          extraSettings = let
            xset = "${pkgs.xorg.xset}/bin/xset";
            xss-lock = "${pkgs.xss-lock}/bin/xss-lock";
          in ''
            in_session ${xss-lock} -l -- /usr/bin/i3lock - -e -f -c 040108 &
            ${xset} +fp $HOME/.local/share/fonts
            ${xset} fp rehash
          '';
        };
      })
    ];
  };
}
