_: let
  settings = {
    theme = "big-duo";

    editor = {
      line-number = "absolute";
      color-modes = true;
      cursorline = true;
      rulers = [80 100];
      bufferline = "multiple";

      lsp.display-inlay-hints = true;
      cursor-shape.insert = "bar";
    };

    keys = {
      normal = let
        shift-lines = [
          "split_selection_on_newline"
          "extend_to_line_bounds"
          "merge_consecutive_selections"
          "delete_selection"
          "goto_line_start"
        ];
      in {
        # Shift+hjkl to extend selections.
        J = "extend_line_down";
        K = "extend_line_up";
        H = "extend_char_left";
        L = "extend_char_right";

        A-k = shift-lines ++ ["move_line_up" "paste_before"];
        A-j = shift-lines ++ ["move_line_down" "paste_before"];

        # Shift+arrows to extend selections.
        S-down = "extend_line_down";
        S-up = "extend_line_up";
        S-left = "extend_char_left";
        S-right = "extend_char_right";

        C-a = "goto_first_nonwhitespace";
        C-e = "goto_line_end";

        C-n = "increment";
        A-n = "decrement";

        # Paste via clipboard as the default.
        y = ["yank" "yank_joined_to_clipboard"];
        Y = ["yank" "yank_main_selection_to_clipboard"];

        # Add join selections back somewhere.
        C-j = "join_selections";

        # Show docs similar to vim.
        C-k = "hover";

        # Rebind C-s since I use it for tmux.
        C-g = "save_selection";
        C-s = "no_op";

        # Vim muscle memory for paragraph jumping... not sure if I'm weird
        # for how much I use these.
        "}" = ["goto_next_paragraph" "collapse_selection"];
        "{" = ["goto_prev_paragraph" "collapse_selection"];

        # Changing primary selection.
        C-l = "rotate_selections_forward";
        C-h = "rotate_selections_backward";
        C-right = "rotate_selections_forward";
        C-left = "rotate_selections_backward";

        # Rotating selections.
        A-l = "rotate_selection_contents_forward";
        A-h = "rotate_selection_contents_backward";
        A-right = "rotate_selection_contents_forward";
        A-left = "rotate_selection_contents_backward";

        space = {
          q = ":buffer-close";
          h = ":toggle-option lsp.display-inlay-hints";
          c = ":toggle-option search.smart-case";
        };

        g = {
          # Jump paragraphs.
          k = "goto_prev_paragraph";
          j = "goto_next_paragraph";
          up = "goto_prev_paragraph";
          down = "goto_next_paragraph";

          # Extra selections.
          L = ["select_mode" "goto_line_end" "normal_mode"];
          H = ["select_mode" "goto_first_nonwhitespace" "normal_mode"];
          S-right = ["select_mode" "goto_line_end" "normal_mode"];
          S-left = ["select_mode" "goto_first_nonwhitespace" "normal_mode"];
          G = ["select_mode" "goto_file_start" "goto_line_start" "normal_mode"];
          E = ["select_mode" "goto_last_line" "goto_line_end" "normal_mode"];
          x = ":buffer-close";
        };

        C-w = {
          C-g = "hsplit";
          C-s = "no_op";
          # tmux-like splits
          "\"" = "hsplit";
          "|" = "vsplit";
        };
      };

      insert = {
        # Account for C-s used by tmux.
        C-g = "commit_undo_checkpoint";
        C-s = "no_op";
      };

      select = {
        "}" = "goto_next_paragraph";
        "{" = "goto_prev_paragraph";
        C-a = "goto_line_start";
        C-e = "goto_line_end";
      };
    };
  };
in {
  programs.helix.settings = settings;
}
