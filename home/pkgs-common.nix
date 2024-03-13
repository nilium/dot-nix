configure: inputs @ {pkgs, ...}: let
  config = configure inputs;
in {
  home.packages =
    (config.extraPackages or [])
    ++ [
      pkgs.coreutils

      pkgs.alejandra
      pkgs.bmake
      pkgs.bottom
      pkgs.curl
      pkgs.entr
      pkgs.fd
      pkgs.fzf
      pkgs.gh
      pkgs.git
      pkgs.gnumake
      pkgs.gnused
      pkgs.gnutar
      pkgs.jq
      pkgs.just
      pkgs.killall
      pkgs.miller
      pkgs.nil
      pkgs.ripgrep
      pkgs.socat
      pkgs.tokei
      pkgs.tree
      pkgs.unzip
      pkgs.wget

      # Compilers
      pkgs.crystal
      pkgs.go_1_22
      pkgs.rustup
    ];
}
