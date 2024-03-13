{self, ...}: {
  nixosModules = {
    unstable-nix = self.homeManagerModules.unstable-nix;
    user-ncower = import ./users/ncower.nix;
    xorg = import ./xorg.nix;
  };
}
