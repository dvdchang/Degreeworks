-- ----------------------------------------------------------------------------
-- $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/bannerapplicants.sql#1 $
-- ----------------------------------------------------------------------------
-- bannerapplicants.sql - used by RAD30JOB and the bannerextract script
-- The sql statement it to be used to extract a list of IDS from Banner
-- Example: sqlplus someid/somepwd @bannerapplicants.sql
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
-- We want the applicant IDs to go to this file always
-- The bannerextract script assumes this name will be used
spool bannerapplicants.ids

select spriden_id from spriden where spriden_pidm = 819;     

spool off
quit
--------------------------------------------


-- Change this select stmt to be whatever you want to select the pool
-- of applicants you want pulled into DegreeWorks
SELECT SPRIDEN_ID                  
FROM SPRIDEN, SARADAP
WHERE ((SELECT COUNT(*) FROM SHRTRCE
    WHERE SHRTRCE_PIDM = SARADAP_PIDM) > 0
AND (SELECT COUNT(*) FROM SGBSTDN
    WHERE SGBSTDN_STST_CODE = 'IS'
    AND SGBSTDN_TERM_CODE_EFF = SARADAP_TERM_CODE_ENTRY
    AND SGBSTDN_PIDM = SARADAP_PIDM) = 0)
AND SPRIDEN_PIDM = SARADAP_PIDM
AND SPRIDEN_CHANGE_IND is NULL
ORDER BY SARADAP_TERM_CODE_ENTRY DESC;

-- Turn off the spooler so our "quit" command does not go to our output file
spool off
quit
-- ----------------------------------------------------------------------------
