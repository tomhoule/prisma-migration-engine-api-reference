{ ... }:

{
  methods.devDiagnostic = {
    description = ''
      The method called at the beginning of `migrate dev` to decide the course of
      action based on the current state of the workspace.

      It acts as a wrapper around diagnoseMigrationHistory. Its role is to interpret the diagnostic
      output, and translate it to a concrete action to be performed by the CLI.
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

