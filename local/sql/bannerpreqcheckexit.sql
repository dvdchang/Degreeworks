REM
REM Send EXIT as the correlation-id to the DW listener
REM to tell it to stop/exit/quit.
REM
DECLARE
BEGIN
   
   -- Tell the DW dap61 listenter to stop/exit - gracefully
   sfkdwaq.p_kill_preq_server;
   COMMIT;
END;
/
exit
