/*
 * reserved_key_words.sql
 * Appendix I, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script segments reserved and key words.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- Define and declare collection.
  TYPE alpha_key IS TABLE OF CHARACTER;  
  code ALPHA_KEY := alpha_key('A','B','C','D','E','F','G','H','I','J'
                             ,'K','L','M','N','O','P','Q','R','S','T'
                             ,'U','V','W','X','Y','Z');

  -- Define a single character indexed collection.  
  TYPE list IS TABLE OF VARCHAR2(2000)
    INDEX BY VARCHAR2(1);

  -- Define two collections.    
  reserved_word LIST;
  key_word      LIST;

  -- Define cursor.
  CURSOR c IS
    SELECT   keyword
    ,        reserved
    ,        res_type
    ,        res_attr
    ,        res_semi
    FROM     v$reserved_words
    ORDER BY keyword;
  
  FUNCTION format_list (list_in LIST) RETURN BOOLEAN IS

    -- Declare control variables.
    current VARCHAR2(1);
    element VARCHAR2(2000);
    status BOOLEAN := TRUE;
    
  BEGIN
    -- Read through an alphabetically indexed collection.
    FOR i IN 1..list_in.COUNT LOOP
      IF i = 1 THEN
        current := list_in.FIRST;
        element := list_in(current);
      ELSE
        IF list_in.NEXT(current) IS NOT NULL THEN
          current := list_in.NEXT(current);
          element := list_in(current);
        END IF;
      END IF;
      dbms_output.put_line('['||current||'] ['||element||']');
    END LOOP;
    RETURN status;
  END format_list;
  
BEGIN

  -- Initialize reserved and key word collections.
  FOR i IN 1..code.LAST LOOP
    FOR j IN c LOOP
      IF code(i) = UPPER(SUBSTR(j.keyword,1,1))
      AND (j.reserved = 'Y' OR j.res_type = 'Y' OR j.res_attr = 'Y' OR j.res_semi = 'Y') THEN
        IF reserved_word.EXISTS(code(i)) THEN
          reserved_word(code(i)) := reserved_word(code(i)) || ', ' || j.keyword;
        ELSE
          reserved_word(code(i)) := j.keyword;
        END IF;
      ELSIF code(i) = UPPER(SUBSTR(j.keyword,1,1)) AND j.reserved = 'N' THEN
        IF key_word.EXISTS(code(i)) THEN
          key_word(code(i)) := key_word(code(i)) || ', ' || j.keyword;
        ELSE
          key_word(code(i)) := j.keyword;
        END IF;
      END IF;
    END LOOP;
  END LOOP;

  -- Print both lists.
  IF format_list(reserved_word) AND format_list(key_word) THEN
    NULL;
  END IF;

END;
/