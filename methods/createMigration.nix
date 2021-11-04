{ ... }:

{
  methods.createMigration = {
    description = ''
      Create the next migration in the migrations history.
    '';

    requestShape = {
      migrationsDirectoryPath = {
        description = "The filesystem path of the migrations directory to use.";
        shape = "String";
      };

      prismaSchema = {
        description = "The current prisma schema to use as a target for the generated migration.";
        shape = "String";
      };

      migrationName = {
        description = "The user-given name for the migration. This will be used in the migration directory.";
        shape = "String";
      };

      draft = {
        description = "If true, always generate a migration, but do not apply.";
        shape = "Bool";
      };
    };

    responseShape = {
      generatedMigrationName = {
        description = "The name of the newly generated migration directory, if any.";
        isNullable = true;
        shape = "String";
      };
    };
  };
}
