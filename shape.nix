lib:

let
  mkOption = lib.mkOption;
  types = lib.types;
  shape = types.submoduleWith {
    shorthandOnlyDefinesConfig = true;
    modules = [
      {
        options = {
          description = mkOption {
            type = types.str;
            default = "";
          };

          isList = mkOption { type = types.bool; default = false; };
          isNullable = mkOption { type = types.bool; default = false; };

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
          taggedUnionOf = mkOption {
            description = ''
              A tagged union field.

              Exactly one of `scalar`, `fields` or `taggedUnionOf` should be
              defined.
            '';
            type = types.nullOr (types.attrsOf shape);
            default = null;
          };
        };
      }
    ];
  };
in
shape
