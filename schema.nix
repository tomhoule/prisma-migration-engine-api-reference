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
            type = types.nullOr (types.enum [ "String" "U32" "I32" "Bool" ]);
            default = null;
          };
          fields = lib.mkOption {
            type = types.nullOr (types.attrsOf shape);
            default = null;
          };
          taggedUnionOf = lib.mkOption {
            type = types.nullOr (types.attrsOf shape);
            default = null;
          };
        };
      };
      checkShape = (shape:
        let shapeTypeCount = foldl'
          (acc: name: acc + (if shape."${name}" == null then 0 else 1))
          0
          [ "scalar" "fields" "taggedUnionOf" ]; in
        if trace "hiiiii uwu ${shapeTypeCount}" (shapeTypeCount != 1)
        then
          (throw "Exactly one of scalar, fields or taggedUnionOf must be defined")
        else
          true
      );
    in
    types.addCheck uncheckedShape checkShape;
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
          requestShape = lib.mkOption { type = shape; };
          responseShape = lib.mkOption { type = shape; };
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
