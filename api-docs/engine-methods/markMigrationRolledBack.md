# markMigrationRolledBack

Mark an existing failed migration as rolled back in the migrations table. It will still be
there, but ignored for all purposes except as audit trail.



## Request shape

Name: markMigrationRolledBackInput

### migrationName: String

The name of the migration to mark applied.

## Response shape

Name: markMigrationRolledBackOutput

### migrationName: String

The name of the migration to mark applied.

