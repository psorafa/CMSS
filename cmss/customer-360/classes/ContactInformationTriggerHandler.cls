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
				String street = contactInfoItem.Street__c == null ? ' ' : contactInfoItem.Street__c;
				String houseNumber = contactInfoItem.HouseNumber__c == null ? ' ' : contactInfoItem.HouseNumber__c;
				String city = contactInfoItem.City__c == null ? ' ' : contactInfoItem.City__c;
				String postalCode = contactInfoItem.PostalCode__c == null ? ' ' : contactInfoItem.PostalCode__c;
				String country = countryValueLabelMap.get(contactInfoItem.Country__c) == null
					? ''
<<<<<<< HEAD
					: countryValueLabelMap.get(contactInfoItem.Country__c);
=======
					: contactInfoItem.Country__c;
>>>>>>> Contact Information Value fix

				contactInfoItem.Value__c = street + ' ' + houseNumber + ' ' + city + ' ' + postalCode + ' ' + country;
			}
			if (contactInfoItem.Type__c == '2') {
				String phoneNumber = contactInfoItem.PhoneNumber__c == null ? ' ' : contactInfoItem.PhoneNumber__c;
				contactInfoItem.Value__c = phoneNumber;
			}
			if (contactInfoItem.Type__c == '3') {
				String email = contactInfoItem.Email__c == null ? ' ' : contactInfoItem.Email__c;
				String dataBoxNumber = contactInfoItem.DataBoxNumber__c == null
					? ' '
					: contactInfoItem.DataBoxNumber__c;
				contactInfoItem.Value__c = email + ' ' + dataBoxNumber;
			}
			if (contactInfoItem.Type__c == '4') {
				String dataBoxNumber = contactInfoItem.DataBoxNumber__c == null
					? ' '
					: contactInfoItem.DataBoxNumber__c;
				contactInfoItem.Value__c = dataBoxNumber;
			}
		}
	}
}
