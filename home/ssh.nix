{
  programs.ssh = {
    enable = true;
    forwardAgent = false;
    extraOptionOverrides.CanonicalizeHostname = "yes";
    includes = ["config-local"];
  };
}
