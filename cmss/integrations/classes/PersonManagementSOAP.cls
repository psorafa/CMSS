global with sharing class PersonManagementSOAP {

	webService static String createAccount(CreateAccountRequest request) {
		return MockServicesUtil.generateRandomString(18);
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
		return MockServicesUtil.generateRandomString(18);
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
}