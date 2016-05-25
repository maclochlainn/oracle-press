/*
 * create_helloworld1.sql
 * Chapter 16, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates a static PL/SQL web page.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE HelloWorldProcedure1 AS
BEGIN
  -- Set an HTML meta tag and render page.
  owa_util.mime_header('text/html');  -- <META Content-type:text/html>
  htp.htmlopen;                       -- <HTML>
  htp.headopen;                       -- <HEAD>
  htp.htitle('HelloWorldProcedure1'); -- <TITLE>HelloWorldProcedure</TITLE>
  htp.headclose;                      -- </HEAD>
  htp.bodyopen;                       -- <BODY>
  htp.line;                           -- <HR>
  htp.print('Hello world.');          -- Hello world.
  htp.line;                           -- <HR>
  htp.bodyclose;                      -- </BODY>
  htp.htmlclose;                      -- </HTML>

END HelloWorldProcedure1;
/
