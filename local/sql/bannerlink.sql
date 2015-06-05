--  ******************************************************************** 
--  $Id: //Tuxedo/RELEASE/Product/sis_Banner/server/sql/bannerlink.sql#1 $
--
--         Banner Data Base link for DegreeWorks
--         SunGard Higher Education            
--
--  This sql command file creates a link to the Banner database
--  from the DegreeWorks database. The following substitution 
--  variables must be provided by the start command:
--
--      &&1     - The Banner database service
--      &&2     - The Banner user logon
--      &&3     - The Banner user's password
--
-- Syntax is: (where xx is the VPD code)
-- sqlplus dwschema_xx/tuxedo @bannerlinks.sql BANDB dwmgr_xx u_pick_it
--  ******************************************************************** 

whenever oserror exit 1;
whenever sqlerror continue;

drop database link &&1;

create database link &&1
  connect to &&2 identified by "&3"
  using '&&1';

whenever sqlerror exit sql.sqlcode;

create or replace synonym spriden for saturn.spriden@&&1;
create or replace synonym sobcact for saturn.sobcact@&&1;
create or replace synonym sorlcur for saturn.sorlcur@&&1;
create or replace synonym sorlfos for saturn.sorlfos@&&1;
create or replace public synonym f_class_calc_fnc for baninst1.f_class_calc_fnc@&&1;

exit
