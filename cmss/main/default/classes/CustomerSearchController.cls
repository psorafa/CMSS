/**
 * Created by a.olexova on 3/17/2020.
 */

public without sharing class CustomerSearchController {

    //used for specification whether we search among Clients, Prospects or Leads
    public static final String CLIENTS = 'CLIENTS';
    public static final String PROSPECTS = 'PROSPECTS';
    public static final String LEADS = 'LEADS';

    /**
     * @description method to search among Account or Lead records.
     *      If no record of client record type found, we will rerun the search, this time among prospects
     *      If no record of prospect record type found, we will rerun the search, this time among leads
     * @return list of sObjects (leads or Accounts) found by query. If null no record was found TODO wrapper instead? so we can return error message?
     * @param firstName, @param lastName and @param birthNumber define that we search among person accounts or leads
     * @param compRegNum defines that we search among leads or all accounts no matter whether business or person
     * @param assetNumber defines that we search among assets returning their parent account
     * @param searchAmong defines whether we search among clients, prospects or leads
     * @author:     Andrea Olexova
     * @date:       2020-03-17
     */
    @AuraEnabled
    public static List<SObject> findRecords(String firstName, String lastName, String birthNumber, String compRegNum, String assetNumber, String searchAmong) {
        System.debug('      =====>  CustomerSearchController.findAccounts  <=====  ');
        System.debug(' =====> input params: ' + firstName + ', ' + lastName + ', ' + birthNumber + ', ' + compRegNum + ', ' + assetNumber + ', ' + searchAmong + ' <===== ');

        List<SObject> foundRecords = new List<SObject>();

        //one of compRegNum, assetNumber and birthNumber needs to be filled in
        // if birthNumber is filled in, one of fistName or lastName needs to be filled in
        if (String.isNotBlank(compRegNum) || String.isNotBlank(assetNumber)
                || (String.isNotBlank(birthNumber) && (String.isNotBlank(firstName) || String.isNotBlank(lastName)))) {
            List<Account> foundAccounts = new List<Account>();
            List<Account> filteredAccounts = new List<Account>();
            List<Lead> foundLeads = new List<Lead>();
            List<Lead> filteredLeads = new List<Lead>();
            List<Asset> foundAssets = new List<Asset>();
            List<Asset> filteredAssets = new List<Asset>();
            List<SObject> searchResults;
            String query;

            //if searchAmong not provided, we use search among clients by default
            searchAmong = String.isBlank(searchAmong) ? CLIENTS : searchAmong;

            query = getQueryString(firstName, lastName, birthNumber, compRegNum, assetNumber, searchAmong);
            searchResults = runSosl(query);

            getAccountsLeadsAssetsFromResults(searchResults, foundAccounts, foundAssets, foundLeads);

            for (Account foundAcc : foundAccounts) {
                if ((String.isNotBlank(birthNumber) && birthNumber == foundAcc.PersonalIdentificationNr__c)
                        || (String.isNotBlank(compRegNum) && compRegNum == foundAcc.CompanyRegistrationNumber__c)) {
                    filteredAccounts.add(foundAcc);
                }
            }

            for (Asset foundAsset : foundAssets) {
                if (String.isNotBlank(assetNumber) &&
                        (assetNumber == foundAsset.Name || foundAsset.Name.startsWithIgnoreCase(assetNumber))) {
                    filteredAssets.add(foundAsset);
                }
            }

            //if we do not find any result, we need to check within what scope we searched
            // first iteration should be among clients, second among prospects and third among leads
            // if we can still change the searchAmong param, we will call this method again
            // we search among leads only for birthNumber search
            // if there is no next iteration available, we return empty list which will result in NO FOUND RECORDS message in UI
            if (filteredAccounts.isEmpty() && filteredLeads.isEmpty() && filteredAssets.isEmpty()) {
                if (CLIENTS == searchAmong) {
                    searchAmong = PROSPECTS;
                } else if (PROSPECTS == searchAmong && String.isNotBlank(birthNumber)) {
                    searchAmong = LEADS;
                } else {
                    return foundRecords;
                }
                findRecords(firstName, lastName, birthNumber, compRegNum, assetNumber, searchAmong);
            } else if (!filteredAccounts.isEmpty()) {
                foundRecords.addAll(filteredAccounts);
            } else if (!filteredLeads.isEmpty()) {
                foundRecords.addAll(filteredLeads);
            } else if (!filteredAssets.isEmpty()) {
                foundRecords.addAll(filteredAssets);
            }
        }
        System.debug(' =====> returning: ' + foundRecords);
        return foundRecords;
    }

    @TestVisible
    private static String getQueryString(String firstName, String lastName, String birthNumber, String compRegNum, String assetNumber, String searchAmong) {
        System.debug(' =====>  CustomerSearchController.getQueryString  <=====  ');
        final String AND_OPERATOR = ' AND ';
        final String ASTERISK = '*';
        final String OPENING_PARENTHESIS = '(';
        final String CLOSING_PARENTHESIS = ')';
        final String SINGLE_QUOTE = '\'';
        final String IN_ALL_FIELDS_RETURNING = ' IN ALL FIELDS RETURNING ';

        String searchTerm = '';
        String accountObjectString = 'Account' + OPENING_PARENTHESIS + 'Id,PersonalIdentificationNr__c,CompanyRegistrationNumber__c,FirstName,LastName WHERE ';
        String leadObjectString = 'Lead' + OPENING_PARENTHESIS + 'Id' + CLOSING_PARENTHESIS;
        String assetObjectString = 'Asset' + OPENING_PARENTHESIS + 'Id,Name,Account.Id,Account.Name' + CLOSING_PARENTHESIS; // todo add condition from parent account
        String accountWhereCondition = 'IsPersonAccount = true';
        String assetWhereCondition = 'Account.IsPersonAccount = true';

        searchTerm += SINGLE_QUOTE;
        if (String.isNotBlank(birthNumber)) {
            searchTerm += birthNumber;
            if (String.isNotBlank(firstName)) {
                searchTerm += AND_OPERATOR + firstName + ASTERISK;
            }
            if (String.isNotBlank(lastName)) {
                searchTerm += AND_OPERATOR + lastName + ASTERISK;
            }
        } else if (String.isNotBlank(compRegNum)) {
            accountWhereCondition = '';
            searchTerm += compRegNum;
        } else if (String.isNotBlank(assetNumber)) {
            searchTerm += assetNumber + ASTERISK;
        }
        searchTerm += SINGLE_QUOTE;

        accountWhereCondition += String.isBlank(accountWhereCondition) ? 'AccountStatus__c ' : ' AND AccountStatus__c ';
        if (CLIENTS == searchAmong) {
            accountWhereCondition += '= ' + SINGLE_QUOTE + '1' + SINGLE_QUOTE;
        } else if (PROSPECTS == searchAmong) {
            accountWhereCondition += '!= ' + SINGLE_QUOTE + '1' + SINGLE_QUOTE;
        }
        accountObjectString += accountWhereCondition + CLOSING_PARENTHESIS;


        String query = 'FIND ' + searchTerm + IN_ALL_FIELDS_RETURNING;
        if (LEADS == searchAmong) {
            query += leadObjectString;
        } else if (String.isNotBlank(assetNumber)) {
            query += assetObjectString;
        } else {
            query += accountObjectString;
        }
        System.debug(' =====> returning query: ' + query);
        return query;
    }

    @TestVisible
    private static List<SObject> runSosl(String query) {
        List<List<SObject>> searchResultList = Search.query(query);
        List<SObject> searchResults = new List<SObject>();
        if (searchResultList != null && !searchResultList.isEmpty()) {
            searchResults = searchResultList.get(0);
        }
        return searchResults;
    }

    @TestVisible
    private static void getAccountsLeadsAssetsFromResults(List<SObject> searchResults, List<Account> foundAccounts, List<Asset> foundAssets, List<Lead> foundLeads) {
        if (searchResults != null && !searchResults.isEmpty()) {
            String sObjectType = String.valueOf(searchResults.getSObjectType());
            if (sObjectType.equalsIgnoreCase('account')) {
                foundAccounts = (List<Account>) searchResults;
            } else if (sObjectType.equalsIgnoreCase('lead')) {
                foundLeads = (List<Lead>) searchResults;
            } else if (sObjectType.equalsIgnoreCase('asset')) {
                foundAssets = (List<Asset>) searchResults;
            }
        }
    }
}