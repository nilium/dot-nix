{
  self,
  helix,
  fex,
  sql,
  ...
}: {
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
    fish = _: {
      imports = [
        ./fish.nix
        ../fish/default.nix
      ];
    };
    fmt = import ./fmt.nix;
    git = import ./git.nix;
    git-tools = import ./git-tools;
    helix = {pkgs, ...}: let
      inherit (pkgs) system;
      helix' = helix.packages.${system}.helix;
    in {
      imports = [./helix];
      programs.helix.package = helix';
    };
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
