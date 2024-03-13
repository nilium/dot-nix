{
  pkgs,
  lib,
  ...
}: let
  unfreePackages = [
    "1password-gui"
    "1password-cli"
    "1password"
    "discord"
  ];

  allowUnfreePackages = pkg: builtins.elem (lib.getName pkg) unfreePackages;

  isDarwin = pkgs.stdenv.isDarwin;
in {
  nixpkgs.config.allowUnfreePredicate = allowUnfreePackages;

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
  home.packages = [
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

  programs.firefox.enable = true;
  programs.pbcopy.enable = !isDarwin;
  programs.afmt = {
    enable = true;
    cmt.enable = true;
  };
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
        "VWKMrBqP82yw4QqfuSglEdud4YYFpo+sqjyHRShnlys=" = ["--rate" "120.0" "--mode" "2560x1440" "--pos" "0x0" "--rotate" "left"];
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
}
