global with sharing class SOAPServices {

	webService static String createAccount(CreateAccountRequest request) {
		return generateRandomString(18);
	}

	webService static void updateCZ(
		String clientzone_id_CRM_GUID,
		String login,
		String phoneno,
		String email,
		Integer clientzone,
		Date signdate,
		Date agreementdate,
		Integer statuscode
	) {

	}

	webService static String createCZContract(
		String name,
		String login,
		String phoneno,
		String email,
		String clientzone,
		String closedby,
		Date signdate,
		String lead_globalid,
		String account_globalid,
		String CZ_MCSB_GUID,
		String representing_client_id,
		String representing_client2_id,
		String represented_relation_role,
		String represented_relation2_role,
		Date validto,
		String relation_MCSB_GUID
	) {
		return generateRandomString(18);
	}

	webService static void activateCZContractRelation(
		String clientzone_id_CRM_GUID,
		Integer amendment_no
	) {

	}

	webService static void signCZContractRelation(
		String clientzone_id_CRM_GUID,
		String representing_client_id,
		Datetime sign_date,
		Integer amendment_no
	) {

	}

	webService static Integer getNewCZContractID() {
		return (Integer) (Math.random() * 100000);
	}

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
		return generateUUID();
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

	webService static void changeCZContractRelations(
		String clientzone_id_CRM_GUID,
		String closedby,
		Integer Amendment_no,
		String representing_client_id,
		Date validto,
		String Relation_MCSB_GUID,
		Integer represented_relation_role
	) {

	}

	webService static String createActivity(CreateActivityRequest request) {
		return generateRandomString(18);
	}

	webService static void updateActivity(UpdateActivityRequest request) {

	}


	private static String generateRandomString(Integer len) {
		final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		String randStr = '';
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr;
	}

	private static String generateUUID() {
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		return h.SubString(0, 8) + '-' + h.SubString(8, 12) + '-' + h.SubString(12, 16) + '-' + h.SubString(16, 20) + '-' + h.substring(20);
	}

	global class CreateAccountRequest {
		global String Person_number;
		global String Name;
		global Integer Client_Global_ID;
		global String first_name;
		global String surname;
		global String title_after;
		global String title_befor;
		global String Personal_identification_nr;
		global String ICO;
		global String clientzone;
		global String loginKz;
		global Boolean activatedKZ;
		global Integer contact_subtype;
		global String Email;
		global String Phone_number_mobile;
		global String Phone_number_work;
		global String Phone_number_home;
		global String Fax;
		global Date valid_from;
		global String Priority;
		global Boolean non_confirm_email;
		global Boolean non_confirm_phonenumber;
		global Date agreem_valid_from;
		global Integer agreem_type;
		global Integer Address_Type;
		global String City;
		global Integer Country;
		global String Street_number;
		global String zip_code;
		global String Street;
		global Date address_Valid_from;
		global Date address_Valid_to;
		global Integer Technical_status;
		global Integer Ext_CommunicationId;
		global Boolean isPoliticallyEngaged;
		global Boolean isResident;
	}

	global class CreateActivityRequest {
		global String Person_number;
		global String type;
		global String describe;
		global String direction;
		global String OZ_from;
		global String phonenumber;
		global Datetime Duedate;
		global Integer StateCode;
		global Integer StatusCode;
		global String name;
		global String OZ_to;
		global Datetime validto;
		global Integer result;
		global String statusmanager_CPU;
		global String modifybyoz_CPU;
		global String author_CPU;
		global String campaign;
		global String email;
		global String is_visible_for_NEL;
		global String opportunity_id;
		global String location;
		global Datetime plannedtodate;
		global String web_link;
		global String letter_city;
		global String letter_house_nr;
		global String letter_postcode;
		global String letter_street;
		global String IS_KZ_message;
		global String IS_read;
		global String activityFrom_client;
		global String activityFrom_lead;
		global String activityTo_client;
		global String activityTo_lead;
		global Datetime validFrom;
	}

	global class UpdateActivityRequest {
		global String Person_number;
		global String type;
		global String describe;
		global String direction;
		global String activity_id;
		global Integer activity_datasource;
		global Datetime Duedate;
		global Integer StateCode;
		global Integer StatusCode;
		global String name;
		global String client;
		global String lead;
		global String OZ;
		global Datetime validto;
		global Integer result;
		global String statusmanager_CPU;
		global String modifybyoz_CPU;
		global String author_CPU;
		global String campaign;
		global String email;
		global String is_visible_for_NEL;
		global String opportunity_id;
		global String location;
		global Datetime plannedtodate;
		global String letter_city;
		global String letter_house_nr;
		global String letter_postcode;
		global String letter_street;
		global String IS_KZ_message;
		global String IS_read;
		global String activityFrom;
		global String activityFrom_client;
		global String activityFrom_lead;
		global String activityTo_client;
		global String activityTo_lead;
		global Datetime validFrom;
	}
}