/*
 * nestedtable_dml2.sql
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

UPDATE   addresses
SET      street_address =
           address_table('Office of Senator McCain'
                         ,'2400 E. Arizona Biltmore Cir.'
                         ,'Suite 1150')
WHERE    address_id = 1;

-- Print formatted elements from aggregate table.
SELECT   *
FROM     TABLE(SELECT   street_address 
               FROM     addresses
               WHERE    address_id = 1);

