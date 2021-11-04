{ ... }:

{
  methods.listMigrationDirectories = {
    description = ''
      It lists the migration directories.
    '';
    requestShape = {
      migrationsDirectoryPath = "String";
    };
    responseShape = {
      migrations = { isList = true; shape = "String"; };
    };
  };
}

