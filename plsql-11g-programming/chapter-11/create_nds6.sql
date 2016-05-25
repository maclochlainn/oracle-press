/*
 * create_nds6.sql
 * Chapter 11, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script NDS using placeholders or bind variables to 
 * read and write a value from a NDS statement.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- Define explicit record structure.
  target  CLOB;
  source  VARCHAR2(2000) := 'A Mel Brooks classic movie!';
  movie   VARCHAR2(60) := 'Young Frankenstein';
  stmt    VARCHAR2(2000);
BEGIN
  -- Set statement.
  stmt := 'BEGIN '
       || 'UPDATE  item '
       || 'SET     item_desc = empty_clob() '
       || 'WHERE   item_id = '
       || '          (SELECT item_id '
       || '           FROM   item '
       || '           WHERE  item_title = :input) '
       || 'RETURNING item_desc INTO :descriptor;'
       || 'END;';

  EXECUTE IMMEDIATE stmt USING movie, IN OUT target;
  dbms_lob.writeappend(target,LENGTH(source),source);
  COMMIT;
END;
/

SELECT item_desc FROM item WHERE item_title = 'Young Frankenstein';

