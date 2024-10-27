{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "nilium";
    repo = "regen";
    rev = "v${version}";
    hash = "sha256-I32YZ5UeqH6BBy4De4ie9V+60NkmgEcLypKJHeKIqrw";
  };
in
  buildGoModule {
    pname = "regen";
    inherit version src;
    vendorHash = null; # No deps.
    meta = {
      description = "Generate random text matching regular expressions";
      homepage = "https://github.com/nilium/regen";
      license = lib.licenses.bsd2;
      maintainers = [lib.maintainers.nilium];
      platforms = lib.platforms.all;
    };
  }
