/*
 * create_counting2.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the counting function using an OUT mode
 * parameter.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION counting
( number_out OUT NUMBER ) RETURN VARCHAR2 IS
  TYPE numbers IS TABLE OF VARCHAR2(5);
  ordinal NUMBERS := numbers('One','Two','Three','Four','Five');
  retval VARCHAR2(9) := 'Not Found';
BEGIN
  -- Replace a null value to ensure increment.
  IF number_out IS NULL THEN
    number_out := 1;
  END IF; 
  -- Increment actual parameter when within range.
  IF number_out < 4 THEN
    retval := ordinal(number_out);
    number_out := number_out + 1;
  ELSE
    retval := ordinal(number_out);
  END IF;
  RETURN retval;
END;
/

DECLARE
  counter NUMBER := 1;
BEGIN
  FOR i IN 1..5 LOOP
    dbms_output.put('Counter ['||counter||']');
    dbms_output.put_line('['||counting(counter)||']');
  END LOOP;
END;
/
