/**
 * Created by konvickaj on 19.05.2022.
 */

({
    doInit: function(component) {
        console.log('som tu: ', component.get("v.recordId"));
        var action = component.get("c.isPortalEnabled");
        action.setCallback(this, function(response) {
            console.log(JSON.stringify(response.getReturnValue()));
            if (response.getReturnValue() && response.getReturnValue().isPortalEnabled) {
                var navurl = response.getReturnValue().urlPrefix + '/eforms?c__migrationLabel=Eformular&c__recId=' + component.get("v.recordId");
                window.location = navurl;
            } else {
                var navService = component.find("navService");
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
            }
        });
        $A.enqueueAction(action);
    }
});