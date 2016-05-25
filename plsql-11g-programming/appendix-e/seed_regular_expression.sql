-- seed_regular_expression.sql
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

BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'SAMPLE_REGEXP') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE sample_regexp CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'SAMPLE_REGEXP_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE sample_regexp_s1';
  END LOOP;
END;
/

CREATE TABLE sample_regexp
( sample_regexp_id NUMBER
, story_thread     CLOB );

CREATE SEQUENCE sample_regexp_s1;

INSERT INTO sample_regexp
VALUES (sample_regexp_s1.nextval,'"The prologue, spoken by Galadriel, shows the Dark Lord Sauron forging the One Ring which he can use to conquer the lands of Middle-earth through his enslavement of the bearers of the Rings of Power. The Rings of Power are powerful magical rings given to individuals from the races of Elves, Dwarves and Men. A Last Alliance of Elves and Men is formed to counter Sauron and his forces at the foot of Mount Doom, but Sauron himself appears to kill Elendil, the king of the Mannish kingdom of Gondor. Just afterward, Isildur grabs his father''s broken sword Narsil, and slashes at Sauron''s hand. The stroke cuts off Sauron''s fingers, separating him from the Ring and vanquishing his army. However, because Sauron''s life is bound in the Ring, he is not completely defeated until the Ring itself is destroyed. Isildur takes the Ring and succumbs to its temptation, refusing to destroy it, but he is later ambushed and killed by orcs and the Ring is lost in the river into which Isildur fell.<p />"');

COMMIT;

