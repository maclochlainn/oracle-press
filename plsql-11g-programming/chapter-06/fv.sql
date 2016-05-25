/*
 * create_fv.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the fv function, that calculates how
 * much you will earn based on a deposit today plus annual
 * interest.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION fv
( current_value   NUMBER := 0
, periods         NUMBER := 1
, interest        NUMBER)
RETURN NUMBER DETERMINISTIC IS
BEGIN
  -- Compounded Daily Interest.
  RETURN current_value * (1 + ((1 + ((interest/100)/365))**365 -1)*periods);
END fv;
/
