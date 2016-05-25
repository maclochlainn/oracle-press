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


-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_types
            WHERE  type_name = 'ITEMS_OBJECT') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE items_object';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_types
            WHERE  type_name = 'ITEM_TABLE') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE item_table';
  END LOOP;
END;
/

CREATE OR REPLACE TYPE item_table IS TABLE OF item_object;
/

CREATE OR REPLACE TYPE items_object IS OBJECT
( items_table    ITEM_TABLE
, CONSTRUCTOR FUNCTION items_object
  (items_table ITEM_TABLE) RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION items_object
  RETURN SELF AS RESULT
, MEMBER FUNCTION get_size RETURN NUMBER
, STATIC FUNCTION get_items_table RETURN ITEM_TABLE)
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY items_object IS
  
  CONSTRUCTOR FUNCTION items_object
  (items_table ITEM_TABLE) RETURN SELF AS RESULT IS
  BEGIN
    self.items_table := items_table;
    RETURN;
  END items_object;

  CONSTRUCTOR FUNCTION items_object
  RETURN SELF AS RESULT IS
    c           NUMBER := 1; -- Counter for table index.
    item        ITEM_OBJECT;
    CURSOR c1 IS
      SELECT item_title, item_subtitle FROM item;  
  BEGIN
    FOR i IN c1 LOOP
      item := item_object(i.item_title,i.item_subtitle);
      items_table.EXTEND;
      self.items_table(c) := item;
      c := c + 1;
    END LOOP;
    RETURN;
  END items_object;

  MEMBER FUNCTION get_size RETURN NUMBER IS
  BEGIN
    RETURN self.items_table.COUNT;
  END get_size;
  
  STATIC FUNCTION get_items_table RETURN ITEM_TABLE IS
    c           NUMBER := 1; -- Counter for table index.
    item        ITEM_OBJECT;
    items_table ITEM_TABLE := item_table();
    CURSOR c1 IS
      SELECT item_title, item_subtitle FROM item;  
  BEGIN
    FOR i IN c1 LOOP
      item := item_object(i.item_title,i.item_subtitle);
      items_table.EXTEND;
      items_table(c) := item;
      c := c + 1;
    END LOOP;
    RETURN items_table;
  END get_items_table;

END;
/

-- Test whether the collection constructor works.
DECLARE
  items ITEMS_OBJECT;
BEGIN
  items := items_object(items_object.get_items_table);
  dbms_output.put_line(items.get_size);
END;
/

-- Test whether the static factory works.
DECLARE
  items ITEM_TABLE;
BEGIN
  items := items_object.get_items_table;
  FOR i IN 1..items.COUNT LOOP
    dbms_output.put_line(items(i).to_string);
  END LOOP;
END;
/
