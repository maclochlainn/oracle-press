/*
 * create_add_user.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates an autonomous pass-by-value function.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION add_user
( system_user_id    NUMBER
, system_user_name  VARCHAR2
, system_group_id   NUMBER
, system_user_type  NUMBER
, last_name         VARCHAR2
, first_name        VARCHAR2
, middle_initial    VARCHAR2
, created_by        NUMBER
, creation_date     DATE
, last_updated_by   NUMBER
, last_update_date  DATE ) RETURN BOOLEAN IS
  -- Set function to perform in its own transaction scope
  PRAGMA AUTONOMOUS_TRANSACTION;
  -- Set default return value.
  retval BOOLEAN := FALSE;
BEGIN
  INSERT INTO system_user
  VALUES
  ( system_user_id, system_user_name, system_group_id, system_user_type
  , last_name, first_name, middle_initial
  , created_by, creation_date, last_updated_by, last_update_date );
  COMMIT;
  -- Reset return value.
  retval := TRUE;
  RETURN retval;
END;
/

-- Anonymous block to test the add_user function.
BEGIN
  IF add_user( 6,'Application DBA', 1, 1
             ,'Brown','Jerry',''
             , 1, SYSDATE, 1, SYSDATE) THEN
    dbms_output.put_line('Record Inserted');
    ROLLBACK;
  ELSE
    dbms_output.put_line('No Record Inserted');
  END IF;
END;
/
