/*
 * create_nds7.sql
 * Chapter 11, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script NDS using placeholders or bind variables to 
 * read and write a value from a PL/SQL anonymous block.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE get_clob
( item_title_in  VARCHAR2, item_desc_out IN OUT CLOB ) IS
BEGIN
  UPDATE  item
  SET     item_desc = empty_clob()
  WHERE   item_id = 
           (SELECT item_id
            FROM   item
            WHERE  item_title = item_title_in)
            RETURNING item_desc INTO item_desc_out;
END get_clob;
/

DECLARE
  -- Define explicit record structure.
  target  CLOB;
  source  VARCHAR2(2000) := 'A Mel Brooks classic movie!';
  movie   VARCHAR2(60) := 'Young Frankenstein';
  stmt    VARCHAR2(2000);
BEGIN
  -- Set statement
  stmt := 'BEGIN '
       || '  get_clob(:input,:output); '
       || 'END;';
  EXECUTE IMMEDIATE stmt USING movie, IN OUT target;
  dbms_lob.writeappend(target,LENGTH(source),source);
  COMMIT;
END;
/
