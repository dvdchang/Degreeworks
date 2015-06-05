--  *************************************************************** 
--         Banner Prereq Response Queue - show messages on CHECK queue
--  $Id$
--  -----------------------------------------------------------------
--  DESCRIPTION:
--  This sql file shows the count of messages waiting on the CHECK response queue
--
--
-- We don't want the column headers in our output file
set pagesize 0
-- We don't want the "1 record selected" message at the end
set feedback off
-- We don't want count to go to stdout - only to the file
set termout off
-- It is good to see what sql is being executed - but not to our output file
set echo off
-- We want the output to go to this file
-- The preqshow script assumes this name will be used
spool preqresponseqshow.out

select count(*) from BANINST1.aq$DW_PREQ_RESPONSE_Qtab;

-- Turn off the spooler so our "quit" command does not go to our output file
spool off
quit

