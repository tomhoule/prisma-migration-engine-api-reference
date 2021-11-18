# createMigration

Create the next migration in the migrations history. If draft is false and there are no
unexecutable steps, it will also apply the newly created migration.

**Note**: The user currently needs database creation/drop permissions in order for the
command to work (because of the shadow database).



## Input type

createMigrationInput

### prismaSchema: String

The current prisma schema to use as a target for the generated migration.

### migrationsDirectoryPath: String

The filesystem path of the migrations directory to use.

### draft: Bool

If true, always generate a migration, but do not apply.

### migrationName: String

The user-given name for the migration. This will be used in the migration directory.

## Output type

createMigrationOutput

### generatedMigrationName: String

The name of the newly generated migration directory, if any.

