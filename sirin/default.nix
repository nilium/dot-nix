{
  nixpkgs,
  nixpkgs-unstable,
  flake-utils,
  home-manager,
  ncrandr,
  afmt,
  fex,
  pact,
  sql,
  helix,
  typst,
  ...
}: {
  system,
  lib,
}: let
  inherit (lib) flakePackages overlayFlakes;

  overlay-unstable = final: prev: {
    inherit (flakePackages helix) helix;
    typst = (flakePackages typst).default;

    ncower = (prev.ncower or {}) // lib.overlayFlakes [sql];
  };

  overlay-stable = final: prev: {
    inherit unstable;
    inherit (overlayFlakes [pact]) pact;
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    overlays = [overlay-unstable];
  };

  pkgs = import nixpkgs {
    inherit system;
    overlays = [overlay-stable];
  };
in {
  nixosConfigurations.sirin = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      nixpkgs.nixosModules.notDetected
      ../users/ncower.nix
      ../system/xorg.nix
      ../sirin/configuration.nix
    ];
  };

  homeConfigurations."ncower@sirin" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    # Specify your home configuration modules here, for example,
    # the path to your home.nix.
    modules = [
      afmt.homeManagerModules.afmt
      ncrandr.homeManagerModules.ncrandr
      pact.homeManagerModules.pact
      {
        home.packages = [(flakePackages fex).fex];
      }
      {
        imports = [
          ../modules/pbcopy.nix
          ../fish/default.nix
        ];
      }
      ../git-tools/git-tools.nix
      ../home/kitty.nix
      ../home/git.nix
      ../home/scr.nix
      ../home/tmux.nix
      ../home/pueue.nix
      (import ../home/helix {inherit (overlayFlakes [helix]) helix;})
      ../home/nushell.nix
      ../home/fish.nix
      ../home/ssh.nix
      (import ../home/hlwm (overlayFlakes [ncrandr]))
      ../home.nix
    ];
  };
}
