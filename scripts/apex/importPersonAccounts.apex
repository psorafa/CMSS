Id personAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

String accountJson = '{0}';

Account[] accs = (Account[])JSON.deserialize(accountJson, Account[].class);
for(Account a : accs) {
    a.RecordTypeId = personAccountRtId;
}

upsert accs ExternalId__c;