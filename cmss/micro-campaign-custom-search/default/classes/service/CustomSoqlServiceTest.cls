@IsTest
private class CustomSoqlServiceTest {
	@TestSetup
	static void beforeTest() {
		Account myAcc = new Account(Name = 'Sportisimo', VatNumber__c = 'CZ6397685965', NACE__c = 'AAA');
		insert myAcc;

		CustomSearchConfiguration__c myCustomSearchConfiguration = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FilterCondition__c = 'Name LIKE \'%s%\' ',
			ObjectType__c = 'Account'
		);
		insert myCustomSearchConfiguration;

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
	static void customSoqlServiceTestGetDataFromDbDto() {
		CustomSearchFilterRequestDto myDto = prepareRequestDto();

		Test.startTest();
		CustomSearchFilterResponseDto my = CustomSearchController.searchResults(myDto);
		Test.stopTest();

		System.assertEquals(1, my.data.size());
	}

	@IsTest
	static void loadAllAccountIdsTest() {
		CustomSearchFilterRequestDto myDto = prepareRequestDto();

		Test.startTest();
		List<Id> ids = CustomSearchController.getAllAccountId(myDto);
		Test.stopTest();

		System.assertEquals(1, ids.size());
	}

	private static CustomSearchFilterRequestDto prepareRequestDto() {
		CustomSearchConfiguration__c myCustomSearchConfiguration = [
				SELECT FieldsetName__c, FilterCondition__c, ObjectType__c
				FROM CustomSearchConfiguration__c
				LIMIT 1
		];

		CustomSearchFilterRequestDto myDto = new CustomSearchFilterRequestDto();
		myDto.configuration = myCustomSearchConfiguration;
		myDto.objectName = 'Account';
		myDto.pageNumber = 1;
		myDto.pageSize = 10;

		CustomSearchFilterRequestDto.CustomFilterItemDto myCustomFilterItemDto = new CustomSearchFilterRequestDto.CustomFilterItemDto();
		List<CustomSearchFilterRequestDto.CustomFilterItemDto> myCustomFilterItemDtoList = new List<CustomSearchFilterRequestDto.CustomFilterItemDto>();

		CustomSearchFilterRequestDto.FilterOptionDto filter1 = new CustomSearchFilterRequestDto.FilterOptionDto();
		filter1.type = 'exact match';
		filter1.value = 'Sportisimo';
		CustomSearchFilterRequestDto.FilterOptionDto filter2 = new CustomSearchFilterRequestDto.FilterOptionDto();
		filter2.type = 'contains';
		filter2.value = 'Sport';

		myCustomFilterItemDto.objectName = 'Account';
		myCustomFilterItemDto.fieldName = 'Name';
		myCustomFilterItemDto.dataType = 'Text';
		myCustomFilterItemDto.filters = new List<CustomSearchFilterRequestDto.FilterOptionDto>{
				filter1, filter2
		};

		myCustomFilterItemDtoList.add(myCustomFilterItemDto);
		myDto.filterItemList = myCustomFilterItemDtoList;
		return myDto;
	}
}
