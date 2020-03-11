String opportunitiesJson = '{0}';

Map<String, Id> accountIds = new Map<String, Id>();
for(Account a : [SELECT Id, ExternalId__c FROM Account WHERE ExternalId__c != NULL]) {
    accountIds.put(a.ExternalId__c, a.Id);
}
Map<String, Id> productIds = new Map<String, Id>();
for(Product2 p : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode != NULL]) {
    productIds.put(p.ProductCode, p.Id);
}
Opportunity[] opps = new Opportunity[]{};
for(Opportunity o : (Opportunity[])JSON.deserialize(opportunitiesJson, Opportunity[].class)) {
    System.debug('Opp: ['+o.Name+']['+o.Account+']['+o.Product__r+']');
    opps.add(o);
    if(String.isNotBlank(o.Account.ExternalId__c)) {
        o.AccountId = accountIds.get(o.Account.ExternalId__c);
    }
    if(String.isNotBLank(o.Product__r.ProductCode)) {
        o.Product__c = productIds.get(o.Product__r.ProductCode);
    }
    o.Account = null;
    o.Product__r = null;
}
System.debug('Importing ['+opps.size()+'] opps');
if(!opps.isEmpty()) {
    Database.upsert(opps, Opportunity.fields.Id, true);
}