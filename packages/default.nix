inputs @ {flake-utils, ...}:
flake-utils.lib.meld inputs [
  ./packages.nix # Miscellaneous packages
  ./afmt # afmt, cmtNN commands
  ./ncrandr # xrandr wrapper using edid hashes for maybe-consistent display naming
  ./pact # Jamey Sharp's pact
]
