/*
 * create_record_errors.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script defines a package to audit error information before
 * writing it to the non-critical error storage table.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE record_errors
( module_name           IN        VARCHAR2
, table_name            IN        VARCHAR2 := NULL
, class_name            IN        VARCHAR2 := NULL
, sqlerror_code         IN        VARCHAR2 := NULL
, sqlerror_message      IN        VARCHAR2 := NULL
, user_error_message    IN        VARCHAR2 := NULL ) IS

  -- Declare anchored record variable.
  nc_error_record NC_ERROR%ROWTYPE;

BEGIN

  -- Substitute actual parameters for default values.
  IF module_name IS NOT NULL THEN
    nc_error_record.module_name := module_name;
  END IF;
  IF table_name IS NOT NULL THEN
    nc_error_record.table_name := module_name;
  END IF;
  IF sqlerror_code IS NOT NULL THEN
    nc_error_record.sqlerror_code := sqlerror_code;
  END IF;
  IF sqlerror_message IS NOT NULL THEN
    nc_error_record.sqlerror_message := sqlerror_message;
  END IF;
  IF user_error_message IS NOT NULL THEN
    nc_error_record.user_error_message := user_error_message;
  END IF;

  -- Insert non-critical error record.
  INSERT INTO nc_error
  VALUES
  ( nc_error_s1.nextval
  , nc_error_record.module_name
  , nc_error_record.table_name
  , nc_error_record.class_name
  , nc_error_record.sqlerror_code
  , nc_error_record.sqlerror_message
  , nc_error_record.user_error_message
  , 2
  , SYSDATE
  , 2
  , SYSDATE);
  
EXCEPTION
  WHEN others THEN
    RETURN;
END;
/
