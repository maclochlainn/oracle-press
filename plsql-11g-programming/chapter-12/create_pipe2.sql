/*
 * create_pipe2.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script deletes a pipe if it exists in the context of the current
 * session, then recreates it.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- An anonymous block program to delete a pipe.
DECLARE

  -- Define and declare a variable by removing a pipe.
--  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('PLSQL$MESSAGE_INBOX');

BEGIN

 NULL; 

END;
/

-- An anonymous block program to create a pipe.
DECLARE

  -- Define and declare variables.
  message_pipe VARCHAR2(30) := 'PLSQL$MESSAGE_INBOX';
  message_size INTEGER      := 20000;
  message_flag BOOLEAN      := FALSE;
   
  -- Function output variable.
  retval INTEGER;

BEGIN

  -- Define a public pipe.
  retval := DBMS_PIPE.CREATE_PIPE(message_pipe
                                 ,message_size
                                 ,message_flag);

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

