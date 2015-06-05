-- ----------------------------------------------------------------------------
-- $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/bannergrantsverify.sql#5 $
-- ----------------------------------------------------------------------------
--
-- Verify permissions in the Banner database needed to install and run DegreeWorks.
-- Must be run as the DegreeWorks account (usually dwmgr) in the Banner database.
-- ----------------------------------------------------------------------------

set pagesize 999 feed off term on echo off trims on ver off head off
spool bannergrantsverify
show user
select 'The following grants are missing in '||global_name from global_name;

-- select 'Error: Missing create procedure privilege.' from dual where not exists (select 'x' from user_sys_privs where PRIVILEGE = 'CREATE PROCEDURE');
-- select 'Error: Missing create public synonym privilege.' from dual where not exists (select 'x' from user_sys_privs where PRIVILEGE = 'CREATE PUBLIC SYNONYM');
select 'Warning: Missing optional grant execute on BANINST1.BWCKFRMT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'BWCKFRMT');
select 'Warning: Missing optional grant execute on BANINST1.BWCKLIBS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'BWCKLIBS');
select 'Warning: Missing optional grant execute on BANINST1.BWLKILIB.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'BWLKILIB');
select 'Warning: Missing optional grant execute on BANINST1.BWLKOIDS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'BWLKOIDS');
select 'Warning: Missing optional grant execute on BANINST1.BWLKOSTM.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'BWLKOSTM');
select 'Error: Missing grant execute on BANINST1.F_CLASS_CALC_FNC.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'F_CLASS_CALC_FNC');
select 'Warning: Missing optional grant execute on WTAILOR.TWBKBSSF.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'TWBKBSSF');
select 'Warning: Missing optional grant execute on WTAILOR.TWBKFRMT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'TWBKFRMT');
select 'warning: Missing optional grant execute on WTAILOR.TWBKWBIS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'TWBKWBIS');
select 'Warning: Missing optional grant execute on WTAILOR.TWGBWSES.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'TWGBWSES');
select 'Warning: Missing optional grant select on GENERAL.GORADID(optional).' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'GORADID');
select 'Error: Missing grant select on GENERAL.GOREMAL.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'GOREMAL');
select 'Warning: Missing optional grant select on GENERAL.GOBUMAP(optional).' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'GOBUMAP');
select 'Error: Missing grant select on SATURN.SARADAP.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SARADAP');
select 'Error: Missing grant select on SATURN.SCBCRKY.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SCBCRKY');
select 'Error: Missing grant select on SATURN.SCBCRSE.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SCBCRSE');
select 'Error: Missing grant select on SATURN.SCBDESC.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SCBDESC');
select 'Error: Missing grant select on SATURN.SCRATTR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SCRATTR');
select 'Error: Missing grant select on SATURN.SCREQIV.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SCREQIV');
select 'Error: Missing grant select on SATURN.SCRLEVL.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SCRLEVL');
select 'Error: Missing grant select on SATURN.SCRRTST.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SCRRTST');
select 'Error: Missing grant select on SATURN.SFRSTCR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SFRSTCR');
select 'Error: Missing grant select on SATURN.SGBSTDN.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SGBSTDN');
select 'Error: Missing grant select on SATURN.SGRADVR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SGRADVR');
select 'Warning: Missing optional grant select on SATURN.SGRATHE(optional).' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SGRATHE');
select 'Error: Missing grant select on SATURN.SGRSATT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SGRSATT');
select 'Error: Missing grant select on SATURN.SGRSPRT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SGRSPRT');
select 'Error: Missing grant select on SATURN.SHBTATC.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHBTATC');
select 'Error: Missing grant select on SATURN.SHRATTC.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRATTC');
select 'Error: Missing grant select on SATURN.SHRATTR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRATTR');
select 'Error: Missing grant select on SATURN.SHRDGMR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRDGMR');
select 'Error: Missing grant select on SATURN.SHRGRDE.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRGRDE');
select 'Error: Missing grant select on SATURN.SHRGRDO.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRGRDO');
select 'Error: Missing grant select on SATURN.SHRICMT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRICMT');
select 'Error: Missing grant select on SATURN.SHRLGPA.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRLGPA');
select 'Error: Missing grant select on SATURN.SHRNCRS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRNCRS');
select 'Error: Missing grant select on SATURN.SHRQPNM.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRQPNM');
-- SHRSAPP must be granted only if Banner is at or above version 8.5.3
select 'Warning: Missing grant select on SATURN.SHRSAPP.' from dual 
    where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRSAPP')
          and exists (select 'x' from survers where survers_release >= '8.5.3');
-- SHRSARJ must be granted only if Banner is at or above version 8.5.3
select 'Warning: Missing grant select on SATURN.SHRSARJ.' from dual 
    where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRSARJ')
          and exists (select 'x' from survers where survers_release >= '8.5.3');
select 'Error: Missing grant select on SATURN.SHRTATC.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTATC');
select 'Error: Missing grant select on SATURN.SHRTATT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTATT');
select 'Error: Missing grant select on SATURN.SHRTCKD.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTCKD');
select 'Error: Missing grant select on SATURN.SHRTCKG.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTCKG');
select 'Error: Missing grant select on SATURN.SHRTCKL.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTCKL');
select 'Error: Missing grant select on SATURN.SHRTCKN.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTCKN');
select 'Error: Missing grant select on SATURN.SHRTGPA.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTGPA');
select 'Error: Missing grant select on SATURN.SHRTRAM.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTRAM');
select 'Error: Missing grant select on SATURN.SHRTRCD.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTRCD');
select 'Error: Missing grant select on SATURN.SHRTRCE.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTRCE');
select 'Error: Missing grant select on SATURN.SHRTRCR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTRCR');
select 'Error: Missing grant select on SATURN.SHRTRIT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTRIT');
select 'Error: Missing grant select on SATURN.SHRTRTK.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SHRTRTK');
select 'Error: Missing grant select on SATURN.SMRPRLE.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SMRPRLE');
select 'Error: Missing grant select on SATURN.SOBCACT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SOBCACT');
select 'Error: Missing grant select on SATURN.SOBSBGI.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SOBSBGI');
select 'Error: Missing grant select on SATURN.SORBTAG.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SORBTAG');
select 'Error: Missing grant select on SATURN.SORDEGR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SORDEGR');
select 'Error: Missing grant select on SATURN.SORLCUR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SORLCUR');
select 'Error: Missing grant select on SATURN.SORLFOS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SORLFOS');
select 'Error: Missing grant select on SATURN.SORTEST.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SORTEST');
select 'Error: Missing grant select on SATURN.SPRIDEN.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SPRIDEN');
select 'Error: Missing grant select on SATURN.SSBSECT.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SSBSECT');
select 'Error: Missing grant select on SATURN.SSBXLST.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SSBXLST');
select 'Error: Missing grant select on SATURN.SSRATTR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SSRATTR');
select 'Error: Missing grant select on SATURN.SSRMEET.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SSRMEET');
select 'Error: Missing grant select on SATURN.SSRXLST.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SSRXLST');
select 'Error: Missing grant select on SATURN.STVACCL.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVACCL');
select 'Error: Missing grant select on SATURN.STVACYR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVACYR');
select 'Error: Missing grant select on SATURN.STVATTR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVATTR');
select 'Error: Missing grant select on SATURN.STVCLAS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVCLAS');
select 'Error: Missing grant select on SATURN.STVCOLL.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVCOLL');
select 'Error: Missing grant select on SATURN.STVCSTA.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVCSTA');
select 'Error: Missing grant select on SATURN.STVDEGC.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVDEGC');
select 'Error: Missing grant select on SATURN.STVGMOD.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVGMOD');
select 'Error: Missing grant select on SATURN.STVLEVL.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVLEVL');
select 'Error: Missing grant select on SATURN.STVMAJR.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVMAJR');
select 'Error: Missing grant select on SATURN.STVNATN.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVNATN');
select 'Error: Missing grant select on SATURN.STVNCRQ.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVNCRQ');
select 'Error: Missing grant select on SATURN.STVNCST.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVNCST');
select 'Error: Missing grant select on SATURN.STVQPTP.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVQPTP');
select 'Error: Missing grant select on SATURN.STVRSTS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVRSTS');
select 'Error: Missing grant select on SATURN.STVSBGI.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVSBGI');
select 'Error: Missing grant select on SATURN.STVSTST.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVSTST');
select 'Error: Missing grant select on SATURN.STVSTYP.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVSTYP');
select 'Error: Missing grant select on SATURN.STVSUBJ.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVSUBJ');
select 'Error: Missing grant select on SATURN.STVTAST.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVTAST');
select 'Error: Missing grant select on SATURN.STVTERM.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'STVTERM');
select 'Error: Missing grant select on SATURN.SURVERS.' from dual where not exists (select 'x' from all_objects where object_type<>'SYNONYM' and object_name = 'SURVERS');
select 'If missing grants are listed above please connect as a DBA account and run the most current bannergrants.sql script.' from dual;

exit
