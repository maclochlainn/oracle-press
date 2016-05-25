/*
 * transaction_scope.sql
 * Chapter 2, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This demonstrates creating a single transaction scope.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

BEGIN
  -- Set savepoint.
  SAVEPOINT new_member;

  -- First insert.
  INSERT INTO member VALUES
  ( member_s1.nextval
  , 1005
  ,'D921-71998'
  ,'4444-3333-3333-4444'
  , 1006
  , 2
  , SYSDATE
  , 2
  , SYSDATE);

  -- Second insert.
  INSERT INTO contact VALUES
  ( contact_s1.nextval
  , member_s1.currval + 1
  , 1003
  ,'Bodwin'
  ,'Jordan'
  ,''
  , 2
  , SYSDATE
  , 2
  , SYSDATE);

  -- Print success message and commit records.
  dbms_output.put_line('Both succeeded.');
  COMMIT;

EXCEPTION
  WHEN others THEN
    -- Rollback to savepoint, and raise exception meesage.
    ROLLBACK TO new_member;
    dbms_output.put_line(SQLERRM);
END;
/
