{lib', ...}:
lib'.merge' [
  ./helix
  ./kakoune

  ({self, ...}: {
    homeManagerModules.editors = {
      imports = with self.homeManagerModules; [
        helix
        kakoune
      ];
    };
  })
]
