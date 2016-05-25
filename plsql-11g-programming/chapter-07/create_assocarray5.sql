/*
 * create_assocarray5.sql
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

DECLARE
  -- Define a varray of twelve strings.
  TYPE months_varray IS VARRAY(12) OF STRING(9 CHAR);

  -- Define an associative array of strings.
  TYPE calendar_table IS TABLE OF VARCHAR2(9 CHAR) INDEX BY BINARY_INTEGER;

  -- Declare and construct a varray.
  month MONTHS_VARRAY :=
    months_varray('January','February','March','April','May','June'
                 ,'July','August','September','October','November','December');

  -- Declare an associative array variable.
  calendar CALENDAR_TABLE;
BEGIN
  -- Check if calendar has no elements, then add months.
  IF calendar.COUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Assignment loop:');
    DBMS_OUTPUT.PUT_LINE('----------------');
    FOR i IN month.FIRST..month.LAST LOOP
      calendar(i) := '';
      DBMS_OUTPUT.PUT_LINE('Index ['||i||'] is ['||calendar(i)||']');
      calendar(i) := month(i);
    END LOOP;

    -- Print assigned element values.
    DBMS_OUTPUT.PUT(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Post-assignment loop:');
    DBMS_OUTPUT.PUT_LINE('---------------------');
    FOR i IN calendar.FIRST..calendar.LAST LOOP
      DBMS_OUTPUT.PUT_LINE('Index ['||i||'] is ['||calendar(i)||']');
    END LOOP;
  END IF;
END;
/
