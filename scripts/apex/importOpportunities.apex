String opportunitiesJson = '{0}';

Map<String, Id> accountIds = new Map<String, Id>();
for(Account a : [SELECT Id, ExternalId__c FROM Account WHERE ExternalId__c != NULL]) {
    accountIds.put(a.ExternalId__c, a.Id);
}
Map<String, Id> productIds = new Map<String, Id>();
for(Product2 p : [SELECT Id, ExternalId FROM Product2 WHERE ExternalId != NULL]) {
    productIds.put(p.ExternalId, p.Id);
}
Opportunity[] opps = new Opportunity[]{};
Set<String> closedStages = new Set<String>{'5', '6', '7'};
for(Opportunity o : (Opportunity[])JSON.deserialize(opportunitiesJson, Opportunity[].class)) {
    Integer days = Math.round(90 * Math.random()); //random number of days less than 3 months
    System.debug('Opp: ['+o.Name+']['+o.Account+']['+o.Product__r+']');
    opps.add(o);
    if(String.isNotBlank(o.Account.ExternalId__c)) {
        o.AccountId = accountIds.get(o.Account.ExternalId__c);
    }
    if(String.isNotBLank(o.Product__r.ExternalId)) {
        o.Product__c = productIds.get(o.Product__r.ExternalId);
    }
    o.Account = null;
    o.Product__r = null;
    if(closedStages.contains(o.StageName)) {
        o.CloseDate = System.today() - days;
    }
    else {
        o.CloseDate = System.today() + days;
    }
    o.DueDate__c = o.CloseDate + 10;
}
System.debug('Importing ['+opps.size()+'] opps');
if(!opps.isEmpty()) {
    Database.upsert(opps, Opportunity.fields.ExternalId__c, true);
}