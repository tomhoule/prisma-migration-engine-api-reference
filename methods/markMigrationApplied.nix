{ ... }:

{
  methods.markMigrationApplied = {
    description = ''
      Mark a migration as applied in the migrations table.
    '';
    requestShape = {
      fields = {
        migrationName = {
          description = "The name of the migration to mark applied.";
          scalar = "String";
        };
        migrationsDirectoryPath = {
          description = "The path to the root of the migrations directory.";
          scalar = "String";
        };
      };
    };
    responseShape = {
      fields = { };
    };
  };
}
