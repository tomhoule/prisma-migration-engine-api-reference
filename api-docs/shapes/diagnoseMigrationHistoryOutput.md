# diagnoseMigrationHistoryOutput
### editedMigrationNames: String

The names of the migrations for which the checksum of the script in the
migration directory does not match the checksum of the applied migration
in the database.


### failedMigrationNames: String

The names of the migrations that are currently in a failed state in
the database.


### hasMigrationsTable: Bool

Is the migrations table initialized in the database?

### history: historyOutput

The current status of the migration history of the database relative to
migrations directory. `None` if they are in sync and up to date.


