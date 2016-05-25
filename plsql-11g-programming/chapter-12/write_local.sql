/*
 * write_local.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script uses DBMS_PIPE to write a local message to
 * the implicit anonymous session pipe. It has the following
 * characteristics:
 *
 * - It can only be accessed by a user that is granted
 *   execute permission on DBMS_PIPE.
 * - It is created in the SGA as a private pipe tied to
 *   the UNIQUE_SESSION_NAME.
 * - It is created implicitly by a session call to the 
 *   DBMS_PIPE.PACK_MESSAGE procedure.
 * - It is anonymous in the sense that you cannot see its
 *   name or address it by name.
 * - You clear the contents of the anonymous local pipe by
 *   executing the DBMS_PIPE.RESET_BUFFER procedure.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Define an anonymous block to populate the local private pipe.
DECLARE

  -- Define variables for functions and procedures. 
  message   VARCHAR2(30 CHAR);
  success   INTEGER;

BEGIN

  -- Assign the unique session name to message.
  message := DBMS_PIPE.UNIQUE_SESSION_NAME;

  -- Reset the local private pipe.
  DBMS_PIPE.RESET_BUFFER;

  -- Write a message to the local private pipe.
  DBMS_PIPE.PACK_MESSAGE(message);

  -- Write what was written to the pipe.
  DBMS_OUTPUT.PUT_LINE('Written to pipe ['||message||']');

END;
/
