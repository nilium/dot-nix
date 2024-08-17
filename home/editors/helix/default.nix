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
              ./pipe-trim.patch # Remove after 24.07 (https://github.com/helix-editor/helix/commit/535351067c2ac018ee2fef6cc685f49065617bd1)
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
