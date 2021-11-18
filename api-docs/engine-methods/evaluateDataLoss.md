# evaluateDataLoss

Development command for migrations. Evaluate the data loss induced by the
next migration the engine would generate on the main database.

At this stage, the engine does not create or mutate anything in the database
nor in the migrations directory.

This is part of the `migrate dev` flow.

**Note**: the engine currently assumes the main database schema is up-to-date with the migration
history.



## Input type

evaluateDataLossInput

### prismaSchema: String



### migrationsDirectoryPath: String



## Output type

evaluateDataLossOutput

### migrationSteps: U32



### warnings: migrationFeedback



### unexecutable: migrationFeedback



