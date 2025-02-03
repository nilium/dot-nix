# dot-nix

Dotfiles as Nix configuration. This is likely to be perpetually unstable
and work-in-progress.

## Machines

  * [Sirin](./sirin), a gen 13 Framework laptop.
  * [Dolya](./dolya), an M1 Macbook Pro.
  * [Zosim](./zosim), an M4 Macbook Pro.
  * [Veles](./veles), Thinkpad T480 running Ubuntu, mainly for testing config.

## Usage

For the most part, this shouldn't require any special environment other than
`nix` with flakes enabled for me to use. A dev shell is provided with `just`
and `alejandra` for quick changes when I want to make sure formatting is
right and to run builds easily.

### Just Recipes

The following recipes in the `justfile` can be used for convenience. They
will always try to build for the current username and hostname. The default
recipe is to build the current user's home-manager config. These can also
be listed using `just --list`.

  * `build {home|host|pkg} [args...]` - Build either the current home or host
    config or a package output. Extra arguments are passed to the `build-home`
    or `build-host` recipes.

  * `build-home [user@host]` - Build the given username and host home-manager
    configuration. This attempts to run `home-manager` from the pinned input,
    so changes over time should not affect this. That's what I'm hoping,
    at least.

  * `build-host [host]` - Build the given host NixOS configuration. Like normal
    `nixos-rebuild`, this tries to build the current hostname's output unless
    another is given.

  * `build-pkg {pkg}` - Build a package output.

  * `activate {home|host} [args...]` - Activate either the current home or host
    config. Extra arguments are passed to `activate-home` or `activate-host`.

  * `activate-home [user@host]` - Activates the given username and host
    home-manager configuration. This runs `home-manager switch`, so to avoid
    any mishaps, this will always run `home-manager build` first.

  * `activate-host [host]` - Activates the given host NixOS configuration. By
    default, like normal `nixos-rebuild`, this will default to the current
    hostname when activating. This runs `nixos-rebuild boot`, not `... switch`,
    because more often than not `nixos-rebuild switch` will kill any current
    session (since I'm likely updating the host).

  * `update {input}` - Update the given flake input.

  * `update-local` - Updates local flake locks (e.g., afmt, ncrandr, pact).

  * `update-packages` - Update both nixpkgs.

  * `home-manager [args]` - Run `home-manager` with the given arguments. Useful
    on machines where I don't want the `home-manager` program itself installed.

## License

All of this is released under the 0BSD license. I do not recommend depending
on it, not that I expect anyone will. The license text can be found in
[LICENSE.txt](./LICENSE.txt).
