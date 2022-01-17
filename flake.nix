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
        cat ./methods/*.toml | dasel -r toml -w json . > $out/api.json;
        out=./iterate-out cargo run --manifest-path=./codegen/Cargo.toml;
      '';
    in
    {
      defaultPackage = pkgs.stdenv.mkDerivation {
        name = "prisma-migration-engine-api";
        buildPhase = "bash ./builder.sh";
        buildInputs = [
          self.packages."${system}".codegen
          pkgs.dasel
        ];
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
        inputsFrom = [
          self.defaultPackage."${system}"
          self.packages."${system}".codegen
        ];
        packages = [ iterate ];
      };

      apps = {
        publishMdDocs = pkgs.writeShellScriptBin "publishMdDocs" ''
          set -euo pipefail

          nix build
          ${pkgs.rsync}/bin/rsync --progress --verbose --recursive --delete ./result/md_docs/ ./api-docs
        '';
      };
    }
  );
}
