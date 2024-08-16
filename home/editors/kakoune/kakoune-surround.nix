{
  lib,
  stdenv,
  ...
}: let
  rtpPath = "share/kak/autoload/plugins";
in
  stdenv.mkDerivation {
    pname = "kakoune-surround";
    version = "v2018.09.17";
    src = lib.cleanSource (builtins.fetchGit {
      url = "ssh://git@github.com/h-youhei/kakoune-surround";
      rev = "efe74c6f434d1e30eff70d4b0d737f55bf6c5022";
    });
    installPhase = ''
      mkdir -p "$out/${rtpPath}/kakoune-surround";
      cp LICENSE surround.kak "$out/${rtpPath}/kakoune-surround"
    '';
  }
