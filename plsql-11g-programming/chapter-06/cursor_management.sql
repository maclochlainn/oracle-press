/*
 * cursor_management.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates a function that returns a weakly-typed
 * system reference cursor.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Define a function to return a reference cursor.
CREATE OR REPLACE FUNCTION get_full_titles
RETURN SYS_REFCURSOR IS
  titles SYS_REFCURSOR;
BEGIN
  OPEN titles FOR
  SELECT  item_title
  ,       item_subtitle
  FROM    item;
  RETURN titles;  
END;
/

DECLARE
  -- Define a type and declare a variable.
  TYPE full_title_record IS RECORD
  ( item_title    item.item_title%TYPE
  , item_subtitle item.item_subtitle%TYPE);
  full_title FULL_TITLE_RECORD;
  
  -- Declare a system reference cursor variable.
  titles SYS_REFCURSOR;
BEGIN
  -- Assign the reference cursor function result.
  titles := get_full_titles;

  -- Print one element of one of the parallel collections.
  LOOP
    FETCH titles INTO full_title;
    EXIT WHEN titles%NOTFOUND;
    dbms_output.put_line('Title ['||full_title.item_title||']');
  END LOOP;
END;
/