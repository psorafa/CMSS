public with sharing class getNewCZContractID {
	public static Decimal getNewCZContractID() {
		//From custom settings get Last Issued Contract Number and add 1
		NumericalSeriesSettings__c lastIssuedContractNumber = NumericalSeriesSettings__c.getOrgDefaults();
		if (lastIssuedContractNumber.ContractNumber__c == null) {
			lastIssuedContractNumber.ContractNumber__c = 0;
		}
		lastIssuedContractNumber.ContractNumber__c += 1;
		System.debug('New value in Custom settings ' + lastIssuedContractNumber.ContractNumber__c);

		upsert lastIssuedContractNumber;
		return lastIssuedContractNumber.ContractNumber__c;
	}
}
