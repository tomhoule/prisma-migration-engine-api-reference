# HistoryDiagnostic

A diagnostic returned by `diagnoseMigrationHistory` when looking at the
database migration history in relation to the migrations directory.


- Variant __HistoriesDiverge__: <no data>

- Variant __DatabaseIsBehind__: [DatabaseIsBehindFields](../DatabaseIsBehindFields.md)

  There are migrations in the migrations directory that have not been  applied to the database yet.

- Variant __MigrationsDirectoryIsBehind__: <no data>

