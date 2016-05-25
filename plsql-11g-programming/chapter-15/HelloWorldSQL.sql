/*
 * HelloWorldSQL.sql
 * Chapter 15, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script builds a PL/SQL wrapper to a Java class file.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED HelloWorldSQL AS
// Class Definition.
public class HelloWorldSQL {

public static String hello() {
  return "Hello World."; }
  
public static String hello(String name) {
  return "Hello " + name + "."; }
}
/

-- Create a PL/SQL wrapper package specification to a Java class file.
CREATE OR REPLACE PACKAGE hello_world_sql AS
  FUNCTION hello
  RETURN VARCHAR2;

  FUNCTION hello
  ( who  VARCHAR2 )
  RETURN VARCHAR2;
END hello_world_sql;
/

-- Create a PL/SQL wrapper package body to a Java class file.
CREATE OR REPLACE PACKAGE BODY hello_world_sql AS

  FUNCTION hello
  RETURN VARCHAR2 IS
  LANGUAGE JAVA
  NAME 'HelloWorldSQL.hello() return String';

  FUNCTION hello
  ( who  VARCHAR2 )
  RETURN VARCHAR2 IS
  LANGUAGE JAVA
  NAME 'HelloWorldSQL.hello(java.lang.String) return String';
END hello_world_sql;
/

-- Create a PL/SQl wrapper function to a Java class method.
CREATE OR REPLACE FUNCTION hello
( who VARCHAR2) RETURN VARCHAR2 IS
LANGUAGE JAVA
NAME 'HelloWorldSQL.hello(java.lang.String) return String';
/

COL salutation FORMAT A14

-- Query for objects.
SELECT   hello('Nathan') AS salutation
FROM     dual;