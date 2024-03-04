{pkgs, ...}: let
  inherit (pkgs) lib stdenv;

  inherit (pkgs) herbstluftwm pact gawk coreutils hsetroot xorg;
  ncrandr = pkgs.ncower.ncrandr;
  inherit (xorg) xmodmap xset;

  autostart = stdenv.mkDerivation {
    name = "hlwm-autostart";
    src = ./autostart;

    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out/bin"
      install $src "$out/bin/autostart"
      wrapProgram "$out/bin/autostart" \
        --prefix PATH : ${lib.makeBinPath [ncrandr pact hsetroot xmodmap xset]} \
        --suffix PATH : ${lib.makeBinPath [herbstluftwm gawk coreutils]}
    '';

    nativeBuildInputs = [pkgs.makeWrapper];
  };

  hlwm-use = pkgs.writeShellApplication {
    name = "hlwm-use";
    runtimeInputs = [herbstluftwm];
    text = ''
      num_monitors="$(herbstclient attr monitors.count)"
      focus_monitor_idx="$(herbstclient attr monitors.focus.index)"
      locked_monitors=()

      herbstclient lock
      for ((i=0; i < "$num_monitors"; i++)); do
        if [[ "$i" != "$focus_monitor_idx" ]]; then
          locked_monitors+=("$i")
          herbstclient lock_tag "$i"
        fi
      done
      herbstclient "$@"
      for i in "''${locked_monitors[@]}"; do
        herbstclient unlock_tag "$i"
      done
      herbstclient unlock
    '';
  };
in {
  home.packages = [
    hlwm-use
  ];

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.herbstluftwm}/bin/herbstluftwm";
  };

  xdg.configFile."herbstluftwm/autostart".source = pkgs.writeShellScript "herbstluftwm-autostart" ''
    exec ${autostart}/bin/autostart
  '';
}
