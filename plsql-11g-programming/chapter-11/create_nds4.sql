/*
 * create_nds4.sql
 * Chapter 11, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script NDS using placeholders or bind variables to 
 * return values from a query.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- Define explicit record structure.
  TYPE title_record IS RECORD
  ( item_title     VARCHAR2(60)
  , item_subtitle  VARCHAR2(60));
  -- Define dynamic variables.  
  title_cursor  SYS_REFCURSOR;
  title_row     TITLE_RECORD;
  stmt          VARCHAR2(2000);
BEGIN
  -- Set statement.
  stmt := 'SELECT  item_title, item_subtitle '
       || 'FROM    item '
       || 'WHERE   SUBSTR(item_title,1,12) = :input';
  
  -- Open and read dynamic curosr, then close it.
  OPEN title_cursor FOR stmt USING 'Harry Potter';
  LOOP
    FETCH title_cursor INTO title_row;
    EXIT WHEN title_cursor%NOTFOUND;
    dbms_output.put_line(
      '['||title_row.item_title||']['||title_row.item_subtitle||']');
  END LOOP;
  CLOSE title_cursor;
END;
/

