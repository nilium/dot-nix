{
  stdenv,
  writeTextFile,
  lib,
  coreutils,
  gnused,
  fzf,
  fd,
  parallel,
}: let
  name = "fish-ep";
  epConfig = writeTextFile {
    name = "ep-paths";
    text = ''
      set -g EP_FZF ${fzf}/bin/fzf
      set -g EP_FD ${fd}/bin/fd
      set -g EP_PARALLEL ${parallel}/bin/parallel
      set -g EP_SED ${gnused}/bin/sed
    '';
  };
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
      ln -s ${epConfig} "$destdir/conf.d/ep-path.fish"
    '';
  }
