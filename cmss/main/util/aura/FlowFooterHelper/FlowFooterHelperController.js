/**
 * In lightning flows used instead of standard footer.
 * You see custom buttons for Save and Cancel.
 *
 * Based on
 * https://success.salesforce.com/ideaView?id=08730000000keEFAAY
 * @author Robert Srna
 */

({
	init: function(cmp, event, helper) {
		var labelValue = $A.get('{!$Label.c.Save}');
		cmp.set('v.saveLabel', labelValue);
		labelValue = $A.get('{!$Label.c.Cancel}');
		cmp.set('v.cancelLabel', labelValue);

		console.log('log init');
	},

	invoke: function(component, event, helper) {
		console.log('invoke');
	},

	onCancel: function(cmp, event, helper) {
		console.log('onCancel');
		cmp.set('v.pressedButton', 'cancel');

		var actionClicked = event.getSource().getLocalId();
		// Fire that action
		var navigate = cmp.get('v.navigateFlow');
		navigate(actionClicked);
	},

	onSave: function(cmp, event, helper) {
		console.log('onSave');
		cmp.set('v.pressedButton', 'save');

		var actionClicked = event.getSource().getLocalId();
		// Fire that action
		var navigate = cmp.get('v.navigateFlow');
		navigate(actionClicked);
	}
});
