@IsTest
public class EventTriggerHandlerTest {
	@IsTest
	static void updateAccountDateFields() {
		Account acc = TestDataFactory.getPersonAccount(
			new Account(
				FirstName = 'Larisa',
				LastName = 'Larisa',
				LastInteractionDate__c = null,
				OpenedActivityDate__c = null
			)
		);
		insert acc;
		Test.startTest();
		Event event = new Event(
			WhatId = acc.Id,
			StartDateTime = system.today() - 6,
			EndDateTime = system.today() - 5,
			Subject = 'Call'
		);
		insert event;
		Test.stopTest();
		Account account = [SELECT Id, LastInteractionDate__c, OpenedActivityDate__c FROM Account WHERE Id = :acc.Id];
		event = [SELECT ActivityDate, EndDateTime FROM Event WHERE Id = :event.Id];

		System.assertEquals(account.LastInteractionDate__c, Date.valueOf(event.EndDateTime));
		System.assertEquals(account.OpenedActivityDate__c, event.ActivityDate);
	}

	@IsTest
	static void insertTest() {
		Account account = TestDataFactory.getPersonAccount(
			new Account(FirstName = 'Ada', LastName = 'Larkin', Birthdate__c = Date.newInstance(1980, 1, 1))
		);
		insert account;
		account = [SELECT PersonContactId FROM Account WHERE Id = :account.Id];

		Test.startTest();
		Event event = new Event(
			WhoId = account.PersonContactId,
			StartDateTime = system.today(),
			EndDateTime = system.today() + 5,
			Subject = 'Vader Bday Party'
		);
		insert event;
		Test.stopTest();

		Event eventAfterInsert = [SELECT AccountAlias__c FROM Event WHERE Subject = 'Vader Bday Party' LIMIT 1];
		List<EventSync__c> eventSycs = [
			SELECT Id, GoogleEventId__c, SFEventId__c, ChangeFromGoogle__c, IsNew__c, IsDeleted__c
			FROM EventSync__c
		];

		System.assertEquals('LarAda_80', eventAfterInsert.AccountAlias__c);
		System.assertEquals(1, eventSycs.size());
		System.assertEquals(null, eventSycs[0].GoogleEventId__c);
		System.assertEquals(event.Id, eventSycs[0].SFEventId__c);
		System.assertEquals(false, eventSycs[0].ChangeFromGoogle__c);
		System.assertEquals(true, eventSycs[0].IsNew__c);
		System.assertEquals(false, eventSycs[0].IsDeleted__c);
	}

	@IsTest
	static void updateTest() {
		Account account = TestDataFactory.getPersonAccount(
			new Account(FirstName = 'Lone', LastName = 'Starr', Birthdate__c = Date.newInstance(1980, 1, 1))
		);
		insert account;
		account = [SELECT PersonContactId FROM Account WHERE Id = :account.Id];
		Event event = new Event(
			WhoId = null,
			StartDateTime = system.today(),
			EndDateTime = system.today() + 5,
			Subject = 'Claim the Schwartz',
			GoogleId__c = '1A2B3C4D5E6'
		);
		insert event;

		Test.startTest();
		event.WhoId = account.PersonContactId;
		event.Subject = 'Just a Plain Yogurt';
		update event;
		Test.stopTest();

		Event eventAfterInsert = [SELECT AccountAlias__c FROM Event WHERE Subject = 'Just a Plain Yogurt' LIMIT 1];
		List<EventSync__c> eventSycs = [
			SELECT Id, GoogleEventId__c, SFEventId__c, ChangeFromGoogle__c, IsNew__c, IsDeleted__c
			FROM EventSync__c
			WHERE GoogleEventId__c = '1A2B3C4D5E6'
		];

		System.assertEquals('StaLon_80', eventAfterInsert.AccountAlias__c);
		System.assertEquals(1, eventSycs.size());
		System.assertEquals(event.Id, eventSycs[0].SFEventId__c);
		System.assertEquals(false, eventSycs[0].ChangeFromGoogle__c);
		System.assertEquals(false, eventSycs[0].IsNew__c);
		System.assertEquals(false, eventSycs[0].IsDeleted__c);
	}
}
