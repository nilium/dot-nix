{
  programs.kitty = {
    enable = true;

    themeFile = "duckbones";
    font = {
      name = "Pragmata Pro Mono Liga";
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
}
