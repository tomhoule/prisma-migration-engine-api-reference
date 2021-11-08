{ pkgs, lib, ... }:

with builtins;

let
  types = lib.types;
  shape =
    let
      uncheckedShape = types.submodule {
        options = {
          description = lib.mkOption {
            type = types.str;
            default = "";
          };

          isList = lib.mkOption { type = types.bool; default = false; };
          isNullable = lib.mkOption { type = types.bool; default = false; };

          scalar = lib.mkOption {
            description = ''
              A scalar field.

              Exactly one of `scalar`, `fields` or `taggedUnionOf` should be
              defined.
            '';
            type = types.nullOr (types.enum [ "String" "U32" "I32" "Bool" ]);
            default = null;
          };
          fields = lib.mkOption {
            description = ''
              A record field.

              Exactly one of `scalar`, `fields` or `taggedUnionOf` should be
              defined.
            '';
            type = types.nullOr (types.attrsOf shape);
            default = null;
          };
          taggedUnionOf = lib.mkOption {
            description = ''
              A tagged union field.

              Exactly one of `scalar`, `fields` or `taggedUnionOf` should be
              defined.
            '';
            type = types.nullOr (types.attrsOf shape);
            default = null;
          };
        };
      };
    in
    types.addCheck uncheckedShape checkShape;
in
{
  options = {
    methods = lib.mkOption {
      description = "A JSON-RPC method";
      type = types.attrsOf (types.uniq (types.submodule {
        options = {
          description = lib.mkOption {
            description = "Docs for the RPC method";
            type = types.str;
          };
          requestShape = lib.mkOption { type = shape; };
          responseShape = lib.mkOption { type = shape; };
        };
      }));
    };
  };
}
