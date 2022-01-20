public class PersonManagementController {
	@AuraEnabled
	public static String searchCSOBNonClient(String birthNumber, String lastName) {
		try {
			PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody response;
			CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
			PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody requestBody = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody();
			requestBody.personalIdentificationNumber = birthNumber;
			requestBody.lastName = lastName;

			PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
			response = port.searchCSOBSNonClient_Http(requestHeader, requestBody);

			if (String.isEmpty(response.jsonResponse)) {
				return null;
			}
			PersonManagementUtility.UpdatePersonCSOBDataRequest updateRequest = PersonManagementUtility.insertPersonCSOBData(
				response.jsonResponse
			);
			Logger.debug('Update request from response', JSON.serialize(updateRequest));
			return JSON.serialize(updateRequest);
		} catch (Exception e) {
			throw new IntegrationException(e);
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static void updateCSOBNonClient(String serializedUpdatePersonCSOBDataRequest) {
		try {
			PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody response;
			CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
			PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody requestBody = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody();
			requestBody.jsonRequest = serializedUpdatePersonCSOBDataRequest;

			PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
			response = port.updateCSOBNonClient_Http(requestHeader, requestBody);
		} catch (Exception e) {
			throw new IntegrationException(e);
		} finally {
			Logger.saveLogs();
		}
	}
}
