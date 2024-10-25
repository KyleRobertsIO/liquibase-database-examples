#!/bin/bash

for i in {1..50};
do
    echo "Attempting To Initialize [$DATABASE_NAME] Database"
    /opt/mssql-tools/bin/sqlcmd \
        -S "localhost" \
        -U ${MSSQL_SA_USERNAME} \
        -P ${MSSQL_SA_PASSWORD} \
        -d master \
        -Q "CREATE DATABASE $DATABASE_NAME;"
    if [ $? -eq 0 ]
    then
        echo "Creating Objects In [$DATABASE_NAME]"
        {
            echo "Creating [$LIQUIBASE_DEFAULT_SCHEMA] Schema"
            /opt/mssql-tools/bin/sqlcmd \
                -S "localhost" \
                -U ${MSSQL_SA_USERNAME} \
                -P ${MSSQL_SA_PASSWORD} \
                -d $DATABASE_NAME \
                -Q "CREATE SCHEMA [$LIQUIBASE_DEFAULT_SCHEMA];"
            echo "Creating [$LIQUIBASE_USERNAME] Admin Login"
            /opt/mssql-tools/bin/sqlcmd \
                -S "localhost" \
                -U ${MSSQL_SA_USERNAME} \
                -P ${MSSQL_SA_PASSWORD} \
                -d master \
                -Q "CREATE LOGIN $LIQUIBASE_USERNAME WITH PASSWORD = '$LIQUIBASE_PASSWORD';"
            echo "Creating [$LIQUIBASE_USERNAME] Admin User"
            /opt/mssql-tools/bin/sqlcmd \
                -S "localhost" \
                -U ${MSSQL_SA_USERNAME} \
                -P ${MSSQL_SA_PASSWORD} \
                -d $DATABASE_NAME \
                -Q "CREATE USER [$LIQUIBASE_USERNAME] FOR LOGIN [$LIQUIBASE_USERNAME];"
            echo "Setting Default Schema [$LIQUIBASE_DEFAULT_SCHEMA] For [$LIQUIBASE_USERNAME] Admin"
            /opt/mssql-tools/bin/sqlcmd \
                -S "localhost" \
                -U ${MSSQL_SA_USERNAME} \
                -P ${MSSQL_SA_PASSWORD} \
                -d $DATABASE_NAME \
                -Q "ALTER USER $LIQUIBASE_USERNAME WITH DEFAULT_SCHEMA = $LIQUIBASE_DEFAULT_SCHEMA;"
            echo "Setting [db_owner] Role For [$LIQUIBASE_USERNAME] Admin"
            /opt/mssql-tools/bin/sqlcmd \
                -S "localhost" \
                -U ${MSSQL_SA_USERNAME} \
                -P ${MSSQL_SA_PASSWORD} \
                -d $DATABASE_NAME \
                -Q "ALTER ROLE [db_owner] ADD MEMBER [$LIQUIBASE_USERNAME];"
            echo "Database Setup Complete"
        } || {
            echo "Database Setup Failed"
            break
        }

        # Keep container process alive forever
        echo "Application database is operational"
        while true
        do
            sleep 1
        done
    else
        # Database is not ready yet for connection
        sleep 1
    fi
done