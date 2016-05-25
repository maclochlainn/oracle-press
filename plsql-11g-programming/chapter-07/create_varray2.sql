/*
 * create_varray2.sql
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
  -- Define a varray of integer with 3 rows.
  TYPE integer_varray IS VARRAY(3) OF INTEGER;

  -- Declare an array initialized as a no element collection.
  varray_integer INTEGER_VARRAY := integer_varray();
BEGIN
  -- Allocate space as you increment the index.
  FOR i IN 1..3 LOOP
    varray_integer.EXTEND;       -- Allocates space in the collection.
    varray_integer(i) := 10 + i; -- Assigns a value to the indexed value.
  END LOOP;

  -- Print initialized array.
  dbms_output.put_line('Varray initialized as values.');
  dbms_output.put_line('-----------------------------');
  FOR i IN 1..3 LOOP
    dbms_output.put     ('Integer Varray ['||i||'] ');
    dbms_output.put_line('['||varray_integer(i)||']');
  END LOOP;
END;
/
