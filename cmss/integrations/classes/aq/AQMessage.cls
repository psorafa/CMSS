public class AQMessage {

	public ChangeEventHeader changeEventHeader;

	public class ChangeEventHeader {
		public Id commitUser;
		public String entityName;
		public String changeType;
		public List<String> changedFields;
		public Id recordId;
	}
}