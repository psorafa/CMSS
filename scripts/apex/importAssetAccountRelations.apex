String relationJson = '{0}';

Map<String, Id> accountIds = new Map<String, Id>();
for(Account a : [SELECT Id, ExternalId__c FROM Account WHERE ExternalId__c != NULL]) {
    accountIds.put(a.ExternalId__c, a.Id);
}
Map<String, Id> productIds = new Map<String, Id>();
for(Product2 p : [SELECT Id, ExternalId FROM Product2 WHERE ExternalId != NULL]) {
    productIds.put(p.ExternalId, p.Id);
}
Map<String, Id> assetIds = new Map<String, Id>();
for(Asset a : [SELECT Id, ExternalId__c FROM Asset WHERE ExternalId__c != NULL]) {
    assetIds.put(a.ExternalId__c, a.Id);
}

AssetAccountRelation__c[] rels = new AssetAccountRelation__c[]{};
for(AssetAccountRelation__c r : (AssetAccountRelation__c[])JSON.deserialize(relationJson, AssetAccountRelation__c[].class)) {
    System.debug('Rel: ['+r.Asset__r+']['+r.Account__r+']');
    rels.add(r);
    if(String.isNotBlank(r.Account__r.ExternalId__c)) {
        r.Account__c = accountIds.get(r.Account__r.ExternalId__c);
    }
    if(String.isNotBlank(r.Asset__r.ExternalId__c)) {
        r.Asset__c = assetIds.get(r.Asset__r.ExternalId__c);
        r.ProductId__c = productIds.get(r.Asset__r.Product2.ExternalId);
    }
    r.Account__r = null;
    r.Asset__r = null;
}
System.debug('Importing ['+rels.size()+'] rels');
if(!rels.isEmpty()) {
    Database.upsert(rels, AssetAccountRelation__c.fields.ExternalId__c, true);
}