/*
 * create_assocarray6.sql
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
  -- Define variables to traverse a string indexed associative array.
  current VARCHAR2(9 CHAR);
  element INTEGER;

  -- Define required collection data types. 
  TYPE months_varray IS VARRAY(12) OF STRING(9 CHAR);.
  TYPE calendar_table IS TABLE OF VARCHAR2(9 CHAR) INDEX BY VARCHAR2(9 CHAR);

  -- Declare a varray.
  month MONTHS_VARRAY :=
    months_varray('January','February','March','April','May','June'
                 ,'July','August','September','October','November','December');

  -- Declare empty associative array.
  calendar CALENDAR_TABLE;
BEGIN
  -- Check if calendar has no elements.
  IF calendar.COUNT = 0 THEN
    -- Print assignment output title.
    DBMS_OUTPUT.PUT_LINE('Assignment loop:');
    DBMS_OUTPUT.PUT_LINE('----------------');
    FOR i IN month.FIRST..month.LAST LOOP
      calendar(month(i)) := TO_CHAR(i);
      DBMS_OUTPUT.PUT_LINE('Index ['||month(i)||'] is ['||i||']');
    END LOOP;

    -- Print assigned output title.
    DBMS_OUTPUT.PUT(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Post-assignment loop:');
    DBMS_OUTPUT.PUT_LINE('---------------------');
    FOR i IN 1..calendar.COUNT LOOP
      IF i = 1 THEN
        -- Assign the first character index to a variable.
        current := calendar.FIRST;
        -- Use the derived index to find the next index.
        element := calendar(current);
      ELSE
        -- Check if next index value exists.
        IF calendar.NEXT(current) IS NOT NULL THEN
          -- Assign the character index to a variable.
          current := calendar.NEXT(current);
          -- Use the derived index to find the next index.
          element := calendar(current);
        ELSE
          -- Exit loop since last index value is read.
          EXIT;
        END IF;
      END IF;

      -- Print an indexed element from the array.
      DBMS_OUTPUT.PUT_LINE('Index ['||current||'] is ['||element||']');
    END LOOP;
  END IF;
END;
/
