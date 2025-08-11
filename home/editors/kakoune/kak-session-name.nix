{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "kak-session-name";
  version = "1.20220731.0";
  src = fetchFromGitHub {
    owner = "nilium";
    repo = "kak-session-name";
    rev = "c8793642b2b95d3e07b242ef03e6cdedfde8c5da";
    hash = "sha256-GMnJJ3D1YTTshk/E4T5t2oMmiIIefHCQRnNNRjC22AQ=";
  };

  cargoHash = "sha256-SeoHmcyc+5lQelP11+AP8RriCJEt7UFgC4DBv4adFi4=";

  postInstall = ''
    mkdir -p "$out/share/kak/autoload/plugins/kak-session-name"
    cp rc/*.kak "$out/share/kak/autoload/plugins/kak-session-name/"
  '';

  meta = {
    homepage = "https://github.com/nilium/kak-session-name/";
    description = "Random session names for Kakoune";
    mainProgram = "kak-session-name";
    license = with lib.licenses; [bsd2 asl20];
  };
}
