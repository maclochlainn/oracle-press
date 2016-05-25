/*
 * nestedtable_dml3.sql
 * Chapter 7, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates and demonstrates a nested table.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

UPDATE   TABLE(SELECT   street_address
               FROM     addresses
               WHERE    address_id = 1)
SET      column_value = 'Office of Senator John McCain'
WHERE    column_value = 'Office of Senator McCain';

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   street_address 
               FROM     addresses
               WHERE    address_id = 1);

DECLARE
  -- Define old and new values.
  new_value VARCHAR2(30 CHAR) := 'Office of Senator John McCain';
  old_value VARCHAR2(30 CHAR) := 'Office of Senator McCain';

  -- Build SQL statement to support bind variables.
  sql_statement VARCHAR2(100 CHAR)
    := 'UPDATE   THE (SELECT   street_address '
    || '              FROM     addresses '
    || '              WHERE    address_id = 21) '
    || 'SET      column_value = :1 '
    || 'WHERE    column_value = :2';
BEGIN
  -- Use dynamic SQL to run the update statement.
  EXECUTE IMMEDIATE sql_statement USING new_value, old_value;
END;
/

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   street_address 
               FROM     addresses
               WHERE    address_id = 1);

