/*
 * create_nds3.sql
 * Chapter 11, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script NDS using placeholders or bind variables.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE insert_item
( asin          VARCHAR2
, item_type     VARCHAR2
, item_title    VARCHAR2
, item_subtitle VARCHAR2 := ''
, rating        VARCHAR2
, agency        VARCHAR2
, release_date  DATE ) IS

  stmt VARCHAR2(2000);

BEGIN
  stmt := 'INSERT INTO item VALUES '
       || '( item_s1.nextval '
       || ',''ASIN''||CHR(58)||:asin '
       || ',(SELECT   common_lookup_id '
       || '  FROM     common_lookup '
       || '  WHERE    common_lookup_type = :item_type)'
       || ', :item_title '
       || ', :item_subtitle '
       || ', empty_clob() '
       || ', NULL '
       || ', :rating '
       || ', :agency '
       || ', :release_date '
       || ', 3, SYSDATE, 3, SYSDATE)';
       dbms_output.put_line(stmt);
  EXECUTE IMMEDIATE stmt
  USING asin, item_type, item_title, item_subtitle, rating,
        agency, release_date;

END insert_item;
/

BEGIN
  insert_item (asin => 'B00005O3VC'
              ,item_type => 'DVD_FULL_SCREEN'
              ,item_title => 'Monty Python and the Holy Grail'
              ,item_subtitle => 'Special Edition'
              ,rating => 'PG'
              ,agency => 'MPAA'
              ,release_date => '23-OCT-2001');
END;
/

BEGIN
  insert_item (asin => 'B000G6BLWE'
              ,item_type => 'DVD_FULL_SCREEN'
              ,item_title => 'Young Frankenstein'
              ,rating => 'PG'
              ,agency => 'MPAA'
              ,release_date => '05-SEP-2006');
END;
/
