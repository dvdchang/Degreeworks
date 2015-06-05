-- ----------------------------------------------------------------------------
-- $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/bannerstudents.sql#1 $
-- ----------------------------------------------------------------------------
-- bannerstudents.sql - used by RAD30JOB and the bannerextract script
-- The sql statement it to be used to extract a list of IDS from Banner
-- Example: sqlplus someid/somepwd @bannerstudents.sql
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
spool bannerstudents.ids

-- Change this select stmt to be whatever you want to select the pool
-- of students you want pulled into DegreeWorks
-- using concurrent curriculum

-- get most current student
SELECT DISTINCT SPRIDEN_ID, ' ', SPRIDEN_PIDM
FROM SPRIDEN, SGBSTDN B, SORLCUR D 
WHERE B.SGBSTDN_STST_CODE IN 
(SELECT STVSTST_CODE FROM STVSTST 
     WHERE STVSTST_REG_IND = 'Y') 
AND B.SGBSTDN_TERM_CODE_EFF = 
   (SELECT MAX(C.SGBSTDN_TERM_CODE_EFF) 
   FROM SGBSTDN C 
   WHERE C.SGBSTDN_TERM_CODE_EFF <= '999999' 
   AND C.SGBSTDN_PIDM = B.SGBSTDN_PIDM 
   AND B.SGBSTDN_LEVL_CODE IN ('01', '02')) 
AND D.SORLCUR_TERM_CODE_CTLG >= '201001'     -- was '200401' 
AND D.SORLCUR_CACT_CODE = 'ACTIVE' 
AND D.SORLCUR_SEQNO = 
   (SELECT MAX(Y.SORLCUR_SEQNO) 
   FROM SORLCUR Y WHERE Y.SORLCUR_PIDM = 
   D.SORLCUR_PIDM AND Y.SORLCUR_PRIORITY_NO = 
   D.SORLCUR_PRIORITY_NO AND Y.SORLCUR_LMOD_CODE = 'LEARNER') 
AND D.SORLCUR_PIDM = B.SGBSTDN_PIDM 
AND SPRIDEN_PIDM = B.SGBSTDN_PIDM 
AND SPRIDEN_CHANGE_IND IS NULL
and ((exists (select 'x' from sfrstcr where
  sfrstcr_pidm = spriden_pidm)) or
  (exists (select 'x' from saradap where
  saradap_pidm = spriden_pidm and
  saradap_term_code_entry > 201404)))
union
-- get those who petitioned for graduation
select distinct spriden.spriden_id, ' ', spriden_pidm
from spriden, shrdgmr, sorlcur d
where spriden_pidm = d.sorlcur_pidm
and spriden_change_ind is null
and shrdgmr_pidm = spriden_pidm
and shrdgmr_degs_code <> 'SO'
and shrdgmr_term_code_grad = '201404'
and d.sorlcur_term_code_ctlg < '201001'
and d.sorlcur_cact_code = 'ACTIVE'
and d.sorlcur_lmod_code = 'LEARNER'
and d.sorlcur_seqno =
 (select max(s.sorlcur_seqno) from sorlcur s 
  where s.sorlcur_pidm = spriden_pidm
  and s.sorlcur_cact_code = 'ACTIVE'
  and s.sorlcur_lmod_code = 'LEARNER');
ORDER BY SPRIDEN_ID; 

spool off
quit

