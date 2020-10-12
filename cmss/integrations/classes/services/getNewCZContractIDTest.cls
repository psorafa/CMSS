@IsTest
private class getNewCZContractIDTest {
	@IsTest
	static void getNewCZContractIDTest() {
		//in Test Class instantiate the custom settings object

		NumericalSeriesSettings__c customSettingsValue = new NumericalSeriesSettings__c();
		//and create the records of the custom settings
		customSettingsValue.ContractNumber__c = 5.0;

		//and insert it in Test class itself.
		insert customSettingsValue;

		Test.startTest();
		Decimal lastIssuedContractNumber = getNewCZContractID.getNewCZContractID();
		Test.stopTest();

		NumericalSeriesSettings__c newIssuedContractNumber = [
			SELECT ContractNumber__c
			FROM NumericalSeriesSettings__c
			LIMIT 1
		];

		System.assertEquals(6, lastIssuedContractNumber);
		System.assert(newIssuedContractNumber != null);
		//System.assertEquals(1, newIssuedContractNumber.size());

		System.assertEquals(6, newIssuedContractNumber.ContractNumber__c);
	}
}
