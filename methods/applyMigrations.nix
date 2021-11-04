{ ... }:

{
  methods.applyMigrations = {
    description = ''
      Apply the migrations from the migrations directory to the database.

      This is the command behind `prisma migrate deploy`.
    '';
    requestShape = {
      migrationsDirectoryPath = { shape = "String"; };
    };
    responseShape = {
      appliedMigrationNames = {
        isList = true;
        shape = "String";
      };
    };
  };
}
