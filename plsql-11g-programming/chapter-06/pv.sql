/*
 * create_pv.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the pv function, that calculates how
 * much you need today plus yearly or annually .
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION pv
( future_value    NUMBER
, periods         NUMBER
, interest        NUMBER )
RETURN NUMBER DETERMINISTIC IS
BEGIN
  RETURN future_value / ((1 + interest/100)**periods);
END pv;
/
