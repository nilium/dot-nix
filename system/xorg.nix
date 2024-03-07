{pkgs, ...}: {
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

    # Enable libinput support for touchpad / mouse.
    libinput = {
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
  };
}
