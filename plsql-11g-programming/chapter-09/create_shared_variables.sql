/*
 * create_shared_variables.sql
 * Chapter 9, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates and demonstrates a package managing
 * a shared variables.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PACKAGE shared_variables IS
  protected   CONSTANT NUMBER := 1;
  unprotected          NUMBER := 1;
END shared_variables;
/

CREATE OR REPLACE PROCEDURE change_unprotected (value NUMBER) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  shared_variables.unprotected := shared_variables.unprotected + value;
  dbms_output.put_line('Unprotected ['||shared_variables.unprotected||']');
END change_unprotected;
/

EXECUTE change_unprotected(2);
EXECUTE change_unprotected(2);

ALTER PACKAGE shared_variables COMPILE SPECIFICATION;

EXECUTE change_unprotected(2);