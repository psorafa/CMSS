String relationJson = '{0}';

Map<String, Id> accountIds = new Map<String, Id>();
for(Account a : [SELECT Id, ExternalId__c FROM Account WHERE ExternalId__c != NULL]) {
    accountIds.put(a.ExternalId__c, a.Id);
}

AccountRelation__c[] rels = new AccountRelation__c[]{};
for(AccountRelation__c r : (AccountRelation__c[])JSON.deserialize(relationJson, AccountRelation__c[].class)) {
    System.debug('Rel: ['+r.RelatedAccount__r+']['+r.Account__r+']');
    rels.add(r);
    if(String.isNotBlank(r.Account__r.ExternalId__c)) {
        r.Account__c = accountIds.get(r.Account__r.ExternalId__c);
    }
    if(String.isNotBlank(r.RelatedAccount__r.ExternalId__c)) {
        r.RelatedAccount__c = accountIds.get(r.RelatedAccount__r.ExternalId__c);
    }
    r.Account__r = null;
    r.RelatedAccount__r = null;
}
System.debug('Importing ['+rels.size()+'] rels');
if(!rels.isEmpty()) {
    Database.upsert(rels, AccountRelation__c.fields.ExternalId__c, true);
}