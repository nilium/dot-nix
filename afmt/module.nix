{afmt}: {
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.programs.afmt;
in {
  options.programs.afmt = {
    enable = mkEnableOption "Whether to enable afmt.";
    cmt = mkOption {
      type = types.submodule {
        options = {
          name = mkOption {
            description = "The name of extra width-specific comment commands to generate.";
            type = types.str;
          };
          widths = mkOption {
            description = "The widths to generate extra comment commands for.";
            type = types.listOf types.int;
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
    cmtWidth = width: let
      width' = toString width;
      goal = toString (width - 2);
    in
      pkgs.writeShellApplication {
        name = "${cfg.cmt.name}${width'}";
        text = ''exec ${afmt}/bin/afmt -w${width'} -g${goal} "''$@"'';
      };
  in
    mkIf cfg.enable {
      home.packages = [afmt] ++ map cmtWidth cfg.cmt.widths;
    };
}
