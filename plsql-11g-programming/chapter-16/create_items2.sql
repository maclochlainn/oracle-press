/*
 * create_item2.sql
 * Chapter 16, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates a dynamic PL/SQL web page that uses
 * Oracle's flexible parameter passing.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE item2
( name_array    OWA_UTIL.ident_ARR
, value_array   OWA_UTIL.ident_ARR ) AS

  CURSOR get_items
  ( begin_item_id NUMBER
  , end_item_id   NUMBER ) IS
    SELECT   item_id AS item_number
    ,        item_title||': '||item_subtitle AS item_title
    ,        item_release_date AS release_date
    FROM     item
    WHERE    item_id BETWEEN begin_item_id AND end_item_id;
BEGIN
  -- Set HTML page rendering tags.
  htp.htmlopen;
  htp.headopen;
  htp.htitle('Item List');  -- Sets the browser window and frame title.
  htp.headclose;
  htp.bodyopen;
  htp.line;

  -- Use PL/SQL Toolkit to format the page.
  htp.tableopen(cborder     => 2
               ,cattributes => 'style=background-color:feedb8');
    htp.tablerowopen;
      htp.tabledata(cvalue      => '#'
                   ,calign      => 'center'
                   ,cattributes => 'style=color:#336699
                                          background-color:#cccc99
                                          font-weight:bold
                                          width=50');
      htp.tabledata(cvalue      => 'Title'
                   ,calign      => 'center'
                   ,cattributes => 'style=color:#336699
                                          background-color:#cccc99
                                          font-weight:bold
                                          width=200');
      htp.tabledata(cvalue      => 'Release Date'
                   ,calign      => 'center'
                   ,cattributes => 'style=color:#336699
                                          background-color:#cccc99
                                          font-weight:bold
                                          width=100');
    htp.tablerowclose;

  -- Use a loop to collect the data.
  FOR i IN get_items(name_array(1),value_array(2)) LOOP

    htp.tablerowopen;
      htp.tabledata(cvalue      => i.item_number
                   ,calign      => 'center'
                   ,cattributes => 'style=background-color:#f7f7e7');
      htp.tabledata(cvalue      => i.item_title
                   ,calign      => 'left'
                   ,cattributes => 'style=background-color:#f7f7e7');
      htp.tabledata(cvalue      => i.release_date
                   ,calign      => 'center'
                   ,cattributes => 'style=background-color:#f7f7e7');
    htp.tablerowclose;

  END LOOP;

  -- Close the table.
  htp.tableclose;

  -- Print a line and close body and page.
  htp.line;
  htp.bodyclose;
  htp.htmlclose;

END item2;
/
