/*
 * exception1.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the handle_errors procedure.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE handle_errors
( object_name           IN        VARCHAR2
, module_name           IN        VARCHAR2 := NULL
, table_name            IN        VARCHAR2 := NULL
, sql_error_code        IN        NUMBER   := NULL
, sql_error_message     IN        VARCHAR2 := NULL
, user_error_message    IN        VARCHAR2 := NULL ) IS

  -- Define a local exception.
  raised_error          EXCEPTION;

  -- Define a collection type and initialize it.
  TYPE error_stack IS TABLE OF VARCHAR2(80);
  errors                ERROR_STACK := error_stack();

  -- Define a local function to verify object type.
  FUNCTION object_type
  ( object_name_in      IN        VARCHAR2 )
  RETURN VARCHAR2 IS
    return_type         VARCHAR2(12) := 'Unidentified';
  BEGIN
    FOR i IN ( SELECT   object_type
               FROM     user_objects
               WHERE    object_name = object_name_in ) LOOP
      return_type := i.object_type;
    END LOOP;
    RETURN return_type;
  END object_type;
BEGIN
  -- Allot space and assign a value to collection.
  errors.EXTEND;
  errors(errors.COUNT) := object_type(object_name)||' ['||object_name||']';

  -- Substitute actual parameters for default values.
  IF module_name IS NOT NULL THEN
    errors.EXTEND;
    errors(errors.COUNT) := 'Module Name: ['||module_name||']';
  END IF;
  IF table_name IS NOT NULL THEN
    errors.EXTEND;
    errors(errors.COUNT) := 'Table Name: ['||table_name||']';
  END IF;
  IF sql_error_code IS NOT NULL THEN
    errors.EXTEND;
    errors(errors.COUNT) := 'SQLCODE Value: ['||sql_error_code||']';
  END IF;
  IF sql_error_message IS NOT NULL THEN
    errors.EXTEND;
    errors(errors.COUNT) := 'SQLERRM Value: ['||sql_error_message||']';
  END IF;
  IF user_error_message IS NOT NULL THEN
    errors.EXTEND;
    errors(errors.COUNT) := user_error_message;
  END IF;

  errors.EXTEND;
  errors(errors.COUNT) := '----------------------------------------';
  RAISE raised_error;
EXCEPTION
  WHEN raised_error THEN
    FOR i IN 1..errors.COUNT LOOP
      dbms_output.put_line(errors(i));
    END LOOP;
    RETURN;
END;
/
