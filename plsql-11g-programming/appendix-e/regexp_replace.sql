-- regexp_replace.sql
-- Appendix E, Oracle Database 11g PL/SQL Programming
-- by Michael McLaughlin
--
-- This creates and seeds a table for demonstration of the regular
-- expression functions.

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

DECLARE
  container VARCHAR2(4000);
  beginning NUMBER := 1;
  ending    NUMBER;
  -- Define a cursor to recover correct story thread.
  CURSOR c IS
    SELECT story_thread
    FROM   sample_regexp
    WHERE  REGEXP_LIKE(story_thread,'a last alliance of elves and men ?','i');
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO container;
    EXIT WHEN c%NOTFOUND;
    -- Set the ending range.
    ending := REGEXP_COUNT(container
                          ,'((^| +)|(["'']))Sauron(([-:,\.;])|( +|$))',1,'i');
    -- Replace all instances one at a time.
    FOR i IN beginning..ending LOOP
      container := REGEXP_REPLACE(container,'Sauron','Sauroman',beginning,i);
    END LOOP;
    dbms_output.put_line(container);
  END LOOP;
END;
/

