-- character_class2.sql
-- Appendix E, Oracle Database 11g PL/SQL Programming
-- by Michael McLaughlin
--
-- This demonstrates using portable character classes as
-- patterns with the REGEXP_SUBSTR function.

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

DECLARE
  counter       NUMBER := 1;
  source_string VARCHAR2(12) := 'A1';
  pattern1      VARCHAR2(12) := '[[:alpha:]]';
  pattern2      VARCHAR2(12) := '[[:alnum:]]';
BEGIN
  -- Compare using standard character class ranges.
  FOR i IN 1..LENGTH(source_string) LOOP
    IF REGEXP_INSTR(SUBSTR(source_string,counter,i),pattern1) = i THEN
      dbms_output.put(REGEXP_SUBSTR(
                        SUBSTR(source_string,counter,i),pattern1));
    ELSE
      dbms_output.put_line(REGEXP_SUBSTR(
                             SUBSTR(source_string,counter,i),pattern2));
    END IF;
    counter := counter + 1;
  END LOOP;
END;
/

