{ ... }:

{
  methods.createMigration = {
    description = ''
      Create the next migration in the migrations history. If draft is false and there are no
      unexecutable steps, it will also apply the newly created migration.

      **Note**: The user currently needs database creation/drop permissions in order for the
      command to work (because of the shadow database).
    '';
    requestShape = "createMigrationInput";
    responseShape = "createMigrationOutput";
  };

  recordShapes = {
    createMigrationInput = {
      fields = {
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

    };

    createMigrationOutput = {
      fields = {
        generatedMigrationName = {
          description = "The name of the newly generated migration directory, if any.";
          isNullable = true;
          shape = "String";
        };
      };
    };
  };
}
