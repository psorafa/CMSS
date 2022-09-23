public with sharing class CustomSearchController {
	@AuraEnabled(Cacheable=true)
	public static List<CustomFilterItemDto> getCustomFilterMap(String objectType, String productName) {
		CustomFilterService service = new CustomFilterService(objectType, productName);

		return service.getCustomFilterMap();
	}

	@AuraEnabled(Cacheable=true)
	public static List<RecordTypeInfoDto> loadTypeList() {
		RecordTypeService service = new RecordTypeService();
		return service.loadRecordTypes();
	}

	@AuraEnabled(Cacheable=true)
	public static List<UserHierarchyTreeDto> loadUserHierarchyTree(Id userId) {
		if (userId == null) {
			userId = UserInfo.getUserId();
		}
		UserHierarchyTreeService service = new UserHierarchyTreeService(userId);
		return new List<UserHierarchyTreeDto>{ service.loadUserHierarchyTree() };
	}

	@AuraEnabled
	public static Integer countResults(CustomSearchFilterRequestDto dto) {
		try {
			CustomSoqlService service = new CustomSoqlService(dto);
			return service.getDataCountFromDbDto();
		} catch (System.QueryException e) {
			Logger.error('Error in CustomSearchController.searchResults countResults', e);
			throw new AuraHandledException(e.getMessage());
		} catch (Exception e) {
			Logger.error('Error in CustomSearchController.searchResults countResults', e);
			throw new AuraHandledException(Label.SearchCommonError);
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static CustomSearchFilterResponseDto searchResults(CustomSearchFilterRequestDto dto) {
		try {
			CustomSoqlService service = new CustomSoqlService(dto);
			Integer countRecords = service.getDataCountFromDbDto();
			List<SObject> data = service.getDataFromDbDto();
			return new CustomSearchFilterResponseDto(data, countRecords);
		} catch (System.QueryException e) {
			Logger.error('Error in CustomSearchController.searchResults searchResults', e);
			throw new AuraHandledException(e.getMessage());
		} catch (Exception e) {
			Logger.error('Error in CustomSearchController.searchResults searchResults', e);
			throw new AuraHandledException(Label.SearchCommonError);
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static List<Id> getAllAccountId(CustomSearchFilterRequestDto dto) {
		CustomSoqlService service = new CustomSoqlService(dto);
		return new List<Id>(service.getAllAccountIdsDbDto());
	}
	@AuraEnabled(Cacheable=true)
	public static List<CustomSearchConfiguration__c> loadBaseConfigurationList(
		String objectApiName,
		String productName
	) {
		return [
			SELECT
				Id,
				Name,
				Description__c,
				FilterCondition__c,
				FieldsetName__c,
				ObjectType__c,
				ProductType__c,
				OwnerFieldName__c,
				DisplayOrder__c
			FROM CustomSearchConfiguration__c
			WHERE ObjectType__c = :objectApiName AND ProductType__c = :productName AND Active__c = TRUE
			ORDER BY DisplayOrder__c ASC NULLS LAST
		];
	}

	@AuraEnabled
	public static List<FieldsetInfoDto> loadFieldsetDetail(String fieldsetName, String objectName) {
		FieldsetService service = new FieldsetService(fieldsetName, objectName);
		return service.getFieldsetInfo();
	}

	@AuraEnabled
	public static void createMicroCampaign(CreateMicroCampaignDto data) {
		try {
			Database.executeBatch(new CreateMicroCampaignBatch(data));
		} catch (Exception e) {
			Logger.error('Error in micro-campaign creation', e);
			throw new AuraHandledException(
				'Unexpected exception: ' +
				e.getMessage() +
				'; transactionId: ' +
				Logger.getTransactionId()
			);
		} finally {
			Logger.saveLogs();
		}
	}
}
