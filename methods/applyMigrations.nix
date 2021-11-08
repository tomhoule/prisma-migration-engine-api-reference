{ ... }:

{
  methods.applyMigrations = {
    description = ''
      Apply the migrations from the migrations directory to the database.

      This is the command behind `prisma migrate deploy`.
    '';
    requestShape = {
      fields = {
        migrationsDirectoryPath = { scalar = "String"; };
      };
    };
    responseShape = {
      fields = {
        appliedMigrationNames = {
          isList = true;
          scalar = "String";
          fields = { hey = { scalar = "String"; }; };
        };
      };
    };
  };
}
