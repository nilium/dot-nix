{
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  terminal_font = "Pragmata Pro Mono Liga";
  unstable = pkgs.unstable;
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-gui"
      "1password-cli"
      "1password"
      "discord"
    ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ncower";
  home.homeDirectory = "/home/ncower";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = let
    inherit (pkgs) ncower;
  in [
    pkgs.alejandra
    pkgs.blueman
    pkgs.bmake
    pkgs.brightnessctl
    pkgs.curl
    pkgs.ectool
    pkgs.entr
    pkgs.fd
    pkgs.firefox
    pkgs.framework-tool
    pkgs.fzf
    pkgs.gnumake
    pkgs.gnused
    pkgs.hsetroot
    pkgs.htop
    pkgs.killall
    pkgs.lld
    pkgs.maim
    pkgs.miller
    pkgs.pavucontrol
    pkgs.ripgrep
    pkgs.rofi
    pkgs.socat
    pkgs.tokei
    pkgs.unzip
    pkgs.xsel
    pkgs.xss-lock
    pkgs.ruby
    unstable.mise

    # Fonts
    pkgs.alegreya
    pkgs.comic-mono
    pkgs.font-awesome_4
    pkgs.ubuntu_font_family
    pkgs.uiua386

    # Compilers
    pkgs.gcc
    unstable.crystal
    unstable.go_1_22
    pkgs.rustup

    # Customized
    (pkgs.polybar.override {
      alsaSupport = true;
      mpdSupport = true;
      pulseSupport = true;
    })

    # Non-free
    pkgs._1password-gui
    pkgs._1password
    pkgs.discord

    # Mine
    pkgs.nil
    ncower.sql

    (pkgs.writeShellApplication {
      name = "hlwm-use";
      runtimeInputs = [pkgs.herbstluftwm];
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
    })

    (pkgs.writeScriptBin "batteries" ''
      #!${pkgs.fish}/bin/fish
      set upower ${pkgs.upower}/bin/upower
      for battery in ($upower --enumerate | ${pkgs.gnugrep}/bin/grep /battery_BAT)
        $upower --show-info $battery
      end
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ncower/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.pbcopy.enable = !isDarwin;

  programs.afmt.enable = true;

  programs.pact.enable = true;

  programs.ncrandr = {
    enable = true;
    configs = let
      herbstclient = "${pkgs.herbstluftwm}/bin/herbstclient";
      config = outputs: {
        inherit outputs;
        post = "${herbstclient} reload";
      };

      # Sirin screen IDs:
      # Laptop    fYl/+WuqJqD3jd5KDKdiCwVLbjDDzjWTN9QqlNfTIC0=
      # Portrait  QpOzw43/FtKcAue8crHd8nD6mv23SIHng0KNfFOadow=
      # Landscape VWKMrBqP82yw4QqfuSglEdud4YYFpo+sqjyHRShnlys=
      # Additional screen IDs can be found by plugging them in and running ncrandr to list them.
      laptop = opts: {
        "fYl/+WuqJqD3jd5KDKdiCwVLbjDDzjWTN9QqlNfTIC0=" = opts ++ ["--mode" "2256x1504" "--rotate" "normal"];
      };

      externals = {
        "QpOzw43/FtKcAue8crHd8nD6mv23SIHng0KNfFOadow=" = ["--primary" "--rate" "120.0" "--mode" "2560x1440" "--pos" "1440x639" "--rotate" "normal"];
        "VWKMrBqP82yw4QqfuSglEdud4YYFpo+sqjyHRShnlys=" = ["--rate" "59.95" "--mode" "2560x1440" "--pos" "0x0" "--rotate" "left"];
      };

      with-laptop = externals // laptop ["--pos" "1592x1879"];
    in {
      slap = config (laptop ["--primary" "--pos" "0x0"]);
      slork = config externals;
      swork = config with-laptop;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;

    # Custom plugins.
    cz-fg.enable = true;
    ep.enable = true;

    functions.fish_greeting = "";
    interactiveShellInit = ''
      fish_add_path -p --move "$(${pkgs.ruby}/bin/gem environment user_gemdir)/bin"
      fish_add_path -p --move "$HOME/.cargo/bin"
      fish_add_path -p --move "$HOME/bin"

      set -g -x EDITOR hx
    '';
  };

  programs.ssh = {
    enable = true;
    forwardAgent = false;
    extraOptionOverrides.CanonicalizeHostname = "yes";
    includes = ["config-local"];
  };

  # Keep kitty and alacritty configured. If one doesn't work, the other probably also doesn't work
  # (fun act: the Intel video driver on the Framework is for some reason a problem for these,
  # so xterm is also important [or just do stuff in a tty]).
  programs.kitty = {
    enable = true;

    theme = "duckbones";
    font = {
      name = terminal_font;
      size = 10;
    };

    shellIntegration.enableFishIntegration = true;

    keybindings = {
      "ctrl+alt+r" = "load_config_file";
      "alt+6" = "set_font_size 10";
      "alt+7" = "set_font_size 11";
      "alt+8" = "set_font_size 13";
      "alt+9" = "set_font_size 16";
      "alt+0" = "set_font_size 20";
      "ctrl+;" = "send_text all \\x1b;";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+c" = "copy_to_clipboard";
    };

    extraConfig = ''
      enable_audio_bell no
      bell_on_tab no
      disable_ligatures always
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true;
      dynamic_title = true;
      scrolling.history = 10000;
      font = let
        fontdef = merge: {family = terminal_font;} // merge;
      in {
        normal = fontdef {};
        bold = fontdef {};
        italic = fontdef {};
        size = 7;
      };

      # Colors (Blood Moon)
      colors = {
        # Default colors
        primary = {
          background = "0x10100E";
          foreground = "0xC6C6C4";
        };

        # Normal colors
        normal = {
          black = "0x10100E";
          red = "0xC40233";
          green = "0x009F6B";
          yellow = "0xFFD700";
          blue = "0x0087BD";
          magenta = "0x9A4EAE";
          cyan = "0x20B2AA";
          white = "0xC6C6C4";
        };

        # Bright colors
        bright = {
          black = "0x696969";
          red = "0xFF2400";
          green = "0x03C03C";
          yellow = "0xFDFF00";
          blue = "0x007FFF";
          magenta = "0xFF1493";
          cyan = "0x00CCCC";
          white = "0xFFFAFA";
        };
      };
    };
  };

  services.pueue = {
    enable = true;
    settings = {
      shared = {
        pueue_directory = "~/.local/share/pueue";
        use_unix_socket = true;
      };

      daemon = {
        groups.default = 4;
      };
    };
  };

  services.parcellite = {
    enable = true;
    package = pkgs.clipit;
    extraOptions = ["--no-icon"];
  };

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.herbstluftwm}/bin/herbstluftwm";
  };
}
