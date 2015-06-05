-- ---------------------------------------------------------------------
-- $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/bannerchecksap.sql#1 $
-- ---------------------------------------------------------------------
-- This script is used by the build script to check if the
-- Banner table SHRSAPP exists in the Banner db.
--
-- Example: sqlplus someid/somepwd @bannerchecksap.sql
-- 
-- We don't want he column headers in our output file
set pagesize 0
-- We don't want the "nn records selected" message at the end
set feedback off
-- We don't want the IDs to go to stdout - only to the file
set termout off
set timing off
-- It is good to see what sql is being executed - but not to our output file
set echo off
-- The build script assumes this name will be used
spool bannerchecksap.txt

-- See if the DW prereq objects exist in this version of the db
desc SATURN.SHRSAPP;
-- Turn off the spooler so our "quit" command does not go to our output file
spool off
quit
