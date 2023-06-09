public with sharing class Logger {
	private static String defaultLogLevel = 'debug';
	private static final String transactionId = getUUID();
	private static Integer defaultLogLevelNumber = 4;
	private static final String DEBUG_LEVEL = 'debug';
	private static final String INFO_LEVEL = 'info';
	private static final String WARN_LEVEL = 'warn';
	private static final String ERROR_LEVEL = 'error';
	private static final Map<String, Integer> logLevelNumberMap = new Map<String, Integer>{
		DEBUG_LEVEL => 4,
		INFO_LEVEL => 3,
		WARN_LEVEL => 2,
		ERROR_LEVEL => 1
	};

	private static List<LogEvent__e> logEventsToPublish = new List<LogEvent__e>();

	static {
		String logLevelPreferred = LoggingSetting__c.getOrgDefaults().Level__c;
		if (logLevelPreferred != null) {
			defaultLogLevel = logLevelPreferred;
		}
		defaultLogLevelNumber = logLevelNumberMap.get(defaultLogLevel);
	}

	// debug level log methods
	public static void debug(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 4) {
			createLogEvent(DEBUG_LEVEL, message, ex, payload);
		}
	}

	public static void debug(String message, Exception ex) {
		debug(message, ex, null);
	}

	public static void debug(String message, String payload) {
		debug(message, null, payload);
	}

	public static void debug(String message) {
		debug(message, null, null);
	}

	// info level log methods
	public static void info(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 3) {
			createLogEvent(INFO_LEVEL, message, ex, payload);
		}
	}

	public static void info(String message, Exception ex) {
		info(message, ex, null);
	}

	public static void info(String message, String payload) {
		info(message, null, payload);
	}

	public static void info(String message) {
		info(message, null, null);
	}

	// warn level log methods
	public static void warn(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 2) {
			createLogEvent(WARN_LEVEL, message, ex, payload);
		}
	}

	public static void warn(String message, Exception ex) {
		warn(message, ex, null);
	}

	public static void warn(String message, String payload) {
		warn(message, null, payload);
	}

	public static void warn(String message) {
		warn(message, null, null);
	}

	// error level log methods
	public static void error(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 1) {
			createLogEvent(ERROR_LEVEL, message, ex, payload);
		}
	}

	public static void error(String message, Exception ex) {
		error(message, ex, null);
	}

	public static void error(String message, String payload) {
		error(message, null, payload);
	}

	public static void error(String message) {
		error(message, null, null);
	}

	private static void createLogEvent(String logLevel, String message, Exception ex, String payload) {
		LogEvent__e logEvent = new LogEvent__e();
		logEvent.TransactionId__c = transactionId;
		logEvent.Message__c = message.length() > 255 ? message.left(255) : message;
		if (ex != null) {
			DmlException outerException = new DmlException(ex);
			logEvent.Exception__c =
				ex.getMessage() +
					'\n' +
					outerException.getStackTraceString().substringAfter('Caused by');
		}
		logEvent.Payload__c = (payload != null && payload.length() > 131072) ? payload.left(131072) : payload;
		logEvent.Level__c = logLevel;
		String stackTraceMethod = new DmlException().getStackTraceString();
		stackTraceMethod = stackTraceMethod.substringAfter('\n');
		while (stackTraceMethod.startsWith('Class.Logger.')) {
			stackTraceMethod = stackTraceMethod.substringAfter('\n');
		}
		stackTraceMethod = stackTraceMethod.substringBetween('Class.', ':');
		logEvent.ClassMethodName__c = stackTraceMethod;
		logEventsToPublish.add(logEvent);
	}

	public static void saveLogs() {
		List<Database.SaveResult> results = EventBus.publish(logEventsToPublish);
		logEventsToPublish.clear();
		for (Database.SaveResult sr : results) {
			if (!sr.isSuccess()) {
				for (Database.Error err : sr.getErrors()) {
					System.debug('Error publishing log events: ' + err.getStatusCode() + ' - ' + err.getMessage());
				}
			}
		}
	}

	private static String getUUID() {
		Blob b = Crypto.generateAesKey(128);
		String h = EncodingUtil.convertToHex(b);
		String guid =
			h.substring(0, 8) +
				'-' +
				h.substring(8, 12) +
				'-' +
				h.substring(12, 16) +
				'-' +
				h.substring(16, 20) +
				'-' +
				h.substring(20);
		return guid;
	}

	public static String serializeHttpRequest(HttpRequest request) {
		Map<String, Object> dataMap = new Map<String, Object>();
		dataMap.put('Endpoint', request.getEndpoint());
		dataMap.put('Method', request.getMethod());
		if (request.getBody() != null) {
			dataMap.put('Body', request.getBody());
		}
		if (request.getBodyDocument() != null) {
			dataMap.put('Body Document', request.getBodyDocument().toXmlString());
		}
		return JSON.serializePretty(dataMap);
	}

	public static String serializeHttpResponse(HttpResponse response) {
		Map<String, Object> dataMap = new Map<String, Object>();
		dataMap.put('Status', response.getStatus());
		dataMap.put('Status code', response.getStatusCode());
		dataMap.put('Body', response.getBody());
		Map<String, String> headers = new Map<String, String>();
		for (String headerKey : response.getHeaderKeys()) {
			headers.put(headerKey, response.getHeader(headerKey));
		}
		dataMap.put('Headers', headers);
		return JSON.serializePretty(dataMap);
	}

	public static String getTransactionId() {
		return transactionId;
	}
}
