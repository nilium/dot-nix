{
  lib',
  self,
  fex,
  sql,
  ...
}:
lib'.merge' [
  ./editors

  {
    homeManagerModules = {
      unstable-nix = import ./unstable-nix.nix;

      packages-common = import ./pkgs-common.nix ({pkgs, ...}: {
        extraPackages = let
          inherit (pkgs) system;
        in [
          fex.packages.${system}.fex
          sql.packages.${system}.sql
        ];
      });
      packages-linux = import ./pkgs-linux.nix;

      alacritty = import ./alacritty.nix;
      clipit = import ./clipit.nix;
      fish = import ./fish.nix;
      fmt = import ./fmt.nix;
      git = import ./git.nix;
      git-tools = import ./git-tools;
      hlwm = args @ {pkgs, ...}: import ./hlwm self args;
      kitty = import ./kitty.nix;
      nushell = import ./nushell.nix;
      pbcopy = import ./pbcopy.nix;
      pueue = import ./pueue.nix;
      scr = import ./scr.nix;
      ssh = import ./ssh.nix;
      tmux = import ./tmux.nix;
    };
  }
]
