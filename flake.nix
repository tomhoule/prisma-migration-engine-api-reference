{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      iterate = pkgs.writeShellScriptBin "iterate" ''
        set -euxo pipefail;
        export out=./iterate-out 
        rm -rf $out;
        mkdir $out;
        METHODS_DIR=methods out=./iterate-out cargo run --manifest-path=./codegen/Cargo.toml;
      '';
    in
    {
      defaultPackage = pkgs.stdenv.mkDerivation {
        name = "prisma-migration-engine-api";
        configurePhase = "mkdir $out";
        buildPhase = "METHODS_DIR=methods codegen";
        installPhase = "echo pewpew";
        buildInputs = [ self.packages."${system}".codegen ];
        src = builtins.path { path = ./.; name = "src"; };
      };

      packages = {
        codegen = pkgs.rustPlatform.buildRustPackage {
          name = "migration-engine-api-codegen";
          src = ./codegen;
          cargoLock = {
            lockFile = ./codegen/Cargo.lock;
          };
        };
      };

      devShell = pkgs.mkShell {
        inputsFrom = [ self.packages."${system}".codegen ];
        packages = [ iterate ];
      };

    }
  );
}
