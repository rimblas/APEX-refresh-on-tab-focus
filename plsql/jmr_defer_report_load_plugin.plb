set define off
alter session set PLSQL_CCFLAGS='OOS_LOGGER:TRUE';
create or replace package body jmr_defer_report_load_plugin
is

--------------------------------------------------------------------------------
--*
--* 
--*
--------------------------------------------------------------------------------
-- CONSTANTS
/**
 * @constant gc_scope_prefix Standard logger package name
 */
gc_scope_prefix constant VARCHAR2(31) := lower($$PLSQL_UNIT) || '.';

-- TYPES
/**
 * @type scope_name_t for logging
 */
subtype scope_name_t is varchar2(60);

procedure log(p_msg in varchar2, p_scope  in varchar2)
is
begin

  $IF $$OOS_LOGGER $THEN
  logger.log(p_msg, p_scope);
  $ELSE
  apex_debug.message(p_scope || ':' || substr(p_msg,1,3000));
  $END

end log;


procedure log_error(p_msg in varchar2, p_scope  in varchar2)
is
begin

  $IF $$LOGGER $THEN
  logger.log_error(p_msg, p_scope);
  $ELSE
  apex_debug.message(p_scope || ': ' || p_msg);
  $END

end log_error;


--------------------------------------------------------------------------------
/**
 * Render the plugin
 * 
 *
 * @example
 * 
 * @issue
 *
 * @author Jorge Rimblas
 * @created May 9, 2020
 * @return
 */
function render (
    p_dynamic_action   in apex_plugin.t_dynamic_action
  , p_plugin           in apex_plugin.t_plugin
)
return apex_plugin.t_dynamic_action_render_result
is
  $IF $$OOS_LOGGER $THEN
  l_scope  logger_logs.scope%type := gc_scope_prefix || 'render';
  $ELSE
  l_scope scope_name_t := gc_scope_prefix || 'render';
  $END

  l_trigger_item   p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
  l_changes_msg    p_plugin.attribute_01%type := p_plugin.attribute_01;
  l_result  apex_plugin.t_dynamic_action_render_result;
begin
  log('BEGIN', l_scope);
  
  l_result.javascript_function := '
  function(){
  var daAction = this.action;
  setTimeout(function() {
      jmr.plugin.deferredUntil1stClick(
      daAction,'
      || apex_javascript.add_value(l_trigger_item, true)
      || apex_javascript.add_value(l_changes_msg, false) || '
      )
  }, 250);
  }';

  log('END', l_scope);
  return l_result;

exception
  when OTHERS then
    log_error('Unhandled Exception', l_scope);
    raise;
end render;



--------------------------------------------------------------------------------

end jmr_defer_report_load_plugin;
/
