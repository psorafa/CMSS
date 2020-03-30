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
    @TestVisible private static SearchCriteriaDTO searchCriteriaObject = new SearchCriteriaDTO();

    /**
     * @description method to search among Account or Lead records.
     *      If no record of client record type found, we will rerun the search, this time among prospects
     *      If no record of prospect record type found, we will rerun the search, this time among leads
     * @return list of sObjects (leads or Accounts) found by query. If null no record was found TODO wrapper instead? so we can return error message?
     * @param searchCriteria stores the criteria of the search.
     *      firstName, lastName and birthNumber define that we search among person accounts or leads
     *      compRegNum defines that we search among leads or all accounts no matter whether business or person
     *      assetNumber defines that we search among assets returning their parent account
     *      searchAmong defines whether we search among clients, prospects or leads
     * @author Andrea Olexova
     */
    @AuraEnabled
    public static List<SObject> findRecords(SearchCriteriaDTO searchCriteria) {
        System.debug(' =====>  CustomerSearchController.findAccounts  <=====  ');
        System.debug(' =====> input params: ' + searchCriteria.firstName + ', ' + searchCriteria.lastName + ', ' + searchCriteria.birthNumber + ', ' + searchCriteria.compRegNum + ', ' + searchCriteria.assetNumber + ', ' + searchCriteria.searchAmong + ' <===== ');

        searchCriteriaObject = searchCriteria == null ? searchCriteriaObject : searchCriteria;
        firstName = searchCriteria.firstName;
        lastName = searchCriteria.lastName;
        birthNumber = searchCriteria.birthNumber;
        compRegNum = searchCriteria.compRegNum;
        assetNumber = searchCriteria.assetNumber;
        searchAmong = String.isBlank(searchCriteria.searchAmong) ? searchAmong : searchCriteria.searchAmong; //if searchAmong not provided, we use search among clients by default

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
        System.debug(' =====> findRecords returning: ' + finalResults);
        return finalResults;
    }

    /**
     * @description method to build and @return complete text of the query to be used by SOSL search
     * @author Andrea Olexova
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
            query = 'FIND ' + searchTerm + ' IN ALL FIELDS RETURNING ' + returningString;
        }

        System.debug(' =====> getQueryString returning: ' + query);
        return query;
    }

    /**
     * @description method to build and @return search term for the sosl query
     * @author Andrea Olexova
     */
    @TestVisible
    private static String getSearchTerm() {
        System.debug(' =====>  CustomerSearchController.getSearchTerm  <=====  ');
        String searchTerm = '\'';

        if (String.isNotBlank(birthNumber)) {
            searchTerm += birthNumber;
            if (String.isNotBlank(firstName)) {
                searchTerm += ' AND ' + firstName + '*';
            }
            if (String.isNotBlank(lastName)) {
                searchTerm += ' AND ' + lastName + '*';
            }
        } else if (String.isNotBlank(compRegNum)) {
            searchTerm += compRegNum;
        } else if (String.isNotBlank(assetNumber)) {
            searchTerm += assetNumber + '*';
        }
        searchTerm += '\'';

        return searchTerm;
    }

    //variables are used in the getReturningString() method
    // out of the method so it is accessible from the test class
    @TestVisible private static final String ACCOUNT_OBJECT_STRING = ACCOUNT_SOBJECT + '(Id,PersonalIdentificationNr__c,CompanyRegistrationNumber__c,FirstName,LastName WHERE ';
    @TestVisible private static final String LEAD_OBJECT_STRING = LEAD_SOBJECT + '(Id,FirstName,LastName)';
    @TestVisible private static final String ASSET_OBJECT_STRING = ASSET_SOBJECT + '(Id,Name,Account.Id,Account.Name WHERE ';
    /**
     * @description method to build and @return text to be used in the SOSL query after RETURNING keyword based on the sObject Type for which we need the string
     * @author Andrea Olexova
     */
    @TestVisible
    private static String getReturningString() {
        System.debug(' =====>  CustomerSearchController.getReturningString  <=====  ');
        String whereCondition = String.isBlank(birthNumber) ? '' : 'IsPersonAccount = true' + ' AND ';
        whereCondition += String.isBlank(assetNumber) ? 'AccountStatus__c ' : 'Account.AccountStatus__c ';

        if (CLIENTS == searchAmong) {
            whereCondition += '= ';
        } else if (PROSPECTS == searchAmong) {
            whereCondition += '!= ';
        }
        whereCondition += '\'1\'';

        if (LEADS == searchAmong) return LEAD_OBJECT_STRING; else if (String.isNotBlank(assetNumber)) return ASSET_OBJECT_STRING + whereCondition + ')'; else return ACCOUNT_OBJECT_STRING + whereCondition + ')';
    }

    /**
     * @description method to run SOSL search using @param query provided
     * @return the first List<SObject> from the results of SOSL search - as we always search within one sobject type
     * @author Andrea Olexova
     */
    @TestVisible
    private static List<SObject> runSosl(String query) {
        System.debug(' =====>  CustomerSearchController.runSosl  <=====  ');
        List<List<SObject>> searchResultList = Search.query(query);
        List<SObject> searchResults = new List<SObject>();

        if (searchResultList != null && !searchResultList.isEmpty()) {
            searchResults = searchResultList.get(0);
        }

        System.debug(' =====> runSosl returning size: ' + searchResults.size());
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
        System.debug(' =====>  getFilteredResults returning size: ' + filteredResults.size());
        return filteredResults;
    }

    /**
     * @description method to change the scope of the search - possibilities are CLIENTS, PROSPECTS AND LEADS
     * first iteration should be among clients, second among prospects and third among leads
     * if we can still change the searchAmong param, we will call method foundRecords again
     * we search among leads only for birthNumber search
     * @author Andrea Olexova
     */
    @TestVisible
    private static void callSearchAgainForDifferentScope() {
        System.debug(' =====>  CustomerSearchController.callSearchAgainForDifferentScope  <=====  ');
        String searchAmongNewValue = '';
        if (CLIENTS == searchAmong) {
            searchAmongNewValue = PROSPECTS;
        } else if (PROSPECTS == searchAmong && String.isNotBlank(birthNumber)) {
            searchAmongNewValue = LEADS;
        }
        System.debug(' =====>  searchAmongNewValue: ' + searchAmongNewValue);
        //we will check  whether it is filled and whether it is not CLIENTS, so we avoid having infinite loop
        if (String.isNotBlank(searchAmongNewValue) && CLIENTS != searchAmongNewValue) {
            searchCriteriaObject.searchAmong = searchAmongNewValue;
            findRecords(searchCriteriaObject);
        }
    }

    public class SearchCriteriaDTO {
        @AuraEnabled public String firstName { get; set; }
        @AuraEnabled public String lastName { get; set; }
        @AuraEnabled public String birthNumber { get; set; }
        @AuraEnabled public String compRegNum { get; set; }
        @AuraEnabled public String assetNumber { get; set; }
        @AuraEnabled public String searchAmong { get; set; }

        public SearchCriteriaDTO() {}

        public SearchCriteriaDTO(String firstName, String lastName, String birthNumber, String compRegNum, String assetNumber, String searchAmong) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.birthNumber = birthNumber;
            this.compRegNum = compRegNum;
            this.assetNumber = assetNumber;
            this.searchAmong = String.isBlank(searchAmong) ? CLIENTS : searchAmong;
        }
    }
}