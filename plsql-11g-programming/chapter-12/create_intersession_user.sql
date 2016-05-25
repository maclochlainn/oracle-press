/*
 * create_intersession_user.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script verifies and defines the PLSQL user. It should be run
 * as the SYSTEM user or a user that has the DBA privilege role and
 * EXECUTE with grant option on DBMS_PIPE.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  -- Define an exception.
  wrong_schema EXCEPTION;
  PRAGMA EXCEPTION_INIT(wrong_schema,-20001);

  -- Define a return variable.
  retval VARCHAR2(1 CHAR);

  /*
  || Define a cursor to identify whether the current user is either the
  || SYSTEM user or a user with the DBA role privilege.
  */
  CURSOR privs IS
    SELECT   DISTINCT null
    FROM     user_role_privs
    WHERE    username = 'SYSTEM'
    OR       granted_role = 'DBA';

BEGIN

  -- Open cursor and read through it.
  OPEN privs;
  LOOP

    -- Read a row.
    FETCH privs INTO retval;

    -- Evaluate if cursor failed.
    IF privs%NOTFOUND THEN

      -- Raise exception.
      RAISE wrong_schema;

    ELSE

      -- Evaluate whether PLSQL user exists and drop it.
      FOR i IN (SELECT null FROM dba_users WHERE username = 'PLSQL') LOOP
        EXECUTE IMMEDIATE 'DROP USER plsql CASCADE';
      END LOOP;

      -- Create user and grant privileges.
      EXECUTE IMMEDIATE 'CREATE USER plsql IDENTIFIED BY plsql';
      EXECUTE IMMEDIATE 'GRANT connect TO plsql';
      EXECUTE IMMEDIATE 'GRANT resource TO plsql';
      EXECUTE IMMEDIATE 'GRANT execute ON dbms_pipe TO plsql';
      EXECUTE IMMEDIATE 'GRANT execute ON dbms_alert TO plsql';

      -- Print successful outcome.
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Created PLSQL user.');

    END IF; 

    -- Exit the loop.
    EXIT;

  END LOOP;

  -- Close cursor.
  CLOSE privs;

EXCEPTION

  -- Handle a defined exception.
  WHEN wrong_schema THEN
    DBMS_OUTPUT.PUT_LINE('The script requires the SYSTEM user and '
    ||                   'you are using the <'||user||'> schema or '
    ||                   'the script requires a user with DBA role '
    ||                   'privileges.');

  -- Handle a generic exception.
  WHEN others THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

END;
/

-- Define SQL*Plus formatting.
COL grantee          FORMAT A8
COL granted_role     FORMAT A30
COL grantor          FORMAT A8
COL privilege        FORMAT A12
COL owner            FORMAT A4
COL table_name       FORMAT A30

-- Query user granted roles.
SELECT   grantee
,        granted_role
FROM     dba_role_privs
WHERE    grantee = 'PLSQL';

-- Query resources.
SELECT   grantor
,        owner
,        table_name
,        grantee
,        privilege
FROM     dba_tab_privs
WHERE    grantee = 'PLSQL';
