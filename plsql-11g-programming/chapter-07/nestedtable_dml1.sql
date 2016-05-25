/*
 * nestedtable_dml1.sql
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
( addresses_s1.nextval
, individuals_s1.currval
, strings
  ('Office of Senator McCain'
  ,'450 West Paseo Redondo'
  ,'Suite 200')
,'Tucson'
,'AZ'
,'85701'
,'USA');

SELECT   street_address
FROM     addresses;

-- Use SQL*Plus to format the output.
COL column_value FORMAT A30

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   street_address 
               FROM     addresses
               WHERE    address_id = 1);

CREATE OR REPLACE FUNCTION many_to_one
(street_address_in ADDRESS_TABLE) RETURN VARCHAR2 IS
  retval VARCHAR2(2000) := '';
BEGIN
  -- Read all elements in the nested table, and delimit with a line break.
  FOR i IN 1..street_address_in.COUNT LOOP
    retval := retval || street_address_in(i) || CHR(10);
  END LOOP;
  RETURN retval;
END many_to_one;
/

-- Use SQL*Plus to format the output.
COL address_label FORMAT A30

-- Print a mailing label.
SELECT   i.first_name || ' '
||       i.middle_initial || ' '
||       i.last_name || CHR(10)
||       many_to_one(a.street_address)
||       city || ', '
||       state || ' '
||       postal_code address_label
FROM     addresses a
,        individuals i
WHERE    a.individual_id = i.individual_id
AND      i.individual_id = 1;

