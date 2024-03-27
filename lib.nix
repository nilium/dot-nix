{
  systems,
  nixpkgs,
  ...
}: let
  inherit (nixpkgs.lib.attrsets) recursiveUpdate;

  lib = rec {
    defaultSystems = systems;

    # Given a set of arguments (with a required system argument) and a
    # perSystem function that returns a set when given the arguments, convert
    # any path ${name}.${subname} to ${name}.${system}.${subname}.
    mkSystemAttrs = args @ {system, ...}: perSystem: let
      outputs = perSystem args;
    in
      builtins.foldl' (acc: name:
        acc // {${name}.${system} = outputs.${name};})
      {}
      (builtins.attrNames outputs);

    # Given a system and a set of flake outputs, for each attribute path
    # ${name}.${system}, flatten it to ${name}. Attributes that do not match
    # that path are kept as-is, including those that contain other systems but
    # not the given system.
    forSystem = system: outputs:
      builtins.foldl' (acc: name:
        acc // {${name} = outputs.${name}.${system} or outputs.${name};})
      {} (builtins.attrNames outputs);

    # mkFlake is a small implementation of something similar to what
    # flake-parts's mkFlake does, but with fewer pieces to it since I like the
    # idea but it's way too complicated and too poorly documented to use.
    #
    # The only required attribute to mkFlake's input set is the inputs
    # attribute. This should ideally contain at least self, but may be a
    # completely empty set if needed. The only goal of making this required is
    # to ensure that if it's empty on purpose, it's written.
    #
    # An example output function:
    #
    #   inputs @ {
    #     self,
    #     ...
    #   }:
    #   lib'.mkFlake {
    #     inherit inputs;
    #     outputs.homeManagerModules.default = {pkgs, ...}: {
    #       home.packages = [self.packages.${pkgs.system}.foobar];
    #     };
    #     perSystem = {pkgs', ...}: {
    #       packages.foobar = pkgs'.writeShellScriptBin "foobar" ''
    #         echo 'Hello, world'
    #       '';
    #     };
    #   }
    #
    mkFlake = {
      inputs,
      systems ? defaultSystems,
      perSystem ? _: {},
      outputs ? {},
      ...
    }:
      builtins.foldl' recursiveUpdate outputs
      (map (system: let
        args = {
          inherit inputs system;
          self' = forSystem system (inputs.self or {});
          pkgs' = inputs.nixpkgs.legacyPackages.${system} or {};
        };
      in
        mkSystemAttrs args perSystem)
      systems);

    # This function is more or less flake-utils.lib.meld, but accepts paths,
    # sets, and functions, because sometimes I want code next to the inner
    # flakes' imports. It also passes a copy of the lib alongside inputs to the
    # inner flakes with an additional merge' function that passes the inputs
    # that were given previously and a mkFlake' function that does the same.
    merge = inputs: let
      lib' = boundToInputs inputs;
      inputs' = {inherit lib';} // inputs;
      loaders = {
        lambda = f: f inputs'; # Output function.
        path = f: import f inputs'; # Import an output function from path.
        set = f: f; # Already-composed outputs.
        list = merge inputs; # List of flakes.
      };
      loader = type: loaders.${type} or (builtins.abort "invalid type ${type} for merged flake");
      load = flake: (loader (builtins.typeOf flake)) flake;
    in
      builtins.foldl' (outputs: flake: recursiveUpdate outputs (load flake)) {};

    # Returns a copy of the library with any function that takes inputs bound
    # to the given inputs.
    boundToInputs = inputs:
      lib
      // {
        merge' = merge inputs;
        mkFlake' = args: mkFlake ({inherit inputs;} // args);
      };
  };
in
  lib
