{
  lib,
  crystal,
  coreutils,
  ...
}:
crystal.buildCrystalPackage {
  pname = "afmt";
  version = "0.1.0";
  src = lib.sources.sourceByRegex (lib.sources.cleanSource ./.) [
    "^src$"
    ".*\.cr$"
    "(^|/)shard\.(lock|yml)$"
  ];
  format = "shards";
  crystalBinaries.afmt.src = "src/afmt.cr";
  fmt_bin = "${coreutils}/bin/fmt";
  propagatedBuildInputs = [coreutils];
}
