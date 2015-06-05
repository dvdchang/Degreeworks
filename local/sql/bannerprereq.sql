-- ---------------------------------------------------------------------
-- $Id$
-- ---------------------------------------------------------------------
-- This script is used by the build script to see if the right version
-- of the Banner Preerq table in place.
-- The sql statement does a count on the table name we expect.
--
-- Example: sqlplus someid/somepwd @bannerprereq.sql
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
-- We want the student IDs to go to this file always
-- The build script assumes this name will be used
spool bannerprereq.txt

-- See if the DW prereq objects exist in this version of the db
select count(object_name) from all_objects where object_name like '%DW_PREQ%';

-- Turn off the spooler so our "quit" command does not go to our output file
spool off
quit
