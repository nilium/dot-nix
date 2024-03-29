self: {
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (pkgs) system writeShellApplication;
  inherit
    (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ifEnable
    attrsToList
    hasAttr
    ;
  inherit (self.packages.${system}) ncrandr;
  cfg = config.programs.ncrandr;
in {
  options.programs.ncrandr = {
    enable = mkEnableOption "Whether to enable ncrandr.";
    configs = mkOption {
      description = "Script configurations to generate";
      type = types.attrsOf (types.submodule {
        options = {
          outputs = mkOption {
            description = "The options to apply to a given output, either by ID or hash.";
            type = types.attrsOf (types.listOf types.str);
          };
          post = mkOption {
            description = ''Script to run after running ncrandr. (E.g., "herbstclient reload")'';
            type = types.str;
            default = "";
          };
        };
      });
    };
  };
  config = mkIf cfg.enable {
    home.packages =
      [
        pkgs.xorg.xrandr
        ncrandr
      ]
      ++ (map ({
        name,
        value,
      }: let
        hasElse = hasAttr "else" value;
        autoElse = ifEnable (!hasElse) ["--output" "__else__" "--off"];
        outputName = output:
          if output == "else"
          then "__else__"
          else output;

        outputs =
          (builtins.foldl' (acc: {
              name,
              value,
            }:
              acc ++ ["--output" (outputName name)] ++ value)
            []
            (attrsToList value.outputs))
          ++ autoElse;
      in
        writeShellApplication {
          inherit name;
          runtimeInputs = [ncrandr pkgs.xorg.xrandr];
          text = ''
            set -e
            ncrandr set ${lib.strings.escapeShellArgs outputs}
            ${value.post}
          '';
        }) (attrsToList cfg.configs));
  };
}
