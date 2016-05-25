/*
 * trigger_alerts1.sql
 * Chapter 12, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script inserts, updates and deletes a row, triggering
 * three alerts.
 */

-- Insert a new row.
INSERT
INTO     messages
VALUES (4,'PLSQL','USERA','Insert, Shazaam.');

-- Upgrade a row.
UPDATE   messages
SET      message = 'Update, Shazaam.'
WHERE    message_id = 2;

-- Delete a row.
DELETE   messages
WHERE    message_id = 3;

-- Commit the changes.
COMMIT;
