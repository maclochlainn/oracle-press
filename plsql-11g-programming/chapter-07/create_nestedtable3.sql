/*
 * create_nestedtable3.sql
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

CREATE OR REPLACE TYPE card_table
  AS TABLE OF VARCHAR2(5 CHAR);
/

DECLARE
  -- Declare a nested table with null values.
  cards CARD_TABLE := card_table(NULL,NULL,NULL);
BEGIN
  -- Print initialized null values.
  dbms_output.put_line('Nested table initialized as nulls.');
  dbms_output.put_line('----------------------------------');
  FOR i IN 1..3 LOOP
    dbms_output.put     ('Cards Varray ['||i||'] ');
    dbms_output.put_line('['||cards(i)||']');
  END LOOP;

  -- Assign values to subscripted members of the table.
  cards(1) := 'Ace';
  cards(2) := 'Two';
  cards(3) := 'Three';

  -- Print initialized values.
  dbms_output.put     (CHR(10)); -- Visual line break.
  dbms_output.put_line('Nested table initialized as Ace, Two and Three.');
  dbms_output.put_line('-----------------------------------------------');
  FOR i IN 1..3 LOOP
    dbms_output.put_line('Cards ['||i||'] '||'['||cards(i)||']');
  END LOOP;
END;
/
