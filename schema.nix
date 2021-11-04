{ pkgs, lib, ... }:

with builtins;

let
  types = lib.types;
  unionType = types.submodule {
    options = {
      taggedUnionOf = lib.mkOption {
        type = types.attrsOf (types.attrsOf shape);
      };
    };
  };
  shape = types.submodule {
    options = {
      description = lib.mkOption {
        type = types.str;
        default = "";
      };
      isList = lib.mkOption { type = types.bool; default = false; };
      isNullable = lib.mkOption { type = types.bool; default = false; };
      shape = lib.mkOption {
        type = types.oneOf [ unionType shape (types.enum [ "String" "U32" "I32" "Bool" ]) ];
      };
    };
  };
in
{
  options = {
    methods = lib.mkOption {
      description = "A JSON-RPC method";
      type = types.attrsOf (types.submodule {
        options = {
          description = lib.mkOption {
            description = "Docs for the RPC method";
            type = types.str;
          };
          requestShape = lib.mkOption { type = types.attrsOf shape; };
          responseShape = lib.mkOption { type = types.attrsOf shape; };
        };
      });
    };

    # notifications = {
    #   name = lib.mkOption { type = lib.types.text; };
    #   description = lib.mkOption { type = lib.types.text; };
    #   shape = lib.mkOption { type = lib.types.listOf shape; };
    # };
  };
}
