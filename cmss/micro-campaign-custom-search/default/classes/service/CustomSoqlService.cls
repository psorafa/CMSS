public with sharing class CustomSoqlService {
	private CustomSearchFilterRequestDto filterRequestDto;

	public CustomSoqlService(CustomSearchFilterRequestDto filterRequestDto) {
		this.filterRequestDto = filterRequestDto;
	}

	public Integer getDataCountFromDbDto() {
		String queryFields = 'COUNT()';
		String query = prepareQuery(queryFields);
		System.debug('query: ' + query);
		return Database.countQuery(query);
	}

	public Set<Id> getAllAccountIdsDbDto() {
		String queryFields = 'Id';
		if (filterRequestDto.objectName.equals('Asset')) {
			queryFields = 'AccountId';
		}

		Set<Id> accountIds = new Set<Id>();
		String query = prepareQuery(queryFields);
		for (SObject record : Database.query(query)) {
			Id accountId = (Id) record.get(queryFields);
			accountIds.add(accountId);
		}
		return accountIds;
	}

	public List<SObject> getDataFromDbDto() {
		FieldsetService service = new FieldsetService(
			this.filterRequestDto.configuration.FieldsetName__c,
			this.filterRequestDto.objectName
		);

		String queryFields = getQueryFieldsFromFieldSetService(service);
		String query =
			prepareQuery(queryFields) +
			' LIMIT ' +
			this.filterRequestDto.pageSize +
			' OFFSET ' +
			this.filterRequestDto.pageSize * (this.filterRequestDto.pageNumber - 1);
		System.debug('data query = ' + query);
		return Database.query(query);
	}

	private String prepareQuery(String queryFields) {
		List<String> customFilters = new List<String>();
		for (CustomSearchFilterRequestDto.CustomFilterItemDto filterItem : this.filterRequestDto.filterItemList) {
			List<CustomSearchFilterRequestDto.FilterOptionDto> filters = filterItem.filters;
			if (filters != null && !filters.isEmpty()) {
				for (CustomSearchFilterRequestDto.FilterOptionDto filter : filters) {
					if (filter != null) {
						String newCondition = getOperatorToSelectStatement(
							filterItem.fieldName,
							filter.type,
							filter.value,
							filterItem.dataType
						);
						customFilters.add(newCondition);
					}
				}
			}
		}
		String customFilterString = String.join(customFilters, ' AND ');
		String baseQuery =
			'SELECT ' +
			queryFields +
			' FROM ' +
			this.filterRequestDto.configuration.ObjectType__c +
			' WHERE ' +
			this.filterRequestDto.configuration.FilterCondition__c;

		if(!customFilters.isEmpty()) {
			return baseQuery + ' AND ' + customFilterString;
		}
		return baseQuery;
	}

	private String getQueryFieldsFromFieldSetService(FieldsetService service) {

		Set<String> fieldList = service.getFieldsetInfoToSoql();
		if (this.filterRequestDto.objectName.equals('Asset')) {
			fieldList.add('AccountId');
		}
		String queryFields = String.join(fieldList, ',');

		if (Test.isRunningTest() && queryFields.length() == 0) {
			queryFields = 'Id ';
		}

		return queryFields;
	}

	public static String getOperatorToSelectStatement(
		String fieldName,
		String inboundOperator,
		String filterValue,
		String dataType
	) {
		switch on inboundOperator {
			when 'exact match' {
				return dataType == 'Text' ? fieldName + ' = \'' + filterValue + '\'' : fieldName + ' = ' + filterValue;
			}
			when 'contains' {
				return fieldName + ' LIKE \'%' + filterValue + '%\'';
			}
			when 'start with' {
				return fieldName + ' LIKE \'' + filterValue + '%\'';
			}
			when 'end with' {
				return fieldName + ' LIKE \'%' + filterValue + '\'';
			}
			when else {
				return dataType == 'Text'
					? fieldName + ' ' + inboundOperator + ' \'' + filterValue + '\''
					: fieldName + ' ' + inboundOperator + ' ' + filterValue;
			}
		}
	}
}
