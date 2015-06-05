-- ---------------------------------------------------------------------
-- $Id$
-- ---------------------------------------------------------------------
-- Send EXIT as the correlation-id to the DW listener
-- to tell it to stop/exit/quit.
-- ---------------------------------------------------------------------

DECLARE
BEGIN
   
   -- Tell the DW dap62 listenter to stop/exit - gracefully
   sfkdwaq.p_kill_desc_server;
   COMMIT;
END;
/
exit
