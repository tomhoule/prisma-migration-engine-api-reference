# createMigrationOutput
- generatedMigrationName: [String](../shapes/String.md)

  The name of the newly generated migration directory, if any.
  
  generatedMigrationName will be null if: 1. The migration we generate would be empty,
  AND 2. the `draft` param was not true, because in that case the engine would
  still generate an empty migration script.


