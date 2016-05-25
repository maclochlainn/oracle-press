/*
 * create_nestedtable4.sql
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

CREATE OR REPLACE TYPE card_unit_varray AS VARRAY(13) OF VARCHAR2(5 CHAR);
/
CREATE OR REPLACE TYPE card_suit_varray AS VARRAY(4) OF VARCHAR2(8 CHAR);
/
CREATE OR REPLACE TYPE card_deck_table AS TABLE OF VARCHAR2(17 CHAR);
/

DECLARE
  -- Declare counter.
  counter INTEGER := 0;

  -- Declare and initialize a card suit and unit collections.
  suits CARD_SUIT_VARRAY :=
    card_suit_varray('Clubs','Diamonds','Hearts','Spades');
  units CARD_UNIT_VARRAY :=
    card_unit_varray('Ace','Two','Three','Four','Five','Six','Seven'
                    ,'Eight','Nine','Ten','Jack','Queen','King');

  -- Declare and initialize a null nested table.
  deck CARD_DECK_TABLE := card_deck_table();
BEGIN
  -- Loop through the four suits, then thirteen cards.
  FOR i IN 1..suits.COUNT LOOP
    FOR j IN 1..units.COUNT LOOP
      counter := counter + 1;
      deck.EXTEND;
      deck(counter) := units(j)||' of '||suits(i);
    END LOOP;
  END LOOP;

  -- Print initialized values.
  dbms_output.put_line('Deck of cards by suit.');
  dbms_output.put_line('----------------------');
  FOR i IN 1..counter LOOP
    dbms_output.put_line('['||deck(i)||']');
  END LOOP;
END;
/
