# lib.nix
{ lib }: {
  # This serves as your isolated evaluation engine
  mkCustomModuleType = { name, option, modules ? [ ], extraArgs ? { } }:
    let
      # Evaluate a standard, isolated Nixpkgs module system instantiation
      eval = lib.evalModules {
        class = "custom-schema-${name}";
        specialArgs = extraArgs;
        modules = [
          # Define the base structure container schema
          {
            options.flake.${name} = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                options = {
                  system = lib.mkOption { type = lib.types.str; };
                  configValue = option;
                };
              });
              default = { };
            };
          }
        ] ++ modules;
      };
    in
    # Return only the clean, final compiled configuration map
    eval.config.flake.${name};
}
