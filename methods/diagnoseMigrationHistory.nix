{ ... }:

{
  methods.diagnoseMigrationHistory = {
    description = ''
      Read the contents of the migrations directory and the migrations table,
      and returns their relative statuses. At this stage, the migration
      engine only reads, it does not write to the database nor the migrations
      directory, nor does it use a shadow database.
    '';
    requestShape = "diagnoseMigrationHistoryInput";
    responseShape = "diagnoseMigrationHistoryOutput";
  };

  enumShapes = {
    historyOutput = {
      variants = {
        DatabaseIsBehind = null;
        MigrationsDirectoryIsBehind = null;
        HistoriesDiverge = null;
      };
    };
  };

  recordShapes = {
    diagnoseMigrationHistoryInput = {
      fields = {
        migrationsDirectoryPath = {
          description = "The path to the root of the migrations directory.";
          shape = "String";
        };
      };
    };

    diagnoseMigrationHistoryOutput = {
      fields = {
        history = {
          description = ''
            The current status of the migration history of the database relative to
            migrations directory. `None` if they are in sync and up to date.
          '';

          isNullable = true;
          shape = "historyOutput";
        };
        failedMigrationNames = {
          description = ''
            The names of the migrations that are currently in a failed state in
            the database.
          '';

          isList = true;
          shape = "String";
        };
        editedMigrationNames = {
          description = ''
            The names of the migrations for which the checksum of the script in the
            migration directory does not match the checksum of the applied migration
            in the database.
          '';

          isList = true;
          shape = "String";
        };
        hasMigrationsTable = {
          description = "Is the migrations table initialized in the database?";
          shape = "Bool";
        };
      };
    };
  };
}

