public with sharing class AssetTriggerHandler extends TriggerHandler {

	public override void afterInsert() {
		pairOpportunity(Trigger.new);
	}

    // ***************************** handlers and helping methods***************************************** //

	private static void pairOpportunity(List<Asset> assetsList) {
		Set<Id> clientIds = new Set<Id>();

		for (Asset asset : assetsList) {
			clientIds.add(asset.AccountId);
		}

		List<Opportunity> oppsToUpsert = new List<Opportunity>();

		Set<String> irrelevantCategories = new Set<String>{
			'5', '6', '7'
		};

		List<Opportunity> oppsToCheck = [
			SELECT
				Id, AccountId, Amount, Author__c, Category__c, CloseDate, CreatedDateTime__c, Description, DueDate__c, ExternalId__c,
				Name, OriginalAsset__c, OwnerId, Owner.CommissionAccountNr__c, Probability, ProductType__c, Reason__c, StageName, UpdateDate__c,
				ValidFrom__c, ValidTo__c, StateCode__c
			FROM Opportunity
			WHERE AccountId IN :clientIds AND Category__c NOT IN :irrelevantCategories
		];

        Map<Id, Asset> assetRelatedInfoById = new Map<Id, Asset>([
            SELECT Id, ClosingAgentId__r.CommissionAccountNr__c
            FROM Asset
            WHERE Id in:assetsList
        ]);

        List<User> cmssHeadQuarterUsers = [
            SELECT Id, CommissionAccountNr__c
            FROM User 
            WHERE CommissionAccountNr__c = '18002'
        ];

        User cmmsHeadQuartersUser = cmssHeadQuarterUsers.size() > 0 ? cmssHeadQuarterUsers[0] : null;

		for (Asset asset : assetsList) {
			List<Opportunity> currentOppsToUpdate = new List<Opportunity>();
			for (Opportunity opp : oppsToCheck) {
				if (opp.AccountId == asset.AccountId &&
					opp.OwnerId == asset.ClosingAgentId__c &&
					opp.ProductType__c == asset.ProductType__c &&
					asset.ProductCloseDate__c >= opp.ValidFrom__c &&
					asset.ProductCloseDate__c <= opp.ValidTo__c.addDays(30)
					) {
					currentOppsToUpdate.add(addOpportunityInfo(opp, asset, assetRelatedInfoById.get(asset.Id), cmmsHeadQuartersUser));
				}
			}
			if (currentOppsToUpdate.size() > 0) { //if opp was found (or more opps were found), add it to the upsert list
				oppsToUpsert.addAll(currentOppsToUpdate);
			} else { //if no opp was paired, we will create a new one
				Opportunity newOpp = new Opportunity();
				oppsToUpsert.add(addOpportunityInfo(newOpp, asset, assetRelatedInfoById.get(asset.Id), cmmsHeadQuartersUser));
			}
		}

		upsert oppsToUpsert;
	}

	private static Opportunity addOpportunityInfo(Opportunity opp, Asset asset, Asset assetRelatedInfo, User hqUser) {
		opp.Reason__c = '3';
		opp.StageName = '7';
		opp.Probability = 100;

		// all other fields in this function are changed only if they don't have any value already
		opp.AccountId = String.isEmpty(opp.AccountId) ? asset.AccountId : opp.AccountId;
		opp.Amount = opp.Amount == null ? getOppAmount(asset) : opp.Amount;
		opp.Category__c = String.isEmpty(opp.Category__c) ? '2' : opp.Category__c;
		opp.CreatedDateTime__c = opp.CreatedDateTime__c == null ? System.now() : opp.CreatedDateTime__c ;
		opp.Description = String.isEmpty(opp.Description) ? 'Příležitost automaticky založena při vzniku smlouvy' : opp.Description;
		opp.DueDate__c = opp.DueDate__c == null ? System.today() : opp.DueDate__c;
		List<String> oppNameList = new List<String>{
			'Sjednání smlouvy', asset.ProductType__c, asset.Name
		};
		opp.Name = String.isEmpty(opp.Name) ? String.join(oppNameList, ' ') : opp.Name;
		opp.OriginalAsset__c = String.isEmpty(opp.OriginalAsset__c) ? asset.Id : opp.OriginalAsset__c;
		opp.ProductType__c = opp.ProductType__c == null ? asset.ProductType__c : opp.ProductType__c;
		opp.UpdateDate__c = opp.UpdateDate__c == null ? System.now() : opp.UpdateDate__c;
		opp.ValidFrom__c = opp.ValidFrom__c == null ? System.now().addMinutes(-30) : opp.ValidFrom__c;
		opp.ValidTo__c = opp.ValidTo__c == null ? System.now() : opp.ValidTo__c;
		opp.StateCode__c = String.isEmpty(opp.StateCode__c) ? '1' : opp.StateCode__c;

		if (String.isEmpty(opp.OwnerId)) {
			if (String.isNotEmpty(asset.ClosingAgentId__c)) {
				opp.OwnerId = asset.ClosingAgentId__c;
            } else if (hqUser != null){
                opp.OwnerId = hqUser.Id;
            } else {
				opp.OwnerId = asset.OwnerId;
			}
		} 

        if (String.isEmpty(opp.Author__c)){
            if (String.isNotEmpty(assetRelatedInfo.ClosingAgentId__r.CommissionAccountNr__c)){
                opp.Author__c = assetRelatedInfo.ClosingAgentId__r.CommissionAccountNr__c;
            } else {
                opp.Author__c = '18002';
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
}
