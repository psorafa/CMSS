public with sharing class ContactInformationTriggerHandler extends TriggerHandler {
	public static void createContactInformationValue(List<ContactInformation__c> contactInfoList) {
		Map<String, String> countryValueLabelMap = new Map<String, String>();

		Schema.DescribeFieldResult fieldResult = ContactInformation__c.Country__c.getDescribe();
		List<Schema.PicklistEntry> pte = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry pickListVal : pte) {
			countryValueLabelMap.put(pickListVal.getValue(), pickListVal.getLabel());
		}
		for (ContactInformation__c contactInfoItem : contactInfoList) {
			contactInfoItem.Value__c = 'neuvedeno';
			if (contactInfoItem.Type__c == '1') {
				contactInfoItem.Value__c =
					contactInfoItem.Street__c +
					' ' +
					contactInfoItem.HouseNumber__c +
					' ' +
					contactInfoItem.City__c +
					' ' +
					contactInfoItem.PostalCode__c +
					' ' +
					countryValueLabelMap.get(contactInfoItem.Country__c);
			}
			if (contactInfoItem.Type__c == '2') {
				contactInfoItem.Value__c = contactInfoItem.PhoneNumber__c;
			}
			if (contactInfoItem.Type__c == '3') {
				contactInfoItem.Value__c = contactInfoItem.Email__c + ' ' + contactInfoItem.DataBoxNumber__c;
			}
			if (contactInfoItem.Type__c == '4') {
				contactInfoItem.Value__c = contactInfoItem.DataBoxNumber__c;
			}
		}
	}
}
