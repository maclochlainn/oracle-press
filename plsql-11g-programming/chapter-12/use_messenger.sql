/*
 * use_messenger.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script demonstrates MESSENGER as a wrapper for the
 * DBMS_PIPE package.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

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
  
BEGIN

  -- Send a message.
  IF (MESSENGER.SEND_MESSAGE(get_user,'Hello World!') = 0) THEN

    -- Receive and print message.
    DBMS_OUTPUT.PUT_LINE(MESSENGER.RECEIVE_MESSAGE);

  END IF;

END;
/
