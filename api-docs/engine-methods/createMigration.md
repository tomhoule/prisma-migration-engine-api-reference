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

  The user-given name for the migration. This will be used in the migration directory.

- migrationsDirectoryPath: [String](../shapes/String.md)

  The filesystem path of the migrations directory to use.

- prismaSchema: [String](../shapes/String.md)

  The current prisma schema to use as a target for the generated migration.

## Response shape

Name: createMigrationOutput

- draft: [Bool](../shapes/Bool.md)

  If true, always generate a migration, but do not apply.

- migrationName: [String](../shapes/String.md)

  The user-given name for the migration. This will be used in the migration directory.

- migrationsDirectoryPath: [String](../shapes/String.md)

  The filesystem path of the migrations directory to use.

- prismaSchema: [String](../shapes/String.md)

  The current prisma schema to use as a target for the generated migration.

