{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ...
}: let
  version = "0.1.0";
  src = fetchFromSourcehut {
    owner = "~nilium";
    repo = "urlcode";
    rev = "v${version}";
    hash = "sha256-mSCMlVfrHguxFEkzvBSvdDWm5Zh3mroB1d+YNqfKuzk=";
  };
in
  buildGoModule {
    pname = "urlcode";
    inherit version src;
    vendorHash = null;
    meta = {
      description = "Encode and decode URL query and path text";
      homepage = "https://git.sr.ht/~nilium/urlcode";
      license = lib.licenses.isc;
      maintainers = [lib.maintainers.nilium];
      platforms = lib.platforms.all;
    };
  }
