{
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
}
