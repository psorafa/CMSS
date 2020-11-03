public class ConsolidationResultTriggerHandler extends TriggerHandler {

	public override void afterInsert() {
		handleConsolidation(Trigger.new);
	}


	// ***************************** handlers and helping methods***************************************** //

	@TestVisible
	private static void handleConsolidation(List<ConsolidationResult__c> consolidationResults) {
		AccountConsolidationUtility consolidationUtility = new AccountConsolidationUtility(consolidationResults);
		consolidationUtility.process();
	}
}