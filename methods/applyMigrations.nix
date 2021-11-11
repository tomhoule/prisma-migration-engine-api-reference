{ ... }:

{
  methods.applyMigrations = {
    description = ''
      Apply the migrations from the migrations directory to the database.

      This is the command behind `prisma migrate deploy`.
    '';
    requestShape = "applyMigrationsInput";
    responseShape = "applyMigrationsOutput";
  };

  recordShapes = {
    applyMigrationsInput = {
      fields = {
        migrationsDirectoryPath = { shape = "String"; };
      };
    };

    applyMigrationsOutput = {
      fields = {
        appliedMigrationNames = {
          isList = true;
          shape = "String";
        };
      };
    };
  };
}
