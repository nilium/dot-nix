{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkMerge mkIf mkEnableOption;
  cfg = config.programs.fish;
in {
  options.programs.fish = {
    cz-fg.enable = mkEnableOption "Enable fish customizations";
    ep.enable = mkEnableOption "Enable fish customizations";
  };

  config = mkMerge [
    (mkIf cfg.cz-fg.enable {
      programs.fish.plugins = [
        {
          name = "cz-fg";
          src = pkgs.writeTextDir "conf.d/cz-fg.fish" ''
            bind \cz 'fg 2>/dev/null; commandline -f repaint'
          '';
        }
      ];
    })
    (mkIf cfg.ep.enable {
      programs.fish.plugins = [
        {
          name = "ep";
          src = (pkgs.callPackage ./ep {}) + "/share/fish-ep";
        }
      ];
    })
  ];
}
