/*
 * write_pipe.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script write three messages to a private or public
 * pipe by using the DBMS_PIPE package.
 *
 * - This script is dependent on create_pipe2.sql and it is
 *   called before running the anonymous PL/SQL block.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Ensure the public pipe is built.
@create_pipe2.sql

-- Demonstrate message sending.
DECLARE

  -- Define line return to separate pipe writes.
  line_return VARCHAR2(1) := CHR(10);

  -- Define a return value
  flag        INTEGER;

BEGIN

  -- Purge pipe content.
  dbms_pipe.purge('PLSQL$MESSAGE_INBOX');

  -- Print input title.
  DBMS_OUTPUT.PUT_LINE('Input Message to Pipe');
  DBMS_OUTPUT.PUT_LINE('---------------------');

  -- Use a range for-loop to send three messages.
  FOR i IN 1..3 LOOP

    -- Print the input line.
    DBMS_OUTPUT.PUT_LINE('Message ['||i||']');

    -- Use the procedure to put a message in the local buffer. 
    DBMS_PIPE.PACK_MESSAGE('Message ['||i||']'||line_return);

    -- Send message, success is a zero return value.
    flag := DBMS_PIPE.SEND_MESSAGE('PLSQL$MESSAGE_INBOX');

  END LOOP;

  -- Print message based on flag status.
  IF (flag = 0) THEN
    DBMS_OUTPUT.PUT_LINE('Message sent to PLSQL$MESSAGE_INBOX.');
  END IF;

END;
/
