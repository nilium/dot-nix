{pkgs, ...}: {
  nix = {
    package = pkgs.nixVersions.nix_2_20;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
