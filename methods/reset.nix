{ ... }:

{
  methods.reset = {
    description = ''
      Drop and recreate the database.
    '';
    requestShape = "resetInput";
    responseShape = "resetOutput";
  };

  recordShapes = {
    resetInput = { fields = { }; };
    resetOutput = { fields = { }; };
  };
}


