public with sharing class AssetTriggerHandler extends TriggerHandler {
	private static final Map<String, Set<String>> VALID_STATUSES_BY_RECORD_TYPE_ID = new Map<String, Set<String>>{
    Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId() => new Set<String>{
        '10003','10005','10006'
    },
    Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('BuildingSavings').getRecordTypeId() => new Set<String>{
        '11001','11008'
    },
    Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('PensionProducts').getRecordTypeId() => new Set<String>{
        '2010','2011'
    },
    Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('RiskLifeInsurance').getRecordTypeId() => new Set<String>{
        '4010','4021'
    },
    Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Mortgages').getRecordTypeId() => new Set<String>{
        '7061'
    },
		Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('PMO').getRecordTypeId() => new Set<String>{
			'8001'
		}
	};

	public override void afterInsert() {
		filterAndPairWithOpp(Trigger.new, null);
	}

	public override void afterUpdate() {
		filterAndPairWithOpp(Trigger.new, (Map<Id, Asset>) Trigger.oldMap);
	}

	// ***************************** handlers and helping methods***************************************** //

	private static void filterAndPairWithOpp(List<Asset> newAssetsList, Map<Id, Asset> oldAssetsMap) {

        Set<String> irrelevantProductTypes = new Set<String>{
            '1','2','13','15'
        };

		List<Asset> filteredAssetsList = new List<Asset>();

		for (Asset asset : newAssetsList) {
			if (
				!irrelevantProductTypes.contains(asset.ProductType__c) &&
				String.isNotEmpty(asset.ClosingAgentId__c) &&
				isAssetStatusActive(asset) &&
                (oldAssetsMap == null ||
                !isAssetStatusActive(oldAssetsMap.get(asset.Id))) && //if record is new or just activated
				asset.ProductCloseDate__c >= System.today()-30 &&
				asset.CreatedDate >= System.today()-1
			) {
				filteredAssetsList.add(asset);
			}
		}

		pairOpportunity(filteredAssetsList);
	}

	private static void pairOpportunity(List<Asset> assetsList) {
		Set<Id> clientIds = new Set<Id>();

		for (Asset asset : assetsList) {
			clientIds.add(asset.AccountId);
		}

		Map<Id, Opportunity> oppsToUpsertbyIds = new Map<Id, Opportunity>();

		Set<String> irrelevantCategories = new Set<String>{
			'5', '6', '7'
		};

		List<Opportunity> oppsToCheck = [
			SELECT
				Id, AccountId, Amount, Author__c, Category__c, CloseDate, CreatedDateTime__c, Description, DueDate__c, ExternalId__c,
				Name, OriginalAsset__c, OwnerId, Owner.CommissionAccountNr__c, Probability, ProductType__c, Reason__c, StageName, UpdateDate__c,
				ValidFrom__c, ValidTo__c
			FROM Opportunity
			WHERE AccountId IN :clientIds AND Category__c NOT IN :irrelevantCategories AND IsClosed = false
		];

        Map<Id, Asset> assetRelatedInfoById = new Map<Id, Asset>([
            SELECT Id, ClosingAgentId__r.CommissionAccountNr__c, ProductType__c
            FROM Asset
            WHERE Id in:assetsList
        ]);

        Map<Id,RecordType> recordtypesByIds = new Map<Id,RecordType>([ //can't use schema because we need Description
				SELECT Id, Name, DeveloperName, Description
				FROM RecordType
				WHERE SobjectType = 'Asset'
        ]);

		for (Asset asset : assetsList) {
			List<Opportunity> currentOppsToUpdate = new List<Opportunity>();
			for (Opportunity opp : oppsToCheck) {
				if (opp.AccountId == asset.AccountId &&
					opp.OwnerId == asset.ClosingAgentId__c &&
					asset.ProductCloseDate__c >= opp.ValidFrom__c &&
					opp.ValidTo__c != null &&
					asset.ProductCloseDate__c <= opp.ValidTo__c.addDays(30)
				) {
                    Opportunity foundOpp = addOpportunityInfo(opp, asset, assetRelatedInfoById.get(asset.Id), recordtypesByIds.get(asset.recordTypeId).Description);
					if (foundOpp != null) {
						currentOppsToUpdate.add(foundOpp);
					}
				}
			}
			if (currentOppsToUpdate.size() > 0) { //if opp was found (or more opps were found), add it to the upsert list
				for (Opportunity opp : currentOppsToUpdate) {
					oppsToUpsertbyIds.put(opp.Id, opp);
				}
			} else { //if no opp was paired, we will create a new one
				Opportunity newOpp = addOpportunityInfo(new Opportunity(), asset, assetRelatedInfoById.get(asset.Id), recordtypesByIds.get(asset.recordTypeId).Description);
				if (newOpp != null) {
					oppsToUpsertbyIds.put(newOpp.Id, newOpp);
				}
			}
		}

		List<Opportunity> oppsToUpsert = oppsToUpsertbyIds.values();
		upsert oppsToUpsert;
	}

	private static Opportunity addOpportunityInfo(Opportunity opp, Asset asset, Asset assetRelatedInfo, String recordTypedescription) {
		opp.Reason__c = '3';
		opp.StageName = '7';
		opp.Probability = 100;

		// all other fields in this function are changed only if they don't have any value already
		opp.AccountId = String.isEmpty(opp.AccountId) ? asset.AccountId : opp.AccountId;
		opp.Amount = opp.Amount == null ? getOppAmount(asset) : opp.Amount;
		opp.Category__c = String.isEmpty(opp.Category__c) ? '2' : opp.Category__c;
		opp.CreatedDateTime__c = opp.CreatedDateTime__c == null ? System.now() : opp.CreatedDateTime__c;
		opp.Description = String.isEmpty(opp.Description) ? 'Příležitost automaticky založena při vzniku smlouvy' : opp.Description;
		opp.DueDate__c = opp.DueDate__c == null ? System.today() : opp.DueDate__c;
		List<String> oppNameList = new List<String>{
			recordTypedescription, asset.Name
		};
		opp.Name = String.isEmpty(opp.Name) ? String.join(oppNameList, ' ') : opp.Name;
		opp.OriginalAsset__c = String.isEmpty(opp.OriginalAsset__c) ? asset.Id : opp.OriginalAsset__c;
		opp.ProductType__c = opp.ProductType__c == null ? recordTypedescription : opp.ProductType__c;
		opp.UpdateDate__c = opp.UpdateDate__c == null ? System.now() : opp.UpdateDate__c;
		opp.ValidFrom__c = opp.ValidFrom__c == null ? System.now().addMinutes(-30) : opp.ValidFrom__c;
		opp.ValidTo__c = opp.ValidTo__c == null ? System.now() : opp.ValidTo__c;

		if (String.isEmpty(opp.OwnerId)) {
			if (String.isNotEmpty(asset.ClosingAgentId__c)) {
				opp.OwnerId = asset.ClosingAgentId__c;
			} else {
				return null; //in this case we don't want to pair at all
			}
		}

		if (String.isEmpty(opp.Author__c)) {
			if (String.isNotEmpty(assetRelatedInfo.ClosingAgentId__r.CommissionAccountNr__c)) {
				opp.Author__c = assetRelatedInfo.ClosingAgentId__r.CommissionAccountNr__c;
			} else {
				return null; //in this case we don't want to pair at all
			}
		}

		if (opp.CloseDate == null) {
			if (asset.ProductCloseDate__c != null) {
				opp.CloseDate = asset.ProductCloseDate__c;
			} else {
				opp.CloseDate = System.today();
			}
		}
		return opp;
	}

	private static Double getOppAmount(Asset asset) {
		if (asset.RecordTypeId == Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('BuildingSavings').getRecordTypeId()) {
			return asset.TargetAmount__c;
		} else if (asset.RecordTypeId == Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId()) {
			return asset.CreditAmount__c;
		}
		return asset.LoanAmount__c;
	}

	private static Boolean isAssetStatusActive(Asset asset) {
		if (!VALID_STATUSES_BY_RECORD_TYPE_ID.containsKey(asset.RecordTypeId)) {
            return False;
		}

		Set<String> validStatuses = VALID_STATUSES_BY_RECORD_TYPE_ID.get(asset.RecordTypeId);
		return validStatuses.contains(asset.Status__c);
	}
}