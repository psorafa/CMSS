public without sharing class RiskDetectionService {
	private static final String SERVICE_ENDPOINT = '/RiskDetectionServiceWeb_v01/RiskDetectionService/treatRiskDetection';

	private Account account;
	private String searchTerm;
	private Integer identificationType;

	public RiskDetectionService(Id accountId, Integer identificationType, String searchTerm) {
		this.account = loadAccount(accountId);
		this.identificationType = identificationType;
		this.searchTerm = searchTerm;
	}

	private Account loadAccount(Id accountId) {
		return [SELECT Id, GlobalId__c, CommissionAccountBase__pc FROM Account WHERE Id = :accountId];
	}

	public RiskDetectionResponseDto callRiskDetectionService() {
		IntegrationSettings__c setting = IntegrationSettings__c.getOrgDefaults();
		String endpoint = setting.EsbEndpoint__c + SERVICE_ENDPOINT;
		String username = setting.EsbUsername__c;
		String password = setting.EsbPassword__c;
		String payload = JSON.serialize(prepareRequestBody());

		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setBody(payload);
		req.setMethod('POST');

		Blob headerValue = Blob.valueOf(username + ':' + password);
		String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
		req.setHeader('Authorization', authorizationHeader);
		req.setHeader('Content-Type', 'application/json');

		Http http = new Http();
		HttpResponse response = http.send(req);

		RiskDetectionResponseDto responseDto = new RiskDetectionResponseDto();
		responseDto.statusCode = response.getStatusCode();
		if (response.getStatusCode() == 200) {
			RiskDetectionResponseDto.SuccessRiskDetectionResponseDto success = (RiskDetectionResponseDto.SuccessRiskDetectionResponseDto) JSON.deserialize(response.getBody(), RiskDetectionResponseDto.SuccessRiskDetectionResponseDto.class);
			responseDto.success = success;
		} else {
			RiskDetectionResponseDto.ErrorRiskDetectionResponseDto errorDto = new RiskDetectionResponseDto.ErrorRiskDetectionResponseDto();
			errorDto.message = response.getBody();
		}

		return responseDto;
	}

	private RiskDetectionRequestDto prepareRequestBody() {
		User currentUser = [SELECT Id, Email, LoginName__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		RiskDetectionRequestDto request = new RiskDetectionRequestDto();
		request.userId = currentUser.LoginName__c;
		request.userEmail = currentUser.Email;
		request.cpu = Integer.valueOf(account.CommissionAccountBase__pc);
		request.globalId = Integer.valueOf(account.GlobalId__c);
		request.identificationType = identificationType;
		request.searchTerm = searchTerm;

		return request;
	}

	public void logoutUser() {
		List<AuthSession> authSession = [
			SELECT Id, Users.Name, SessionType, LoginType
			FROM AuthSession
			WHERE UsersId = :UserInfo.getUserId()
		];

		List<Database.DeleteResult> deleteResults = Database.delete(authSession);
		for (Database.DeleteResult result : deleteResults) {
			if (result.success) {
				System.debug('Logout successful. UserId: ' + result.getId());
			} else {
				System.debug('Logout failed. UserId: ' + result.getId());
			}
		}
	}
}
