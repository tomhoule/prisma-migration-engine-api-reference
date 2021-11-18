{ ... }:

{
  methods.reset = {
    description = ''
      Drop and recreate the database. The migrations will not be applied, as it would overlap with
      `applyMigrations`.
    '';
    requestShape = "resetInput";
    responseShape = "resetOutput";
  };

  recordShapes = {
    resetInput = { fields = { }; };
    resetOutput = { fields = { }; };
  };
}


