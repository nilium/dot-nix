{
  stdenv,
  kakoune-lsp,
  ...
}:
stdenv.mkDerivation {
  pname = "kak-lsp-config";
  inherit (kakoune-lsp) version src;
  phases = ["unpackPhase installPhase"];
  installPhase = ''
    cp kak-lsp.toml "$out"
  '';
}
