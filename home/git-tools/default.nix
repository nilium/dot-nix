{pkgs, ...}: let
  git-tools = pkgs.callPackage ./package.nix {};
in {
  home.packages = [git-tools];
}
