{ ... }:

{
  methods.dbExecute = {
    description = ''
      Execute a database script directly on the specified live database.

      Note that this may not be defined on all connectors.
    '';
    requestShape = "dbExecuteInput";
    responseShape = "dbExecuteOutput";
  };

  recordShapes = {
    dbExecuteInput = {
      fields = {
        datasourceType = { shape = "dbExecuteDatasourceType"; };
        inputType = { shape = "dbExecuteInputType"; };
      };
    };

    dbExecuteOutput = {
      fields = { };
    };
  };

  enumShapes = {
    dbExecuteInputType = {
      description = "The input script for dbExecute.";

      variants = {
        url = { shape = "string"; };
        filePath = { shape = "string"; };
      };
    };

    dbExecuteDatasourceType = {
      description = "The location of the live database to connect to in dbExecute.";

      variants = {
        url = {
          description = "The URL of the database to run the command on.";
          shape = "string";
        };
        schema = {
          description = "Path to the Prisma schema to take the datasource URL from.";
          shape = "string";
        };
      };
    };
  };
}
