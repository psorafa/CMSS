String assetJson = '{0}';

Map<String, Id> productIds = new Map<String, Id>();
for(Product2 p : [SELECT Id, ExternalId FROM Product2 WHERE ExternalId != NULL]) {
    productIds.put(p.ExternalId, p.Id);
}

Asset[] assets = new Asset[]{};
for(Asset a : (Asset[])JSON.deserialize(assetJson, Asset[].class)) {
    System.debug('Prod: ['+a.ExternalId__c+']');
    if(String.isNotBLank(a.Product2.ExternalId)) {
        a.Product2Id = productIds.get(a.Product2.ExternalId);
    }
    a.Product2 = null;
    assets.add(a);
}
System.debug('Importing ['+assets.size()+'] assets');
if(!assets.isEmpty()) {
    Database.upsert(assets, Asset.fields.ExternalId__c, true);
}