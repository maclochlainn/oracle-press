/*
 * varray_dml3.sql
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

DECLARE
  TYPE address_type IS RECORD
  ( address_id          INTEGER
  , individual_id       INTEGER
  , street_address      STRINGS
  , city                VARCHAR2(20 CHAR)
  , state               VARCHAR2(20 CHAR)
  , postal_code         VARCHAR2(20 CHAR)
  , country_code        VARCHAR2(10 CHAR));
  address              ADDRESS_TYPE;

  CURSOR get_street_address
    (address_id_in      INTEGER) IS
    SELECT   *
    FROM     addresses
    WHERE    address_id = address_id_in;
BEGIN
  -- Access the cursor.
  OPEN  get_street_address(1);
  FETCH get_street_address INTO  address;
  CLOSE get_street_address;

  -- Reset the first element of the varray type variable.
  address.street_address(1) := 'Office of Senator John McCain';

  -- Update the entire varray column value.
  UPDATE   addresses
  SET      street_address = address.street_address
  WHERE    address_id = 1;
END;
/

-- Use SQL*Plus to format the output.
COL column_value FORMAT A30

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   CAST(street_address AS
                             varray_nested_table) 
               FROM     addresses
               WHERE    address_id = 1);
