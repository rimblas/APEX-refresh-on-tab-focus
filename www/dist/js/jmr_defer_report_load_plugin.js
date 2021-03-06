var jmr = jmr || {};

(function(jmr, $, undefined) {
    var C_TABS_CONTAINER = 't-TabsRegion',
        C_TABS_CONTAINER_SEL = '.' + C_TABS_CONTAINER,
        C_TAB_PANEL = 'a-Tabs-panel',
        C_TAB_PANEL_SEL = '.' + C_TAB_PANEL,
        C_TAB_PANEL_PREFIX = "SR_";

 jmr.plugin = {

    /*
     * Used to Defer slow loading reports under a tab until they are visible.
     * Listen for a tab becoming active and then switch the trigger Item
     * and refresh the region
     * This fuction must run after the tabs are initialized. Call too soon and
     * the C_TAB_PANEL class won't be set
     *
     * @example
     * jmr.deferredUntil1stClick("AUDIT_TAB", "P11_TAB_VISIBLE_IND");
     *
     * @author Jorge Rimblas
     * @created February 26, 2019
     * @param Report Region
     * @param Trigger Item: Can be an APEX Item or a callback function
     * @param loadingMessage: displayed while the report loads the first time
     */
    deferredUntil1stClick: function (action, triggerItem, loadingMessage) {
        var reportRegion,
            el$,
            tabsContainer,
            watchRegion,
            loadingMessage_lang = loadingMessage || apex.lang.getMessage("FETCHING_LATEST_CHANGES");

        // We support REGION or JQUERY_SELECTOR
        if (action.affectedElementsType==="REGION") {
            el$ = $("#" + action.affectedRegionId);
            reportRegion = action.affectedRegionId;
        }
        else if (action.affectedElementsType==="JQUERY_SELECTOR") {
            el$ = $(action.affectedElements);
            reportRegion = el$[0].id;
        }
        else {
            apex.debug.error("You must specify a Region or jQuery selector to watch");
        }

        tabsContainer = el$.parents(C_TABS_CONTAINER_SEL);

        apex.debug.message(4, {tabsContainer});
        apex.debug.message(4, {reportRegion});
        apex.debug.message(4, {triggerItem});

        watchRegion = el$.parent(); // assume the parent is the watch region
                                    // meaning the Tab 

        if (watchRegion.hasClass(C_TAB_PANEL)) {
            // Yes, the parent was the Tab, add the Tab refix`
            watchRegion = C_TAB_PANEL_PREFIX + reportRegion;
        }
        else {
            // The Tab is higher up, find it.
            watchRegion = el$.parents(C_TAB_PANEL_SEL)[0].id;
        }

        apex.debug.message(4, {watchRegion});

        apex.debug.message(4, 'Listening for changes on ' + tabsContainer[0].id);

        $(tabsContainer).on("atabsactivate", function(event, ui) {
            var region,
                msgEl$;

            // excluded ui.showing because when the position is remembered showing is undefined
            if (ui.active.href == "#" + watchRegion) {
                if (typeof triggerItem === "function") {
                    // we have a callback, use it
                    apex.debug.message(4, "Your tab is active. Calling cb");
                    triggerItem();
                }
                else {
                    apex.debug.message(4, "Your tab is active. Item " + triggerItem + ":" +$v(triggerItem));
                    if ($v(triggerItem) == "N") {
                        region = apex.region(reportRegion);
                        // switch to visible the first time ONLY and refresh
                        $s(triggerItem, "Y");
                        if (region.type == "InteractiveReport") {
                            msgEl$ = region.element.find(".a-IRR-noDataMsg-text");
                        }
                        else {
                            msgEl$ = region.element.find(".nodatafound");
                        }
                        // if there's a msgElement, place our temporary message
                        msgEl$ && msgEl$.html(loadingMessage_lang);
                        apex.debug.message(4, "Refreshing report");
                        apex.region(reportRegion).refresh();
                    }
                    else {
                        apex.debug.message(4, "The Report content already visible");
                    }
                }
            }
        });
    }
 };
})(jmr, apex.jQuery);

//# sourceMappingURL=jmr_defer_report_load_plugin.js.map
