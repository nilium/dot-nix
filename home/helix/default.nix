{
  imports = [
    ./config.nix
    ./languages.nix
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;

    themes = {
      big-duo = import ./big-duo.nix;
      big-duo-l = import ./big-duo-l.nix;
    };
  };
}
