/*
 * varray_dml1.sql
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

INSERT INTO individuals VALUES
( individuals_s1.nextval, 'John', 'Sidney', 'McCain', 'Mr.');

INSERT INTO addresses VALUES
( 1
, individuals_s1.currval
,strings
  ('Office of Senator McCain'
  ,'450 West Paseo Redondo'
  ,'Suite 200')
,'Tucson'
,'AZ'
,'85701'
,'USA');

SELECT   street_address
FROM     addresses;

-- Create a PL/SQL table data type.
CREATE OR REPLACE TYPE varray_nested_table IS TABLE OF VARCHAR2(30 CHAR);
/

-- Use SQL*Plus to format the output.
COL column_value FORMAT A30

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   CAST(street_address AS
                             varray_nested_table) 
               FROM     addresses
               WHERE    address_id = 1);

