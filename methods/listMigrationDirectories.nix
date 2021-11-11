{ ... }:

{
  methods.listMigrationDirectories = {
    description = ''
      It lists the migration directories.
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

