{
  ncrandr,
  pact,
  ...
}: {pkgs, ...}: let
  inherit (pkgs) lib stdenv system;
  inherit (pkgs) herbstluftwm gnugrep gawk coreutils hsetroot xorg;
  inherit (xorg) xmodmap xset;

  pact' = pact.packages.${system}.default;

  polybar = pkgs.polybar.override {
    alsaSupport = true;
    mpdSupport = true;
    pulseSupport = true;
  };

  autostart = stdenv.mkDerivation {
    name = "hlwm-autostart";
    src = ./autostart;

    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out/bin"
      install $src "$out/bin/autostart"
      wrapProgram "$out/bin/autostart" \
        --prefix PATH : ${lib.makeBinPath [ncrandr pact' hsetroot xmodmap xset]} \
        --suffix PATH : ${lib.makeBinPath [polybar herbstluftwm gawk gnugrep coreutils]}
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

  polybar-config = pkgs.callPackage ./polybar.nix {};
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

  xdg.configFile."herbstluftwm/polybar.ini".source = polybar-config;
}
