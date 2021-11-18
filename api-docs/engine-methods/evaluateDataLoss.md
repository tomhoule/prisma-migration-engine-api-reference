# evaluateDataLoss

Development command for migrations. Evaluate the data loss induced by the
next migration the engine would generate on the main database.

At this stage, the engine does not create or mutate anything in the database
nor in the migrations directory.

This is part of the `migrate dev` flow.

**Note**: the engine currently assumes the main database schema is up-to-date with the migration
history.



## Request shape

Name: evaluateDataLossInput

- migrationsDirectoryPath: [String](../shapes/String.md)



- prismaSchema: [String](../shapes/String.md)



## Response shape

Name: evaluateDataLossOutput

- migrationSteps: [U32](../shapes/U32.md)

  The number migration steps that would be generated. If this is empty, we
  wouldn't generate a new migration, unless the `draft` option is
  passed.


- unexecutable: [migrationFeedback](../shapes/migrationFeedback.md)

  Steps that cannot be executed on the local database in the
  migration that would be generated.


- warnings: [migrationFeedback](../shapes/migrationFeedback.md)

  Destructive change warnings for the local database. These are the
  warnings *for the migration that would be generated*. This does not
  include other potentially yet unapplied migrations.


