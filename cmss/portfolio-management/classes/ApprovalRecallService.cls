public class ApprovalRecallService {
	@InvocableMethod(label='Recall Approvals')
	public static void recallApprovals(List<List<String>> recordIds) {
		List<String> objectsToRecallIds = flattenListOfListsOfStrings(recordIds);
		List<ProcessInstanceWorkitem> workitems = [
			SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId
			FROM ProcessInstanceWorkitem
			WHERE ProcessInstance.TargetObjectId IN :objectsToRecallIds
		];
		List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
		for (ProcessInstanceWorkitem singleItem : workitems) {
			Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
			request.setAction('Removed');
			request.setWorkitemId(singleItem.Id);
			requests.add(request);
		}
		Approval.process(requests, false);
	}

	private static List<String> flattenListOfListsOfStrings(List<List<String>> listOfListsOfStrings) {
		List<String> listOfStrings = new List<String>();
		for (List<String> singleList : listOfListsOfStrings) {
			for (String singleItem : singleList) {
				listOfStrings.add(singleItem);
			}
		}
		return listOfStrings;
	}
}
