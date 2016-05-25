/*
 * create_nc_errors.sql
 * Chapter 5, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script defines a non-critical exception storage table.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'NC_ERROR') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE nc_error CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'NC_ERROR_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE nc_error_s1';
  END LOOP;
END;
/

CREATE TABLE nc_error
( error_id            NUMBER         CONSTRAINT pk_nce   PRIMARY KEY
, module_name         VARCHAR2(30)   CONSTRAINT nn_nce_1 NOT NULL
, table_name          VARCHAR2(30)
, class_name          VARCHAR2(30)
, sqlerror_code       VARCHAR2(9)
, sqlerror_message    VARCHAR2(2000)
, user_error_message  VARCHAR2(2000)
, last_updated_by     NUMBER         CONSTRAINT nn_nce_2 NOT NULL
, last_update_date    DATE           CONSTRAINT nn_nce_3 NOT NULL
, created_by          NUMBER         CONSTRAINT nn_nce_4 NOT NULL
, creation_date       DATE           CONSTRAINT nn_nce_5 NOT NULL);

CREATE SEQUENCE nc_error_s1;