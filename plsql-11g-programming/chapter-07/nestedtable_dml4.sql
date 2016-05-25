/*
 * nestedtable_dml3.sql
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

INSERT INTO individuals VALUES
( individuals_s1.nextval, 'Edward', 'Moore', 'Kennedy', 'Mr.');

INSERT INTO addresses VALUES
( addresses_s1.nextval
, individuals_s1.currval
, address_table('Office of Senator Kennedy')
, 'Boston'
, 'MA'
, '02203'
, 'USA');

DECLARE
  TYPE address_type IS RECORD
  ( address_id          INTEGER
  , individual_id       INTEGER
  , street_address      ADDRESS_VARRAY
  , city                VARCHAR2(20 CHAR)
  , state               VARCHAR2(20 CHAR)
  , postal_code         VARCHAR2(20 CHAR)
  , country_code        VARCHAR2(10 CHAR));
  address               ADDRESS_TYPE;

  -- Define a cursor to return the %ROWTYPE value.
  CURSOR get_street_address
    (address_id_in      INTEGER) IS
    SELECT   *
    FROM     addresses
    WHERE    address_id = address_id_in;
BEGIN
  -- Access the cursor.
  OPEN  get_street_address(2);
  FETCH get_street_address INTO  address;
  CLOSE get_street_address;

  -- Add elements.
  address.street_address.EXTEND(2);
  address.street_address(2) := 'JFK Building';
  address.street_address(3) := 'Suite 2400';

  -- Update the varray column value.
  UPDATE   addresses
  SET      street_address = address.street_address
  WHERE    address_id = 2;
END;
/

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   street_address 
               FROM     addresses
               WHERE    address_id = 1);

