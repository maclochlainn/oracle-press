/*
 * recursion.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates two recursive functions. The factorial
 * function demonstrates linear recursion, and the fibonacci
 * function demonstrates non-linear recursion.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Create a linear recursion program.
CREATE OR REPLACE FUNCTION factorial
( n BINARY_DOUBLE ) RETURN BINARY_DOUBLE IS
BEGIN
  IF n <= 1 THEN
    RETURN 1;
  ELSE
    RETURN n * factorial(n - 1);
  END IF;
END factorial;
/

-- Create a non-linear recursion program.
CREATE OR REPLACE FUNCTION fibonacci
( n BINARY_DOUBLE ) RETURN BINARY_DOUBLE IS
BEGIN
  IF n <= 2 THEN
    RETURN 1;
  ELSE
    RETURN fibonacci(n - 2) + fibonacci(n - 1);
  END IF;
END fibonacci;
/

  