CREATE OR ALTER PROCEDURE [dbo].[sp_init_build_healthcheck]
    @LIQUIBASE_ADMIN_USERNAME NVARCHAR(max)
AS
BEGIN
    DECLARE @LIQUIBASE_ADMIN_SETUP BIT;
    SET @LIQUIBASE_ADMIN_SETUP = (
        SELECT COUNT(*)
        FROM (
            SELECT
                DP1.name AS DatabaseRoleName,   
                ISNULL (DP2.name, 'No members') AS DatabaseUserName   
            FROM sys.database_role_members AS DRM  
            RIGHT OUTER JOIN sys.database_principals AS DP1  
                ON DRM.role_principal_id = DP1.principal_id  
            LEFT OUTER JOIN sys.database_principals AS DP2  
            ON DRM.member_principal_id = DP2.principal_id  
            WHERE 
                DP1.type = 'R'
                AND DP2.name = @LIQUIBASE_ADMIN_USERNAME
                AND DP1.name = 'db_owner'
        ) result
    )
    IF @LIQUIBASE_ADMIN_SETUP = 0
    BEGIN
        THROW 51000, 'Liquidbase admin user or [db_owner] role not applied', 1;
    END
    DROP PROCEDURE [dbo].[sp_init_build_healthcheck];
END