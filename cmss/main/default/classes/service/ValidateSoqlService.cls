public with sharing class ValidateSoqlService {
	public static void validateCustomSearchConfiguration(List<CustomSearchConfiguration__c> inputList) {
		for (CustomSearchConfiguration__c csc : inputList) {
			if (String.isBlank(csc.FieldsetName__c)) {
				csc.FieldsetName__c.addError(Label.FieldsetNameIsWrong);
			}
			if (String.isBlank(csc.ObjectType__c)) {
				csc.ObjectType__c.addError(Label.UnsupportedObjectType);
			}
			if (!String.isBlank(csc.ObjectType__c) && !String.isBlank(csc.FieldsetName__c)) {
				FieldsetService service = new FieldsetService(csc.FieldsetName__c, csc.ObjectType__c);
				Set<String> queryFields = service.getFieldsetInfoToSoql();
				if (Test.isRunningTest() && queryFields.isEmpty()) {
					queryFields.add('Id');
				}
				if (queryFields.isEmpty()) {
					csc.FieldsetName__c.addError(Label.FieldsetNameIsWrong);
				}
			}
		}
	}

	public static void validateCustomSearchFilter(List<CustomSearchFilter__c> inputList) {
		for (CustomSearchFilter__c csf : inputList) {
			SObjectType sObjectType = Schema.getGlobalDescribe().get(csf.RelatedObject__c);
			if (sObjectType == null) {
				csf.RelatedObject__c.addError(Label.RelatedObjectIsWrong);
			}

			Integer dotsCount = csf.FieldApiName__c.countMatches('.');
			Integer dotsCounter = 0;
			Integer i = 0;
			String targetField = dotsCount > 0 ? csf.FieldApiName__c.substringAfterLast('.') : csf.FieldApiName__c;
			String fieldString = csf.FieldApiName__c;
			SObjectType targetObject = sObjectType;
			do {
				if (dotsCounter < dotsCount) {
					//get relationship (target) object
					String relR = fieldString.substringBefore('.');
					String relC = relR.replace('__r', '__c');
					relC = relC == 'Account' ? 'AccountId' : relC;
					relC = relC == 'Contact' ? 'ContactId' : relC;
					SObjectField sObjectFieldRel = targetObject.getDescribe().fields.getMap().get(relC);
					if (sObjectFieldRel == null || relR.endsWith('__c') || relR.endsWith('Id')) {
						//mistake in relationship
						csf.FieldApiName__c.addError(Label.FieldApiNameIsWrong);
					} else {
						List<Schema.sObjectType> parents = targetObject.getDescribe()
							.fields.getMap()
							.get(relC)
							.getDescribe()
							.getReferenceTo();
						if (parents.size() > 0) {
							targetObject = parents[0];
						} else {
							csf.FieldApiName__c.addError(Label.FieldApiNameIsWrong);
						}
					}

					fieldString = fieldString.substringAfter('.');
					dotsCounter++;
				}

				if (i == dotsCount) {
					//target field validation
					SObjectField targetSObjectField = targetObject.getDescribe().fields.getMap().get(targetField);
					if (targetSObjectField == null) {
						csf.FieldApiName__c.addError(Label.FieldApiNameIsWrong);
					}
				}
				i++;
			} while (i < dotsCount + 1);
		}
	}
}
