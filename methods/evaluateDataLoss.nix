{ ... }:

let
  migrationFeedback = {
    description = "A data loss warning or an unexecutable migration error, associated with the step that triggered it.";
    isList = true;
    fields = {
      message = { scalar = "String"; };
      stepIndeex = { scalar = "U32"; };
    };
  };
in
{
  methods.evaluateDataLoss = {
    description = ''
      Development command for migrations. Evaluate the data loss induced by the
      next migration the engine would generate on the main database.

      At this stage, the engine does not create or mutate anything in the database
      nor in the migrations directory.

      This is part of the `migrate dev` flow.
    '';
    requestShape = {
      fields = {
        prismaSchema = { scalar = "String"; };
        migrationsDirectoryPath = { scalar = "String"; };
      };
    };
    responseShape = {
      fields = {
        migrationSteps = { scalar = "U32"; };
        warnings = migrationFeedback;
        unexecutable = migrationFeedback;
      };
    };
  };
}

