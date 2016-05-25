/*
 * if_then.sql
 * Chapter 2, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This demonstrates the NVL() function and IF-THEN statement.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- Define a Boolean variable.
  my_var BOOLEAN;
BEGIN
  -- Use a NVL function to substitute a value for evalution.
  IF NOT NVL(my_var,false) THEN
    dbms_output.put_line('This should happen!');
  ELSE
    dbms_output.put_line('This can''t happen!');
  END IF;
END;
/
