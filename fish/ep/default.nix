{
  stdenv,
  lib,
  coreutils,
  gnused,
  fzf,
  fd,
  parallel,
}: let
  name = "fish-ep";
in
  stdenv.mkDerivation {
    inherit name;
    version = "0.1.0";
    src = lib.sources.sourceFilesBySuffices (lib.sources.cleanSource ./.) [".fish"];
    doConfigure = false;
    doBuild = false;
    doInstall = true;
    propagatedBuildInputs = [
      coreutils
      gnused
      fzf
      fd
      parallel
    ];
    installPhase = ''
      destdir="$out/share/$name"
      mkdir -p "$destdir"
      cp -r conf.d functions "$destdir/"
    '';
  }
