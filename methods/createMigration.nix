{ ... }:

{
  methods.createMigration = {
    description = ''
      Create the next migration in the migrations history.
    '';

    requestShape = {
      fields = {
        migrationsDirectoryPath = {
          description = "The filesystem path of the migrations directory to use.";
          scalar = "String";
        };

        prismaSchema = {
          description = "The current prisma schema to use as a target for the generated migration.";
          scalar = "String";
        };

        migrationName = {
          description = "The user-given name for the migration. This will be used in the migration directory.";
          scalar = "String";
        };

        draft = {
          description = "If true, always generate a migration, but do not apply.";
          scalar = "Bool";
        };
      };

    };

    responseShape = {
      fields = {
        generatedMigrationName = {
          description = "The name of the newly generated migration directory, if any.";
          isNullable = true;
          scalar = "String";
        };
      };
    };
  };
}
