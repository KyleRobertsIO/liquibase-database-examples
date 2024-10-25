CREATE OR REPLACE PROCEDURE check_database_privilege_and_proceed()
LANGUAGE plpgsql
AS $$
DECLARE
    has_privilege BOOLEAN;  -- Declare a boolean variable to store the result of the privilege check
BEGIN
    -- Check if 'liquibase_admin' has the 'CONNECT' privilege on 'demo_db'
    SELECT has_database_privilege('liquibase_admin', 'demo_db', 'CONNECT') INTO has_privilege;

    -- If the user has the privilege, proceed with the procedure
    IF has_privilege THEN
        RAISE NOTICE 'User liquibase_admin has CONNECT privilege on demo_db.';
        -- Place your main procedure logic here
        -- For example, you can do any operation if the privilege is granted
        -- Example: RAISE NOTICE 'Running the procedure logic...';
    ELSE
        -- Raise an error if the privilege is not granted
        RAISE EXCEPTION 'User liquibase_admin does not have CONNECT privilege on demo_db.';
    END IF;
END;
$$;