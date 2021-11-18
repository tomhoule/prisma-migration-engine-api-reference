{ ... }:

{
  methods.reset = {
    description = ''
      Try to make the database empty: no data and no schema. On most connectors, this is
      implemented by dropping and recreating the database. If that fails (most likely because of
      insufficient permissions), the engine attemps a "best effort reset" by inspecting the
      contents of the database and dropping them individually.

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


