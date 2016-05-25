/*
 * create_helloworld_objectc.sql
 * Chapter 14, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This builds an object type and body, then a test program.
 */

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

CREATE OR REPLACE TYPE hello_there IS OBJECT
( who VARCHAR2(20)
, CONSTRUCTOR FUNCTION hello_there
  RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION hello_there
  ( who VARCHAR2 )
  RETURN SELF AS RESULT
, MEMBER FUNCTION get_who RETURN VARCHAR2
, MEMBER PROCEDURE set_who (who VARCHAR2)
, MEMBER PROCEDURE to_string )
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY hello_there IS
  
  CONSTRUCTOR FUNCTION hello_there RETURN SELF AS RESULT IS
    hello HELLO_THERE := hello_there('Generic Object.');
  BEGIN
    self := hello;
    RETURN;
  END hello_there;
  
  CONSTRUCTOR FUNCTION hello_there (who VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    self.who := who;
    RETURN;
  END hello_there;

  MEMBER FUNCTION get_who RETURN VARCHAR2 IS
  BEGIN
    RETURN self.who;
  END get_who;

  MEMBER PROCEDURE set_who (who VARCHAR2) IS
  BEGIN
    self.who := who;
  END set_who;
  
  MEMBER PROCEDURE to_string IS
  BEGIN
    dbms_output.put_line('Hello '||self.who);
  END to_string;
  
END;
/