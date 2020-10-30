public with sharing class TaskService {
	public static void setRecordType(List<Task> taskList) {
		List<TaskRecordTypeMapping__mdt> rtMappingList = [
			SELECT RecordTypeDeveloperName__c, TypeAPIName__c
			FROM TaskRecordTypeMapping__mdt
		];
		Map<String, String> rtMappingMap = new Map<String, String>();

		for (TaskRecordTypeMapping__mdt rtMappingItem : rtMappingList) {
			rtMappingMap.put(rtMappingItem.TypeAPIName__c, rtMappingItem.RecordTypeDeveloperName__c);
		}

		for (Task taskItem : taskList ) {
			if (taskItem.Type != null) {
				String taskTypeDevName = rtMappingMap.get(taskItem.Type);
				taskItem.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName()
					.get(taskTypeDevName)
					.getRecordTypeId();
			}
		}
	}
}
