 * exception2.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the three dependent procedures for testing
 * error management without using DBMS_UTILITY.FORMAT_ERROR_BACKTRACE.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE error_level3 IS
  one_character           VARCHAR2(1);
  two_character           VARCHAR2(2)  := 'AB';
  local_object            VARCHAR2(30) := 'ERROR_LEVEL3';
  local_module            VARCHAR2(30) := 'MAIN';
  local_table             VARCHAR2(30) :=  NULL;
  local_user_message      VARCHAR2(80) :=  NULL;
BEGIN
  one_character := two_character; 
EXCEPTION
  WHEN others THEN
    handle_errors( object_name => local_object
                 , module_name => local_module
                 , sql_error_code => SQLCODE
                 , sql_error_message => SQLERRM );
    RAISE;
END error_level3;
/
CREATE OR REPLACE PROCEDURE error_level2 IS
  local_object            VARCHAR2(30) := 'ERROR_LEVEL2';
  local_module            VARCHAR2(30) := 'MAIN';
  local_table             VARCHAR2(30) :=  NULL;
  local_user_message      VARCHAR2(80) :=  NULL;
BEGIN
  error_level3();
EXCEPTION
  WHEN others THEN
    handle_errors( object_name => local_object
                 , module_name => local_module
                 , sql_error_code => SQLCODE
                 , sql_error_message => SQLERRM );
    RAISE;
END error_level2;
/
CREATE OR REPLACE PROCEDURE error_level1 IS
  local_object            VARCHAR2(30) := 'ERROR_LEVEL1';
  local_module            VARCHAR2(30) := 'MAIN';
  local_table             VARCHAR2(30) :=  NULL;
  local_user_message      VARCHAR2(80) :=  NULL;
BEGIN
  error_level2();
EXCEPTION
  WHEN others THEN
    handle_errors( object_name => local_object
                 , module_name => local_module
                 , sql_error_code => SQLCODE
                 , sql_error_message => SQLERRM );
    RAISE;
END error_level1;
/

-- Test exception management.
BEGIN
  error_level1;
END;
/
