{
  config,
  lib,
  ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.kernelParams = ["i915.force_probe=46a6"];
  boot.extraModulePackages = [];
  boot.kernel.sysctl = {
    # For Tailscale
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "ext4";
    neededForBoot = true;
    options = ["noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/HOME";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077" "defaults"];
  };

  swapDevices = [
    {device = "/dev/disk/by-label/SWAP";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Network.
  networking.hostName = "sirin";

  # Framework-specific settings.
  services.tlp.settings = {
    USB_DENYLIST = "0bda:8156";
  };
}
