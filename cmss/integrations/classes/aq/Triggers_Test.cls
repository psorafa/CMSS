@IsTest
private class Triggers_Test {

	@IsTest
	static void testAccountTrigger() {
		Account a = TestDataFactory.getAccount();
		insert a;
		a.Name = 'another name';
		update a;
		delete a;
	}

	@IsTest
	static void testAccountRelationTrigger() {
		AccountRelation__c a = TestDataFactory.getAccountRelation(null, null);
		insert a;
		a.RelationType__c = '0';
		update a;
		delete a;
	}

	@IsTest
	static void testClientZoneTrigger() {
		ClientZone__c z = TestDataFactory.getClientZone(null);
		insert z;
		z.AgreementDate__c = Date.today();
		update z;
		delete z;
	}

	@IsTest
	static void testOpportunityTrigger() {
		Opportunity o = TestDataFactory.getOpportunity();
		insert o;
		o.Name = 'another name';
		update o;
		delete o;
	}

	@IsTest
	static void testTaskTrigger() {
		Task t = TestDataFactory.getTask(new Task());
		insert t;
		t.Subject = 'another subject';
		update t;
		delete t;
	}
}