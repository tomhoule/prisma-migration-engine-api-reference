{ ... }:

{
  methods.devDiagnostic = {
    description = ''
      Method called at the beginning of `migrate dev` to decide the course of
      action based on the current state of the workspace.
    '';
    requestShape = {
      fields = {
        migrationsDirectoryPath = { scalar = "String"; };
      };
    };
    responseShape = {
      fields = {
        action = {
          description = ''
            The suggested course of action for the CLI.
          '';
          taggedUnionOf = {
            Reset = {
              fields = {
                reason = {
                  scalar = "String";
                };
              };
            };
            CreateMigration = { };
          };
        };
      };
    };
  };
}

