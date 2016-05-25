/*
 * get_bfilename.sql
 * Chapter 8, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * This script queries a BFILENAME column for a file name.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION get_bfilename
( table_name        VARCHAR2
, column_name       VARCHAR2
, primary_key_name  VARCHAR2
, primary_key_value VARCHAR2)
RETURN VARCHAR2 IS

  -- Define a locator.
  locator           BFILE;

  -- Define alias and file name.
  dir_alias VARCHAR2(255);
  directory VARCHAR2(255);
  file_name VARCHAR2(255);
  
  -- Define local variable for Native Dynamic SQL.
  stmt      VARCHAR2(2000);
  delimiter VARCHAR2(1) := '/';

  -- Define a local exception for size violation.
  directory_num EXCEPTION;
  PRAGMA EXCEPTION_INIT(directory_num,-22285);  

BEGIN

  -- Wrap the statement in an anonymous block to create and OUT mode variable.
  stmt := 'BEGIN '
       || 'SELECT '||column_name||' '
       || 'INTO :locator '
       || 'FROM '||table_name||' '
       || 'WHERE '||primary_key_name||' = '||''''||primary_key_value||''';'
       || 'END;';

  -- Return a scalar query result from a dynamic SQL statement.
  EXECUTE IMMEDIATE stmt USING OUT locator;

  -- Check for available locator.
  IF locator IS NOT NULL THEN     
    dbms_lob.filegetname(locator,dir_alias,file_name);
  END IF;

  -- Return file name.
  RETURN delimiter||LOWER(dir_alias)||delimiter||file_name;

EXCEPTION
  WHEN directory_num THEN
  RETURN NULL;

END get_bfilename;
/
