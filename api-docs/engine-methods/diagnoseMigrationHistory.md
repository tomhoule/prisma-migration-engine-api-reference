# diagnoseMigrationHistory

Read the contents of the migrations directory and the migrations table,
and returns their relative statuses. At this stage, the migration
engine only reads, it does not write to the database nor the migrations
directory, nor does it use a shadow database.



## Input type

diagnoseMigrationHistoryInput

### migrationsDirectoryPath: String

The path to the root of the migrations directory.

## Output type

diagnoseMigrationHistoryOutput

### history: historyOutput

The current status of the migration history of the database relative to
migrations directory. `None` if they are in sync and up to date.


### hasMigrationsTable: Bool

Is the migrations table initialized in the database?

### editedMigrationNames: String

The names of the migrations for which the checksum of the script in the
migration directory does not match the checksum of the applied migration
in the database.


### failedMigrationNames: String

The names of the migrations that are currently in a failed state in
the database.


