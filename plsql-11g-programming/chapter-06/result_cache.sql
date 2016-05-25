/*
 * result_cache.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates the get_title function, it uses a Oracle 11g
 * new feature. You cannot run this on older releases of the database.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Create a scalar collection of strings.
CREATE OR REPLACE TYPE strings AS TABLE OF VARCHAR2(60);
/

CREATE OR REPLACE FUNCTION get_title
( partial_title VARCHAR2 ) RETURN STRINGS
RESULT_CACHE RELIES_ON(item) IS
  -- Declare a collection control variable and collection variable. 
  counter      NUMBER  := 1;
  return_value STRINGS := strings();

  -- Define a parameterized cursor.
  CURSOR get_title
  ( partial_title VARCHAR2 ) IS
  SELECT   item_title
  FROM     item
  WHERE    UPPER(item_title) LIKE '%'||UPPER(partial_title)||'%';
BEGIN
  -- Read the data and write it to the collection in a cursor FOR loop.
  FOR i IN get_title(partial_title) LOOP
    return_value.EXTEND;
    return_value(counter) := i.item_title;
    counter := counter + 1;
  END LOOP;
  RETURN return_value;
END get_title;
/

list
show errors

DECLARE
  list STRINGS;
BEGIN
  list := get_title('Harry');
  FOR i IN 1..list.LAST LOOP
    dbms_output.put_line('list('||i||') : ['||list(i)||']');
  END LOOP;
END;
/
