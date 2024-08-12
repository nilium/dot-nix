{
  # Author: Noel Cower <ncower@nil.dev>

  palette = {
    background = "#101012";
    background_bright = "#202026";
    background_ui = "#080808";
    blue = "#5ab0e0";
    cursor_primary = "#33ddff";
    cursor_secondary = "#2d9ec7";
    cyan = "#00d2e5";
    foreground = "#c6cfd2";
    foreground_dull = "#7d8182";
    green = "#99cc66";
    highlight_primary = "#31647d";
    highlight_secondary = "#343947";
    lime = "#bbe16c";
    magenta = "#fb97d2";
    orange_bright = "#f46f5a";
    pink = "#e75c95";
    purple = "#bd76e3";
    red = "#fa7980";
    violet_bright = "#d0bdfe";
    yellow = "#f5d852";
    yellow_dull = "#a3a56e";
    inlay_hint = "#76868a";
  };

  # Syntax.
  "comment" = {fg = "yellow_dull";};
  "constant" = {fg = "magenta";};
  "constant.character.escape" = {fg = "red";};
  "constant.numeric" = {fg = "green";};
  "constructor" = {fg = "pink";};
  "function" = {fg = "cyan";};
  "function.macro" = {fg = "purple";};
  "function.special" = {fg = "purple";};
  "keyword" = {fg = "yellow";};
  "keyword.control" = {fg = "orange_bright";};
  "keyword.directive" = {fg = "pink";};
  "namespace" = {fg = "purple";};
  "operator" = {fg = "cyan";};
  "punctuation" = {fg = "foreground";};
  "punctuation.special" = {fg = "red";};
  "string" = {fg = "lime";};
  "string.regexp" = {fg = "pink";};
  "string.special.path" = {fg = "lime";};
  "tag" = {fg = "pink";};
  "type" = {fg = "magenta";};
  "type.builtin" = {fg = "orange_bright";};
  "type.enum.variant" = {fg = "pink";};
  "variable" = {fg = "foreground";};

  # Diff.
  "diff.delta" = {fg = "violet_bright";};
  "diff.minus" = {fg = "red";};
  "diff.plus" = {fg = "green";};

  # Interface / markup.
  "markup.bold" = {fg = "blue";};
  "markup.heading" = {fg = "violet_bright";};
  "markup.italic" = {fg = "yellow";};
  "markup.link.text" = "magenta";
  "markup.link.url" = "cyan";
  "markup.list" = "cyan";
  "markup.quote" = {fg = "yellow";};
  "markup.raw" = {fg = "foreground";};
  "markup.raw.inline" = {fg = "red";};

  # UI.
  "ui.background" = {
    fg = "foreground";
    bg = "background";
  };
  "ui.cursor" = {
    fg = "background";
    bg = "cursor_secondary";
    modifiers = ["dim"];
  };
  "ui.cursor.match" = {
    fg = "yellow";
    modifiers = ["underlined"];
  };
  "ui.cursor.primary" = {
    fg = "background";
    bg = "cursor_primary";
    modifiers = ["dim"];
  };
  "ui.cursorline" = {bg = "background_bright";};
  "ui.gutter" = {bg = "background_ui";};
  "ui.help" = {
    fg = "foreground";
    bg = "background_ui";
  };
  "ui.linenr" = {fg = "foreground_dull";};
  "ui.linenr.selected" = {fg = "cyan";};
  "ui.menu" = {
    fg = "foreground";
    bg = "background_ui";
  };
  "ui.menu.selected" = {
    fg = "cyan";
    bg = "background_ui";
  };
  "ui.popup" = {
    fg = "foreground";
    bg = "background_ui";
  };
  "ui.selection" = {bg = "highlight_secondary";};
  "ui.selection.primary" = {bg = "highlight_primary";};
  "ui.statusline" = {
    fg = "yellow";
    bg = "background_ui";
  };
  "ui.statusline.inactive" = {
    fg = "yellow_dull";
    bg = "background_ui";
  };
  "ui.text" = {fg = "foreground";};
  "ui.text.focus" = {fg = "cyan";};
  "ui.virtual.ruler" = {bg = "background_ui";};
  "ui.virtual.whitespace" = {fg = "yellow";};
  "ui.virtual.inlay-hint" = {fg = "inlay_hint";};
  "ui.window" = {fg = "yellow";};

  # Diagnostics (gutter).
  "diagnostic.error" = {fg = "red";};
  "diagnostic.hint" = {fg = "green";};
  "diagnostic.warning" = {fg = "yellow";};

  # Diagnostics (window).
  "error" = {fg = "red";};
  "warning" = {fg = "yellow";};
}
