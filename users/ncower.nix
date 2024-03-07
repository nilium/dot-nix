{pkgs, ...}: {
  users.users.ncower = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmtTpCpIeFSE+nz8+mOD4+C3rpQtYCGCEIEBRRh9h+D"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJMs/x7sWSkjVY5tNBHlLOF6puCPljTWbbyUTL6rpnF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKO38Mqhwb9PvAUA+daYRg31wvdoidUmd+gTTl1mDKBQ"
    ];

    packages = [pkgs.git];
  };
}
