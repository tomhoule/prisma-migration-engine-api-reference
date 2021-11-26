# createMigration

Create the next migration in the migrations history. If draft is false and there are no
unexecutable steps, it will also apply the newly created migration.

**Note**: The user currently needs database creation/drop permissions in order for the
command to work (because of the shadow database).



## Request shape

Name: createMigrationInput


- draft: [Bool](../shapes/Bool.md)

  If true, always generate a migration, but do not apply.


- migrationName: [String](../shapes/String.md)

  The user-given name for the migration. This will be used for the migration directory.


- migrationsDirectoryPath: [String](../shapes/String.md)

  The filesystem path of the migrations directory to use.


- prismaSchema: [String](../shapes/String.md)

  The current prisma schema to use as a target for the generated migration.


## Response shape

Name: createMigrationOutput


- generatedMigrationName: [String](../shapes/String.md)

  The name of the newly generated migration directory, if any.
  
  generatedMigrationName will be null if: 1. The migration we generate would be empty,
  AND 2. the `draft` param was not true, because in that case the engine would
  still generate an empty migration script.


