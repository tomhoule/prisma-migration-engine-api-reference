{ ... }:

{
  methods.schemaPush = {
    description = ''
      The command behind `db push`.
    '';
    requestShape = {
      fields = {
        schema = { scalar = "String"; };
        force = { scalar = "Bool"; };
      };
    };
    responseShape = {
      fields = {
        executedSteps = { scalar = "U32"; };
        warnings = { isList = true; scalar = "String"; };
        unexecutable = { isList = true; scalar = "String"; };
      };
    };
  };
}
