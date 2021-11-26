# devDiagnostic

The method called at the beginning of `migrate dev` to decide the course of
action based on the current state of the workspace.

It acts as a wrapper around diagnoseMigrationHistory. Its role is to interpret the diagnostic
output, and translate it to a concrete action to be performed by the CLI.



## Request shape

Name: devDiagnosticInput


- migrationsDirectoryPath: [String](../shapes/String.md)



## Response shape

Name: devDiagnosticOutput


- action: [devAction](../shapes/devAction.md)

  The suggested course of action for the CLI.


