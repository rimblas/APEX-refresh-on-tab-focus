create or replace package jmr_defer_report_load_plugin
is

--------------------------------------------------------------------------------
--*
--* 
--*
--------------------------------------------------------------------------------



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
return apex_plugin.t_dynamic_action_render_result;


--------------------------------------------------------------------------------

end jmr_defer_report_load_plugin;
/
