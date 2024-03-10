let
  flakePackages' = system: flake: flake.packages.${system};

  overlayFlake' = system: flake: removeAttrs (flakePackages' system flake) ["default"];
  overlayFlakes' = system: flakes:
    builtins.foldl' (acc: flake: acc // (overlayFlake' system flake)) {}
    flakes;

  forSystem = system: {
    flakePackages = flakePackages' system;
    overlayFlake = overlayFlake' system;
    overlayFlakes = overlayFlakes' system;
  };
in {
  inherit forSystem;
}
