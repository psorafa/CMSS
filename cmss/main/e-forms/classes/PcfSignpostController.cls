/**
 * Created by lukas.krbec on 03.06.2022.
 */

public class PcfSignpostController {
	@AuraEnabled
	public static List<WrapedProcess> getRelatedMigrationProcesses(String recordId) {
		List<WrapedProcess> processes = new List<WrapedProcess>();
		String title = UserInfo.getLanguage() == 'cs' ? 'Title_CZ__c' : 'Title_EN__c';
		for (Document_Configuration__mdt p : [SELECT Migration_Process__r.DeveloperName, Migration_Process__r.Title_CZ__c, Migration_Process__r.Title_EN__c, Template_Code__c FROM Document_Configuration__mdt]) {
			processes.add(new WrapedProcess(p.Migration_Process__r.DeveloperName, (String) p.getSobject('Migration_Process__r').get(title), p.Template_Code__c));
		}
		System.debug(processes);
		return processes;
	}
	public class WrapedProcess {
		@AuraEnabled public string developerName { get; set; }
		@AuraEnabled public string title { get; set; }
		@AuraEnabled public string template { get; set; }

		public WrapedProcess(String developerName, String title, String template) {
			this.developerName = developerName;
			this.title = title;
			this.template = template;
		}
	}

	@AuraEnabled
	public static CommunityWrapper isPortalEnabled() {
		CommunityWrapper cw = new CommunityWrapper();
		Site site = [SELECT Id FROM Site WHERE UrlPathPrefix = 's' LIMIT 1];
		//cw.isPortalEnabled = true;
		cw.isPortalEnabled = [SELECT Id, IsPortalEnabled FROM User WHERE Id = :UserInfo.getUserId()].IsPortalEnabled;
		cw.urlPrefix = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :site.Id].SecureUrl;
		return cw;
	}

	public class CommunityWrapper {
		@AuraEnabled
		public Boolean isPortalEnabled;
		@AuraEnabled
		public String urlPrefix;
	}
}