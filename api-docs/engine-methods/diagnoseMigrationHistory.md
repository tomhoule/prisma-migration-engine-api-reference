# diagnoseMigrationHistory

Read the contents of the migrations directory and the migrations table,
and returns their relative statuses. At this stage, the migration
engine only reads, it does not write to the database nor the migrations
directory, nor does it use a shadow database.



## Request shape

Name: diagnoseMigrationHistoryInput

- migrationsDirectoryPath: [String](../shapes/String.md)

  The path to the root of the migrations directory.


## Response shape

Name: diagnoseMigrationHistoryOutput

- editedMigrationNames: [String](../shapes/String.md)

  The names of the migrations for which the checksum of the script in the
  migration directory does not match the checksum of the applied migration
  in the database.


- failedMigrationNames: [String](../shapes/String.md)

  The names of the migrations that are currently in a failed state in
  the migrations table.


- hasMigrationsTable: [Bool](../shapes/Bool.md)

  Is the migrations table initialized/present in the database?


- history: [historyOutput](../shapes/historyOutput.md)

  The current status of the migration history of the database
  relative to migrations directory. `null` if they are in sync and up
  to date.


