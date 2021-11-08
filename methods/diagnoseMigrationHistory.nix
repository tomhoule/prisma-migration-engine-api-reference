{ ... }:

{
  methods.diagnoseMigrationHistory = {
    description = ''
      Read the contents of the migrations directory and the migrations table,
      and returns their relative statuses. At this stage, the migration
      engine only reads, it does not write to the database nor the migrations
      directory, nor does it use a shadow database.
    '';
    requestShape = {
      migrationsDirectoryPath = {
        description = "The path to the root of the migrations directory.";
        scalar = "String";
      };
    };
    responseShape = {
      history = {
        description = ''
          The current status of the migration history of the database relative to
          migrations directory. `None` if they are in sync and up to date.
        '';

        isNullable = true;
        taggedUnionOf = {
          DatabaseIsBehind = { };
          MigrationsDirectoryIsBehind = { };
          HistoriesDiverge = { };
        };
      };
      failedMigrationNames = {
        description = ''
          The names of the migrations that are currently in a failed state in
          the database.
        '';

        isList = true;
        scalar = "String";
      };
      editedMigrationNames = {
        description = ''
          The names of the migrations for which the checksum of the script in the
          migration directory does not match the checksum of the applied migration
          in the database.
        '';

        isList = true;
        scalar = "String";
      };
      hasMigrationsTable = {
        description = "Is the migrations table initialized in the database?";
        scalar = "Boolean";
      };
    };
  };
}

