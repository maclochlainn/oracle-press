/*
 * create_signal_triggers.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script builds a trigger DBMS_ALERT signals on events
 * to the MESSAGES table.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Drop a trigger if one already exists.
BEGIN
  FOR i IN (SELECT null
            FROM user_triggers
            WHERE trigger_name = 'SIGNAL_MESSAGES') LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER signal_messages';
  END LOOP;
END;
/

-- Create necessary table.
@create_messages_table.sql

-- Create a signaling trigger.
CREATE OR REPLACE TRIGGER signal_messages
AFTER
INSERT OR UPDATE OR DELETE
OF message_id
  ,message_source
  ,message_destination
  ,message
ON messages
FOR EACH ROW

BEGIN

  -- Check if no row preivously existed - an insert.
  IF :old.message_id IS NULL THEN
  
    -- Signal Event.
    DBMS_ALERT.SIGNAL(
      'EVENT_MESSAGE_QUEUE'
      ,:new.message_source||':Insert');

    -- Insert alert message.
    INSERT
    INTO     messages_alerts
    VALUES   (:new.message_source||':Insert');

  -- Check if no row will exist after DML - a delete.
  ELSIF :new.message_id IS NULL THEN

    -- Signal Event.
    DBMS_ALERT.SIGNAL(
      'EVENT_MESSAGE_QUEUE'
      ,:old.message_source||':Delete');

    -- Insert alert message.
    INSERT
    INTO     messages_alerts
    VALUES   (:old.message_source||':Delete');

  -- This handles update DMLs.
  ELSE

    -- Check if message source is updated.
    IF :new.message_source IS NULL THEN

      -- Signal Event.
      DBMS_ALERT.SIGNAL(
        'EVENT_MESSAGE_QUEUE'
        ,:new.message_source||':Update#1');

      -- Insert alert message.
      INSERT
      INTO     messages_alerts
      VALUES   (:new.message_source||'Update#1');

    -- A column other than message source is updated.
    ELSE

      -- Signal Event.
      DBMS_ALERT.SIGNAL(
        'EVENT_MESSAGE_QUEUE'
        ,:old.message_source||':Update#2');

      -- Insert alert message.
      INSERT
      INTO     messages_alerts
      VALUES   (:old.message_source||':Update#2');

    END IF;

  END IF;

END;
/
