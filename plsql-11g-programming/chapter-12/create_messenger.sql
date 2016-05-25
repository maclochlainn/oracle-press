/*
 * create_messenger.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script sends builds a package to send and receive
 * messages between users.
 *
 * It has a dependencies on message pipes adhering to a
 * standard naming convention. Please ensure you have
 * run create_pipe3.sql in any user schemas that will
 * participate in your test. Alternatively, please have
 * the script in the same directory where it can be 
 * called by this script.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Call script to build local pipes.
@create_pipe3.sql

-- Create package specification.
CREATE OR REPLACE PACKAGE messenger IS

  -- Define function specification.
  FUNCTION send_message
    (user_name      VARCHAR2
    ,message        VARCHAR2
    ,message_box    VARCHAR2 DEFAULT 'MESSAGE_INBOX')
    RETURN INTEGER;

  -- Define function specification.
  FUNCTION receive_message
    RETURN VARCHAR2;

END messenger;
/

-- Show any errors while building specification.
show errors

-- Create package body.
CREATE OR REPLACE PACKAGE BODY messenger IS

  -- Define local package function to return user name.
  FUNCTION get_user 
    RETURN VARCHAR2 IS

  BEGIN

    -- Use a cursor for-loop to get user name.
    FOR i IN (SELECT user FROM dual) LOOP

      -- Return the user.
      return i.user;

    END LOOP;
 
  END get_user;
  
  -- Implement package function defined in specification.
  FUNCTION send_message
    (user_name      VARCHAR2
    ,message        VARCHAR2
    ,message_box    VARCHAR2 DEFAULT 'MESSAGE_INBOX')
    RETURN INTEGER IS

    -- Define variable for target mailbox.
    message_pipe    VARCHAR2(100 CHAR);

  BEGIN

    -- Purge local pipe content.
    DBMS_PIPE.RESET_BUFFER;

    -- Declare the target outbox for a message.
    message_pipe := UPPER(user_name) || '$'
                 || UPPER(message_box);

    -- Use the procedure to put a message in the local buffer. 
    DBMS_PIPE.PACK_MESSAGE(message);

    -- Send message, success is a zero return value.
    IF (DBMS_PIPE.send_message(message_pipe) = 0) THEN

      -- Message sent, so return 0.
      RETURN 0;

    ELSE

      -- Message not sent, so return 1.
      RETURN 1;

    END IF; 

  END send_message;
  
  -- Implement package function defined in specification.
  FUNCTION receive_message
    RETURN VARCHAR2 IS

    -- Define variable for target mailbox.
    message         VARCHAR2(4000 CHAR) :=  NULL;
    message_box     VARCHAR2(100 CHAR);
    inbox           VARCHAR2(14 CHAR) := 'MESSAGE_INBOX';
    timeout         INTEGER := 0;
    return_code     INTEGER;

  BEGIN

    -- Purge local pipe content.
    DBMS_PIPE.RESET_BUFFER;

    -- Declare the target outbox for a message.
    message_box := get_user || '$' || inbox;

    -- Use the procedure to put a message in the local buffer. 
    return_code := DBMS_PIPE.receive_message(message_box,timeout);

    -- Evaluate and process return code.
    CASE return_code
      WHEN 0 THEN 

        -- Read the message into a variable.
        DBMS_PIPE.UNPACK_MESSAGE(message);

      WHEN 1 THEN

      -- Assign message.
      message := 'The message pipe is empty.';

      WHEN 2 THEN 

      -- Assign message.
      message := 'The message is too large for variable.';

      WHEN 3 THEN 

      -- Assign message.
      message := 'An interrupt occurred, contact the DBA.';

    END CASE;

    -- Return the message.
    RETURN message;

  END receive_message;

END messenger;
/

-- Show any errors while building specification.
show errors
