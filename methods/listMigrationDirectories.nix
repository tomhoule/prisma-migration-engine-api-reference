{ ... }:

{
  methods.listMigrationDirectories = {
    description = ''
      List the names of the migrations in the migrations directory.
    '';
    requestShape = "listMigrationDirectoriesInput";
    responseShape = "listMigrationDirectoriesOutput";
  };

  recordShapes = {
    listMigrationDirectoriesInput = {
      fields = {
        migrationsDirectoryPath = { shape = "String"; };
      };
    };
    listMigrationDirectoriesOutput = {
      fields = {
        migrations = { isList = true; shape = "String"; };
      };
    };
  };
}

