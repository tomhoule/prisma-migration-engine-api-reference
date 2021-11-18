{ ... }:

{
  methods.markMigrationRolledBack = {
    description = ''
      Mark an existing failed migration as rolled back in the migrations table. It will still be
      there, but ignored for all purposes except as audit trail.
    '';
    requestShape = "markMigrationRolledBackInput";
    responseShape = "markMigrationRolledBackOutput";
  };

  recordShapes = {
    markMigrationRolledBackInput = {
      fields = {
        migrationName = {
          description = "The name of the migration to mark applied.";
          shape = "String";
        };
      };
    };

    markMigrationRolledBackOutput = {
      fields = { };
    };
  };
}
