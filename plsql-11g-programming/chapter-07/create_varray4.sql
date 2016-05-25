/*
 * create_varray4.sql
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

CREATE OR REPLACE TYPE integer_varray
  AS VARRAY(100) OF INTEGER NOT NULL;
/

DECLARE
  varray_integer INTEGER_VARRAY := integer_varray();
BEGIN
  FOR i IN 1..varray_integer.LIMIT LOOP
    varray_integer.EXTEND;
  END LOOP;
    dbms_output.put     ('Integer Varray Initialized ');
    dbms_output.put_line('['||varray_integer.COUNT||']');
END;
/
