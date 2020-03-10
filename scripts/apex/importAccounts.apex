Id personAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
Id businessAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();

String personAccounts = '{0}';
String businessAccounts = '{1}';

Account[] accs = new Account[]{};
for(Account a : (Account[])JSON.deserialize(personAccounts, Account[].class)) {
    a.RecordTypeId = personAccountRtId;
    System.debug('Acc: ['+a.ExternalId__c+']');
    accs.add(a);
}
for(Account a : (Account[])JSON.deserialize(businessAccounts, Account[].class)) {
    a.RecordTypeId = businessAccountRtId;
    System.debug('Acc: ['+a.ExternalId__c+']');
    accs.add(a);
}
System.debug('Importing ['+accs.size()+'] Accounts');
if(!accs.isEmpty()) {
    Database.upsert(accs, Account.fields.ExternalId__c, true);
}