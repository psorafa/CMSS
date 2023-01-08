@IsTest
public class EDocumentControllerTest {
	@TestSetup
	static void setup() {
		insert TestDataFactory.getIntegrationSettings();

		User u = TestDataFactory.getUserWithProfile(new User(), 'Standard User');
		insert u;

		EDocumentControllerTest.addPermSet();
	}

	@future
	private static void addPermSet() {
		List<User> users = [SELECT Id FROM User WHERE Alias = 'tstU'];
		List<PermissionSet> ps = [SELECT Id, Name FROM PermissionSet WHERE Name = 'CMSS_User'];
		insert new PermissionSetAssignment(AssigneeId = users[0].id, PermissionSetId = ps[0].Id);
	}

	@IsTest
	static void testEDocumentController() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			null,
			new Map<String, String>{
				'GetDocumentBySBIdRequest' => '<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:GetDocumentBySBIdResponse xmlns:ns3=\"http://service.cmss.cz/edocument/EDocumentService/v05\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:eDocumentData>JVBERi0xLjQNJeLjz9MNCjEgMCBvYmoNPDwvTWFya0luZm88PC9NYXJrZWQgdHJ1ZT4+L01ldGFkYXRhIDE4IDAgUi9PdXRwdXRJbnRlbnRzWzw8L0Rlc3RPdXRwdXRQcm9maWxlIDIxIDAgUi9PdXRwdXRDb25kaX</ns3:eDocumentData></ns3:responseBody></ns3:GetDocumentBySBIdResponse></soapenv:Body></soapenv:Envelope>'
			},
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		User u = [SELECT Id FROM User WHERE Alias = 'tstU'];

		Task t = TestDataFactory.getTask(new Task());
		t.OwnerId = u.Id;
		t.LetterId__c = '123';
		t.LetterType__c = 'A003';
		insert t;

		EDocumentController controller;
		Test.startTest();
		System.runAs(u) {
			ApexPages.currentPage().getParameters().put('recordId', t.Id);
			controller = new EDocumentController(null);
			controller.loadDocument();
		}
		Test.stopTest();

		System.assert(controller.isError == false);
		System.assert(controller.showPDF == true);
		System.assert(controller.base64Data.startsWith('JVBERi0xLjQN'));

		Access_Log__c log = [SELECT Id, TaskLetterId__c, TaskLetterType__c, TaskId__c FROM Access_Log__c LIMIT 1];
		System.assert(log != null);
	}

	@IsTest
	static void testEDocumentControllerError() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			null,
			new Map<String, String>{
				'GetDocumentBySBIdRequest' => '<soapenv:Envelope xmlns:soapenv=http://schemas.xmlsoap.org/soap/envelope/> <soapenv:Body> <soapenv:Fault> <faultcode>soapenv:Server</faultcode> <faultstring>EDocument with pressId:4171a459-9655-415c-afb6-0351a78e9c1 not found!</faultstring> <detail> <ns2:CMSSServiceFaultInfo xmlns:ns2=http://service.cmss.cz/common/CommonMessage/v01 xmlns:ns3=http://service.cmss.cz/edocument/EDocumentService/v05> <ns2:errorDetail/> <ns2:faultHeader> <ns2:conversationIdName>adf</ns2:conversationIdName> <ns2:conversationIdValue>afd</ns2:conversationIdValue> <ns2:correlationId>adf</ns2:correlationId> <ns2:messageId>adfafs</ns2:messageId> <ns2:physicalSource>adfa</ns2:physicalSource> <ns2:sourceSystem>afdafd</ns2:sourceSystem> <ns2:targetSystem>asdf</ns2:targetSystem> <ns2:timestamp>2021-09-22T08:50:43.969+02:00</ns2:timestamp> <ns2:userId>asdf</ns2:userId> </ns2:faultHeader> <ns2:message>EDocument not found!</ns2:message> <ns2:system>eRMS</ns2:system> </ns2:CMSSServiceFaultInfo> </detail> </soapenv:Fault> </soapenv:Body> </soapenv:Envelope>'
			},
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		User u = [SELECT Id FROM User WHERE Alias = 'tstU'];

		Task t = TestDataFactory.getTask(new Task());
		t.OwnerId = u.Id;
		t.LetterId__c = '123';
		t.LetterType__c = 'A003';
		insert t;

		EDocumentController controller;
		Test.startTest();
		System.runAs(u) {
			ApexPages.currentPage().getParameters().put('recordId', t.Id);
			controller = new EDocumentController(null);
			controller.loadDocument();
		}
		Test.stopTest();

		System.assert(controller.isError == true);
		System.assert(controller.showPDF == false);
		System.assert(controller.base64Data == null);
	}

	@IsTest
	static void testCreateAccessLogRecord() {
		Test.startTest();
		new EDocumentController(null).createAccessLogRecord('letterId', 'A003', 'taskId');
		Test.stopTest();

		Access_Log__c log = [SELECT Id, TaskLetterId__c, TaskLetterType__c, TaskId__c FROM Access_Log__c LIMIT 1];

		System.assertEquals('letterId', log.TaskLetterId__c);
		System.assertEquals('A003', log.TaskLetterType__c);
		System.assertEquals('taskId', log.TaskId__c);
	}
}
