{ ... }:

{
  methods.markMigrationRolledBack = {
    description = ''
      Mark a migration as applied in the migrations table.
    '';
    requestShape = {
      fields = {
        migrationName = {
          description = "The name of the migration to mark applied.";
          scalar = "String";
        };
      };
    };
    responseShape = {
      fields = { };
    };
  };
}
