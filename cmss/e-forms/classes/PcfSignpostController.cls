/**
 * Created by lukas.krbec on 03.06.2022.
 */

public class PcfSignpostController {
    @AuraEnabled
    public static List<WrapedProcess> getRelatedMigrationProcesses(String recordId){
        List<WrapedProcess> processes = new List<WrapedProcess>();
        String title = UserInfo.getLanguage() == 'cs' ? 'Title_CZ__c' : 'Title_EN__c';
        for(Migration_Process__mdt p : [SELECT DeveloperName,Title_CZ__c,Title_EN__c FROM Migration_Process__mdt]){
            processes.add(new WrapedProcess(p.DeveloperName, (String)p.get(title)));
        }
        return processes;
    }
    public class WrapedProcess{
        @AuraEnabled public string developerName { get; set; }
        @AuraEnabled public string title { get; set; }

        public WrapedProcess(String developerName, String title){
            this.developerName = developerName;
            this.title = title;
        }
    }

    @AuraEnabled
    public static CommunityWrapper isPortalEnabled() {
        CommunityWrapper cw = new CommunityWrapper();
        Site site = [SELECT Id FROM Site WHERE UrlPathPrefix = 's' LIMIT 1];
        //cw.isPortalEnabled = true;
        cw.isPortalEnabled = [SELECT Id, IsPortalEnabled FROM User WHERE Id = :UserInfo.getUserId()].IsPortalEnabled;
        cw.urlPrefix = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
        return cw;
    }

    public class CommunityWrapper {
        @AuraEnabled
        public Boolean isPortalEnabled;
        @AuraEnabled
        public String urlPrefix;
    }
}