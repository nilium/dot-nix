{pkgs, ...}: let
  fmtWidth = width: let
    width' = toString width;
    goal = toString (width - 2);
  in
    pkgs.writeShellScriptBin "fmt${width'}" ''
      exec ${pkgs.coreutils}/bin/fmt -w${width'} -g${goal} "$@"
    '';
in {
  home.packages = [
    (fmtWidth 72)
    (fmtWidth 80)
    (fmtWidth 100)
    (fmtWidth 120)
  ];
}
