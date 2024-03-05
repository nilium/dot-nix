{pkgs, ...}: let
  inherit (pkgs) lib;
in {
  language = let
    tabs = {
      tab-width = 8;
      unit = "\t";
    };
    spaces = spaces: {
      tab-width = spaces;
      unit = lib.concatStrings (lib.replicate spaces " ");
    };
  in [
    {
      name = "go";
      indent = tabs;
      text-width = 80;
    }
    {
      name = "gomod";
      indent = tabs;
    }
    {
      name = "gowork";
      indent = tabs;
    }
    {
      name = "git-commit";
      comment-token = ";";
      indent = spaces 4;
    }
    {
      name = "git-rebase";
      comment-token = ";";
      indent = spaces 4;
    }
    {
      name = "python";
      auto-format = true;
    }
    {
      name = "nix";
      formatter.command = "${pkgs.alejandra}/bin/alejandra";
      auto-format = true;
    }
  ];

  language-server.gopls.config = {
    source.organizeImports = true;
    ui.diagnostic.staticcheck = true;
    hints = {
      compositeLiteralFields = true;
      compositeLiteralTypes = true;
      assignVariableTypes = true;
      parameterNames = true;
      rangeVariableTypes = true;
    };
  };
}
