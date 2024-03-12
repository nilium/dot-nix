{pkgs, ...}: {
  home.packages = [
    pkgs.ectool
    pkgs.framework-tool
    pkgs.htop

    # Desktop stuff
    pkgs.blueman
    pkgs.brightnessctl
    pkgs.hsetroot
    pkgs.lld
    pkgs.maim
    pkgs.networkmanagerapplet
    pkgs.pavucontrol
    pkgs.rofi
    pkgs.xsel
    pkgs.xss-lock

    # Fonts
    pkgs.alegreya
    pkgs.comic-mono
    pkgs.font-awesome_4
    pkgs.ubuntu_font_family
    pkgs.uiua386

    # Compilers
    pkgs.gcc

    # Non-free
    pkgs._1password-gui
    pkgs._1password
    pkgs.discord
  ];
}
