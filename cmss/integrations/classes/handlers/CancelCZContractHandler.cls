public class CancelCZContractHandler {
	private ClientZone__c clientZone;

	public CancelCZContractHandler(ClientZone__c clientZone) {
		this.clientZone = clientZone;
	}

	public void handle() {
		updateExistingClientZone();
	}

	private void updateExistingClientZone() {
		clientZone.Role__c = '8';
		clientZone.Status__c = '2';
		DmlUtility.updateRecord(clientZone);
	}
}
