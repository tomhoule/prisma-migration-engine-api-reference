# devDiagnostic

The method called at the beginning of `migrate dev` to decide the course of
action based on the current state of the workspace.

It acts as a wrapper around diagnoseMigrationHistory. Its role is to interpret the diagnostic
output, and translate it to a concrete action to be performed by the CLI.



## Input type

devDiagnosticInput

### migrationsDirectoryPath: String



## Output type

devDiagnosticOutput

### action: devAction

The suggested course of action for the CLI.


