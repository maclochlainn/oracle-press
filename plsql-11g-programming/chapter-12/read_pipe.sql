/*
 * read_pipe.sql
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
 * - This script is dependent on write_pipe.sql and it is
 *   called before running the anonymous PL/SQL block.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Ensure the public pipe is built.
@create_pipe2.sql
@write_pipe.sql

-- Demonstrate message receiving.
DECLARE

  -- Define message variable.
  line_return VARCHAR2(1)     := CHR(10);
  message     VARCHAR2(4000);
  output      VARCHAR2(4000);

  -- Define a return value
  flag        INTEGER;

BEGIN

  -- Print input title.
  DBMS_OUTPUT.PUT(line_return);
  DBMS_OUTPUT.PUT_LINE('Output Message from Pipe');
  DBMS_OUTPUT.PUT_LINE('------------------------');

  -- Use range for-loop to receive and read three messages.
  FOR i IN 1..3 LOOP

    -- Reset the local buffer.
    DBMS_PIPE.RESET_BUFFER;

    -- Receive message, success is a zero return value.
    flag := DBMS_PIPE.RECEIVE_MESSAGE('PLSQL$MESSAGE_INBOX',0);

    -- Read message from local buffer.
    DBMS_PIPE.UNPACK_MESSAGE(message);

    -- Append message to output variable.
    output := output || message;

  END LOOP;

  -- Print message based on flag status.
  IF (flag = 0) THEN

    -- Print the output variable.
    DBMS_OUTPUT.PUT(output);

    -- Print confirmation message.
    DBMS_OUTPUT.PUT_LINE(
      'Message received from PLSQL$MESSAGE_INBOX.');

  END IF;

END;
/
