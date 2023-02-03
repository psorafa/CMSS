public with sharing class RecordTypeService {
	private static final String BASE_64_MAP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	public RecordTypeService() {
	}

	public List<RecordTypeInfoDto> loadRecordTypes() {
		List<RecordTypeInfoDto> recordTypeInfoList = new List<RecordTypeInfoDto>();
		SObjectField type = CustomSearchConfiguration__c.ProductType__c;
		Map<String, List<String>> recordTypeByObjectMap = getDependentPicklistValues(type);
		Map<String, PicklistEntry> picklistEntriesByStrings = getPicklistEntryMap(type);
		for (String objectName : recordTypeByObjectMap.keySet()) {
			List<String> recordTypeList = recordTypeByObjectMap.get(objectName);
			for (String recordType : recordTypeList) {
				PicklistEntry picklistEntry = picklistEntriesByStrings.get(recordType);
				RecordTypeInfoDto item = new RecordTypeInfoDto();
				item.label = picklistEntry.getLabel();
				item.value = recordType;
				item.objectType = objectName;
				recordTypeInfoList.add(item);
			}
		}
		return recordTypeInfoList;
	}

	public Map<String, PicklistEntry> getPicklistEntryMap(SObjectField field) {
		List<PicklistEntry> picklistEntries = field.getDescribe().getPicklistValues();
		Map<String, PicklistEntry> picklistEntryMap = new Map<String, PicklistEntry>();
		for (PicklistEntry picklistEntry : picklistEntries) {
			picklistEntryMap.put(picklistEntry.getValue(), picklistEntry);
		}
		return picklistEntryMap;
	}

	public Map<String, List<String>> getDependentPicklistValues(SObjectField dependToken) {
		Schema.DescribeFieldResult depend = dependToken.getDescribe();
		Schema.SObjectField controlToken = depend.getController();
		if (controlToken == null) {
			return new Map<String, List<String>>();
		}

		Schema.DescribeFieldResult control = controlToken.getDescribe();
		List<Schema.PicklistEntry> controlEntries;
		if (control.getType() != Schema.DisplayType.BOOLEAN) {
			controlEntries = control.getPicklistValues();
		}

		Map<String, List<String>> dependentPicklistValues = new Map<String, List<String>>();
		for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
			Object validFrom = getEntryValidFrom(entry);
			if (entry.isActive() && String.isNotBlank((String) validFrom)) {
				List<String> base64chars = ((String) validFrom).split('');
				for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
					Object controlValue = (controlEntries == null
						? (Object) (index == 1)
						: (Object) (controlEntries[index].isActive() ? controlEntries[index].getValue() : null));
					Integer bitIndex = index / 6;
					if (bitIndex > base64chars.size() - 1) {
						break;
					}
					Integer bitShift = 5 - Math.mod(index, 6);
					if (controlValue == null || (BASE_64_MAP.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0) {
						continue;
					}
					if (!dependentPicklistValues.containsKey((String) controlValue)) {
						dependentPicklistValues.put((String) controlValue, new List<String>());
					}

					dependentPicklistValues.get((String) controlValue).add(entry.getValue());
				}
			} else if (entry.isActive()) {
				if (!dependentPicklistValues.containsKey('PortfolioManagementRequest__c')) {
					dependentPicklistValues.put('PortfolioManagementRequest__c', new List<String>());
				}
				dependentPicklistValues.get('PortfolioManagementRequest__c').add(entry.getValue());
			}
		}
		return dependentPicklistValues;
	}

	private Object getEntryValidFrom(PicklistEntry entry) {
		String entryJson = JSON.serialize(entry);
		Map<String, Object> entryMap = (Map<String, Object>) JSON.deserializeUntyped(entryJson);
		return entryMap.get('validFor');
	}
}
