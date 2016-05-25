/*
 * read_message.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script unpacks the local buffer.
*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE

  message VARCHAR2(30 CHAR) := NULL;
  success INTEGER;

BEGIN

  success := DBMS_PIPE.RECEIVE_MESSAGE('ORA$PIPE$00F3B7B50001',1);

  IF (success = 0) THEN
    DBMS_PIPE.UNPACK_MESSAGE(message);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Error');
    message := TO_CHAR(success);
  END IF;

  DBMS_OUTPUT.PUT_LINE('Message ['||message||']');

END;
/
