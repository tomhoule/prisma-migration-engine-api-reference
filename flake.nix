{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      api = lib.evalModules { modules = [ ./schema.nix ./methods/schemaPush.nix ]; };
    in
    {
      defaultPackage = builtins.trace (builtins.toJSON api.config) pkgs.cowsay;
      packages = {
        prisma-migration-engine-api-rs = { };
        prisma-migration-engine-api-ts = { };
      };
    }
  );
}
