/*
 * create_pipe4.sql
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
  retval INTEGER := DBMS_PIPE.REMOVE_PIPE('EVENT_MESSAGE_QUEUE');

BEGIN

 NULL; 

END;
/
