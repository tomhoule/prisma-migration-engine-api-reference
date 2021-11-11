{ pkgs, lib, ... }:

with builtins;

let
  types = lib.types;
  enumVariant = types.submoduleWith {
    shorthandOnlyDefinesConfig = true;
    modules = [
      {
        options = {
          description = lib.mkOption { type = types.str; default = ""; };
          shape = lib.mkOption { type = types.str; };
        };
      }
    ];
  };
  enumShape = types.submoduleWith {
    shorthandOnlyDefinesConfig = true;
    modules = [
      {
        options = {
          description = lib.mkOption {
            type = types.str;
            default = "";
          };

          variants = lib.mkOption {
            type = types.uniq (types.attrsOf (types.nullOr enumVariant));
          };
        };
      }
    ];
  };
  recordField = types.submoduleWith {
    shorthandOnlyDefinesConfig = true;
    modules = [
      {
        options = {
          description = lib.mkOption { type = types.str; default = ""; };
          isList = lib.mkOption {
            type = types.bool;
            default = false;
          };
          isNullable = lib.mkOption {
            type = types.bool;
            default = false;
          };
          shape = lib.mkOption { type = types.str; };
        };
      }
    ];
  };
  recordShape = types.submoduleWith
    {
      shorthandOnlyDefinesConfig = true;
      modules = [
        {
          options = {
            description = lib.mkOption {
              type = types.str;
              default = "";
            };

            fields = lib.mkOption {
              type = types.attrsOf recordField;
            };
          };
        }
      ];
    };
in
{
  options = {
    methods = lib.mkOption {
      description = "A JSON-RPC method";
      type = types.attrsOf (types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        modules = [
          {
            options = {
              description = lib.mkOption {
                description = "Docs for the RPC method";
                type = types.str;
              };
              requestShape = lib.mkOption { type = types.str; };
              responseShape = lib.mkOption { type = types.str; };
            };
          }
        ];
      });
    };

    recordShapes = lib.mkOption {
      description = "The repository of record shapes for the whole API.";
      type = types.attrsOf recordShape;
    };

    enumShapes = lib.mkOption {
      description = "The repository of enum (tagged union) shapes for the whole API.";
      type = types.attrsOf enumShape;
    };
  };
}

