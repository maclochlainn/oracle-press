/*
 * create_varray1.sql
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

-- This is in create_varray1.sql on the publisher web site.
DECLARE
  -- Define a varray with a maximum of 3 rows.
  TYPE integer_varray IS VARRAY(3) OF INTEGER;

  -- Declare the varray with null values.
  varray_integer INTEGER_VARRAY := integer_varray(NULL,NULL,NULL);
BEGIN
  -- Print initialized null values.
  dbms_output.put_line('Varray initialized as nulls.');
  dbms_output.put_line('----------------------------');
  FOR i IN 1..3 LOOP
    dbms_output.put     ('Integer Varray ['||i||'] ');
    dbms_output.put_line('['||varray_integer(i)||']');
  END LOOP;

  -- Assign values to subscripted members of the varray.
  varray_integer(1) := 11;
  varray_integer(2) := 12;
  varray_integer(3) := 13;

  -- Print initialized null values.
  dbms_output.put     (CHR(10)); -- Visual line break.
  dbms_output.put_line('Varray initialized as values.');
  dbms_output.put_line('-----------------------------');
  FOR i IN 1..3 LOOP
    dbms_output.put_line('Integer Varray ['||i||'] '
    ||                   '['||varray_integer(i)||']');
  END LOOP;
END;
/
