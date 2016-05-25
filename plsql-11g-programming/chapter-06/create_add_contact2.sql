/*
 * create_add_contact2.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script creates a pass-by-reference procedure.
 */

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Define automonous function to secure any surrogate key values.
CREATE OR REPLACE FUNCTION get_sequence_value
(sequence_name VARCHAR2) RETURN NUMBER IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  id_value  NUMBER;
  statement VARCHAR2(2000);
BEGIN
  -- Build dynamic SQL statement as anonymous block PL/SQL unit.
  statement := 'BEGIN'                                ||CHR(10)
            || '  SELECT  '||sequence_name||'.nextval'||CHR(10)
            || '  INTO     :id_value'                 ||CHR(10)
            || '  FROM     dual;'                     ||CHR(10)
            || 'END;';

  -- Execute dynamic SQL statement.
  EXECUTE IMMEDIATE statement USING OUT id_value; 

  RETURN id_value;
END get_sequence_value;
/

CREATE OR REPLACE procedure add_contact
( contact_id           OUT NUMBER  -- Primary key after insert.
, member_id         IN     NUMBER  -- Foreign key preceding insert.
, contact_type      IN     NUMBER
, last_name         IN     VARCHAR2
, first_name        IN     VARCHAR2
, middle_initial    IN     VARCHAR2 := NULL
, created_by        IN     NUMBER
, creation_date     IN     DATE     := SYSDATE
, last_updated_by   IN     NUMBER
, last_update_date  IN     DATE     := SYSDATE) IS

BEGIN
  -- Set savepoint so all or nothing happens.
  SAVEPOINT add_contact;

  -- Suggest inlining the get_sequence_value function.
  PRAGMA INLINE(get_sequence_value,'YES');

  -- Assign next value from sequence and insert record.
  contact_id := get_sequence_value('CONTACT_S1');
  INSERT INTO contact VALUES
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_initial
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date);

EXCEPTION
  WHEN others THEN
    ROLLBACK TO add_contact;
    RAISE_APPLICATION_ERROR(-20001,SQLERRM);
END add_contact;
/


CREATE OR REPLACE procedure add_address
( address_id           OUT NUMBER
, contact_id        IN     NUMBER
, address_type      IN     NUMBER   := NULL
, street_address    IN     VARCHAR2 := NULL
, city              IN     VARCHAR2 := NULL
, state_province    IN     VARCHAR2 := NULL
, postal_code       IN     VARCHAR2 := NULL
, created_by        IN     NUMBER
, creation_date     IN     DATE     := SYSDATE
, last_updated_by   IN     NUMBER
, last_update_date  IN     DATE     := SYSDATE) IS

  -- Declare surrogate key variables.
  street_address_id NUMBER;

BEGIN
  -- Set savepoint so all or nothing happens.
  SAVEPOINT add_address;

  -- Check data is present for insert to ADDRESS table.
  IF address_type IS NOT NULL   AND
     city IS NOT NULL           AND
     state_province IS NOT NULL AND
     postal_code IS NOT NULL    THEN

    -- Assign next value from sequence and insert record.
    address_id := get_sequence_value('ADDRESS_S1');
    INSERT INTO address VALUES
    ( address_id
    , contact_id
    , address_type
    , city
    , state_province
    , postal_code
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date);

    -- Check data is present for insert to ADDRESS table.
    IF street_address IS NOT NULL THEN

      -- Assign next value from sequence and insert record.
      street_address_id := get_sequence_value('STREET_ADDRESS_S1');
      INSERT INTO street_address VALUES
      ( street_address_id
      , address_id
      , street_address
      , created_by
      , creation_date
      , last_updated_by
      , last_update_date);
    END IF;
  END IF;

EXCEPTION
  WHEN others THEN
    ROLLBACK TO add_address;
    RAISE_APPLICATION_ERROR(-20001,SQLERRM);
END add_address;
/

-- Define anonymous block to test ADD_CONTACT and ADD_ADDRESS procedures.
DECLARE
 
  -- Declare surrogate key variables.
  member_id  NUMBER;
  contact_id NUMBER;
  address_id NUMBER;

  -- Declare local function to get type.
  FUNCTION get_type
  ( table_name  VARCHAR2
  , column_name VARCHAR2
  , type_name   VARCHAR2) RETURN NUMBER IS
    retval NUMBER;
  BEGIN
    SELECT   common_lookup_id
    INTO     retval
    FROM     common_lookup
    WHERE    common_lookup_table = table_name
    AND      common_lookup_column = column_name
    AND      common_lookup_type = type_name;
    RETURN retval;
  END get_type;

  -- Define automonous function to secure surrogate key values.
  FUNCTION get_member_id RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    id_value NUMBER;
  BEGIN
    SELECT member_s1.nextval INTO id_value FROM dual;
    RETURN id_value;
  END;

BEGIN

  -- Declare surrogate key variables.
  member_id := get_member_id;

  INSERT INTO member VALUES
  ( member_id
  ,(SELECT common_lookup_id
    FROM   common_lookup
    WHERE  common_lookup_table = 'MEMBER'
    AND    common_lookup_column = 'MEMBER_TYPE'
    AND    common_lookup_type = 'GROUP')
  , '4563-98-71'
  , '5555-6363-1212-4343'
  ,(SELECT common_lookup_id
    FROM   common_lookup
    WHERE  common_lookup_table = 'MEMBER'
    AND    common_lookup_column = 'CREDIT_CARD_TYPE'
    AND    common_lookup_type = 'VISA_CARD')
  , 3
  , SYSDATE
  , 3
  , SYSDATE);

  -- Call procedure to insert records in related tables.
  add_contact( member_id => member_id
             , contact_id => contact_id
             , contact_type => get_type('CONTACT','CONTACT_TYPE','CUSTOMER')
             , last_name => 'Rodriguez'
             , first_name => 'Alex'
             , created_by => 3
             , last_updated_by => 3);

  -- Call procedure to insert records in related tables.
  add_address( address_id => address_id
             , contact_id => contact_id
             , address_type => get_type('ADDRESS','ADDRESS_TYPE','HOME')
             , street_address => 'East 161st Street'
             , city => 'Bronx'
             , state_province => 'NY'
             , postal_code => '10451'
             , created_by => 3
             , last_updated_by => 3);


END;
/
