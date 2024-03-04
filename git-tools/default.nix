{
  lib,
  stdenv,
  symlinkJoin,
  ruby,
  fzf,
  makeWrapper,
  ...
}: let
  script = src: patch: let
    name = baseNameOf src;
  in
    stdenv.mkDerivation (let
      config = {
        inherit name src;
        dontUnpack = true;
        installPhase = ''
          mkdir -p "$out/bin";
          install "$src" "$out/bin/$name"
        '';
      };
    in
      config // (patch config));

  git-w2 = script ./git-w2 (_: {
    propagatedBuildInputs = [ruby];
  });

  git-sb = script ./git-sb (prev: {
    nativeBuildInputs = [makeWrapper];
    propagatedBuildInputs = [ruby];
    installPhase =
      prev.installPhase
      + ''
        wrapProgram "$out/bin/$name" --suffix PATH : ${lib.makeBinPath [fzf]}
      '';
  });
in
  symlinkJoin {
    name = "git-tools";
    paths = [
      git-w2
      git-sb
    ];
  }
