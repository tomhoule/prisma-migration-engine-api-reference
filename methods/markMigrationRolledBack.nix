{ ... }:

{
  methods.markMigrationRolledBack = {
    description = ''
      Mark a migration as applied in the migrations table.
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
