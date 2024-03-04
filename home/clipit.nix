{pkgs, ...}: {
  services.parcellite = {
    enable = true;
    package = pkgs.clipit;
    extraOptions = ["--no-icon"];
  };
}
