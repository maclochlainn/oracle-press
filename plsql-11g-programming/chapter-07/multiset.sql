/*
 * multiset.sql
 * Chapter 7, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates and demonstrates a collection set operators.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE TYPE list IS TABLE OF NUMBER;
/

CREATE OR REPLACE FUNCTION format_list(set_in LIST) RETURN VARCHAR2 IS
  retval VARCHAR2(2000);
BEGIN
  IF set_in IS NULL THEN
    dbms_output.put_line('Result: <Null>');
  ELSIF set_in.COUNT = 0 THEN
    dbms_output.put_line('Result: <Empty>');
  ELSE
    FOR i IN set_in.FIRST..set_in.LAST LOOP
      IF i = set_in.FIRST THEN
        IF set_in.COUNT = 1 THEN
          retval := '('||set_in(i)||')';
        ELSE
          retval := '('||set_in(i);  
        END IF;
      ELSIF i <> set_in.LAST THEN
        retval := retval||', '||set_in(i);
      ELSE
        retval := retval||', '||set_in(i)||')';
      END IF;
    END LOOP;
  END IF;
  RETURN retval;
END format_list;
/


-- Demonstrate the equivalent of a MINUS operator with collections.
DECLARE
  a LIST := list(1,2,3,4);
  b LIST := list(4,5,6,7);
BEGIN
  dbms_output.put_line(format_list(a MULTISET EXCEPT b)); 
END;
/

-- Demonstrate the equivalent of a INTERSECT operator with collections.
DECLARE
  a LIST := list(1,2,3,4);
  b LIST := list(4,5,6,7);
BEGIN
  dbms_output.put_line(format_list(a MULTISET INTERSECT b)); 
END;
/

-- Demonstrate the equivalent of a UNION ALL operator with collections.
DECLARE
  a LIST := list(1,2,3,4);
  b LIST := list(4,5,6,7);
BEGIN
  dbms_output.put_line(format_list(a MULTISET UNION b)); 
END;
/

-- Demonstrate the equivalent of a UNION operator with collections.
DECLARE
  a LIST := list(1,2,3,4);
  b LIST := list(4,5,6,7);
BEGIN
  dbms_output.put_line(format_list(a MULTISET UNION DISTINCT b)); 
END;
/

-- Demonstrate the equivalent of a UNION operator with collections.
DECLARE
  a LIST := list(1,2,3,4);
  b LIST := list(4,5,6,7);
BEGIN
  dbms_output.put_line(format_list(SET(a MULTISET UNION b))); 
END;
/

-- Demonstrate the equivalent of a MINUS operator with collections.
DECLARE
  a LIST := list(1,2,3,3,4,4,5,6,6,7);
BEGIN
  dbms_output.put_line(format_list(SET(a))); 
END;
/
