@isTest
private class TaskServiceTest {
	@isTest
	static void recordTypeAssignment() {
		List<Task> taskList = new List<Task>();

		for (Integer i = 6; i < 9; i++) {
			Integer modNumber = Math.mod(i, 5);
			String modText = String.valueOf(modNumber);
			Task taskItem = new Task();
			taskItem.Subject = 'New Task' + i;
			taskItem.Type = modText;
			taskList.add(taskItem);
		}
		Test.startTest();
		insert taskList;
		Test.stopTest();

		List<Task> updatedTaskList = [
			SELECT Id, RecordTypeId, Type, RecordType.DeveloperName
			FROM Task
			WHERE Id = :taskList
		];

		List<TaskRecordTypeMapping__mdt> rtMappingList = [
			SELECT RecordTypeDeveloperName__c, TypeAPIName__c
			FROM TaskRecordTypeMapping__mdt
		];
		Map<String, String> metadataMap = new Map<String, String>();
		for (TaskRecordTypeMapping__mdt rtMappingItem : rtMappingList) {
			metadataMap.put(rtMappingItem.TypeAPIName__c, rtMappingItem.RecordTypeDeveloperName__c);
		}

		for (Task taskItemWithRecordType : updatedTaskList) {
			String taskTypeDevName = metadataMap.get(taskItemWithRecordType.Type);
			System.assertEquals(taskTypeDevName, taskItemWithRecordType.RecordType.DeveloperName);
		}
	}
}
