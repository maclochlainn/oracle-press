/*
 * create_pipelined1.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the pipelined_numbers function. It declares a
 * VARRAY collection reads it into a pipe and returns it.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION pipelined_numbers
RETURN NUMBERS
PIPELINED IS
  list NUMBERS := numbers(0,1,2,3,4,5,6,7,8,9);
BEGIN
  FOR i IN 1..list.LAST LOOP
    PIPE ROW(list(i));
  END LOOP;
  RETURN;
END;
/