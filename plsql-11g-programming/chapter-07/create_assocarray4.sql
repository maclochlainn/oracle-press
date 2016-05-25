/*
 * create_assocarray4.sql
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
  -- Define an associative array of strings.
  TYPE card_table IS TABLE OF VARCHAR2(5 CHAR)
    INDEX BY BINARY_INTEGER;

  -- Define an associative array variable.
  cards CARD_TABLE;
BEGIN
  IF cards.COUNT <> 0 THEN
    DBMS_OUTPUT.PUT_LINE(cards(1));
  ELSE
    cards.EXTEND;
  END IF;
END;
/
