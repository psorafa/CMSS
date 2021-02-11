public class SObjectUtil {

	public static void stripNullFields(SObject so) {
		if (so == null) {
			return;
		}
		Map<String, Object> valuesMap = so.getPopulatedFieldsAsMap();
		so.clear();
		for (String fieldName : valuesMap.keySet()) {
			Object value = valuesMap.get(fieldName);
			if (value != null) {
				so.put(fieldName, value);
			}
		}
	}

	public static void copyFields(SObject source, SObject destination) {
		if (source == null) {
			return;
		}
		Map<String, Object> soMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(source));
		for (String fieldName : soMap.keySet()) {
			if (fieldName != 'attributes') {
				destination.put(fieldName, source.get(fieldName));
			}
		}
	}
}