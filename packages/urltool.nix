{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ...
}: let
  version = "0.2.0";
  src = fetchFromSourcehut {
    owner = "~nilium";
    repo = "urltool";
    rev = "v${version}";
    hash = "sha256-T2Ufr20JCJX2dTwKHbsJQHWtar0w+AqNjpQ2hbzMC2U=";
  };
in
  buildGoModule {
    pname = "urltool";
    inherit version src;
    vendorHash = null;
    meta = {
      description = "Command-line tool to parse and manipulate URLs";
      homepage = "https://git.sr.ht/~nilium/urltool";
      license = lib.licenses.isc;
      maintainers = [lib.maintainers.nilium];
      platforms = lib.platforms.all;
    };
  }
