{ ... }:

{
  methods.evaluateDataLoss = {
    description = ''
      Development command for migrations. Evaluate the data loss induced by the
      next migration the engine would generate on the main database.

      At this stage, the engine does not create or mutate anything in the database
      nor in the migrations directory.

      This is part of the `migrate dev` flow.

      **Note**: the engine currently assumes the main database schema is up-to-date with the migration
      history.
    '';
    requestShape = "evaluateDataLossInput";
    responseShape = "evaluateDataLossOutput";
  };

  recordShapes = {
    evaluateDataLossInput = {
      fields = {
        prismaSchema = { shape = "String"; };
        migrationsDirectoryPath = { shape = "String"; };
      };
    };

    evaluateDataLossOutput = {
      fields = {
        migrationSteps = { shape = "U32"; };
        warnings = { shape = "migrationFeedback"; isList = true; };
        unexecutable = { shape = "migrationFeedback"; isList = true; };
      };
    };

    migrationFeedback = {
      description = "A data loss warning or an unexecutable migration error, associated with the step that triggered it.";
      fields = {
        message = { shape = "String"; };
        stepIndex = { shape = "U32"; };
      };
    };
  };
}

