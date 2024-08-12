{helix, ...}: {
  homeManagerModules.helix = {pkgs, ...}: {
    imports = [
      ./config.nix
      ./languages.nix
    ];

    programs.helix = {
      enable = true;
      defaultEditor = true;
      package = helix.packages.${pkgs.system}.helix;

      themes = {
        big-duo = import ./big-duo.nix;
        big-duo-l = import ./big-duo-l.nix;
      };
    };
  };
}
