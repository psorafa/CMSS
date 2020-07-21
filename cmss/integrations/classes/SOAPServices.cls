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
		webService String Person_number;
		webService String Name;
		webService Integer Client_webService_ID;
		webService String first_name;
		webService String surname;
		webService String title_after;
		webService String title_befor;
		webService String Personal_identification_nr;
		webService String ICO;
		webService String clientzone;
		webService String loginKz;
		webService Boolean activatedKZ;
		webService Integer contact_subtype;
		webService String Email;
		webService String Phone_number_mobile;
		webService String Phone_number_work;
		webService String Phone_number_home;
		webService String Fax;
		webService Date valid_from;
		webService String Priority;
		webService Boolean non_confirm_email;
		webService Boolean non_confirm_phonenumber;
		webService Date agreem_valid_from;
		webService Integer agreem_type;
		webService Integer Address_Type;
		webService String City;
		webService Integer Country;
		webService String Street_number;
		webService String zip_code;
		webService String Street;
		webService Date address_Valid_from;
		webService Date address_Valid_to;
		webService Integer Technical_status;
		webService Integer Ext_CommunicationId;
		webService Boolean isPoliticallyEngaged;
		webService Boolean isResident;
	}

	global class CreateActivityRequest {
		webService String Person_number;
		webService String type;
		webService String describe;
		webService String direction;
		webService String OZ_from;
		webService String phonenumber;
		webService Datetime Duedate;
		webService Integer StateCode;
		webService Integer StatusCode;
		webService String name;
		webService String OZ_to;
		webService Datetime validto;
		webService Integer result;
		webService String statusmanager_CPU;
		webService String modifybyoz_CPU;
		webService String author_CPU;
		webService String campaign;
		webService String email;
		webService String is_visible_for_NEL;
		webService String opportunity_id;
		webService String location;
		webService Datetime plannedtodate;
		webService String web_link;
		webService String letter_city;
		webService String letter_house_nr;
		webService String letter_postcode;
		webService String letter_street;
		webService String IS_KZ_message;
		webService String IS_read;
		webService String activityFrom_client;
		webService String activityFrom_lead;
		webService String activityTo_client;
		webService String activityTo_lead;
		webService Datetime validFrom;
	}

	global class UpdateActivityRequest {
		webService String Person_number;
		webService String type;
		webService String describe;
		webService String direction;
		webService String activity_id;
		webService Integer activity_datasource;
		webService Datetime Duedate;
		webService Integer StateCode;
		webService Integer StatusCode;
		webService String name;
		webService String client;
		webService String lead;
		webService String OZ;
		webService Datetime validto;
		webService Integer result;
		webService String statusmanager_CPU;
		webService String modifybyoz_CPU;
		webService String author_CPU;
		webService String campaign;
		webService String email;
		webService String is_visible_for_NEL;
		webService String opportunity_id;
		webService String location;
		webService Datetime plannedtodate;
		webService String letter_city;
		webService String letter_house_nr;
		webService String letter_postcode;
		webService String letter_street;
		webService String IS_KZ_message;
		webService String IS_read;
		webService String activityFrom;
		webService String activityFrom_client;
		webService String activityFrom_lead;
		webService String activityTo_client;
		webService String activityTo_lead;
		webService Datetime validFrom;
	}
}