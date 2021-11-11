{ ... }:

{
  methods.markMigrationApplied = {
    description = ''
      Mark a migration as applied in the migrations table.
    '';
    requestShape = "markMigrationAppliedInput";
    responseShape = "markMigrationAppliedOutput";
  };

  recordShapes = {
    markMigrationAppliedInput = {
      fields = {
        migrationName = {
          description = "The name of the migration to mark applied.";
          shape = "String";
        };
        migrationsDirectoryPath = {
          description = "The path to the root of the migrations directory.";
          shape = "String";
        };
      };
    };

    markMigrationAppliedOutput = {
      fields = { };
    };
  };
}
