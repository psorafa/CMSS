public class TestDataGenerator {

	public static AQMessage prepareMessage() {
		AQMessage message = new AQMessage();
		AQMessage.ChangeEventHeader header = new AQMessage.ChangeEventHeader();
		header.changedFields = new List<String>{
			'Example__c'
		};
		header.changeType = 'UPDATE';
		header.entityName = 'Test__c';
		message.changeEventHeader = header;
		return message;
	}
}