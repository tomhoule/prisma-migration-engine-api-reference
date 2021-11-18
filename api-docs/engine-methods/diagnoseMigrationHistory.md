# diagnoseMigrationHistory

Read the contents of the migrations directory and the migrations table,
and returns their relative statuses. At this stage, the migration
engine only reads, it does not write to the database nor the migrations
directory, nor does it use a shadow database.



## Request shape

Name: diagnoseMigrationHistoryInput

### migrationsDirectoryPath: String

The path to the root of the migrations directory.

## Response shape

Name: diagnoseMigrationHistoryOutput

### migrationsDirectoryPath: String

The path to the root of the migrations directory.

