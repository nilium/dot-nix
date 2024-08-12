{
  # Author: Noel Cower <ncower@nil.dev>

  palette = {
    foreground = "#101012";
    foreground_dull = "#404046";
    cursor_primary = "#ffde4d";
    cursor_secondary = "#ffabf5";
    highlight_primary = "#fff2b3";
    highlight_secondary = "#f7d9fa";
    background = "#faf7e6";
    background_ui = "#b8ecf5";
    background_ui_dull = "#d8eaed";
    blue = "#062096";
    cyan = "#007c87";
    green = "#147500";
    lime = "#549e00";
    magenta = "#c91a82";
    pink = "#ab0046";
    purple = "#4f1b6b";
    red = "#8c0008";
    orange_bright = "#f55b02";
    violet_bright = "#623fb5";
    yellow = "#a67f00";
    comment = "#8f7950";
    inlay_hint = "#0f8c2b";
    diff_delta_bg = "#e9d1ee";
    diff_plus_bg = "#d9eed1";
    diff_minus_bg = "#eed1d1";
  };

  # Syntax.
  "comment" = {fg = "comment";};
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
  "diff.delta" = {
    fg = "violet_bright";
    bg = "diff_delta_bg";
  };
  "diff.minus" = {
    fg = "red";
    bg = "diff_minus_bg";
  };
  "diff.plus" = {
    fg = "green";
    bg = "diff_plus_bg";
  };

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
  "ui.cursor" = {bg = "cursor_secondary";};
  "ui.cursor.match" = {fg = "violet_bright";};
  "ui.cursor.primary" = {bg = "cursor_primary";};
  "ui.cursorline" = {bg = "background_ui";};
  "ui.gutter" = {bg = "background";};
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
    fg = "foreground";
    bg = "background_ui";
  };
  "ui.statusline.inactive" = {
    fg = "foreground_dull";
    bg = "background_ui_dull";
  };
  "ui.text" = {fg = "foreground";};
  "ui.text.focus" = {fg = "cyan";};
  "ui.virtual.ruler" = {bg = "background_ui";};
  "ui.virtual.whitespace" = {fg = "yellow";};
  "ui.virtual.inlay-hint" = {fg = "inlay_hint";};
  "ui.window" = {fg = "foreground";};

  # Diagnostics (gutter).
  "diagnostic.error" = {fg = "red";};
  "diagnostic.hint" = {fg = "green";};
  "diagnostic.warning" = {fg = "yellow";};

  # Diagnostics (window).
  "error" = {fg = "red";};
  "warning" = {fg = "yellow";};
}
