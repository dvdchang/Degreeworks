-- ----------------------------------------------------------------------------
-- $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/bannergrants.sql#4 $
-- ----------------------------------------------------------------------------
-- BannerGrants
--
-- Create a user with necessary permissions in a Banner database for use in DW.
-- This script should be run by a DBA user.

set pages 0 feed on term on echo on

-- NOTE: If your DegreeWorks user is not named dwmgr please 
-- change dwmgr to your username in the line below. 
-- If your user has not yet been created, un-comment the line
-- below which contains the "create user" command. Also change the
-- user's password by changing "tuxedo" to a new password.

define dwuser=dwmgr;

-- create user &&dwuser identified by tuxedo;

grant create session to &&dwuser;
grant create procedure to &&dwuser;
grant create public synonym to &&dwuser;
grant execute on f_class_calc_fnc to &&dwuser;
grant execute on TWBKBSSF to &&dwuser;
grant execute on TWBKWBIS to &&dwuser;
grant execute on TWBKFRMT to &&dwuser;
grant execute on BWCKFRMT to &&dwuser;
grant execute on BWCKLIBS to &&dwuser;
grant execute on BWLKILIB to &&dwuser;
grant execute on BWLKOIDS to &&dwuser;
grant execute on BWLKOSTM to &&dwuser;
grant select on GOBUMAP to &&dwuser;
grant select on GORADID to &&dwuser;
grant select on GOREMAL to &&dwuser;
grant select on SARADAP to &&dwuser;
grant select on SCBCRKY to &&dwuser;
grant select on SCBCRSE to &&dwuser;
grant select on SCBDESC to &&dwuser;
grant select on SCRATTR to &&dwuser;
grant select on SCREQIV to &&dwuser;
grant select on SCRLEVL to &&dwuser;
grant select on SCRRTST to &&dwuser;
grant select on SFRSTCR to &&dwuser;
grant select on SGBSTDN to &&dwuser;
grant select on SGRADVR to &&dwuser;
grant select on SGRSATT to &&dwuser;
grant select on SGRATHE to &&dwuser;
grant select on SGRSPRT to &&dwuser;
grant select on SHBTATC to &&dwuser;
grant select on SHRICMT to &&dwuser;
grant select on SHRATTC to &&dwuser;
grant select on SHRATTR to &&dwuser;
grant select on SHRDGMR to &&dwuser;
grant select on SHRGRDE to &&dwuser;
grant select on SHRGRDO to &&dwuser;
grant select on SHRLGPA to &&dwuser;
grant select on SHRNCRS to &&dwuser;
grant select on SHRQPNM to &&dwuser;
grant select on SHRTATC to &&dwuser;
grant select on SHRTATT to &&dwuser;
grant select on SHRTCKD to &&dwuser;
grant select on SHRTCKG to &&dwuser;
grant select on SHRTCKL to &&dwuser;
grant select on SHRTCKN to &&dwuser;
grant select on SHRTGPA to &&dwuser;
grant select on SHRTRAM to &&dwuser;
grant select on SHRTRCD to &&dwuser;
grant select on SHRTRCE to &&dwuser;
grant select on SHRTRCR to &&dwuser;
grant select on SHRTRIT to &&dwuser;
grant select on SHRTRTK to &&dwuser;
grant select on SMRPRLE to &&dwuser;
grant select on SOBCACT to &&dwuser;
grant select on SOBCURR to &&dwuser;
grant select on SOBSBGI to &&dwuser;
grant select on SORBTAG to &&dwuser;
grant select on SORCCON to &&dwuser;
grant select on SORCMJR to &&dwuser;
grant select on SORCMNR to &&dwuser;
grant select on SORMCRL to &&dwuser;
grant select on SORDEGR to &&dwuser;
grant select on SORLCUR to &&dwuser;
grant select on SORLFOS to &&dwuser;
grant select on SORTEST to &&dwuser;
grant select on SPRIDEN to &&dwuser;
grant select on SSBSECT to &&dwuser;
grant select on SSBXLST to &&dwuser;
grant select on SSRATTR to &&dwuser;
grant select on SSRMEET to &&dwuser;
grant select on SSRXLST to &&dwuser;
grant select on STVACCL to &&dwuser;
grant select on STVACYR to &&dwuser;
grant select on STVATTR to &&dwuser;
grant select on STVCLAS to &&dwuser;
grant select on STVCOLL to &&dwuser;
grant select on STVCSTA to &&dwuser;
grant select on STVDEGC to &&dwuser;
grant select on STVGMOD to &&dwuser;
grant select on STVLEVL to &&dwuser;
grant select on STVMAJR to &&dwuser;
grant select on STVNATN to &&dwuser;
grant select on STVNCRQ to &&dwuser;
grant select on STVNCST to &&dwuser;
grant select on STVQPTP to &&dwuser;
grant select on STVRSTS to &&dwuser;
grant select on STVSBGI to &&dwuser;
grant select on STVSSTS to &&dwuser;
grant select on STVSTST to &&dwuser;
grant select on STVSTYP to &&dwuser;
grant select on STVSUBJ to &&dwuser;
grant select on STVTAST to &&dwuser;
grant select on STVTERM to &&dwuser;
grant select on SURVERS to &&dwuser;
grant select on TWGBWSES to &&dwuser;
grant select, insert on SHRSAPP to &&dwuser;
grant select, insert on SHRSARJ to &&dwuser;
grant select on SHRSAPP_SEQUENCE to &&dwuser;
grant select on SHRSARJ_SEQUENCE to &&dwuser;

-- The following grants are often used in BAN080. Uncomment lines for the grants you wish to issue:

-- grant select on GORVISA to &&dwuser;
-- grant select on RORSAPR to &&dwuser;
-- grant select on RPRAWRD to &&dwuser;
-- grant select on SGRSACT to &&dwuser;
-- grant select on SHRTTRM to &&dwuser;
-- grant select on SPBPERS to &&dwuser;
-- grant select on SPRHOLD to &&dwuser;
-- grant select on STVACTC to &&dwuser;
-- grant select on STVASTD to &&dwuser;
-- grant select on STVATTS to &&dwuser;
-- grant select on STVHLDD to &&dwuser;


