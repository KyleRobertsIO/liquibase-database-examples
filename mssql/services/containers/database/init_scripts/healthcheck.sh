#!/bin/bash

/opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U $MSSQL_SA_USERNAME \
    -P $MSSQL_SA_PASSWORD \
    -d $DATABASE_NAME \
    -i/db_setup/init_sql/healthcheck.sql

/opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U $MSSQL_SA_USERNAME \
    -P $MSSQL_SA_PASSWORD \
    -d $DATABASE_NAME \
    -Q "EXEC [dbo].[sp_init_build_healthcheck] $LIQUIBASE_USERNAME" -b -o /dev/null