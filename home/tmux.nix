options @ {pkgs, ...}: let
  defaultLinuxCopy = let
    xsel = "${pkgs.xsel}/bin/xsel";
  in "${xsel} -i -c && ${xsel} -o -c | ${xsel} -i -p";
  defaultMacCopy = "pbcopy"; # System copy.
  defaultCopy =
    if pkgs.stdenv.isDarwin
    then defaultMacCopy
    else defaultLinuxCopy;
  copyCommand = options.copyCommand or defaultCopy;
in {
  programs.tmux = {
    enable = true;

    terminal = "xterm-256color";
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 6000;
    mouse = true;
    keyMode = "vi";
    shortcut = "s";
    secureSocket = true;

    extraConfig = ''
      set-option -g terminal-overrides ',xterm-256color:Tc,screen-256color:Tc'

      set -g renumber-windows on
      set -g escape-time 0
      set -g repeat-time 360

      unbind %
      bind '|' split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      bind -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel '${copyCommand}'
      bind -Tcopy-mode-vi 'v' send -X begin-selection

      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      bind -r left select-pane -L
      bind -r down select-pane -D
      bind -r up select-pane -U
      bind -r right select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      bind -r S-left resize-pane -L 5
      bind -r S-down resize-pane -D 5
      bind -r S-up resize-pane -U 5
      bind -r S-right resize-pane -R 5

      bind -r C-h resize-pane -L
      bind -r C-j resize-pane -D
      bind -r C-k resize-pane -U
      bind -r C-l resize-pane -R

      bind -r C-left resize-pane -L
      bind -r C-down resize-pane -D
      bind -r C-up resize-pane -U
      bind -r C-right resize-pane -R

      # default statusbar colors
      set-option -g status-style bg=black,fg=yellow
      # default window title colors
      set-window-option -g window-status-style fg=brightblue,bg=default
      # active window title colors
      set-window-option -g window-status-current-style fg=brightred,bg=default

      # pane border
      set-option -g pane-border-style fg="#777777"
      set-option -g pane-active-border-style fg=brightred

      # message text
      set-option -g message-style bg=black,fg=brightred

      # pane number display
      set-option -g display-panes-active-colour blue #blue
      set-option -g display-panes-colour brightred #orange

      # clock
      set-window-option -g clock-mode-colour green #green

      set-option -g pane-border-status bottom
      set-option -g pane-border-format " #P: #{pane_current_command} "
    '';
  };
}
