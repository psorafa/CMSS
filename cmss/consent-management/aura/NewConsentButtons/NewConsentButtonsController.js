({
    gotoNewGeneralConsentFlow : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/flow/GeneralConsentCreation?accountId=" + component.get("v.recordId") + "&retURL=%2F" + component.get("v.recordId")
        });
        urlEvent.fire();
    },

    gotoNewInternalConsentFlow : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/flow/InternalConsentCreation?accountId=" + component.get("v.recordId") + "&retURL=%2F" + component.get("v.recordId")
        });
        urlEvent.fire();
    }
});