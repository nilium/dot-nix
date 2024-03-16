{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "pact"; # No version, so no pname / version.
  src = fetchFromGitHub {
    owner = "jameysharp";
    repo = "pact";
    rev = "533341958e3a4b6809b0a01ad74e921cdb570320";
    hash = "sha256-WhVq2ue1aGDt2g236565sDt9rlvHbHMH/F3isZCIgxk=";
  };

  installPhase = ''
    mkdir -p "$out/bin"
      install pact "$out/bin/pact"
  '';
}
