/*
 * test_profiler.sql
 * Appendix G, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script requires configuration steps qualified in the
 * Appendix.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION glue_strings
(string1 VARCHAR2, string2 VARCHAR2) RETURN VARCHAR2 IS
  new_string VARCHAR2(2000);
BEGIN
  IF string1 IS NOT NULL THEN
    IF string2 IS NOT NULL THEN
      new_string := string1 || ': ' || string2;
    ELSE
      new_string := string1;
    END IF;
  ELSE
    IF string2 IS NOT NULL THEN
      new_string := string2;
    END IF;
  END IF;
  RETURN new_string;
END glue_strings;
/

CREATE OR REPLACE TYPE varchar2_table IS TABLE OF VARCHAR2(2000);
/

CREATE OR REPLACE TYPE number_table IS TABLE OF NUMBER;
/

CREATE OR REPLACE PROCEDURE quantity_onhand
( item_title         IN     VARCHAR2
, item_rating_agency IN     VARCHAR2
, item_titles        IN OUT VARCHAR2_TABLE
, quantities         IN OUT NUMBER_TABLE) IS
  -- Define counter variable.
  counter            NUMBER := 1;
  -- Define dynamic cursor.
  CURSOR c (item_title_in VARCHAR2, item_rating_agency_in VARCHAR2) IS
    SELECT   glue_strings(item_title,item_subtitle) AS full_title
    ,        COUNT(*) AS quantity_on_hand
    FROM     item
    WHERE    REGEXP_LIKE(item_title,item_title_in)
    AND      item_rating_agency = item_rating_agency_in
    GROUP BY glue_strings(item_title,item_subtitle)
    ,        item_rating_agency;
BEGIN
  -- Read cursor and assign column values to parallel arrays.
  FOR i IN c (item_title,item_rating_agency) LOOP
    item_titles.EXTEND;
    item_titles(counter) := i.full_title;
    quantities.EXTEND;
    quantities(counter) := i.quantity_on_hand;
    counter := counter + 1;
  END LOOP;
END;
/

DECLARE
  -- Input values.
  item_title         VARCHAR2(30) := 'Harry Potter';
  item_rating_agency VARCHAR2(4)  := 'MPAA';
  -- Output values.
  full_title         VARCHAR2_TABLE := varchar2_table();
  rating_agency      NUMBER_TABLE := number_table();
BEGIN
  dbms_hprof.start_profiling('PROFILER_DIR','harry.txt');
  -- Call reference cursor.
  quantity_onhand(item_title,item_rating_agency,full_title,rating_agency);
  -- Loop through parallel collections until all records are read.
  FOR i IN 1..full_title.COUNT LOOP
    dbms_output.put(full_title(i));
    dbms_output.put(rating_agency(i));
  END LOOP;
  dbms_hprof.stop_profiling;
END;
/

COL method_name           FORMAT A30
COL function_name         FORMAT A24
COL subtree_elapsed_time  FORMAT 99.90 HEADING "Subtree|Elapsed|Time"
COL function_elapsed_time FORMAT 99.90 HEADING "Function|Elapsed|Time"
COL calls                 FORMAT 99    HEADING "Calls"

SELECT   RPAD(' ',level*2,' ')||dfi.owner||'.'||dfi.module AS method_name
,        dfi.function AS function_name
,       (dpci.subtree_elapsed_time/1000) AS subtree_elapsed_time
,       (dpci.function_elapsed_time/1000) AS function_elapsed_time
,        dpci.calls
FROM     dbmshp_parent_child_info dpci
,        dbmshp_function_info dfi
WHERE    dpci.runid = dfi.runid
AND      dpci.parentsymid = dfi.symbolid
AND      dpci.runid = 4
CONNECT
BY PRIOR dpci.childsymid = dpci.parentsymid
START
WITH     dpci.parentsymid = 1;
