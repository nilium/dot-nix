{...}: {
  homeManagerModules.kakoune = {pkgs, ...}: {
    xdg.configFile."kak/colors/triplejelly.kak".text = builtins.readFile ./triplejelly.kak;

    programs.kakoune = {
      enable = true;

      config.colorScheme = "triplejelly";

      config.hooks = [
        {
          name = "RegisterModified";
          option = "'\"'";
          commands = ''nop %sh{ printf %s "$kak_main_reg_dquote" | pbcopy }'';
        }
        {
          name = "BufSetOption";
          option = "filetype=go";
          commands = ''
            set-option buffer indentwidth 8
            set-option buffer tabstop 8
          '';
        }
        {
          name = "BufSetOption";
          option = "filetype=(rust|markdown|kak)";
          commands = ''
            set-option buffer indentwidth 4
            set-option buffer tabstop 4
          '';
        }
        # parinfer-rust
        {
          name = "WinSetOption";
          option = "filetype=(clojure|lisp|scheme|racket|fennel)";
          commands = ''
            require-module parinfer
            parinfer-enable-window -smart
          '';
        }
        # kakoune-lsp
        {
          name = "WinSetOption";
          option = "filetype=(rust|go)";
          commands = ''
            try %{ racer-disable-autocomplete }
            lsp-enable-window
            lsp-inlay-hints-enable window
            hook window BufWritePre .* %{ try lsp-formatting-sync }
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=go";
          commands = ''
            hook buffer BufWritePre .* %{ try %{ lsp-code-action-sync 'Organize Imports' } }
          '';
        }
        # smarttab
        {
          name = "WinSetOption";
          option = "filetype=go";
          commands = ''
            require-module smarttab
            smarttab
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=(rust|markdown|kak)";
          commands = "expandtab";
        }
        # kakoune-state-save
        {
          name = "KakBegin";
          option = ".*";
          commands = ''
            state-save-reg-load colon
            state-save-reg-load pipe
            state-save-reg-load slash
          '';
        }
        {
          name = "KakEnd";
          option = ".*";
          commands = ''
            state-save-reg-save colon
            state-save-reg-save pipe
            state-save-reg-save slash
          '';
        }
      ];

      # NB: keyMappings only supports global mappings.
      config.keyMappings = let
        keymap = mode: key: effect: docstring: {inherit mode key effect docstring;};
        normal = keymap "normal";
        goto = keymap "goto";
        match = keymap "match";
        user = keymap "user";
        view = keymap "view";
        multiselect = keymap "multiselect";
        enter-mode = mode: key: dest: keymap mode key ":enter-user-mode ${dest}<ret>" "${dest} mode";

        match-variants = mode: prefix: let
          moded = keymap mode;
          variant = key: effect: docstring: moded key "${prefix}${effect}" docstring;
        in [
          (variant "b" "b" "parenthesis block")
          (variant "(" "(" "parenthesis block")
          (variant ")" ")" "parenthesis block")
          (variant "B" "B" "brace block")
          (variant "{" "{" "brace block")
          (variant "}" "}" "brace block")
          (variant "r" "r" "bracket block")
          (variant "[" "[" "bracket block")
          (variant "]" "]" "bracket block")
          (variant "a" "a" "angle block")
          (variant "<lt>" "<lt>" "angle block")
          (variant "<gt>" "<gt>" "angle block")
          (variant ''\"'' ''\"\"'' "double quote string")
          (variant "Q" "Q" "double quote string")
          (variant "''''" "''''" "single quote string")
          (variant "q" "q" "single quote string")
          (variant "`" "`" "grave quote string")
          (variant "g" "g" "grave quote string")
          (variant "w" "w" "word")
          (variant "W" "<a-w>" "WORD")
          (variant "s" "s" "sentence")
          (variant "p" "p" "paragraph")
          (variant "<space>" "<space>" "whitespaces")
          (variant "i" "i" "indent")
          (variant "u" "u" "argument")
          (variant "n" "n" "number")
          (variant "c" "c" "custom object desc")
          (variant "<semicolon>" "<semicolon>" "run command in object context")
        ];
      in
        [
          (normal "<c-semicolon>" "<a-semicolon>" "swap caret locations")

          (normal "}" "}p;" "move cursor forward one paragraph")
          (normal "]" "}p" "extend selection forward one paragraph")
          (normal "{" "{p;" "move cursor back one paragraph")
          (normal "[" "{p" "extend selection back one paragraph")

          (goto "}" "<esc>}" "extend selection")
          (goto "]" "<esc>]" "extend selection")
          (goto "[" "<esc>[" "extend selection")
          (goto "{" "<esc>{" "extend selection")

          (goto "n" "<esc>:buffer-next<ret>" "go to next buffer")
          (goto "p" "<esc>:buffer-previous<ret>" "go to next buffer")
          (goto "q" "<esc>:delete-buffer<ret>" "delete buffer")
          (goto "L" "<esc>Gl" "extend selection to line end")
          (goto "H" "<esc>Gh" "extend selection to line begin")
          (goto "G" "<esc>Gg" "extend selection to buffer top")
          (goto "E" "<esc>Ge" "extend selection to buffer end")
          (goto "I" "<esc>Gi" "extend selection to line non blank start")
          (goto "<gt>" "<esc>G." "extend selection to last buffer change")

          (enter-mode "normal" "m" "match")
          (match "m" "m" "select next enclosed")
          (match "M" "M" "extend to next enclosed")
          (match "n" "n" "select prior enclosed")
          (match "N" "N" "extend to prior enclosed")
          (match "s" ":surround<ret>" "add surround")
          (match "r" ":delete-surround<ret>" "replace surround")
          (match "d" ":change-surround<ret>" "delete surround")
          (enter-mode "match" "i" "match-inner")
          (enter-mode "match" "a" "match-around")

          # Default to extending selection
          (normal "T" "<a-t>" "extend select until next character")
          (normal "<a-t>" "T" "move selection before next character")
          (normal "F" "<a-f>" "extend selection through next character")
          (normal "<a-f>" "F" "move selection to next character")

          # Clipboard
          (user "<space>" "<semicolon>," "clear selection")
          (user "y" "<a-|>pbcopy<ret>" "copy selection to clipboard")
          (user "p" "<a-!>pbpaste<ret>" "append clipboard after selection")
          (user "P" "!pbpaste<ret>" "insert clipboard before selection")
          (user "R" "|pbpaste<ret>" "replace selection with clipboard")

          # Make n and N non-selection and v-n and v-N add selections
          (normal "N" "<a-n>" "previous match")

          # Add a basic selection mode for modal n/N instead of alt keys
          (normal "<c-v>" "V" "enter view mode")
          (view "v" "<esc>" "exit view mode")
          (view "V" "<esc>" "exit view mode")
          (normal "v" ":enter-user-mode -lock multiselect<ret>" "multiselect mode")
          (multiselect "n" "N" "add next search result to selection")
          (multiselect "N" "<a-N>" "add prior search result to selection")
          (multiselect "j" "J" "extend selection down")
          (multiselect "h" "H" "extend selection left")
          (multiselect "l" "L" "extend selection right")
          (multiselect "k" "K" "extend selection up")
          (multiselect "v" "<esc>" "exit selection mode")

          # Tmux splits
          (user "\\\"" ":split<ret>" "split horizontally")
          (user "|" ":vsplit<ret>" "split vertically")

          # kakoune-lsp
          (normal "<c-k>" ":lsp-hover<ret>" "show hover information for cursor")
          (normal "<c-K>" ":lsp-code-actions<ret>" "perform code actions")
          (user "k" ":lsp-hover<ret>" "show hover information for cursor")
          (user "a" ":lsp-code-actions<ret>" "perform code actions")
          (user "r" ":lsp-rename-prompt<ret>" "rename object")

          # fzf
          (user "t" ": fzf-mode<ret>f" "open a file with fzf")
          (user "g" ": fzf-mode<ret>g" "open a file found with rg")
          (user "b" ": fzf-mode<ret>b" "open a buffer with fzf")
        ]
        ++ (match-variants "match-inner" "<a-i>")
        ++ (match-variants "match-around" "<a-a>");

      config.numberLines = {
        enable = true;
        relative = true;
      };

      config.showMatching = true;

      config.scrollOff = {
        lines = 3;
        columns = 5;
      };

      plugins = with pkgs.kakounePlugins; [
        (pkgs.callPackage ./kak-session-name.nix {})
        (pkgs.callPackage ./kakoune-surround.nix {})
        parinfer-rust # Module: parinfer
        auto-pairs-kak
        smarttab-kak
        # smarttab
        # powerline_expandtab
        fzf-kak
        # fzf
        # fzf-bzr
        # fzf-git
        # fzf-hg
        # fzf-svn
        # fzf-buffer
        # fzf-cd
        # fzf-ctags
        # fzf-file
        # fzf-grep
        # fzf-project
        # fzf-search
        # fzf-vcs
        # fzf-sk-grep
        kakoune-state-save
        byline-kak # Module: byline
        kakoune-lsp
      ];

      extraConfig = ''
        eval %sh{kak-lsp --kakoune -s $kak_session}
        require-module byline

        # Add an extra tmux command to open a popup. Because...
        define-command -params 1.. -shell-completion -docstring 'open a tmux popup' tmux-terminal-popup %{
            tmux-terminal-impl 'display-popup -E' %arg{@}
        }

        # Vague emulation of Vim split and vsplit, just to be a little easier on muscle
        # memory.
        define-command -params 0..1 -file-completion -docstring 'split horizontally' split %{
            tmux-terminal-vertical kak -c %val{session} %arg{@}
        }

        alias global hsplit split

        define-command -params 0..1 -file-completion -docstring 'split vertically' vsplit %{
            tmux-terminal-horizontal kak -c %val{session} %arg{@}
        }

        # Sort of janky command to align everything that matches the current literal
        # selection.
        define-command -params 0..1 align-in -docstring 'align all instances of the main selection in an object' %{
            evaluate-commands -draft %sh{
                obj="''${1:-p}"
                case "$obj" in
                '%') :;;
                *) obj="<a-i>$obj";;
                esac
                expr="$(printf '%s' "$kak_selection" | sed -Ee 's/^/\\\\Q/;s/\\E/\\E\\\\\\\\E\\\\Q/g')"
                printf "execute-keys '%s'\n" "''${obj}s''${expr}<ret>&"
            }
        }

        # Also a janky command to strip whitespace on demand.
        define-command strip-ws -docstring 'strip trailing whitespace from buffer' %{
            try %{ execute-keys -draft -save-regs '"' '%s[ \t]+$<ret>d' }
        }

        # fzf
        require-module fzf-file
        set-option global fzf_file_command 'fd -tf'

        require-module fzf-grep
        set-option global fzf_grep_command 'rg'
      '';
    };
  };
}
