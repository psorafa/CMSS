@IsTest
private class ContactInformationTriggerHandlerTest {
	@IsTest
	static void createContactInformationValueTest() {
		ContactInformation__c contactInfo = TestDataFactory.getContactInformation(new ContactInformation__c());
		ContactInformation__c contactInfo2 = TestDataFactory.getContactInformation(
			new ContactInformation__c(Type__c = '2', PhoneNumber__c = '777556541')
		);

		Test.startTest();
		insert new List<ContactInformation__c>{contactInfo, contactInfo2};
		Test.stopTest();

		List<ContactInformation__c> contactInfoValues = [
			SELECT Value__c
			FROM ContactInformation__c
			WHERE Type__c = '1'
		];
		List<ContactInformation__c> contactInfoPhoneValues = [
			SELECT Value__c
			FROM ContactInformation__c
			WHERE Type__c = '2'
		];

		for (ContactInformation__c cItem : contactInfoValues) {
			String cItemValue = cItem.Value__c;
			System.assertEquals('Street 52 City 100 00 CZ', cItemValue);
		}
		for (ContactInformation__c cItemPhone : contactInfoPhoneValues) {
			String cItemPhoneValue = cItemPhone.Value__c;
			System.assertEquals('777556541', cItemPhoneValue);
		}
	}
	@IsTest
	static void createContactInformationNullValueTest() {
		ContactInformation__c contactInfo = TestDataFactory.getContactInformation(new ContactInformation__c());
		ContactInformation__c contactInfo2 = TestDataFactory.getContactInformation(
			new ContactInformation__c(City__c = null)
		);
		ContactInformation__c contactInfo3 = TestDataFactory.getContactInformation(
			new ContactInformation__c(Type__c = '3', Email__c = 'test@test.com', DataBoxNumber__c = null)
		);

		Test.startTest();
		insert new List<ContactInformation__c>{contactInfo, contactInfo2};
		Test.stopTest();

		List<ContactInformation__c> contactInfoValues = [SELECT Value__c FROM ContactInformation__c];

		for (ContactInformation__c cItem : contactInfoValues) {
			String cItemValue = cItem.Value__c;
			System.assert(!cItemValue.contains('null'));
		}
	}
}
