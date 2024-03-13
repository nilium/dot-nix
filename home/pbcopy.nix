{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.pbcopy;

  pbcopy = pkgs.writeShellApplication {
    name = "pbcopy";
    runtimeInputs = [pkgs.xsel pkgs.coreutils];
    text = ''
      tee >(xsel --input --primary) | xsel --input --clipboard
    '';
  };

  pbpaste = pkgs.writeShellApplication {
    name = "pbpaste";
    runtimeInputs = [
      pkgs.xsel
    ];
    text = ''
      exec xsel --output --clipboard
    '';
  };
in {
  options.programs.pbcopy = {
    enable = mkEnableOption "Enable pbcopy and pbpaste.";
  };

  config = mkIf cfg.enable {
    home.packages = [pbcopy pbpaste];
  };
}
