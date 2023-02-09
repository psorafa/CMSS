@IsTest
private class DisplayPDFControllerTest {
	private static Account acc;

	static void makeData() {
		User user = TestDataFactory.getUser(new User());
		insert user;
		insert TestDataFactory.getPermissionSetAssignments(user.Id);
		insert TestDataFactory.getNumericalSettings();
		TestDataFactory.defaultCaseOwner = user;
		System.runAs(user) {
			acc = new Account();
			acc.name = 'testAcc';
			insert acc;

			List<MigrationPremiumTypes.PdfTemplateItem> items = new List<MigrationPremiumTypes.PdfTemplateItem>();
			MigrationPremiumTypes.PdfTemplateItem item = new MigrationPremiumTypes.PdfTemplateItem();
			item.title = '123';
			item.value = '123';
			items.add(item);

			Case c1 = TestDataFactory.getCase(new Case(Subject = 'Case1', AccountId = acc.Id));
			c1.Template__c = JSON.serialize(items);
			insert c1;
			Apexpages.currentpage().getparameters().put('id', c1.Id);
			EformsCheckboxTranslation__c eFormCs = new EformsCheckboxTranslation__c();
			eFormCs.Name = '123';
			eFormCs.SyncElemName__c = '123';
			eFormCs.SyncElemValue__c = '123';
			eFormCs.PlaceholderNameValuePair__c = '123';
			insert eFormCs;

			ContentVersion cv = new ContentVersion();
			cv.Description = 'test description';
			cv.PathOnClient = 'test_file.txt';
			cv.Title = 'test file';
			cv.VersionData = Blob.valueOf('test file body');
			insert cv;
		}
	}

	@IsTest
	public static void DisplayPDFControllerTest() {
		makeData();
		DisplayPDFController cntrl = new DisplayPDFController();
		cntrl.displayText = 'text';
	}

	@IsTest
	public static void buildPlaceholderMapTest() {
		//makeData();
		List<MigrationPremiumTypes.PdfTemplateItem> items = new List<MigrationPremiumTypes.PdfTemplateItem>();
		MigrationPremiumTypes.PdfTemplateItem item = new MigrationPremiumTypes.PdfTemplateItem();
		item.title = '123';
		item.value = '123';
		items.add(item);

		Map<String, String> returnMap = DisplayPDFController.buildPlaceholderMap(items);
		System.assertEquals('123', returnMap.get('123'));
	}

	@IsTest
	public static void buildPdfDataTest() {
		//makeData();
		List<MigrationPremiumTypes.PdfTemplateItem> items = new List<MigrationPremiumTypes.PdfTemplateItem>();
		MigrationPremiumTypes.PdfTemplateItem item = new MigrationPremiumTypes.PdfTemplateItem();
		item.title = '123';
		item.value = '123';
		items.add(item);
		ContentVersion cv = new ContentVersion();
		cv.Description = 'test description';
		cv.PathOnClient = 'test_file.txt';
		cv.Title = 'test file';
		cv.VersionData = Blob.valueOf('test file body');
		insert cv;

		Map<String, String> returnMap = DisplayPDFController.buildPlaceholderMap(items);
		String returnString = DisplayPDFController.buildPdfData(cv.VersionData.toString(), returnMap);
		System.assertEquals('test file body', returnString);
	}
}
