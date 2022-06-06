/**
 * Created by konvickaj on 19.05.2022.
 */

({
    doInit : function(component) {
        console.log('som tu: ', component.get("v.recordId"));
        var navService = component.find("navService");
        //var workspaceAPI = component.find("workspace");
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__migrationPremiumWrapper',
            },
            state: {
                "c__recId": component.get("v.recordId"),
                "c__migrationLabel": 'E formulář'
            }
        };
        navService.navigate(pageReference);
        //dont know why getFocusedTabInfo works but getEnclosingTabId dont :( but it works
        /*workspaceAPI.getFocusedTabInfo().then(function(enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId.tabId,
                pageReference: pageReference
            }).then(function(subtabId) {
                console.log("The new subtab ID is:" + subtabId);
            }).catch(function(error) {
                console.error(error);
            });
        });*/
    }

});