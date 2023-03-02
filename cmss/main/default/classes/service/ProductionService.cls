public with sharing class ProductionService {
	public static void upsertProductionSharing(List<sObject> newProductionList, Map<Id, sObject> oldProductionMap) {
		Map<String, List<String>> fieldNamesMap = new Map<String, List<String>>{
			'TeamManager__c' => new List<String>{
				'CurrentTeamManager__c',
				Schema.Production__Share.rowCause.TeamManager__c
			},
			'RegionManager__c' => new List<String>{
				'CurrentRegionManager__c',
				Schema.Production__Share.rowCause.RegionManager__c
			},
			'SalesNetManager__c' => new List<String>{
				'CurrentSalesNetManager__c',
				Schema.Production__Share.rowCause.SalesNetManager__c
			}
		};
		Map<String, SharingService.sharingSettingsWrap> sharingSettingsMap = new Map<String, SharingService.sharingSettingsWrap>();
		for (String field : fieldNamesMap.keySet()) {
			sharingSettingsMap.put(
				field,
				new SharingService.sharingSettingsWrap(
					'AccessLevel',
					'Read',
					fieldNamesMap.get(field)[1],
					fieldNamesMap.get(field)[0]
				)
			);
		}
		SharingService.upsertSharing(newProductionList, oldProductionMap, sharingSettingsMap, 'ParentId');
	}
}
