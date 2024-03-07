{
  lib,
  writeText,
  ...
}: let
  inherit (lib.lists) imap0;
  inherit (lib.strings) concatLines concatStrings toJSON;
  inherit (lib.attrsets) mergeAttrsList attrsToList mapAttrs';
  inherit (lib) range;

  quote = toJSON;

  named-steps = steps: name:
    mergeAttrsList (
      imap0
      (n: step: {"${name}-${toString n}" = step;})
      steps
    );

  gradient-steps = named-steps [
    color.cyshade1
    color.cyshade2
    color.cyshade3
    color.cyshade4
    color.cyshade5
    color.cyshade6
    color.yellow
    color.amber
    color.red
  ];

  withSuffix = suffix: attrs:
    mapAttrs' (name: value: {
      name = "${name}${suffix}";
      inherit value;
    })
    attrs;

  shade-steps = named-steps (map (i: color."cgshade${toString i}") (range 0 9));

  signal-steps = named-steps ["" "" "" "" "" "" "" "" "" ""];
  battery-steps = named-steps ["" "" "" "" ""];

  color = import ./polybar-colors.nix;

  stanzaGroup = sectionPrefix: group:
    concatStrings (
      map
      ({
        name,
        value,
      }: ''
        [${sectionPrefix}${name}]
        ${stanza value}
      '')
      (attrsToList group)
    );

  stanza = stanza:
    concatLines (
      map ({
        name,
        value,
      }: "${name} = ${quote value}") (attrsToList stanza)
    );

  config = let
    battery-module = for: default:
      {
        type = "internal/battery";
        battery = "\${env:${for}:${default}}";
        full-at = 99;
        adapter = "AC";
        poll-interval = 5;
        time-format = "%H:%M";
        format-charging = "🔌 <ramp-capacity> <label-charging>";
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-full = "<ramp-capacity> <label-full>";
        label-charging = "%percentage%%";
        label-discharging = "%percentage%% (%time%)";
        label-full = "%percentage%%";
        animation-charging-framerate = 750;
      }
      // (battery-steps "ramp-capacity")
      // (battery-steps "animation-charging");

    network-module = for: default: id:
      {
        type = "internal/network";
        interface = "\${env:${for}:${default}}";
        interval = 1.0;
        accumulate-stats = false;
        unknown-as-up = true;
        format-connected = "<ramp-signal> <label-connected>";
        format-disconnected = "<label-disconnected>";
        label-connected = "%${id}% (%local_ip%)";
        label-connected-foreground = color.fg;
        label-disconnected = "▼ %ifname% (Disconnected)";
        label-disconnected-foreground = color.grey;
      }
      // (signal-steps "ramp-signal")
      // (withSuffix "-foreground" (shade-steps "ramp-signal"));
  in {
    settings = {
      throttle-output = 5;
      throttle-output-for = 10;
      screenchange-reload = false;
      compositing-background = "source";
      compositing-foreground = "over";
      compositing-overline = "over";
      compositing-underline = "over";
      compositing-border = "over";
      format-foreground = color.fg;
    };

    global.wm = {
      margin-bottom = 10;
      margin-top = 0;
    };

    bar = let
      common = {
        monitor = "\${env:POLYBAR_MONITOR:eDP-1}";
        monitor-strict = true;
        monitor-exact = true;

        font-0 = "\${env:POLYBAR_NORMAL_FONT:Ubuntu Condensed:size=12;3}";
        font-1 = "\${env:POLYBAR_FIXED_FONT:PragmataPro:size=14;4}";

        override-redirect = false;
        bottom = true;
        fixed-center = true;
        width = "100%";
        height = 50;
        background = color.bg;
        radius = 0.0;
        overline-size = 4;
        underline-size = 0;
        border-bottom-size = 0;
        border-color = color.ac;
        padding = 2;
        module-margin-left = 2;
        module-margin-right = 2;
        modules-left = "workspaces";
        modules-center = "date battery";
        modules-right = "pulseaudio wlan lan";
        dim-value = 0.5;
        enable-ipc = true;
      };
    in {
      primary =
        common
        // {
          modules-right = "pulseaudio wlan lan tray";
        };
      secondary = common;
    };

    module.date = {
      type = "internal/date";
      interval = 1.0;
      time = " %H:%M:%S %p";
      time-alt = "%H:%M:%S";
      date = "%a %b %e";
      date-alt = "%Y-%m-%d";
      format = "<label>";
      label = "%date% %time%";
    };

    module.tray = {
      type = "internal/tray";
      tray-padding = "2px";
    };

    # TODO: support T480's dual batteries? I think that's the only machine I have that still has
    # more than one.
    module.battery = battery-module "POLYBAR_BAT0" "BAT1";

    module.lan = network-module "POLYBAR_LAN_IFACE" "eth0" "ifname";
    module.wlan = network-module "POLYBAR_WLAN_IFACE" "wlp3s0" "essid";

    module.pulseaudio =
      {
        type = "internal/pulseaudio";
        use-ui-max = true;
        interval = 5;
        bar-volume-width = 9;
        bar-volume-gradient = false;
        bar-volume-indicator-foreground = color.fg;
        bar-volume-indicator = "";
        bar-volume-indicator-font = 2;
        bar-volume-fill = "─";
        bar-volume-fill-font = 2;
        bar-volume-empty = "─";
        bar-volume-empty-font = 2;
        bar-volume-empty-foreground = color.grey;
        format-volume = " <bar-volume>";
        format-muted = " <bar-volume>";
        label-volume = "%percentage%%";
        label-muted = "Muted";
        label-muted-foreground = "#666";
      }
      // (gradient-steps "bar-volume-foreground");

    module.workspaces = {
      type = "internal/xworkspaces";
      pin-workspaces = false;
      enable-click = true;
      enable-scroll = true;
      icon-0 = "2;";
      icon-1 = "3;";
      icon-default = "";
      format = "<label-state>";
      format-padding = 0;
      label-monitor = "%name%";
      label-active-foreground = color.fg;
      label-active-background = color.bg;
      label-active-overline = color.ac;
      label-active-underline = color.ac;
      label-occupied-foreground = color.fg;
      label-occupied-underline = color.ae;
      label-occupied-overline = color.ae;
      label-urgent-foreground = color.red;
      label-urgent-underline = color.red;
      label-urgent-overline = color.red;
      label-empty-foreground = color.grey;
      label-active-padding = 2;
      label-urgent-padding = 2;
      label-occupied-padding = 2;
      label-empty-padding = 2;
    };
  };
in
  writeText "polybar-config" (concatStrings (
    map ({
      name,
      value,
    }:
      if builtins.all builtins.isAttrs (builtins.attrValues value)
      then stanzaGroup "${name}/" value
      else stanzaGroup "" {${name} = value;})
    (attrsToList config)
  ))
