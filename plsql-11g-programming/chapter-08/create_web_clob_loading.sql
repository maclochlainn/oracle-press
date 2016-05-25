/*
 * load_web_clob_loading.sql
 * Chapter 8, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * This script builds a web access procedure for a CLOB in the
 * ITEM table.
 */

CREATE OR REPLACE PROCEDURE web_load_clob_from_file  
( item_id_in IN     NUMBER
, descriptor IN OUT CLOB ) IS

BEGIN

  -- A FOR UPDATE makes this a DML transaction.
  UPDATE    item
  SET       item_desc = empty_clob()
  WHERE     item_id = item_id_in
  RETURNING item_desc INTO descriptor;
       
END web_load_clob_from_file;
/

