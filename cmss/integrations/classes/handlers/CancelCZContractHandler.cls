public class CancelCZContractHandler {
	private ClientZone__c clientZone;

	public CancelCZContractHandler(ClientZone__c clientZone) {
		this.clientZone = clientZone;
	}

	public void handle() {
		updateExistingClientZone();
	}

	private void updateExistingClientZone() {
		ClientZone__c clientZoneToUpdate = new ClientZone__c(
			Id = clientZone.Id,
			Role__c = '8',
			Status__c = '2',
			CancellationDate__c = System.today()
		);
		DmlUtility.updateRecord(clientZoneToUpdate);
	}
}
