/*
 * create_pipelined2.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the pipelined package specification, a 
 * pipelined function that uses the collection from the package
 * specification, and an implementation of the same pipelined 
 * function inside the package body.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PACKAGE pipelined IS
  -- Define a PL/SQL record type and Collection of the record type.
  TYPE account_record IS RECORD
  ( account     VARCHAR2(10)
  , full_name   VARCHAR2(42));
  TYPE account_collection IS TABLE OF account_record;
  
  -- Define a pipelined function.
  FUNCTION pf RETURN account_collection PIPELINED;
END pipelined;
/

CREATE OR REPLACE PACKAGE BODY pipelined IS
  -- Implement a pipelined function.
  FUNCTION pf
  RETURN account_collection
  PIPELINED IS
    -- Declare a collection control variable and collection variable.
    counter NUMBER := 1;
    account ACCOUNT_COLLECTION := account_collection();
    
    -- Define a cursor.
    CURSOR c IS
      SELECT   m.account_number
      ,        c.last_name || ', '||c.first_name full_name
      FROM     member m JOIN contact c ON m.member_id = c.member_id
      ORDER BY c.last_name, c.first_name, c.middle_initial;
  BEGIN
    FOR i IN c LOOP
      account.EXTEND;
      account(counter).account   := i.account_number;
      account(counter).full_name := i.full_name;
      PIPE ROW(account(counter));
      counter := counter + 1;
    END LOOP;
    RETURN;
  END pf;
END pipelined;
/

SELECT * FROM TABLE(pipelined.pf);

CREATE OR REPLACE FUNCTION pf
RETURN pipelined.account_collection
PIPELINED IS
    -- Declare a collection control variable and collection variable.
    counter NUMBER := 1;
    account PIPELINED.ACCOUNT_COLLECTION := pipelined.account_collection();
    
    -- Define a cursor.
    CURSOR c IS
      SELECT   m.account_number
      ,        c.last_name || ', '||c.first_name full_name
      FROM     member m JOIN contact c ON m.member_id = c.member_id
      ORDER BY c.last_name, c.first_name, c.middle_initial;
  BEGIN
    FOR i IN c LOOP
      account.EXTEND;
      account(counter).account   := i.account_number;
      account(counter).full_name := i.full_name;
      PIPE ROW(account(counter));
      counter := counter + 1;
    END LOOP;
    RETURN;
  END pf;
/

SELECT * FROM TABLE(pf);

CREATE OR REPLACE PROCEDURE read_pipe
( pipe_in pipelined.account_collection ) IS
BEGIN
  FOR i IN 1..pipe_in.LAST LOOP
    dbms_output.put(pipe_in(i).account);
    dbms_output.put(pipe_in(i).full_name);
  END LOOP;
END read_pipe;
/

EXECUTE read_pipe(pf);
