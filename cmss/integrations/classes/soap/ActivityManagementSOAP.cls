global with sharing class ActivityManagementSOAP {

	webService static String createActivity(CreateActivityRequest request) {
		return MockServicesUtil.generateRandomString(18);
	}

	webService static void updateActivity(UpdateActivityRequest request) {

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