global with sharing class OpportunitySOAP {

	webService static String createOpportunity(
		Integer customerGlobalId,
		String describe,
		String subject,
		Integer state,
		Integer stateReason,
		Integer Result,
		String campaign_id,
		String author,
		String statusmanager,
		Date valid_from,
		Date valid_to,
		Integer Category,
		String contract_no,
		Date delegated_date
	) {
		return MockServicesUtil.generateUUID();
	}

	webService static void updateOpportunity(
		String opportunity_id_CRM_GUID,
		Integer customerGlobalId,
		String describe,
		String subject,
		Integer state,
		Integer stateReason,
		Integer Result,
		String lead,
		String campaign_id,
		String author,
		String statusmanager,
		Date valid_from,
		Date valid_to,
		Integer Category,
		String contract_no,
		Date delegated_date
	) {

	}

}