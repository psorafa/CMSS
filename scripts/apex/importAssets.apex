String assetJson = '{0}';

Map<String, Id> productIds = new Map<String, Id>();
for(Product2 p : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode != NULL]) {
    productIds.put(p.ProductCode, p.Id);
}

Asset[] assets = new Asset[]{};
for(Asset a : (Asset[])JSON.deserialize(assetJson, Asset[].class)) {
    System.debug('Prod: ['+a.ExternalId__c+']');
    if(String.isNotBLank(a.Product2.ProductCode)) {
        a.Product2Id = productIds.get(a.Product2.ProductCode);
    }
    a.Product2 = null;
    assets.add(a);
}
System.debug('Importing ['+assets.size()+'] assets');
if(!assets.isEmpty()) {
    Database.upsert(assets, Asset.fields.ExternalId__c, true);
}