{pkgs, ...}: let
  git-tools = pkgs.callPackage ./default.nix {};
in {
  home.packages = [git-tools];
}
