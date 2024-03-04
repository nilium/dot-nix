{pact}: {
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.pact;
in {
  options.programs.pact = {
    enable = mkEnableOption "Whether to enable pact.";
  };
  config = mkIf cfg.enable {
    home.packages = [pact];
  };
}
