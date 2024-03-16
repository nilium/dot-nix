{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ...
}: let
  version = "1.1.0";
  src = fetchFromSourcehut {
    owner = "~nilium";
    repo = "mtar";
    rev = "v${version}";
    hash = "sha256-d85SqsdDYL7fVkOQFrz0IZDsVgaPAiHb4xHjpGggYKo=";
  };
in
  buildGoModule {
    pname = "mtar";
    inherit version src;
    vendorHash = null;
    meta = {
      description = "Tar utility for constructing unusual archives";
      homepage = "https://git.sr.ht/~nilium/mtar";
      license = lib.licenses.bsd2;
      maintainers = [lib.maintainers.nilium];
      platforms = lib.platforms.all;
    };
  }
