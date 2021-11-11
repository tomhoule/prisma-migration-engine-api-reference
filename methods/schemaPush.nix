{ ... }:

{
  methods.schemaPush = {
    description = ''
      The command behind `db push`.
    '';
    requestShape = "schemaPushInput";
    responseShape = "schemaPushOutput";
  };

  recordShapes = {
    schemaPushInput = {
      fields = {
        schema = { shape = "String"; };
        force = { shape = "Bool"; };
      };
    };

    schemaPushOutput = {
      fields = {
        executedSteps = { shape = "U32"; };
        warnings = { isList = true; shape = "String"; };
        unexecutable = { isList = true; shape = "String"; };
      };
    };
  };
}
