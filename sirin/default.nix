{
  nixpkgs,
  ntk,
  home-manager,
  ncrandr,
  afmt,
  fex,
  pact,
  sql,
  helix,
  typst,
  ...
}: let
  system = "x86_64-linux";
  inherit (ntk.lib.forSystem system) flakePackages overlayFlakes;

  extra-packages = final: prev: {
    inherit (overlayFlakes [pact]) pact;
    inherit (flakePackages helix) helix;
    typst = (flakePackages typst).default;
    ncower = (prev.ncower or {}) // overlayFlakes [sql];
  };

  pkgs = import nixpkgs {
    inherit system;
    overlays = [extra-packages];
  };
in {
  nixosConfigurations.sirin = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      nixpkgs.nixosModules.notDetected

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

      ../users/ncower.nix
      # Use updated nix because of command deprecations.
      ../home/unstable-nix.nix
      ../system/xorg.nix
      ./configuration.nix
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
    modules = [
      # Use updated nix because of command deprecations.
      ../home/unstable-nix.nix

      afmt.homeManagerModules.afmt
      ncrandr.homeManagerModules.ncrandr
      pact.homeManagerModules.pact
      {
        home.packages = [(flakePackages fex).fex];
      }
      ../home/pkgs-common.nix
      ../home/pkgs-linux.nix
      {
        imports = [
          ../modules/pbcopy.nix
          ../fish/default.nix
          ../home/fmt.nix
        ];
      }
      ../git-tools/git-tools.nix
      ../home/kitty.nix
      (import ../home/git.nix {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJMs/x7sWSkjVY5tNBHlLOF6puCPljTWbbyUTL6rpnF";
      })
      ../home/scr.nix
      ../home/tmux.nix
      ../home/pueue.nix
      (import ../home/helix {inherit (overlayFlakes [helix]) helix;})
      ../home/nushell.nix
      ../home/fish.nix
      ../home/ssh.nix
      (import ../home/hlwm (overlayFlakes [ncrandr]))

      ./home.nix
    ];
  };
}
