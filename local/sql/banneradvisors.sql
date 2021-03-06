-- ----------------------------------------------------------------------------
-- $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/banneradvisors.sql#1 $
-- ----------------------------------------------------------------------------
-- $Id: //Tuxedo/MAIN/Product/sql/banid.sql#2
-- banneradvisors.sql - used by RAD30JOB and the bannerextract script
-- The sql statement it to be used to extract a list of IDS from Banner
-- Example: sqlplus someid/somepwd @banneradvisors.sql
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
-- The bannerextract script assumes this name will be used
spool banneradvisors.ids

-- Change this select stmt to be whatever you want to select the pool
-- of advisors you want pulled into DegreeWorks
-- We are selecting the advisors from the SGRADVR table for active students. 
-- In the first query we are getting the SPRIDEN records for these advisors. 
-- The next stuff refers to the advisor and the then selects the active students

-- CMU Localization === Modified extract to match CMU values

select distinct spriden_id from spriden, sgradvr, sgbstdn b
 where spriden_change_ind is null
  and spriden_pidm = sgradvr_advr_pidm
  and (b.sgbstdn_stst_code in
        (select stvstst_code from stvstst where stvstst_reg_ind = 'Y')
       and b.sgbstdn_term_code_eff = 
        (select max(c.sgbstdn_term_code_eff)
         from sgbstdn c where c.sgbstdn_term_code_eff <= '999999'
         and c.sgbstdn_pidm = b.sgbstdn_pidm)
       and b.sgbstdn_levl_code in('01', '02')
       and b.sgbstdn_term_code_ctlg_1 >= '200410')
  and b.sgbstdn_pidm = sgradvr_pidm
  order by spriden_id;


-- Turn off the spooler so our "quit" command does not go to our output file
spool off
quit
-- ----------------------------------------------------------------------------
Example 0: for testing
select spriden_id from spriden where spriden_pidm < 20;

EXAMPLE 1: using SGRADVR to get each of the advisors on student records
select distinct spriden_id from spriden, sgradvr, sgbstdn b
 where spriden_change_ind is null
  and spriden_pidm = sgradvr_advr_pidm
  and (b.sgbstdn_stst_code in
        (select stvstst_code from stvstst where stvstst_reg_ind = 'Y')
       and b.sgbstdn_term_code_eff = 
        (select max(c.sgbstdn_term_code_eff)
         from sgbstdn c where c.sgbstdn_term_code_eff <= '200710'
         and c.sgbstdn_pidm = b.sgbstdn_pidm)
       and b.sgbstdn_levl_code in('UG', 'GR')
       and b.sgbstdn_term_code_ctlg_1 >= '200410')
  and b.sgbstdn_pidm = sgradvr_pidm
  order by spriden_id;
