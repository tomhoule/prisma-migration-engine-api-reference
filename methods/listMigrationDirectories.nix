{ ... }:

{
  methods.listMigrationDirectories = {
    description = ''
      It lists the migration directories.
    '';
    requestShape = {
      fields = {
        migrationsDirectoryPath = { scalar = "String"; };
      };
    };
    responseShape = {
      fields = {
        migrations = { isList = true; scalar = "String"; };
      };
    };
  };
}

