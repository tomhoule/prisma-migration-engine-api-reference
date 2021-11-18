# evaluateDataLossOutput
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


