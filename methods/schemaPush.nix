{ ... }:

{
  methods.schemaPush = {
    description = ''
      The command behind `db push`.
    '';
    requestShape = {
      schema = { shape = "String"; };
      force = { shape = "Bool"; };
    };
    responseShape = {
      executedSteps = { shape = "U32"; };
      warnings = { isList = true; shape = "String"; };
      unexecutable = { isList = true; shape = "String"; };
    };
  };
}
