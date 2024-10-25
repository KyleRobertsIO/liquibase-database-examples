#!/bin/bash

createLiquibaseAdminUser() {
    echo "Creating Liquibase Admin User [$LIQUIBASE_ADMIN_USERNAME]"
    {
        psql -U $POSTGRES_USER -c "CREATE USER $LIQUIBASE_ADMIN_USERNAME WITH PASSWORD '$LIQUIBASE_ADMIN_PASSWORD';"
    } || {
        echo "Failed to CREATE USER..."
        return 1
    }
    return 0
}

createDatabase() {
    echo "Creating Project Database [$POSTGRES_DATABASE]"
    {
        psql -U $POSTGRES_USER -c "CREATE DATABASE $POSTGRES_DATABASE;"
    } || {
        echo "Failed to CREATE DATABASE..."
        return 1
    }
    return 0
}

setLiquibaseGrantAllPrivileges() {
    echo "Granting All Previleges To Liquibase Admin User [$LIQUIBASE_ADMIN_USERNAME]"
    {
        psql -U $POSTGRES_USER -c "GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DATABASE TO $LIQUIBASE_ADMIN_USERNAME;"
    } || {
        echo "Failed to GRANT ALL PRIVILEGES..."
        return 1
    }
    return 0
}

grantLoginForLiquibaseAdminUser() {
    echo "Granting Login To Liquibase Admin User [$LIQUIBASE_ADMIN_USERNAME]"
    {
        psql -U $POSTGRES_USER -c "ALTER ROLE $LIQUIBASE_ADMIN_USERNAME WITH LOGIN;"
    } || {
        echo "Failed to GRANT LOGIN..."
        return 1
    }
    return 0
}

grantConnectOnDatabaseForLiquibaseAdminUser() {
    echo "Granting Connect On Database [$POSTGRES_DATABASE] To Liquibase Admin User [$LIQUIBASE_ADMIN_USERNAME]"
    {
        psql -U $POSTGRES_USER -c "GRANT CONNECT ON DATABASE $POSTGRES_DATABASE TO $LIQUIBASE_ADMIN_USERNAME;"
    } || {
        echo "Failed to GRANT CONNECT..."
        return 1
    }
    return 0
}

createLiquibaseDefaultSchema() {
    echo "Creating Default Liquibase Schema [$LIQUIBASE_DEFAULT_SCHEMA] On Database [$POSTGRES_DATABASE]"
    {
        psql -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "CREATE SCHEMA $LIQUIBASE_DEFAULT_SCHEMA;"
    } || {
        echo "Failed to CREATE SCEHMA..."
        return 1
    }
    return 0
}

setLiquibaseGrantAllPrivilegesOnLiquibaseSchema() {
    echo "Granting All Previleges To Liquibase Admin User [$LIQUIBASE_ADMIN_USERNAME] On Schema [$LIQUIBASE_DEFAULT_SCHEMA]"
    {
        psql -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "GRANT ALL PRIVILEGES ON SCHEMA $LIQUIBASE_DEFAULT_SCHEMA TO $LIQUIBASE_ADMIN_USERNAME;"
    } || {
        echo "Failed to GRANT ALL PRIVILEGES..."
        return 1
    }
    return 0
}

createDatabase
createLiquibaseAdminUser
grantLoginForLiquibaseAdminUser
createLiquibaseDefaultSchema
setLiquibaseGrantAllPrivilegesOnLiquibaseSchema
setLiquibaseGrantAllPrivileges
grantConnectOnDatabaseForLiquibaseAdminUser
echo "Complete Liquibase Admin Setup"