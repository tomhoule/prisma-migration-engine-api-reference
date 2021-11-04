{ ... }:

{
  methods.devDiagnostic = {
    description = ''
      Method called at the beginning of `migrate dev` to decide the course of
      action based on the current state of the workspace.
    '';
    requestShape = {
      migrationsDirectoryPath = { shape = "String"; };
    };
    responseShape = {
      action = {
        description = ''
          The suggested course of action for the CLI.
        '';
        shape = {
          taggedUnionOf = {
            Reset = {
              reason = {
                shape = "String";
              };
            };
            CreateMigration = { };
          };
        };
      };
    };
  };
}

