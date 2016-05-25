/*
 * create_nestedtable2.sql
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
  -- Define a nested table.
  TYPE card_suit IS TABLE OF VARCHAR2(5 CHAR);

  -- Declare a no element collection.
  cards CARD_SUIT := card_suit();
BEGIN
  -- Allocate space as you increment the index.
  FOR i IN 1..3 LOOP
    cards.EXTEND;
    IF    i = 1 THEN
      cards(i) := 'Ace';
    ELSIF i = 2 THEN
      cards(i) := 'Two';
    ELSIF i = 3 THEN
      cards(i) := 'Three';
    END IF;
  END LOOP;

  -- Print initialized collection.
  dbms_output.put_line('Nested table initialized as Ace, Two and Three.');
  dbms_output.put_line('-----------------------------------------------');
  FOR i IN 1..3 LOOP
    dbms_output.put     ('Cards ['||i||'] ');
    dbms_output.put_line('['||cards(i)||']');
  END LOOP;
END;
/
