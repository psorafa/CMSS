/**
 * In lightning flows used like last component.
 * Action: openRecord = shows a salesforce record to a user
 * and therefore end of flow dialog.
 *
 * @author Robert Srna
 */
({
	doInit: function(component, event, helper) {
		console.log('doInit');
		$A.enqueueAction(action);
	},

	invoke: function(component, event, helper) {
		console.log('invoke');

		var helperAction = component.get('v.helperAction');
		console.log('helperAction=' + helperAction);

		if (helperAction == 'exit') {
			var a = component.get('c.exitAction');
			$A.enqueueAction(a);
		} else if (helperAction == 'openRecord') {
			var a = component.get('c.openRecord');
			$A.enqueueAction(a);
		}
	},

	exitAction: function(component, event, helper) {
		console.log('exitAction enter');
		window.open('www.seznam.cz', '_top');
	},

	openRecord: function(component, event, helper) {
		// Get the record ID attribute
		var record = component.get('v.openRecordId');

		/* toto je spravny kod, ale kvuli chybe zde redirect nefunguje
         * https://success.salesforce.com/issues_view?id=a1p3A0000019QSOQA2
   // Get the Lightning event that opens a record in a new tab
   var redirect = $A.get("e.force:navigateToSObject");
   
   // Pass the record ID to the event
   redirect.setParams({
      "recordId": record
   });
        
   console.log('before fire');     
   // Open the record
   redirect.fire();
    
    console.log('record:' + component.get("v.recordId"));
    console.log('redirect:' + redirect);
        console.log('muj konec');
        
*/

		/* toto byl pokus a asi stejny problem jako u navigateToSObject
        var eUrl= $A.get("e.force:navigateToURL");
    eUrl.setParams({
      "url": '/'+record 
    });
    eUrl.fire();
*/

		//window.open('https://srna-dev-ed--c.eu15.visual.force.com/'+record,'_top');
		//window.open('/'+record,'_top');
		window.open('/lightning/r/' + record + '/view', '_top');
	}
});
