/**
 * Created by a.olexova on 3/17/2020.
 */

public without sharing class CustomerSearchController {

    //used for specification whether we search among Clients, Prospects or Leads
    public static final String CLIENTS = 'CLIENTS';
    public static final String PROSPECTS = 'PROSPECTS';
    public static final String LEADS = 'LEADS';

    //names of SObjects possibly returned by sosl query
    public static final String ACCOUNT_SOBJECT = 'Account';
    public static final String ASSET_SOBJECT = 'Asset';
    public static final String LEAD_SOBJECT = 'Lead';

    //inputs from findRecords method
    @TestVisible private static String firstName, lastName, birthNumber, compRegNum, assetNumber, searchAmong = CLIENTS;

    /**
     * @description method to search among Account or Lead records.
     *      If no record of client record type found, we will rerun the search, this time among prospects
     *      If no record of prospect record type found, we will rerun the search, this time among leads
     * @return list of sObjects (leads or Accounts) found by query. If null no record was found TODO wrapper instead? so we can return error message?
     * @param searchedFirstName, @param searchedLastName and @param searchedBirthNumber define that we search among person accounts or leads
     * @param searchedCompRegNum defines that we search among leads or all accounts no matter whether business or person
     * @param searchedAssetNumber defines that we search among assets returning their parent account
     * @param searchAmongWhat defines whether we search among clients, prospects or leads
     * @author:     Andrea Olexova
     */
    @AuraEnabled
    public static List<SObject> findRecords(String searchedFirstName, String searchedLastName, String searchedBirthNumber, String searchedCompRegNum, String searchedAssetNumber, String searchAmongWhat) {
        System.debug('      =====>  CustomerSearchController.findAccounts  <=====  ');
        System.debug(' =====> input params: ' + searchedFirstName + ', ' + searchedLastName + ', ' + searchedBirthNumber + ', ' + searchedCompRegNum + ', ' + searchedAssetNumber + ', ' + searchAmongWhat + ' <===== ');

        firstName = searchedFirstName;
        lastName = searchedLastName;
        birthNumber = searchedBirthNumber;
        compRegNum = searchedCompRegNum;
        assetNumber = searchedAssetNumber;
        searchAmong = String.isBlank(searchAmongWhat) ? searchAmong : searchAmongWhat; //if searchAmong not provided, we use search among clients by default

        List<SObject> finalResults = new List<SObject>();

        //one of compRegNum, assetNumber and birthNumber needs to be filled in
        // if birthNumber is filled in, one of fistName or lastName needs to be filled in
        if (String.isNotBlank(compRegNum) || String.isNotBlank(assetNumber)
                || (String.isNotBlank(birthNumber) && (String.isNotBlank(firstName) || String.isNotBlank(lastName)))) {
            String query = getQueryString();
            List<SObject> searchResults = String.isNotBlank(query) ? runSosl(query) : new List<SObject>();

            if (!searchResults.isEmpty()) {
                finalResults = getFilteredResults(searchResults);
            }
            if (finalResults.isEmpty()) {
                //if we do not find any result, we will change the scope of search if still possible or return empty list
                callSearchAgainForDifferentScope();
            }
        }
        System.debug(' =====> returning: ' + finalResults);
        return finalResults;
    }

    @TestVisible private static final String AND_OPERATOR = ' AND ';
    @TestVisible private static final String ASTERISK = '*';
    @TestVisible private static final String OPENING_PARENTHESIS = '(';
    @TestVisible private static final String CLOSING_PARENTHESIS = ')';
    @TestVisible private static final String SINGLE_QUOTE = '\'';
    @TestVisible private static final String IN_ALL_FIELDS_RETURNING = ' IN ALL FIELDS RETURNING ';
    /**
     * @description method to build and @return complete text of the query to be used by SOSL search
     * @author:     Andrea Olexova
     */
    @TestVisible
    private static String getQueryString() {
        System.debug(' =====>  CustomerSearchController.getQueryString  <=====  ');
        String query = '';
        String searchTerm = '';
        String returningString = '';

        searchTerm = getSearchTerm();
        returningString = getReturningString();

        if (String.isNotBlank(searchTerm) && String.isNotBlank(returningString)) {
            query = 'FIND ' + searchTerm + IN_ALL_FIELDS_RETURNING + returningString;
        }

        System.debug(' =====> returning query: ' + query);
        return query;
    }

    /**
     * @description method to build and @return search term for the sosl query
     * @author:     Andrea Olexova
     */
    @TestVisible
    private static String getSearchTerm() {
        System.debug(' =====>  CustomerSearchController.getSearchTerm  <=====  ');
        String searchTerm = SINGLE_QUOTE;

        if (String.isNotBlank(birthNumber)) {
            searchTerm += birthNumber;
            if (String.isNotBlank(firstName)) {
                searchTerm += AND_OPERATOR + firstName + ASTERISK;
            }
            if (String.isNotBlank(lastName)) {
                searchTerm += AND_OPERATOR + lastName + ASTERISK;
            }
        } else if (String.isNotBlank(compRegNum)) {
            searchTerm += compRegNum;
        } else if (String.isNotBlank(assetNumber)) {
            searchTerm += assetNumber + ASTERISK;
        }
        searchTerm += SINGLE_QUOTE;

        return searchTerm;
    }

    //variables are used in the getReturningString() method
    // out of the method so it is accessible from the test class
    @TestVisible private static final String ACCOUNT_OBJECT_STRING = ACCOUNT_SOBJECT + OPENING_PARENTHESIS + 'Id,PersonalIdentificationNr__c,CompanyRegistrationNumber__c,FirstName,LastName WHERE ';
    @TestVisible private static final String LEAD_OBJECT_STRING = LEAD_SOBJECT + OPENING_PARENTHESIS + 'Id,FirstName,LastName' + CLOSING_PARENTHESIS;
    @TestVisible private static final String ASSET_OBJECT_STRING = ASSET_SOBJECT + OPENING_PARENTHESIS + 'Id,Name,Account.Id,Account.Name WHERE ';
    /**
     * @description method to build  and @return text to be used in the SOSL query after RETURNING keyword based on the sObject Type for which we need the string
     * @author:     Andrea Olexova
     */
    @TestVisible
    private static String getReturningString() {
        System.debug(' =====>  CustomerSearchController.getReturningString  <=====  ');
        String whereCondition = String.isBlank(birthNumber) ? '' : 'IsPersonAccount = true' + AND_OPERATOR;
        whereCondition += String.isBlank(assetNumber) ? 'AccountStatus__c ' : 'Account.AccountStatus__c ';

        if (CLIENTS == searchAmong) {
            whereCondition += '= ';
        } else if (PROSPECTS == searchAmong) {
            whereCondition += '!= ';
        }
        whereCondition += SINGLE_QUOTE + '1' + SINGLE_QUOTE;

        if (LEADS == searchAmong) return LEAD_OBJECT_STRING; else if (String.isNotBlank(assetNumber)) return ASSET_OBJECT_STRING + whereCondition + CLOSING_PARENTHESIS; else return ACCOUNT_OBJECT_STRING + whereCondition + CLOSING_PARENTHESIS;
    }

    /**
     * @description method to run SOSL search using @param query provided
     * @return the first List<SObject> from the results of SOSL search - as we always search within one sobject type
     * @author:     Andrea Olexova
     */
    @TestVisible
    private static List<SObject> runSosl(String query) {
        System.debug(' =====>  CustomerSearchController.runSosl  <=====  ');
        List<List<SObject>> searchResultList = Search.query(query);
        List<SObject> searchResults = new List<SObject>();

        if (searchResultList != null && !searchResultList.isEmpty()) {
            searchResults = searchResultList.get(0);
        }

        System.debug(' =====>  returning size: ' + searchResults.size());
        return searchResults;
    }

    @TestVisible
    private static List<SObject> getFilteredResults(List<SObject> searchResults) {
        System.debug(' =====>  CustomerSearchController.getFilteredResults  <=====  ');
        List<SObject> filteredResults = new List<SObject>();
        if (searchResults != null) {
            String sObjectType = String.valueOf(searchResults.getSObjectType());
            if (sObjectType.equalsIgnoreCase(ACCOUNT_SOBJECT)) {
                for (Account accountResult : (List<Account>) searchResults) {
                    if ((String.isNotBlank(birthNumber) && birthNumber == accountResult.PersonalIdentificationNr__c)
                            || (String.isNotBlank(compRegNum) && compRegNum == accountResult.CompanyRegistrationNumber__c)) {
                        filteredResults.add(accountResult);
                    }
                }
            } else if (sObjectType.equalsIgnoreCase(ASSET_SOBJECT)) {
                for (Asset assetResult : (List<Asset>) searchResults) {
                    if (String.isNotBlank(assetNumber) &&
                            (assetNumber == assetResult.Name || assetResult.Name.startsWithIgnoreCase(assetNumber))) {
                        filteredResults.add(assetResult);
                    }
                }
            } else if (sObjectType.equalsIgnoreCase(LEAD_SOBJECT)) {
                for (Lead leadResult : (List<Lead>) searchResults) {
                    if ((String.isNotBlank(lastName)
                            && (lastName == leadResult.LastName || leadResult.LastName.startsWithIgnoreCase(lastName)))
                            || (String.isNotBlank(firstName)
                            && (firstName == leadResult.FirstName || leadResult.FirstName.startsWithIgnoreCase(firstName)))) {
                        filteredResults.add(leadResult);
                    }
                }
            }
        }
        System.debug(' =====>  filteredSobjects.size: ' + filteredResults.size());
        return filteredResults;
    }

    /**
     * @description method to change the scope of the search - possibilities are CLIENTS, PROSPECTS AND LEADS
     * first iteration should be among clients, second among prospects and third among leads
     * if we can still change the searchAmong param, we will call method foundRecords again
     * we search among leads only for birthNumber search
     * @author:     Andrea Olexova
     */
    @TestVisible
    private static void callSearchAgainForDifferentScope() {
        System.debug(' =====>  CustomerSearchController.getFilteredResults  <=====  ');
        String searchAmongNewValue = '';
        if (CLIENTS == searchAmong) {
            searchAmongNewValue = PROSPECTS;
        } else if (PROSPECTS == searchAmong && String.isNotBlank(birthNumber)) {
            searchAmongNewValue = LEADS;
        }
        System.debug(' =====>  searchAmongNewValue: ' + searchAmongNewValue);
        //we will check  whether it is filled and whether it is not CLIENTS, so we avoid having infinite loop
        if (String.isNotBlank(searchAmongNewValue) && CLIENTS != searchAmongNewValue) findRecords(firstName, lastName, birthNumber, compRegNum, assetNumber, searchAmongNewValue);
    }
}