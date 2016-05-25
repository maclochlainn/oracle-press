/*
 * query_profiler.sql
 * Appendix G, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script queries data from the PL/SQL Hierchical Profiler.
 */

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
BY PRIOR dpci.childsymid = dpci.parentsymid  -- Child always connects on left.
START
WITH     dpci.parentsymid = 1;
