@IsTest
private class CustomSoqlServiceTest {
	@TestSetup
	static void beforeTest() {
		Account myAcc = new Account(Name = 'Sportisimo', VatNumber__c = 'CZ6397685965', NACE__c = 'AAA');
		insert myAcc;

		CustomSearchConfiguration__c myCustomSearchConfiguration = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FILTERCONDITION__C = 'Name LIKE \'%s%\' ',
			ObjectType__c = 'Account'
		);
		insert myCustomSearchConfiguration;

		CustomSearchFilter__c csf = new CustomSearchFilter__c(
			FieldApiName__c = 'api',
			RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('Text', 'CustomSearchFilter__c'),
			RelatedObject__c = 'Account',
			Filter__c = 'contains'
		);
		insert csf;
	}
	@IsTest
	static void getOperatorToSelectStatementTest() {
		Test.startTest();
		String em = CustomSoqlService.getOperatorToSelectStatement('name', 'exact match', 'sport', 'Text');
		String co = CustomSoqlService.getOperatorToSelectStatement('name', 'contains', 'sport', 'Text');
		String sv = CustomSoqlService.getOperatorToSelectStatement('name', 'start with', 'sport', 'Text');
		String ev = CustomSoqlService.getOperatorToSelectStatement('name', 'end with', 'sport', 'Text');
		String nm = CustomSoqlService.getOperatorToSelectStatement('VatNumber__c', '<=', '1234', 'number');
		System.assertEquals(em, 'name = \'sport\'');
		System.assertEquals(co, 'name LIKE \'%sport%\'');
		System.assertEquals(sv, 'name LIKE \'sport%\'');
		System.assertEquals(ev, 'name LIKE \'%sport\'');
		System.assertEquals(nm, 'VatNumber__c <= 1234');
		Test.stopTest();
	}

	@IsTest
	static void customSoqlServiceTestgetDataFromDbdto() {
		CustomSearchFilterRequestDto mydto = new CustomSearchFilterRequestDto();
		CustomSearchConfiguration__c myCustomSearchConfiguration = [
			SELECT FieldsetName__c, FilterCondition__c, ObjectType__c
			FROM CustomSearchConfiguration__c
			LIMIT 1
		];

		mydto.configuration = myCustomSearchConfiguration;
		mydto.objectName = 'Account';
		List<CustomSearchFilterRequestDto.CustomFilterItemDto> myfilterItemList = new List<CustomSearchFilterRequestDto.CustomFilterItemDto>();
		CustomSearchFilterRequestDto.CustomFilterItemDto myCustomFilterItemDto = new CustomSearchFilterRequestDto.CustomFilterItemDto();
		CustomSearchFilterRequestDto.CustomFilterItemDto myCustomFilterItemDto2 = new CustomSearchFilterRequestDto.CustomFilterItemDto();
		List<CustomSearchFilterRequestDto.CustomFilterItemDto> myCustomFilterItemDtoList = new List<CustomSearchFilterRequestDto.CustomFilterItemDto>();

		myCustomFilterItemDto.objectName = 'Account';
		myCustomFilterItemDto.fieldName = 'Name';
		myCustomFilterItemDto.dataType = 'Text';
		myCustomFilterItemDto.filters = new List<CustomSearchFilterRequestDto.FilterOptionDto>();

		CustomSearchFilterRequestDto.FilterOptionDto filter1 = new CustomSearchFilterRequestDto.FilterOptionDto();
		filter1.type = 'exact match';
		filter1.value = 'Sportisimo';
		CustomSearchFilterRequestDto.FilterOptionDto filter2 = new CustomSearchFilterRequestDto.FilterOptionDto();
		filter2.type = 'contains';
		filter2.value = 'Sport';

		myCustomFilterItemDto.filters.add(filter1);
		myCustomFilterItemDto.filters.add(filter2);

		myCustomFilterItemDtoList.add(myCustomFilterItemDto);
		mydto.filterItemList = myCustomFilterItemDtoList;
		System.debug(mydto);
		Test.startTest();
		CustomSoqlService service = new CustomSoqlService(mydto);
		List<SObject> my = new List<SObject>();
		my = service.getDataFromDbDto();
		Test.stopTest();
		system.System.debug(my);
		System.assertEquals(1, my.size());
	}
}
