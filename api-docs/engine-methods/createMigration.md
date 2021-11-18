# createMigration

Create the next migration in the migrations history. If draft is false and there are no
unexecutable steps, it will also apply the newly created migration.

**Note**: The user currently needs database creation/drop permissions in order for the
command to work (because of the shadow database).
