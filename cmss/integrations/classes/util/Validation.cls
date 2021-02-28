public with sharing class Validation {

	public static void requireAttribute(Object attribute, String attributeName) {
		if (attribute == null) {
			throw new SOAPCommonTypes.BusinessException(101, 'Mising required attribute: ' + attributeName);
		}
	}
}