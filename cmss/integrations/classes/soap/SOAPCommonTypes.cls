global with sharing class SOAPCommonTypes {

	public class Response {
		public CommonHeader responseHeader;
		public Boolean isFault = false;
		public Fault fault;
		public Object responseBody;
    }
    
    public class OutboundRequestHeader {
        public OutboundRequestHeader() {
            this.timestamp = System.now();
            this.messageId = MockServicesUtil.generateUUID();
            this.sourceSystem = 'SalesForce';
            this.physicalSource = Url.getSalesforceBaseUrl().toExternalForm();
            this.userId = UserInfo.getUserId();
        }
		public String conversationIdName;
        public String conversationIdValue;
        public String correlationId;
        public String messageId;
        public String physicalSource;
        public String sourceSystem;
        public String targetSystem;
        public DateTime timestamp;
        public String userId;
        private String[] conversationIdName_type_info = new String[]{'conversationIdName','http://service.cmss.cz/common/CommonMessage/v01',null,'0','1','false'};
        private String[] conversationIdValue_type_info = new String[]{'conversationIdValue','http://service.cmss.cz/common/CommonMessage/v01',null,'0','1','false'};
        private String[] correlationId_type_info = new String[]{'correlationId','http://service.cmss.cz/common/CommonMessage/v01',null,'0','1','false'};
        private String[] messageId_type_info = new String[]{'messageId','http://service.cmss.cz/common/CommonMessage/v01',null,'1','1','false'};
        private String[] physicalSource_type_info = new String[]{'physicalSource','http://service.cmss.cz/common/CommonMessage/v01',null,'0','1','false'};
        private String[] sourceSystem_type_info = new String[]{'sourceSystem','http://service.cmss.cz/common/CommonMessage/v01',null,'1','1','false'};
        private String[] targetSystem_type_info = new String[]{'targetSystem','http://service.cmss.cz/common/CommonMessage/v01',null,'0','1','false'};
        private String[] timestamp_type_info = new String[]{'timestamp','http://service.cmss.cz/common/CommonMessage/v01',null,'1','1','false'};
        private String[] userId_type_info = new String[]{'userId','http://service.cmss.cz/common/CommonMessage/v01',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://service.cmss.cz/common/CommonMessage/v01','true','false'};
        private String[] field_order_type_info = new String[]{'conversationIdName','conversationIdValue','correlationId','messageId','physicalSource','sourceSystem','targetSystem','timestamp','userId'};
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