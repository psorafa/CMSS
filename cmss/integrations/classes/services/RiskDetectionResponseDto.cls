public with sharing class RiskDetectionResponseDto {
	@AuraEnabled
	public Integer statusCode { get; set; }
	@AuraEnabled
	public SuccessRiskDetectionResponseDto success { get; set; }
	@AuraEnabled
	public ErrorRiskDetectionResponseDto error { get; set; }

	public class SuccessRiskDetectionResponseDto {
		@AuraEnabled
		public Integer recordId { get; set; }
	}

	public class ErrorRiskDetectionResponseDto {
		@AuraEnabled
		public String message { get; set; }
	}

	public Boolean isSuccess() {
		return statusCode == 200;
	}
}
