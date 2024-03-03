{pkgs, ...}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "scr";
      paths = let
        screenshotBin = name: args:
          pkgs.writeShellApplication {
            inherit name;
            runtimeInputs = [pkgs.maim];
            text = ''
              printf -v fname 'screenshot-%(%Y-%m-%dT%H:%M:%S)T.png'
              exec maim ${builtins.concatStringsSep " " args} "$@" "$HOME/$fname"
            '';
          };
      in [
        (screenshotBin "scr" ["--select" "--hidecursor"])
        (screenshotBin "scr10" ["--select" "--delay=10" "--hidecursor"])
        (screenshotBin "scr10-cursor" ["--select" "--delay=10"])
      ];
    })
  ];
}
