{pkgs, ...}: {
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
}
