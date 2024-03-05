{pkgs, ...}: {
  programs.nushell = {
    enable = true;
    configFile.text = ''
    '';
    envFile.text = ''
      $env.PATH = ($env.PATH |
        split row (char esep) |
        prepend (${pkgs.ruby}/bin/gem environment user_gemdir | into string | str trim | path join "bin") |
        prepend ($env.HOME | path join ".cargo" "bin") |
        prepend ($env.HOME | path join "bin")
      )

      $env.PATH = "hx"
    '';
  };
}
