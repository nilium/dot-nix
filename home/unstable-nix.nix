{pkgs, ...}: {
  nix = {
    # File is a misnomer now, but don't need any unstable features right now besides flakes because
    # they'll never be stable and might eventually get removed.
    package = pkgs.nixVersions.stable;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
