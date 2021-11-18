# markMigrationApplied

Mark a migration as applied in the migrations table.

There are two possible outcomes:

- The migration is already in the table, but in a failed state. In this case, we will mark it
as rolled back, then create a new entry.
- The migration is not in the table. We will create a new entry in the migrations table. The
`started_at` and `finished_at` will be the same.
- If it is already applied, we return a user-facing error.



## Request shape

Name: markMigrationAppliedInput

### migrationName: String

The name of the migration to mark applied.

### migrationsDirectoryPath: String

The path to the root of the migrations directory.

## Response shape

Name: markMigrationAppliedOutput

### migrationName: String

The name of the migration to mark applied.

### migrationsDirectoryPath: String

The path to the root of the migrations directory.

