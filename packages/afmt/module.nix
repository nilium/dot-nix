self: {
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (self.packages.${pkgs.system}) afmt;
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.programs.afmt;
in {
  options.programs.afmt = {
    enable = mkEnableOption "Whether to enable afmt.";
    cmt = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Whether to enable cmt scripts.";
          name = mkOption {
            description = "The name of extra width-specific comment commands to generate.";
            type = types.str;
            default = "cmt";
          };
          widths = mkOption {
            description = "The widths to generate extra comment commands for.";
            type = types.listOf types.int;
            default = [72 80 100 120];
          };
        };
      };

      default = {
        name = "cmt";
        widths = [80 100 120];
      };
    };
  };
  config = let
    cmtScripts = self.lib.generators.cmtPackages {
      inherit pkgs;
      inherit (cfg.cmt) name widths;
    };
    cmtScripts' = lib.optionals cfg.cmt.enable cmtScripts;
  in
    mkIf cfg.enable {
      home.packages = [afmt] ++ cmtScripts';
    };
}
