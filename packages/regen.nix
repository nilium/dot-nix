{
  lib,
  buildGoPackage,
  fetchFromSourcehut,
  ...
}: let
  version = "0.1.1";
  src = fetchFromSourcehut {
    owner = "~nilium";
    repo = "regen";
    rev = "v${version}";
    hash = "sha256-Gmn9cfukd+1QhpIMEQe4ALuAxy5VEdGxGayJXVvwpbo=";
  };
in
  buildGoPackage {
    pname = "regen";
    inherit version src;
    goPackagePath = "go.spiff.io/regen";
    meta = {
      description = "Generate random text matching regular expressions";
      homepage = "https://git.sr.ht/~nilium/regen";
      license = lib.licenses.bsd2;
      maintainers = [lib.maintainers.nilium];
      platforms = lib.platforms.all;
    };
  }
