{
  lib,
  crystal,
  xorg,
}:
crystal.buildCrystalPackage {
  pname = "ncrandr";
  version = "0.1.0";
  src = lib.sources.sourceByRegex (lib.sources.cleanSource ./.) [
    "^src$"
    ".*\.cr$"
    "(^|/)shard\.(lock|yml)$"
  ];
  format = "shards";
  crystalBinaries.ncrandr.src = "src/ncrandr.cr";
  xrandr_bin = "${xorg.xrandr}/bin/xrandr";
  propagatedBuildInputs = [xorg.xrandr];
}
