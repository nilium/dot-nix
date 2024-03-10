default-host := `hostname -s`
default-user := `id -nu`

_sel := '.#'

# This stops short of enabling experimental features because it's really required for any of this
# to work and should be set for the system, so probably better to keep this free of overrides that
# could mislead later.
home-manager := 'nix run --inputs-from . home-manager -- '

# Build the current home configuration.
default: build-home

# Build either a home or host config.
build home-or-host *args:
	@just build-{{home-or-host}} {{args}}

# Build a home-manager config.
build-home user=default-user host=default-host:
	{{home-manager}} --flake {{quote(_sel + user + '@' + host)}} build
	
# Build a NixOS host config.
build-host host=default-host:
	nixos-rebuild --flake {{quote(_sel + host)}} build

# Activate a home or host config.
activate home-or-host *args:
	@just activate-{{home-or-host}} {{args}}

# Switch to the current configuration.
activate-home user=default-user host=default-host: (build-home user host)
	{{home-manager}} --flake {{quote(_sel + user + '@' + host)}} switch

# Schedule the current configuration for boot.
activate-host host=default-host:
	nixos-rebuild --flake {{quote(_sel + host)}} boot

# Update a particular flake input.
update input:
	nix flake update {{quote(input)}}

# Update local in-repo flake inputs.
update-local: (update 'afmt') \
              (update 'ncrandr') \
              (update 'pact') \
			  (update 'ntk') \

# Update nixpkgs.
update-packages: (update 'nixpkgs')

# Run home-manager with the given arguments.
home-manager *args:
	{{home-manager}} {{args}}
