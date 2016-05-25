/*
 * HelloWorld3.sql
 * Chapter 15, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script builds a PL/SQL wrapper to a Java class file.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Create a nested table of strings.
CREATE OR REPLACE TYPE varchar2_type AS TABLE OF NUMBER;
/

-- Drop any objects to make script re-runnable.
BEGIN

  FOR i IN (SELECT   table_name
            FROM     user_tables
            WHERE    table_name = 'MYTABLE' ) LOOP
            
    -- Use NDS to drop the dependent object type.
    EXECUTE IMMEDIATE 'DROP TABLE mytable';
    
  END LOOP;
  
END;
/

-- Create table to support script.
CREATE TABLE mytable
( character VARCHAR2(100));

-- Create a PL/SQL wrapper package to a Java class file.
CREATE OR REPLACE PACKAGE hello_world3 AS

  -- Define a single argument procedure.
  PROCEDURE doDML
  ( dml   VARCHAR2
  , input VARCHAR2 );
  
  -- Define a single argument function.
  FUNCTION doDQL
  ( dql   VARCHAR2 )
  RETURN  VARCHAR2;
  
END hello_world3;
/

-- Create a PL/SQL wrapper package to a Java class file.
CREATE OR REPLACE PACKAGE BODY hello_world3 AS

  -- Define a single argument procedure.
  PROCEDURE doDML
  ( dml   VARCHAR2
  , input VARCHAR2 ) IS
  LANGUAGE JAVA
  NAME 'HelloWorld3.doDML(java.lang.String,java.lang.String)';
  
  -- Define a single argument function.
  FUNCTION doDQL
  ( dql   VARCHAR2 )
  RETURN  VARCHAR2 IS
  LANGUAGE JAVA
  NAME 'HelloWorld3.doDQL(java.lang.String) return String';
  
END hello_world3;
/

COL object_name   FORMAT A30
COL object_type   FORMAT A12
COL object_status FORMAT A7

-- Query for objects.
SELECT   object_name
,        object_type
,        status
FROM     user_objects
WHERE    object_name IN ('HelloWorld3','HELLO_WORLD3');


BEGIN

  hello_world3.doDML('INSERT INTO MYTABLE VALUES (?)','Bobby McGee');
  
  DBMS_OUTPUT.PUT_LINE(hello_world3.doDQL('SELECT character FROM mytable'));

END;
/

-- Test the Java class file through the PL/SQL wrapper.
SELECT   hello_world3.doDQL('SELECT character FROM mytable')
FROM     dual;