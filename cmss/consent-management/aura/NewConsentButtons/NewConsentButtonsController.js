({
    doInit :  function(component, event, helper) {
        helper.checkPermissionsInApex({
            objectName : 'Consent__c',
            operation : 'insert'
        }, component);
        helper.checkPermissionsInApex({
            objectName : 'InternalConsent__c',
            operation : 'insert'
        }, component);
    },

    getValueFromLwc : function(component, event, helper) {
        var isClosed = event.getParam('isClosed');
        if (isClosed) {
            component.set("v.showGeneralConsentModal", false);
        }
        var isCreated = event.getParam('isCreated');
        if (isCreated) {
            $A.get('e.force:refreshView').fire();
        }
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
    },
});