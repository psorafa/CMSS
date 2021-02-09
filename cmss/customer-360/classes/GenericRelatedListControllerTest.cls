@IsTest
public class GenericRelatedListControllerTest {

	private static Account acc;

	@TestSetup
	static void makeData() {
		acc = new Account();
		acc.name = 'testAcc';
		insert acc;

		List<ContactInformation__c> contInfos = new List<ContactInformation__c>();
		ContactInformation__c contInf1 = new ContactInformation__c(
			Street__c = 'testStreet1',
			Email__c = 'testEmail1@testemail.com',
			PhoneNumber__c = '777888999',
			Account__c = acc.Id
		);
		ContactInformation__c contInf2 = new ContactInformation__c(
			Street__c = 'testStreet2',
			Email__c = 'testEmail2@testemail.com',
			PhoneNumber__c = '777888000',
			Account__c = acc.Id
		);
		ContactInformation__c contInf3 = new ContactInformation__c(
			Street__c = 'testStreet3',
			Email__c = 'testEmail3@testemail.com',
			PhoneNumber__c = '777888111',
			Account__c = acc.Id
		);

		contInfos.add(contInf1);
		contInfos.add(contInf2);
		contInfos.add(contInf3);

		insert contInfos;
	}

	@IsTest
	public static void testGetDataForDataTable() {
		Account testAcc = acc;
		List<string> listOfFields = new List<string>{
			'Street__c', 'Email__c', 'PhoneNumber__c'
		};
		String myData = GenericRelatedListController.getDataForDataTable(
			'ContactInformation__c',
			listOfFields,
			'Account__c = \'' + testAcc.id + '\''
		);

		List<ContactInformation__c> expectedData = [
			SELECT Street__c, Id, Email__c, PhoneNumber__c
			FROM ContactInformation__c
			WHERE Account__c = :testAcc.id
			WITH SECURITY_ENFORCED
			ORDER BY CreatedDate DESC
		];

		List<SObject> deserializedObjs = (List<SObject>) JSON.deserialize(myData, List<SObject>.class);

		System.assertEquals(expectedData.size(), deserializedObjs.size());
	}

	@isTest
	public static void testGetFieldsDetails() {
		List<String> listOfFields = new List<String>{
			'Id', 'Email__c', 'Street__c'
		};
		List<ColumnDTO> myData = GenericRelatedListController.getFieldsDetails(
			'ContactInformation__c',
			listOfFields
		);
		Map<String, List<String>> expectedData = new Map<String, List<String>>();

		List<string> mail = new List<string>{
			'Email', 'Email__c', 'text'
		};
		List<string> street = new List<string>{
			'Street', 'Street__c', 'text'
		};
		List<string> recordId = new List<string>{
			'Record ID', 'Id', 'text'
		};
		List<string> fieldName = new List<string>{
			'Contact Information Name',
			'Name',
			'url',
			'Name',
			'ContactInformation__c',
			'Id',
			'Id_Link'
		};
		expectedData.put('Email__c', mail);
		expectedData.put('Street__c', street);
		expectedData.put('Id', recordId);
		expectedData.put('fieldName', fieldName);

	}
}
