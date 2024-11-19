{pkgs, ...}: let
  inherit (pkgs) lib;

  uiua-tree-sitter = {
    owner = "shnarazk";
    repo = "tree-sitter-uiua";
    rev = "868b3d672d5622add493437eb7f2ee6956f14ccf";
    hash = "sha256-bu4LmmvZDS9xswWZNMRdfgrWut6meHwqK20p0MFrBcU=";
  };

  tabs = {
    tab-width = 8;
    unit = "\t";
  };

  spaces = spaces: {
    tab-width = spaces;
    unit = lib.concatStrings (lib.replicate spaces " ");
  };

  languages = {
    language = [
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
      {
        name = "uiua";
        scope = "source.uiua";
        file-types = ["ua"];
        shebangs = ["uiua"];
        injection-regex = "uiua";
        formatter = {
          command = "uiua";
          args = ["fmt" "--io"];
        };
        auto-format = true;
        language-servers = ["uiua"];
        comment-tokens = "#";
        indent = spaces 4;
      }
    ];

    grammar = [
      {
        name = "uiua";
        source = {
          git = "https://github.com/${uiua-tree-sitter.owner}/${uiua-tree-sitter.repo}";
          inherit (uiua-tree-sitter) rev;
        };
      }
    ];

    language-server.uiua = {
      command = "uiua";
      args = ["lsp"];
    };

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
  };
in {
  programs.helix.languages = languages;
  xdg.configFile."helix/runtime/queries/uiua".source = "${pkgs.fetchFromGitHub uiua-tree-sitter}/queries";
}
