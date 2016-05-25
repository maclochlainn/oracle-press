/*
 * create_nds1.sql
 * Chapter 11, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script NDS to conditionally drop a table.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

BEGIN
  -- Use a loop to check whether to drop a sequence.
  FOR i IN (SELECT null
            FROM   user_objects
            WHERE  object_name = 'SAMPLE_SEQUENCE') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE sample_sequence';
    dbms_output.put_line('Dropped [sample_sequence].');
  END LOOP;
END;
/

