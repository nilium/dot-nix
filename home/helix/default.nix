{helix, ...}: input @ {pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = helix;

    settings = import ./config.nix input;
    languages = import ./languages.nix input;
    themes = {
      big-duo = import ./big-duo.nix;
      big-duo-l = import ./big-duo-l.nix;
    };
  };
}
