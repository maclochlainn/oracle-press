/*
 * register_interest.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script registers interest in a DBMS_ALERT
 * to the MESSAGES table.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Remove your registered interest in a DBMS_ALERT.
BEGIN

  -- Remove/deregister interest from an alert.
  DBMS_ALERT.REMOVE('EVENT_MESSAGE_QUEUE');

END;
/

-- Call signal trigger, which also builds the table.
@create_signal_trigger.sql

-- Register interest in an alert.
BEGIN

  -- Register interest in an alert.
  DBMS_ALERT.REGISTER('EVENT_MESSAGE_QUEUE');

END;
/
