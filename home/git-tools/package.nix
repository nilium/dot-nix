{
  lib,
  stdenv,
  writeScriptBin,
  writeShellApplication,
  symlinkJoin,
  ruby,
  fzf,
  jq,
  xdg-utils,
  ...
}: let
  script = src: deps: let
    name = baseNameOf src;
    script = writeScriptBin name (builtins.readFile src);
    runtimeInputs = [script] ++ deps;
  in
    writeShellApplication {
      inherit name runtimeInputs;
      text = ''
        exec ${script} "$@"
      '';
    };

  git-w2 = script ./git-w2 [ruby];
  git-sb = script ./git-sb [ruby fzf];
  git-mr = script ./git-mr ([jq] ++ lib.ifEnable stdenv.isLinux [xdg-utils]);
in
  symlinkJoin {
    name = "git-tools";
    paths = [
      git-w2
      git-sb
      git-mr
    ];
  }
