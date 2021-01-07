global with sharing class SOAPCommonTypes {

	public class Response {
		public CommonHeader responseHeader;
		public Boolean isFault = false;
		public Fault fault;
		public Object responseBody;
    }
    
	global class CommonHeader {
		webService String messageId;
		webService Datetime timestamp;
		webService String correlationId;
		webService String sourceSystem;
		webService String physicalSource;
		webService String targetSystem;
		webService String userId;
		webService String conversationIdValue;
		webService String conversationIdName;
	}

	global class Fault {
		webService Integer errorNumber;
		webService Integer errorDetail;
		webService String message;
	}

	public class BusinessException extends Exception {
		private Integer errorNumber;
		private Integer detailNumber;

		public BusinessException(Integer errorNumber, String message) {
			this(message);
			this.errorNumber = errorNumber;
		}

		public BusinessException(Integer errorNumber, String message, Exception e) {
			this(message, e);
			this.errorNumber = errorNumber;
		}

		public Integer getErrorNumber() {
			return errorNumber;
		}

		public Integer getDetailNumber() {
			return detailNumber;
		}
	}
}