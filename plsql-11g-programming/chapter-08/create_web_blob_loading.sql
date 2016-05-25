/*
 * load_web_blob_loading.sql
 * Chapter 8, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * This script builds a web access procedure for a BLOB in the
 * ITEM table.
 */

CREATE OR REPLACE PROCEDURE web_load_blob_from_file  
( item_id_in IN     NUMBER
, descriptor IN OUT BLOB ) IS

BEGIN

  -- A FOR UPDATE makes this a DML transaction.
  UPDATE    item
  SET       item_blob = empty_blob()
  WHERE     item_id = item_id_in
  RETURNING item_blob INTO descriptor;
       
END web_load_blob_from_file;
/

