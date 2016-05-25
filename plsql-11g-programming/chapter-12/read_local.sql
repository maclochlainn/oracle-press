/*
 * read_local.sql
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
 * - It is read implicitly by a session call to the 
 *   DBMS_PIPE.UNPACK_MESSAGE procedure.
 * - It is anonymous in the sense that you cannot see its
 *   name or address it by name.
 * - You clear the contents of the anonymous local pipe by
 *   executing the DBMS_PIPE.RESET_BUFFER procedure.
 * - If you have not immediately run write_local.sql this
 *   program may raise an error, so it calls write_local.sql
 *   automatically. Therefore, you it must be run from a
 *   local directory that contains write_local.sql.
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

  -- Read a message from the local private pipe.
  DBMS_PIPE.UNPACK_MESSAGE(message);

  -- Print the contents of the message.
  DBMS_OUTPUT.PUT_LINE('Message ['||message||']');

END;
/
