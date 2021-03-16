public with sharing class AccountRelatedListController {

    @AuraEnabled(cacheable=true)
    public static AccountInfo getAccounts(Id userId, String portManType, String billingCity, String billingPostalCode, Integer recordsToShow, Integer offset) {
        AccountInfo ai = new AccountInfo();
        ai.accountCount = Database.countQuery(
            'SELECT COUNT() ' +
            'FROM Account ' +
            'WHERE PortfolioMngmt' + portManType + '__c = :userId ' +
            (String.isNotBlank(billingCity) ? 'AND BillingCity LIKE :billingCity ' : '') +
            (String.isNotBlank(billingPostalCode) ? 'AND BillingPostalCode LIKE :billingPostalCode ' : '')
        );
        ai.accounts = queryAccounts(userId, portManType, billingCity, billingPostalCode, recordsToShow, offset);

        return ai;
    }

    @AuraEnabled(cacheable=true)
    public static Id getUserId(String commAccountBase) {
        User[] users = [SELECT Id FROM User WHERE CommissionAccountBase__c = :commAccountBase];
        return users.size() > 0 ? users[0].Id : null;
    }

    @AuraEnabled
    public static void createPortManRequestsForUsersClients(PortfolioManagementRequest__c pmr, Id userId, String portManType) {
        PortfolioManagementRequest__c[] pmrs = new PortfolioManagementRequest__c[]{};
        for (Account a : queryAccounts(userId, portManType, null, null, 50000, 0)) {
            clonePMR(pmrs, pmr, a.Id);
        }
        insert pmrs;
    }

    @AuraEnabled
    public static void createPortManRequests(PortfolioManagementRequest__c pmr, String[] accountIds) {
        PortfolioManagementRequest__c[] pmrs = new PortfolioManagementRequest__c[]{};
        for (Id accId : accountIds) {
            clonePMR(pmrs, pmr, accId);
        }
        insert pmrs;
    }

    private static void clonePMR(PortfolioManagementRequest__c[] pmrs, PortfolioManagementRequest__c pmr, Id accId) {
        PortfolioManagementRequest__c newPMR = pmr.clone(false, true, false, false);
        newPMR.Account__c = accId;
        newPMR.BatchID__c = '1';
        pmrs.add(newPMR);
    }

    private static Account[] queryAccounts(Id userId, String portManType, String billingCity, String billingPostalCode, Integer recordsToShow, Integer offset) {
        return Database.query(
            'SELECT CombinedName__c, BillingStreet, BillingCity, BillingPostalCode, Phone, PersonEmail, PersonType__c ' +
            'FROM Account ' +
            'WHERE PortfolioMngmt' + portManType + '__c = :userId ' +
            (String.isNotBlank(billingCity) ? 'AND BillingCity LIKE :billingCity ' : '') +
            (String.isNotBlank(billingPostalCode) ? 'AND BillingPostalCode LIKE :billingPostalCode ' : '') +
            'LIMIT ' + recordsToShow + ' ' +
            'OFFSET ' + offset
        );
    }

    public class AccountInfo {
        @AuraEnabled
        public Integer accountCount;
        @AuraEnabled
        public Account[] accounts;
    }
}
