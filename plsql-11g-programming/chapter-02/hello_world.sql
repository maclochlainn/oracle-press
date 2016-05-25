/*
 * hello_world.sql
 * Chapter 2, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script prints Hello World.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

BEGIN
  dbms_output.put_line('Hello World.');
END;
/