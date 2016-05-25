/*
 * create_contact_t2.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script defines a trigger to manage critical errors.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_triggers
            WHERE  trigger_name = 'CONTACT_T1') LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER contact_t1';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_triggers
            WHERE  trigger_name = 'CONTACT_T3') LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER contact_t3';
  END LOOP;
END;
/

CREATE OR REPLACE TRIGGER contact_t2
BEFORE INSERT ON contact
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  CURSOR c ( member_id_in NUMBER ) IS
    SELECT null
    FROM   contact c
    ,      member m
    WHERE  c.member_id = m.member_id
    AND    c.member_id = member_id_in
    HAVING COUNT(*) > 1;
BEGIN
  FOR i IN c (:new.member_id) LOOP
    record_errors( module_name => 'CREATE_CONTACT_T2'
                 , table_name => 'MEMBER'
                 , class_name => 'MEMBER_ID ['||:new.contact_id||']'
                 , sqlerror_code => 'ORA-20001'
                 , user_error_message => 'Too many contacts per account.');
  END LOOP;
  COMMIT;
  RAISE_APPLICATION_ERROR(-20001,'Already two signers.');
END;
/