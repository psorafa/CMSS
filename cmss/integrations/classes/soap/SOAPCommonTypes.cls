global with sharing class SOAPCommonTypes {

	public class OutboundHttpHeader {
		public void addWssToHeader(DOM.XmlNode header, String username, String password) {
			String wsse = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
			String pwdType = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText';
			String encodingType = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
			DOM.XmlNode security = header.addChildElement('Security', wsse, 'wsse');
			security.setAttribute('mustUnderstand', '1');
			security.setAttribute('xmlns:wsu', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');
			DOM.XmlNode usernameToken = security.addChildElement('UsernameToken', wsse, 'wsse');
			//usernameToken.setAttribute('wsu:Id', 'UsernameToken-266927B69C471CFC5E16082843487846');
			usernameToken.addChildElement('Username', wsse, 'wsse').addTextNode(username);
			DOM.XmlNode pwd = usernameToken.addChildElement('Password', wsse, 'wsse');
			pwd.setAttribute('Type', pwdType);
			pwd.addTextNode(password);
			DOM.XmlNode nonce = usernameToken.addChildElement('Nonce', wsse, 'wsse');
			nonce.setAttribute('EncodingType', encodingType);
			nonce.addTextNode(generateNonce());
			String now = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
			usernameToken.addChildElement('Created', wsse, 'wsu').addTextNode(now.substring(0, now.length() - 2) + ':00');
		}
            public void addWssToHeader1(DOM.XmlNode header, String username, String password) {
			String wsse = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
            String wsu = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
			String pwdType = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText';
			String encodingType = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
			DOM.XmlNode security = header.addChildElement('Security', wsse, 'wsse');
			security.setAttribute('mustUnderstand', '1');
			security.setAttribute('xmlns:wsu', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');
			DOM.XmlNode usernameToken = security.addChildElement('UsernameToken', wsse, 'wsse');
			//usernameToken.setAttribute('wsu:Id', 'UsernameToken-266927B69C471CFC5E16082843487846');
			usernameToken.addChildElement('Username', wsse, 'wsse').addTextNode(username);
			DOM.XmlNode pwd = usernameToken.addChildElement('Password', wsse, 'wsse');
			pwd.setAttribute('Type', pwdType);
			pwd.addTextNode(password);
			DOM.XmlNode nonce = usernameToken.addChildElement('Nonce', wsse, 'wsse');
			nonce.setAttribute('EncodingType', encodingType);
			nonce.addTextNode(generateNonce());
			String now = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
			usernameToken.addChildElement('wsu:Created', null , null).addTextNode(now.substring(0, now.length() - 2) + ':00');
		}

		private String generateNonce() {
			Long randomLong = Crypto.getRandomLong();
			return EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(randomLong)));
		}
	}

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