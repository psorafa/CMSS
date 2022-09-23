({
    checkPermissionsInApex : function (params, component) {
        var helper = this;
        var action = component.get("c.checkUserCRUD");
        action.setParams(params);
        action.setCallback(this, function(response) {
            helper.processCheckPermissionResult(response, params, component)
        });
        $A.enqueueAction(action);
    },

    processCheckPermissionResult : function (response, params, component) {
        var state = response.getState();
        if (state === "SUCCESS") {
            if (params.objectName == 'Consent__c') {
                component.set('v.hasCreateConsentPermission', response.getReturnValue());
            }
            if (params.objectName == 'InternalConsent__c') {
                component.set('v.hasCreateInternalConsentPermission', response.getReturnValue());
            }
        } else {
            console.log('Unknown error', JSON.stringify(response.getError()));
        }
    }
});