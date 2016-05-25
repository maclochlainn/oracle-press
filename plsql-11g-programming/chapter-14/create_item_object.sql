/*
 * create_item_object.sql
 * Chapter 14, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This builds an object type and body, then a test program.
 */

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

CREATE OR REPLACE TYPE item_object IS OBJECT
( item_title    VARCHAR2(60)
, item_subtitle VARCHAR2(60)
, CONSTRUCTOR FUNCTION item_object
  RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION item_object
  (item_title VARCHAR2, item_subtitle VARCHAR2)
  RETURN SELF AS RESULT
, STATIC FUNCTION get_item_object (item_id NUMBER) RETURN ITEM_OBJECT
, MEMBER FUNCTION to_string RETURN VARCHAR2 )
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY item_object IS
  
  CONSTRUCTOR FUNCTION item_object RETURN SELF AS RESULT IS
    item ITEM_OBJECT := item_object('Generic Title','Generic Subtitle');
  BEGIN
    self := item;
    RETURN;
  END item_object;
  
  CONSTRUCTOR FUNCTION item_object
  (item_title VARCHAR2, item_subtitle VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.item_title := item_title;
    self.item_subtitle := item_subtitle;
    RETURN;
  END item_object;

  STATIC FUNCTION get_item_object (item_id NUMBER) RETURN ITEM_OBJECT IS
    item ITEM_OBJECT;
    CURSOR c (item_id_in NUMBER) IS
      SELECT item_title, item_subtitle FROM item WHERE item_id = item_id_in;  
  BEGIN
    FOR i IN c (item_id) LOOP
      item := item_object(i.item_title,i.item_subtitle);
    END LOOP;
    RETURN item;
  END get_item_object;

  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.item_title||']['||self.item_subtitle||']';
  END to_string;
  
END;
/

-- Test whether the static constructor works.
BEGIN
  dbms_output.put_line(item_object.get_item_object(1050).to_string);
END;
/