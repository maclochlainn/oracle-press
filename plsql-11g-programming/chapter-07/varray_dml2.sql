/*
 * varray_dml2.sql
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

UPDATE   addresses
SET      street_address =
           strings('Office of Senator McCain'
                  ,'2400 E. Arizona Biltmore Cir.'
                  ,'Suite 1150')
WHERE    address_id = 1;

-- Use SQL*Plus to format the output.
COL column_value FORMAT A30

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   CAST(street_address AS
                             varray_nested_table) 
               FROM     addresses
               WHERE    address_id = 1);
