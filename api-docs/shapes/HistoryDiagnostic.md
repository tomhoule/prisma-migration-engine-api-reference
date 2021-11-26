# HistoryDiagnostic

A diagnostic returned by `diagnoseMigrationHistory` when looking at the
database migration history in relation to the migrations directory.


- Variant __DatabaseIsBehind__: [DatabaseIsBehindFields](../shapes/DatabaseIsBehindFields.md)

  There are migrations in the migrations directory that have not been  applied to the database yet.

- Variant __MigrationsDirectoryIsBehind__: &lt;no data&gt;

- Variant __HistoriesDiverge__: &lt;no data&gt;

