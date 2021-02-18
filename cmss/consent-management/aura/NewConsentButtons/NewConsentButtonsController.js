({
    getValueFromLwc : function(component, event, helper) {
		component.set("v.showGeneralConsentModal", false);
	},
    gotoNewGeneralConsentFlow : function (component, event, helper) {
        component.set('v.showGeneralConsentModal', true);
    },
    gotoNewInternalConsentFlow : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/flow/InternalConsentCreation?accountId=" + component.get("v.recordId") + "&retURL=%2F" + component.get("v.recordId")
        });
        urlEvent.fire();
    }
});