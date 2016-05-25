/*
 * create_pipe1.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script deletes pipes if it exists in the context of the current
 * session, then recreates them.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to delete a pipe.
DECLARE

  -- Define and declare a variable by removing a pipe.
  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('PLSQL$THREAD_COMPLETE');

  -- Define and declare a variable by removing a pipe.
  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('PLSQL$THREAD_DEPENDENT');

  -- Define and declare a variable by removing a pipe.
  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('PLSQL$THREAD_REGISTER');

BEGIN

 NULL; 

END;
/

-- An anonymous block program to create a pipe.
DECLARE

  -- Function output variable.
  retval INTEGER;

BEGIN

  -- Define a private pipe.
  retval := DBMS_PIPE.CREATE_PIPE('PLSQL$THREAD_COMPLETE'
                                 , 20000 );

  -- Define a private pipe.
  retval := DBMS_PIPE.CREATE_PIPE('PLSQL$THREAD_DEPENDENT'
                                 , 20000 );

  -- Define a private pipe.
  retval := DBMS_PIPE.CREATE_PIPE('PLSQL$THREAD_REGISTER'
                                 , 20000 );

  -- Print the retval status.
  IF (retval = 0) THEN
    DBMS_OUTPUT.PUT_LINE('MESSAGE_INBOX pipe is created.');
  END IF;

EXCEPTION

  -- Raise generic exception.
  WHEN others THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

END;
/    

