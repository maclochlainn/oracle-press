/*
 * create_javalib1.sql
 * Chapter 13, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script demonstrates how to build a Java library
 * wrapper.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION read_string
  (file IN VARCHAR2)
  RETURN VARCHAR2 IS
  LANGUAGE JAVA
  NAME 'ReadFile1.readString(java.lang.String) return String';
/
