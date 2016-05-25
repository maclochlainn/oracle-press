/*
 * create_assocarray1.sql
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

DECLARE
  -- Define an associative array.
  TYPE card_table IS TABLE OF VARCHAR2(5 CHAR)
    INDEX BY BINARY_INTEGER;

  -- Declare and attempt to construct an associative array.
  cards CARD_TABLE := card_table('A','B','C');
BEGIN
  NULL;
END;
/
