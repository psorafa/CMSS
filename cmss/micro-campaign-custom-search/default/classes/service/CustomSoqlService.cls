public with sharing class CustomSoqlService {
	private CustomSearchFilterRequestDto filterRequestDto;

	public CustomSoqlService(CustomSearchFilterRequestDto filterRequestDto) {
		this.filterRequestDto = filterRequestDto;
	}

	public Integer getDataCountFromDbDto() {
		String queryFields = 'Id';
		String query = prepareQuery(queryFields);
		return Search.query(query).size();
	}

	public Set<Id> getAllAccountIdsDbDto() {
		String queryFields = 'Id';
		if (filterRequestDto.objectName.equals('Asset')) {
			queryFields = 'AccountId';
		}

		Set<Id> accountIds = new Set<Id>();
		String query = prepareQuery(queryFields);
		System.debug('query: ' + query);
		List<List<SObject>> soslRecords = Search.query(query);
		System.debug('soslRecords: ' + soslRecords);
		List<SObject> records = soslRecords.get(0);
		System.debug('records: ' + records);
		for (SObject record : records) {
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
		String query = prepareQuery(queryFields);
		System.debug('data query = ' + query);
		return Search.query(query).get(0);
	}

	public void validateQuery() {
		String query = prepareQuery('Id');
		System.debug('validation query = ' + query);
		Search.query(query); // throws exception if query is invalid
	}

	private String prepareQuery(String queryFields) {
		List<String> searchTermValues = this.getBaseQueryValues();
		System.debug('searchTermValues = ' + searchTermValues);
		List<String> customFilterConditionList = new List<String>();
		for (CustomSearchFilterRequestDto.CustomFilterItemDto filterItem : this.filterRequestDto.filterItemList) {
			List<CustomSearchFilterRequestDto.FilterOptionDto> filters = filterItem.filters;
			for (CustomSearchFilterRequestDto.FilterOptionDto filter : filters) {
				if (filter != null) {
					if (isValidSOSLSearchTermType(filterItem.dataType)) {
						searchTermValues.add(filter.value);
					}
					String newCondition = getOperatorToSelectStatement(
						filterItem.fieldName,
						filter.type,
						filter.value,
						filterItem.dataType
					);
					customFilterConditionList.add(newCondition);
				}
			}
		}
		String objectType = this.filterRequestDto.configuration.ObjectType__c;
		String searchTerm = String.join(searchTermValues, ' OR ');
		String baseCondition = this.filterRequestDto.configuration.FilterCondition__c;
		Integer pageSize = this.filterRequestDto.pageSize;
		Integer pageNumber = this.filterRequestDto.pageNumber;

		String query =
			'FIND {' +
			searchTerm +
			'} IN ALL FIELDS RETURNING ' +
			objectType +
			' (' +
			queryFields +
			' WHERE ' +
			baseCondition;

		if (!customFilterConditionList.isEmpty()) {
			query += ' AND ' + String.join(customFilterConditionList, ' AND ');
		}
		query += ' )';
		query += ' LIMIT ' + pageSize;
		System.debug('final query: ' + query);
		return query;
	}

	private Boolean isValidSOSLSearchTermType(String dataType) {
		return dataType == 'Text';
	}

	private List<String> getBaseQueryValues() {
		List<String> values = new List<String>();
		String baseQuery = this.filterRequestDto.configuration.FilterCondition__c;
		System.debug('baseQuery = ' + baseQuery);
		List<String> groups = baseQuery.split('(AND|OR)');
		System.debug('groups = ' + groups);
		for (String groupItem : groups) {
			String clearItem = groupItem.trim();
			if (clearItem.lastIndexOf(':') > 0) {
				//exclude expression like NEXT_N_MONTHS:6
				continue;
			}
			Integer lastSpace = clearItem.lastIndexOf(' ');
			String value = clearItem.substring(lastSpace + 1);
			String clearValue = value.replaceAll('\'', '').replaceAll('%', '*');
			values.add(clearValue);
		}
		return values;
	}

	public static String getQueryFieldsFromFieldSetService(FieldsetService service) {
		List<String> fieldList = service.getFieldsetInfoToSoql();
		String queryFields = String.join(fieldList, ',');

		if (Test.isRunningTest() && fieldList.isEmpty()) {
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
