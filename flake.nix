{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;

      methods = builtins.map
        (fileName: ./. + "/methods/${fileName}")
        (builtins.attrNames (builtins.readDir ./methods));

      api = lib.evalModules {
        modules = [ ./schema.nix ] ++ methods;
      };
    in
    {
      defaultPackage = derivation {
        name = "prisma-migration-engine-api";
        builder = "${pkgs.bash}/bin/bash";
        args = [ ./builder.sh ];
        API_JSON = builtins.toJSON api.config;
        PATH = builtins.foldl' (acc: pkg: acc + ":${pkg}/bin") "" [ pkgs.coreutils pkgs.jq ];
        system = system;
      };
      packages = {
        prisma-migration-engine-api-rs = { };
        prisma-migration-engine-api-ts = { };
      };
    }
  );
}
