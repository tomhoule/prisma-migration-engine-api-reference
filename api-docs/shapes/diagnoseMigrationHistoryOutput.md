# diagnoseMigrationHistoryOutput
- editedMigrationNames: [String](../shapes/String.md)

  The names of the migrations for which the checksum of the script in the
  migration directory does not match the checksum of the applied migration
  in the database.


- failedMigrationNames: [String](../shapes/String.md)

  The names of the migrations that are currently in a failed state in
  the migrations table.


- hasMigrationsTable: [Bool](../shapes/Bool.md)

  Is the migrations table initialized/present in the database?


- history: [HistoryDiagnostic](../shapes/HistoryDiagnostic.md)

  The current status of the migration history of the database
  relative to migrations directory. `null` if they are in sync and up
  to date.


