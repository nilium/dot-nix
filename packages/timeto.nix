{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ...
}: let
  version = "1.1.0";
  src = fetchFromSourcehut {
    owner = "~nilium";
    repo = "timeto";
    rev = "v${version}";
    hash = "sha256-0keyiEU/eRF2UtoZ6kAtLecQc8yfIWEOZFSVxa9r7N0=";
  };
in
  buildGoModule {
    pname = "timeto";
    inherit version src;
    vendorHash = null;
    meta = {
      description = "Print the amount of time in different units until or since a point in time";
      homepage = "https://git.sr.ht/~nilium/timeto";
      license = lib.licenses.bsd2;
      maintainers = [lib.maintainers.nilium];
      platforms = lib.platforms.all;
    };
  }
