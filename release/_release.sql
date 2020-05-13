--
--                             
--  ____            __                   ____    _                   _         
-- |  _ \    ___   / _|   ___   _ __    |  _ \  | |  _   _    __ _  (_)  _ __  
-- | | | |  / _ \ | |_   / _ \ | '__|   | |_) | | | | | | |  / _` | | | | '_ \ 
-- | |_| | |  __/ |  _| |  __/ | |      |  __/  | | | |_| | | (_| | | | | | | |
-- |____/   \___| |_|    \___| |_|      |_|     |_|  \__,_|  \__, | |_| |_| |_|
--                                                           |___/             
--
--
--   NOTES: This plugin requires the package jmr_defer_report_load_plugin to
--   be installed. 
--   See https://rimblas.com/blog/2020/05/move-your-apex-plugin-plsql-code-to-the-database/
--

CLEAR SCREEN

-- Terminate the script on Error during the beginning
whenever sqlerror exit

--  define - Sets the character used to prefix substitution variables
SET define '^'
--  verify off prevents the old/new substitution message
SET verify off
--  feedback - Displays the number of records returned by a script ON=1
SET feedback off
--  timing - Displays the time that commands take to complete
SET timing off
--  display dbms_output messages
SET serveroutput on

define logname                      =''     -- Name of the log file

--  Start The logging
--  =============================================
set termout off
column my_logname new_val logname
select 'release_log_'||sys_context( 'userenv', 'service_name' )|| '_' || to_char(sysdate, 'YYYY-MM-DD_HH24-MI-SS')||'.log' my_logname from dual;
-- good to clear column names when done with them
column my_logname    clear
set termout on
spool ^logname

PRO  ============================   App  Update  ==========================
PRO  == Version: v1.0.0
PRO  ============================= Installation ===========================
PRO

PRO  Log File                 = ^logname

PRO _________________________________________________
PRO . TABLES



PRO _________________________________________________
PRO . VIEW



PRO _________________________________________________
PRO . PACKAGES

PRO .. jmr_defer_report_load_plugin
@../plsql/jmr_defer_report_load_plugin.pls
@../plsql/jmr_defer_report_load_plugin.plb



PRO _________________________________________________
PRO . DML



-- PRO _________________________________________________
-- PRO Deploying demo application

-- @../app/_ins.sql

PRO _________________________________________________
PRO Install your plugin!
PRO ../apex/dynamic_action_plugin_jmr_rimblas_deferreportload.sql
PRO
PRO _________________________________________________
PRO . READY!

spool off

exit
