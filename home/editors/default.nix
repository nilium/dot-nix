{lib', ...}:
lib'.merge' [
  ./helix

  ({self, ...}: {
    homeManagerModules.editors = {
      imports = with self.homeManagerModules; [
        helix
      ];
    };
  })
]
