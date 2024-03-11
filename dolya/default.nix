{
  nixpkgs,
  ntk,
  home-manager,
  afmt,
  fex,
  helix,
  sql,
  ...
}: let
  system = "aarch64-darwin";
  inherit (ntk.lib.forSystem system) flakePackages overlayFlakes;

  extra-packages = final: prev: {
    inherit (flakePackages helix) helix;
    # typst = (flakePackages typst).default;
    ncower = (prev.ncower or {}) // overlayFlakes [sql];
  };

  pkgs = import nixpkgs {
    inherit system;
    overlays = [extra-packages];
  };
in {
  homeConfigurations."ncower@dolya" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules = [
      {
        home.username = "ncower";
        home.homeDirectory = "/Users/ncower";
        home.stateVersion = "23.11";
      }

      # Use updated nix because of command deprecations.
      ../home/unstable-nix.nix

      # afmt / cmt$Width
      afmt.homeManagerModules.afmt
      {
        programs.afmt.enable = true;
        programs.afmt.cmt.enable = true;
      }
      {
        imports = [
          ../home/fmt.nix
        ];
      }

      # Personal software
      {
        home.packages = [
          (flakePackages fex).fex
          (flakePackages sql).sql
        ];
      }

      # Shells
      {
        imports = [
          ../fish/default.nix
        ];
      }
      ../home/fish.nix
      ../home/nushell.nix

      # Git scripts
      (import ../home/git.nix {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmtTpCpIeFSE+nz8+mOD4+C3rpQtYCGCEIEBRRh9h+D";
      })
      ../git-tools/git-tools.nix

      # Helix build and configuration
      (import ../home/helix {inherit (overlayFlakes [helix]) helix;})

      # Misc packages
      {
        home.packages = [
          pkgs.alejandra
          pkgs.bmake
          pkgs.curl
          pkgs.entr
          pkgs.fd
          pkgs.fzf
          pkgs.gh
          pkgs.git
          pkgs.gnumake
          pkgs.gnused
          pkgs.htop
          pkgs.jq
          pkgs.just
          pkgs.miller
          pkgs.nil
          pkgs.ripgrep
          pkgs.socat
          pkgs.tokei
          pkgs.tree
          pkgs.unzip
          pkgs.ruby
          pkgs.wget

          pkgs.crystal
          pkgs.go_1_22
          pkgs.rustup
        ];
      }

      # tmux configuration
      ../home/tmux.nix
    ];
  };
}
