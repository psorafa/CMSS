public with sharing class PortfolioManagementRequestTriggerHandler extends TriggerHandler {

	public override void beforeInsert() {
		PortfolioManagementRequestService.setPortfolioManager(Trigger.new, null);
		setBatchIds(Trigger.new);
	}

	public override void beforeUpdate() {
		PortfolioManagementRequestService.setPortfolioManager(Trigger.new, (Map<Id, PortfolioManagementRequest__c>) Trigger.oldMap);
	}

	public override void afterInsert() {
		PortfolioManagementRequestService.changeCPEClientState(Trigger.new);
	}

	// ***************************** handlers and helping methods***************************************** //

	private static void setBatchIds(List<PortfolioManagementRequest__c> requests) {
		for (PortfolioManagementRequest__c request : requests) {
			String base = UserInfo.getUserId() + Date.today();
			if (requests.size() == 1) {
				base += Math.random();
			} else if (request.BatchID__c == null) {
				request.addError('BatchID__c is required in bulk insert');
			}
			if (request.BatchID__c != null) {
				base += request.BatchID__c;
			}
			Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(base));
			request.BatchID__c = EncodingUtil.base64Encode(hash);
		}
	}
}