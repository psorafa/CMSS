public with sharing class AgentCPUCheck {

	@AuraEnabled
	public static Boolean checkAgentCPU(String agentCPU) {
		List<User> u = [
			SELECT Id
			FROM User
			WHERE CommissionAccountBase__c = :agentCPU
		];
		return true ? u.size() > 0 : false;
	}
}
