/**
 * Created by lukas.krbec on 03.06.2022.
 */

({
    close : function(component, event, helper) {
            $A.get("e.force:closeQuickAction").fire();
      	}
});