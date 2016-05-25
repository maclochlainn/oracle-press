/*
 * create_pipe3.sql
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
  retval INTEGER;

  -- Define function to return user name.
  FUNCTION get_user 
    RETURN VARCHAR2 IS

  BEGIN

    -- Use a cursor for-loop to get user name.
    FOR i IN (SELECT user FROM dual) LOOP
      return i.user;
    END LOOP;
 
  END get_user;
  
BEGIN

  -- Remove USER$PIPE_NAME pipes.
  retval := DBMS_PIPE.REMOVE_PIPE(get_user||'$'||'MESSAGE_INBOX');
  retval := DBMS_PIPE.REMOVE_PIPE(get_user||'$'||'MESSAGE_OUTBOX');

END;
/

-- An anonymous block program to create a pipe.
DECLARE

  -- Define and declare variables.
  message_pipe_in   VARCHAR2(30) := 'MESSAGE_INBOX';
  message_pipe_out  VARCHAR2(30) := 'MESSAGE_OUTBOX';
  message_size      INTEGER      := 100;
  message_flag      BOOLEAN      := FALSE;
   
  -- Function output variable.
  retval INTEGER;

  -- Define output variable.
  output VARCHAR2(4000 CHAR);

  -- Define custom exceptions.
  pipename_is_null  EXCEPTION;
  message_not_sized EXCEPTION;

  -- Define precompiler instructions for custom exceptions.
  PRAGMA EXCEPTION_INIT(pipename_is_null,-23321);
  PRAGMA EXCEPTION_INIT(message_not_sized,-6557);

  -- Define function to return user name.
  FUNCTION get_user 
    RETURN VARCHAR2 IS

  BEGIN

    -- Use a cursor for-loop to get user name.
    FOR i IN (SELECT user FROM dual) LOOP
      return i.user;
    END LOOP;
 
  END get_user;
  
  PROCEDURE print_status
    (pipename   VARCHAR2
    ,pipesize   INTEGER
    ,private    BOOLEAN DEFAULT TRUE
    ,value_in   INTEGER) IS
    
    -- Define a variable length string for Boolean.
    state       VARCHAR2(5 CHAR) := 'True';

  BEGIN

    -- Check boolean and change if not default.
    IF NOT private THEN
      state := 'False';
    END IF;

    -- Print the retval status.
    IF (value_in = 0) THEN
      DBMS_OUTPUT.PUT_LINE('Created successfully');
      DBMS_OUTPUT.PUT_LINE('Pipe Name ['||pipename||']');
      DBMS_OUTPUT.PUT_LINE('Pipe Size ['||pipesize||']');
      DBMS_OUTPUT.PUT_LINE('Private   ['||state   ||']');
      DBMS_OUTPUT.PUT(CHR(10));
    END IF;

  END print_status;

BEGIN

  -- Prepend the user name to the pipe names.
  message_pipe_in := get_user || '$' || message_pipe_in;
  message_pipe_out := get_user || '$' || message_pipe_out;

  -- Define a private pipe for inbound messages.
  retval := DBMS_PIPE.CREATE_PIPE
              (pipename    => message_pipe_in
              ,maxpipesize => message_size
              ,private     => message_flag);

  -- Print output value.
  print_status(message_pipe_in
              ,message_size
              ,message_flag
              ,retval);

  -- Reset message flag to set private pipe.
  message_flag := TRUE;

  -- Define a private pipe for outbound messages.
  retval := DBMS_PIPE.CREATE_PIPE
              (pipename    => message_pipe_out
              ,maxpipesize => message_size
              ,private     => message_flag);

  -- Print output value.
  print_status(message_pipe_out
              ,message_size
              ,message_flag
              ,retval);

  -- Print the retval status.
  IF (retval = 0) THEN
    DBMS_OUTPUT.PUT(output);
  END IF;

EXCEPTION

  -- Raise when PIPENAME is null.
  WHEN pipename_is_null THEN
    DBMS_OUTPUT.PUT_LINE('No pipe name is defined.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

  -- Raise when MAXPIPESIZE is null.
  WHEN message_not_sized THEN
    DBMS_OUTPUT.PUT_LINE('A null cannot be the max size.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

  -- Raise generic exception.
  WHEN others THEN
    DBMS_OUTPUT.PUT_LINE('Another type of error.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

END;
/    

