# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 16;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_11;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  programs.xwayland.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;

    # Use modesetting.
    videoDrivers = ["modesetting" "intel"];

    # Use xsession.
    desktopManager.session = [
      {
        name = "xsession";
        start = ''
          ${pkgs.runtimeShell} $HOME/.xsession &
          waitPID=$!
        '';
      }
    ];

    xkb = {
      layout = "us";
      options = "caps:escape";
    };

    # Disable synpatics because it's bad.
    synaptics.enable = false;
  };

  # Enable libinput support for touchpad / mouse.
  services.libinput = {
    enable = true;

    # Natural scrolling for regular mice.
    mouse = {
      naturalScrolling = true;
    };

    # Natural scrolling and the other usual options for touchpads.
    touchpad = {
      accelSpeed = "0.17";
      naturalScrolling = true;
      disableWhileTyping = true;
      tapping = true;
      # Don't reserve small regions of the touchpad to act as tappable buttons.
      clickMethod = "clickfinger";
    };
  };

  # Enable TLP.
  services.tlp.enable = true;

  # Trim.
  services.fstrim.enable = true;

  # Enable firmware updates.
  services.fwupd.enable = true;

  # Enable Tailscale.
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Enable CUPS to print documents.
  # Note: not right now. I don't have the patience.
  # services.printing.enable = true;

  # Polkit.
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll" && (subject.isInGroup("users") || subject.isInGroup("wheel"))) {
        return polkit.Result.YES;
      }
    })
  '';

  # Fingerprint reader.
  services.fprintd.enable = true;

  security.pam.services = let
    lid-is-open = pkgs.writeShellApplication {
      name = "pam-lid-is-open";
      runtimeInputs = [pkgs.gnugrep];
      text = ''
        set -eu
        ${pkgs.gnugrep}/bin/grep -qPe 'state:[[:space:]]*closed' "$1"
      '';
    };
    text = ''
      # Account management.
      account required pam_unix.so # unix (order 10900)

      # Authentication management.
      auth sufficient pam_unix.so likeauth try_first_pass # unix (order 11600)
      auth [success=1 default=ignore] pam_exec.so quiet ${lid-is-open}/bin/pam-lid-is-open /proc/acpi/button/lid/LID0/state
      auth sufficient /nix/store/fq4vbhdk8dqywxirg3wb99zidfss7sbi-fprintd-1.94.2/lib/security/pam_fprintd.so timeout=10 # fprintd (order 11400)
      auth required pam_deny.so # deny (order 12400)

      # Password management.
      password sufficient pam_unix.so nullok yescrypt # unix (order 10200)

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
      session required pam_unix.so # unix (order 10200)
    '';
  in {
    i3lock.text = text;
    i3lock-color.text = text;

    sudo.text = ''
      # Account management.
      account required pam_unix.so # unix (order 10900)

      # Authentication management.
      auth sufficient pam_unix.so likeauth try_first_pass # unix (order 11600)
      auth [success=1 default=ignore] pam_exec.so quiet ${lid-is-open}/bin/pam-lid-is-open /proc/acpi/button/lid/LID0/state
      auth sufficient /nix/store/fq4vbhdk8dqywxirg3wb99zidfss7sbi-fprintd-1.94.2/lib/security/pam_fprintd.so timeout=10 # fprintd (order 11400)
      auth required pam_deny.so # deny (order 12400)

      # Password management.
      password sufficient pam_unix.so nullok yescrypt # unix (order 10200)

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
      session required pam_unix.so # unix (order 10200)
    '';
  };

  # Enable sound.
  # NOTE: sound.enable removed, pipewire enabled by default.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;

  # OpenGL.
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [
    pkgs.mesa
    pkgs.mesa.drivers
    pkgs.vaapiIntel
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
    pkgs.intel-media-driver
  ];

  # Bluetooth.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set up regular user and some packages that should be available out of the gate.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.bash
    pkgs.coreutils
    pkgs.curl
    pkgs.openssh
    pkgs.wget
  ];

  programs = {
    fish.enable = true; # This probably isn't needed, really.
    zsh.enable = true; # Needed for a few scripts.
    neovim.enable = true; # Backup editor.
    git.enable = true; # To fetch dotfiles.
  };

  # List services that you want to enable:

  # For keyring access. Necessary for 1Password.
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  programs.ssh.startAgent = true;

  # logind-friendly locker.
  # TODO: probably move this to home-manager.
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.i3lock}/bin/i3lock --color=000000";
  };

  # Because Gnome has infected the rest of the ecosystem.
  programs.dconf.enable = true;

  # Thunderbolt daemon.
  services.hardware.bolt.enable = true;
  # Ambient light sensor.
  hardware.sensor.iio.enable = true;
  # Thermal management.
  services.thermald.enable = true;
  # Screen brightness.
  services.illum.enable = true;
  # Battery access.
  services.upower.enable = true;

  # Open ports in the firewall (if needed).
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
