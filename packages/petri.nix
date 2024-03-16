{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "nilium";
    repo = "petri";
    rev = "6387b0da3611f6939690873696938abd7a99d075";
    hash = "sha256-WGQ2/THaN6L4ILCD7oW+JkRSkn3rVU20mBdwA9iAHjI=";
  };
in
  buildGoModule {
    pname = "petri";
    inherit version src;
    vendorHash = "sha256-aF9gILpv50AAOEo8hWlEH6mZ7t9xEq2zDn/iISHorI0=";
    meta = {
      description = "Print tmux windows, panes, processes, and files as a tree";
      homepage = "https://github.com/nilium/petri";
      license = lib.licenses.unlicense;
      maintainers = [lib.maintainers.nilium];
      platforms = lib.platforms.linux;
    };
  }
