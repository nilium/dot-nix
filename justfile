default-host := `hostname -s || echo -n nowhere`
default-user := `id -nu || echo -n nobody`

_sel := '.#'

export NIX_CONFIG := 'experimental-features = nix-command flakes'

# This stops short of enabling experimental features because it's really required for any of this
# to work and should be set for the system, so probably better to keep this free of overrides that
# could mislead later.
home-manager := 'nix run --inputs-from . home-manager -- '

check:
	nix flake show --no-update-lock-file --all-systems

[positional-arguments]
fmt *args:
	alejandra {{ args }} .

# Build the current home configuration.
default: build-home

# Build either a home or host config.
build home-or-host-or-pkg *args:
	@just build-{{home-or-host-or-pkg}} {{args}}

# Build a home-manager config.
build-home user=default-user host=default-host:
	{{home-manager}} --flake {{quote(_sel + user + '@' + host)}} build --impure
	
# Build a NixOS host config.
build-host host=default-host:
	nixos-rebuild --flake {{quote(_sel + host)}} build

# Build a package output.
build-pkg name:
	nix build {{quote(_sel + name)}}

# Activate a home or host config.
activate home-or-host *args:
	@just activate-{{home-or-host}} {{args}}

# Switch to the current configuration.
activate-home user=default-user host=default-host:
	{{home-manager}} --flake {{quote(_sel + user + '@' + host)}} switch --impure

# Schedule the current configuration for boot.
activate-host host=default-host:
	nixos-rebuild --flake {{quote(_sel + host)}} boot

# Schedule the current configuration for boot.
switch-host host=default-host:
	nixos-rebuild --flake {{quote(_sel + host)}} switch

# Update a particular flake input.
update input:
	nix flake update {{quote(input)}}

# Update nixpkgs.
update-packages: (update 'nixpkgs')

# Run home-manager with the given arguments.
home-manager *args:
	{{home-manager}} {{args}}
