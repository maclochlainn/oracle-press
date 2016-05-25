/*
 * create_varray3.sql
 * Chapter 7, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates and demonstrates a varray.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE TYPE integer_varray AS VARRAY(3) OF INTEGER;
/

-- This is in create_varray1.sql on the publisher web site.
DECLARE
  varray_integer INTEGER_VARRAY := integer_varray(NULL,NULL,NULL);
BEGIN
  -- Assign values to replace the null values.
  FOR i IN 1..3 LOOP
    varray_integer(i) := 10 + i;
  END LOOP;
  -- Print the initialized values.
  dbms_output.put_line('Varray initialized as values.');
  dbms_output.put_line('-----------------------------');
  FOR i IN 1..3 LOOP
    dbms_output.put     ('Integer Varray ['||i||'] ');
    dbms_output.put_line('['||varray_integer(i)||']');
  END LOOP;
END;
/
