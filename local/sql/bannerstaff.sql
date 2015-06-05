set pagesize 0
set feedback off
set termout off
set timing off
set echo off
spool bannerstaff.ids
select distinct spriden_id from spriden, sirattr a
where spriden_pidm= sirattr_pidm
and spriden_change_ind is null
and sirattr_fatt_code = 'ADV'
and sirattr_term_code_eff = (select max(sirattr_term_code_eff)
    from sirattr s
    where a.sirattr_pidm = s.sirattr_pidm);
spool off;
quit;

