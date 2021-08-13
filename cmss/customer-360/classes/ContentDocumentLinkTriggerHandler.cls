public class ContentDocumentLinkTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		setExternalVisibility(Trigger.new);
	}

	// ***************************** handlers and helping methods***************************************** //
	@TestVisible
	private static void setExternalVisibility(List<ContentDocumentLink> links) {
		for (ContentDocumentLink link : links) {
			link.Visibility = 'AllUsers';
		}
	}
}
