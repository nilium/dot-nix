{pkgs, ...}: {
  # Note: home-manager's toKDL function isn't usable as of this writing, so just generate the
  # config manually. Avoid programs.zellij because it might accidentally generate a config file
  # later.
  home.packages = [pkgs.zellij];
  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
