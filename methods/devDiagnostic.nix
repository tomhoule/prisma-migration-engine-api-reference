{ ... }:

{
  methods.devDiagnostic = {
    description = ''
      Method called at the beginning of `migrate dev` to decide the course of
      action based on the current state of the workspace.
    '';
    requestShape = "devDiagnosticInput";
    responseShape = "devDiagnosticOutput";
  };

  enumShapes = {
    devAction = {
      variants = {
        Reset = {
          shape = "devActionReset";
        };
        CreateMigration = null;
      };
    };
  };

  recordShapes = {
    devDiagnosticInput = {
      fields = {
        migrationsDirectoryPath = {
          shape = "String";
        };
      };
    };

    devActionReset = {
      fields = {
        reason = {
          shape = "String";
        };
      };
    };

    devDiagnosticOutput = {
      fields = {
        action = {
          description = ''
            The suggested course of action for the CLI.
          '';
          shape = "devAction";
        };
      };
    };
  };
}

