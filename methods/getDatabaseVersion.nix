{ ... }:

{
  methods.getDatabaseVersion = {
    description = ''
      Get the database version for error reporting.
    '';
    requestShape = "getDatabaseVersionInput";
    responseShape = "getDatabaseVersionOutput";
  };

  recordShapes = {
    getDatabaseVersionInput = { fields = { }; };
    getDatabaseVersionOutput = {
      fields = {
        version = { shape = "String"; };
      };
    };
  };
}

