-- $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/bannergrants2.sql#3 $

-- bannergrants2.sql
--
-- Grant access to Banner objects needed for DegreeWorks pre-requesite checking.
-- You must run this script in the Banner database as sysdba. 

-- NOTE: If your DegreeWorks user is not named dwmgr please 
-- change dwmgr to your username in the line below. 

set pages 0 feed on term on echo on
define dwuser=dwmgr;

grant execute on SFKDWAQ to &&dwuser;
grant execute on SYS.DBMS_AQ to &&dwuser;
BEGIN
DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ALL','BANINST1.DW_PREQ_REQUEST_Q','&&dwuser',TRUE);
DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ALL','BANINST1.DW_PREQ_RESPONSE_Q',' &&dwuser ',TRUE);
DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ALL','BANINST1.DW_DESC_REQUEST_Q',' &&dwuser ',TRUE);
DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ALL','BANINST1.DW_DESC_RESPONSE_Q',' &&dwuser ',TRUE);
END;
/

grant select on BANINST1.aq$DW_PREQ_REQUEST_Qtab  to &&dwuser;
grant select on BANINST1.aq$DW_PREQ_RESPONSE_Qtab to &&dwuser;
grant select on BANINST1.aq$DW_DESC_REQUEST_Qtab  to &&dwuser;
grant select on BANINST1.aq$DW_DESC_RESPONSE_Qtab to &&dwuser;

grant execute on SO_DW_DESC_DESCRIPTION to &&dwuser;
grant execute on SO_DW_DESC_DESCRIPTION_V to &&dwuser;
grant execute on SO_DW_DESC_REFERENCE to &&dwuser;
grant execute on SO_DW_DESC_REFERENCE_V to &&dwuser;
grant execute on SO_DW_DESC_REQUEST to &&dwuser;
grant execute on SO_DW_DESC_RESPONSE to &&dwuser;
grant execute on SO_DW_PREQ_CORRELATION_ID to &&dwuser;
grant execute on SO_DW_PREQ_CRSE_REQUEST to &&dwuser;
grant execute on SO_DW_PREQ_CRSE_REQUEST_V to &&dwuser;
grant execute on SO_DW_PREQ_CRSE_RESPONSE to &&dwuser;
grant execute on SO_DW_PREQ_CRSE_RESPONSE_V to &&dwuser;
grant execute on SO_DW_PREQ_ERROR to &&dwuser;
grant execute on SO_DW_PREQ_ERROR_V to &&dwuser;
grant execute on SO_DW_PREQ_REQUEST to &&dwuser;
grant execute on SO_DW_PREQ_RESPONSE to &&dwuser;
grant execute on SO_DW_PREQ_STUDENT to &&dwuser;
grant execute on SO_DW_PREQ_TERM to &&dwuser;

