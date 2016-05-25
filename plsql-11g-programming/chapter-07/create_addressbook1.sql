/*
 * create_addressbook1.sql
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


SPOOL create_addressbook.log

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'INDIVIDUALS') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE individuals CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'INDIVIDUALS_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE individuals_s1';
  END LOOP;
END;
/

CREATE TABLE individuals
( individual_id             INTEGER             NOT NULL
, first_name                VARCHAR2(30 CHAR)   NOT NULL
, middle_name               VARCHAR2(30 CHAR)
, last_name                 VARCHAR2(30 CHAR)   NOT NULL
, title                     VARCHAR2(10 CHAR)
, CONSTRAINT indiv_pk       PRIMARY KEY(individual_id));

CREATE SEQUENCE individuals_s1;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'ADDRESSES') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE addresses CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'ADDRESSES_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE addresses_s1';
  END LOOP;
END;
/

CREATE OR REPLACE TYPE strings
  AS VARRAY(3) OF VARCHAR2(30 CHAR);
/

CREATE TABLE addresses
( address_id               INTEGER             NOT NULL
, individual_id            INTEGER             NOT NULL
, street_address           STRINGS
, city                     VARCHAR2(20 CHAR)   NOT NULL
, state                    VARCHAR2(20 CHAR)   NOT NULL
, postal_code              VARCHAR2(20 CHAR)   NOT NULL
, country_code             VARCHAR2(10 CHAR)   NOT NULL
, CONSTRAINT addr_pk       PRIMARY KEY(address_id)
, CONSTRAINT addr_indiv_fk FOREIGN KEY(individual_id)
  REFERENCES individuals   (individual_id));

CREATE SEQUENCE addresses_s1;

INSERT INTO individuals VALUES
( individuals_s1.nextval, 'John', 'Sidney', 'McCain', 'Mr.');

INSERT INTO addresses VALUES
( addresses_s1.nextval
, individuals_s1.currval
,strings
  ('Office of Senator McCain'
  ,'450 West Paseo Redondo'
  ,'Suite 200')
,'Tucson'
,'AZ'
,'85701'
,'USA');

-- Select raw compound collection type.
SELECT   street_address
FROM     addresses;

-- Create a PL/SQL table data type.
CREATE OR REPLACE TYPE varray_nested_table
IS TABLE OF VARCHAR2(30 CHAR);
/

-- Use SQL*Plus to format the output.
COL column_value FORMAT A30

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   CAST(street_address AS
                             varray_nested_table) AS elements
               FROM     addresses
               WHERE    address_id = 1);

CREATE OR REPLACE FUNCTION pipelined_street_addresses
( nested_id NUMBER, nested_table STRINGS ) RETURN STRINGS PIPELINED IS


  TYPE nested IS VARRAY(3) OF VARCHAR2(30);
  table_copy NESTED := nested();
BEGIN
  FOR i IN 1..3 LOOP
    PIPE ROW(nested_table(i));
  END LOOP;
  RETURN;
END;
/

CREATE OR REPLACE FUNCTION pipelined_street_addresses
( nested_id NUMBER, nested_table STRINGS ) RETURN STRINGS PIPELINED IS
  TYPE nested_record IS RECORD
  ( column_id    NUMBER
  , column_value VARCHAR2(30));
  
  TYPE nested IS VARRAY(3) OF NESTED_RECORD;
  table_copy NESTED := nested();
BEGIN
  FOR i IN 1..3 LOOP
    PIPE ROW(nested_table(i));
  END LOOP;
  RETURN;
END;
/

INSERT INTO addresses VALUES
( addresses_s1.nextval
, individuals_s1.currval
,strings
  ('Office of Senator John McCain'
  ,'450 West Paseo Redondo'
  ,'Suite 200')
,'Tucson'
,'AZ'
,'85701'
,'USA');


SELECT   *
FROM     TABLE(SELECT pipelined_street_addresses(address_id, street_address) FROM addresses);

SPOOL OFF