/*
 * merge.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the function that merges strings.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION merge
( last_name     VARCHAR2
, first_name    VARCHAR2
, middle_initial VARCHAR2 )
RETURN VARCHAR2 PARALLEL_ENABLE IS
BEGIN
  RETURN last_name ||', '||first_name||' '||middle_initial;
END;
/
