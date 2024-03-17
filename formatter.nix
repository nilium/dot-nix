{lib', ...}: (lib'.mkFlake' {
  perSystem = {pkgs', ...}: {formatter = pkgs'.alejandra;};
})
