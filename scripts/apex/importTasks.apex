String assetTasksJson = '{0}';

Map<String, Id> accountIds = new Map<String, Id>();
for(Account a : [SELECT Id, ExternalId__c FROM Account WHERE ExternalId__c != NULL]) {
    accountIds.put(a.ExternalId__c, a.Id);
}
Map<String, Id> assetIds = new Map<String, Id>();
for(Asset a : [SELECT Id, ExternalId__c FROM Asset WHERE ExternalId__c != NULL]) {
    assetIds.put(a.ExternalId__c, a.Id);
}

Task[] tasks = new Task[]{};
for(Task t : (Task[])JSON.deserialize(assetTasksJson, Task[].class)) {
	System.debug('Task: ['+t.Subject+']['+t.WhatId+']['+t.AccountId+']');
	Integer days = Math.round(31 * Math.random()); //random number of days less than 1 month
	if(String.isNotBlank(t.Asset__r.ExternalId__c)) {
		t.Asset__c = assetIds.get(t.Asset__r.ExternalId__c);
		t.Asset__r = null;	//cannot specify both Id and object
    }
	if(String.isNotBlank(t.Account.ExternalId__c)) {
		t.WhatId = t.AccountId;
    }
	//open tasks RND in past
	if(t.IsClosed) {
		t.ActivityDate = (System.today() - days);
		t.UpdateDate__c = t.ActivityDate;
	} else {
		t.ActivityDate = (System.today() + days);
	}
	t.ValidFrom__c = t.ActivityDate - Math.round(7 * Math.random());	//created up to a week before
	t.ValidTo__c = t.ActivityDate;
	//closed tasks RND in future
    tasks.add(t);
}
System.debug('Importing ['+tasks.size()+'] tasks');
if(!tasks.isEmpty()) {
    Database.upsert(tasks, Task.fields.ExternalId__c, true);
}