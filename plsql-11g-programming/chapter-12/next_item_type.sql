/*
 * next_item_type.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script tests DBMS_PIPE for a private pipe.
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

  -- Define session.
  session     VARCHAR2(30) := DBMS_PIPE.UNIQUE_SESSION_NAME;

  -- Define line return to separate pipe writes.
  line_return VARCHAR2(1) := CHR(10);
  message     VARCHAR2(4000);
  output      VARCHAR2(4000);

  -- Define a return values.
  flag        INTEGER;
  code        INTEGER;

  -- Define and declare input variables.
  message1    INTEGER     := 1776;
  message2    DATE        := TO_DATE('04-JUL-1776');
  message3    VARCHAR2(30 CHAR) := 'John Adams';

  -- Define output variables.
  message11   INTEGER;
  message12   DATE;
  message13   VARCHAR2(30 CHAR);

BEGIN

  -- Purge pipe content.
  DBMS_PIPE.PURGE('PLSQL$MESSAGE_INBOX');

  -- Print input title.
  DBMS_OUTPUT.PUT_LINE('Input Message to Pipe');
  DBMS_OUTPUT.PUT_LINE('Session: ['||session||']');
  DBMS_OUTPUT.PUT_LINE('--------------------------------');

  -- Do the following for message1, message2 and message3:
  -- 1. Print the input line.
  -- 2. Use the procedure to put a message in local buffer
  --    of a specific data type. 
  -- 3. Send message, success is a zero return value.

  -- Process message1.
  DBMS_OUTPUT.PUT_LINE(message1||'[NUMBER]');
  DBMS_PIPE.PACK_MESSAGE(message1);
  flag := DBMS_PIPE.SEND_MESSAGE('PLSQL$MESSAGE_INBOX');

  -- Process message2.
  DBMS_OUTPUT.PUT_LINE(message2||'[DATE]');
  DBMS_PIPE.PACK_MESSAGE(message2);
  flag := DBMS_PIPE.SEND_MESSAGE('PLSQL$MESSAGE_INBOX');

  -- Process message3.
  DBMS_OUTPUT.PUT_LINE(message3||'[VARCHAR2]');
  DBMS_PIPE.PACK_MESSAGE(message3);
  flag := DBMS_PIPE.SEND_MESSAGE('PLSQL$MESSAGE_INBOX');

  -- Print message based on flag status.
  IF (flag = 0) THEN
    DBMS_OUTPUT.PUT_LINE('Message sent to PLSQL$MESSAGE_INBOX.');
  END IF;

  -- Print input title.
  DBMS_OUTPUT.PUT(line_return);
  DBMS_OUTPUT.PUT_LINE('Output Message from Pipe');
  DBMS_OUTPUT.PUT_LINE('Session: ['||session||']');
  DBMS_OUTPUT.PUT_LINE('--------------------------------');

  -- Use range for-loop to receive and read three messages.
  FOR i IN 1..3 LOOP

    -- Reset the local buffer.
    DBMS_PIPE.RESET_BUFFER;

    -- Receive message, success is a zero return value.
    flag := DBMS_PIPE.RECEIVE_MESSAGE('PLSQL$MESSAGE_INBOX',0);

    -- Get the item type from the buffer contents.
    code := DBMS_PIPE.NEXT_ITEM_TYPE;    

    -- Use case statement to return string.
    CASE code

      -- When buffer contents is a NUMBER.
      WHEN 6 THEN

        -- Unpack into a NUMBER variable type.
        DBMS_PIPE.UNPACK_MESSAGE(message11);
        output := output || message11
               ||'[NUMBER]'||line_return;

      -- When buffer contents is a VARCHAR2.
      WHEN 9 THEN

        -- Unpack into a VARCHAR2 variable type.
        DBMS_PIPE.UNPACK_MESSAGE(message13);
        output := output || message13
               ||'[VARCHAR2]'||line_return;

      -- When buffer contents is a DATE.
      WHEN 12 THEN

        -- Unpack into a DATE variable type.
        DBMS_PIPE.UNPACK_MESSAGE(message12);
        output := output || message12
               ||'[DATE]'||line_return;

    END CASE;

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
