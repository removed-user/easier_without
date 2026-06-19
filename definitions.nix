# You can now define your schema definitions dynamically using your raw extracted type builder:


# schemas/my-schema.nix
{ lib, myEngineLib }: 
let
  # The blueprint for what data your custom modules can accept
  myCustomValueOption = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "Service activity";
        port = lib.mkOption { type = lib.types.port; default = 8080; };
      };
    };
  };
in
# Instantiate the schema structure
myEngineLib.mkCustomModuleType {
  name = "workspaces";
  option = myCustomValueOption;
  modules = [
    # Inject actual configuration or downstream inputs here directly
    {
      flake.workspaces.production = {
        system = "x86_64-linux";
        configValue.enable = true;
        configValue.port = 9000;
      };
    }
  ];
}
