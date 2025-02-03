{helix, ...}: {
  homeManagerModules.helix = {pkgs, ...}: {
    imports = [
      ./config.nix
      ./languages.nix
    ];

    programs.helix = {
      enable = true;
      defaultEditor = true;
      package = let
        helix-pkgs = helix.packages.${pkgs.system};
        helix-patched = helix-pkgs.helix-unwrapped.overrideAttrs (prev: {
          patches =
            (prev.patches or [])
            ++ [
              ./ruler-order.patch #
            ];
        });
      in
        helix-pkgs.helix.passthru.wrapper helix-patched;

      themes = {
        big-duo = import ./big-duo.nix;
        big-duo-l = import ./big-duo-l.nix;
      };
    };
  };
}
