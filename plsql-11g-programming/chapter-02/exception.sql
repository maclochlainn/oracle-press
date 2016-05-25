/*
 * exception.sql
 * Chapter 2, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script triggers and exception when the runtime
 * substitution variable is too large for the target
 * variable.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  my_var VARCHAR2(10);
BEGIN
  my_var := '&input';
  dbms_output.put_line('Hello '|| my_var );
EXCEPTION
  WHEN others THEN
    dbms_output.put_line(SQLERRM);
END;
/
