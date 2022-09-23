/**
 * Created by a.olexova on 3/17/2020.
 */

public without sharing class CustomerSearchController {
	//used for specification whether we search among Clients, Prospects or Leads
	public static final String CLIENTS = 'CLIENTS';
	public static final String PROSPECTS = 'PROSPECTS';
	public static final String LEADS = 'LEADS';

	//names of SObjects possibly returned by sosl query
	@TestVisible
	private static final String ACCOUNT_SOBJECT = 'Account';
	@TestVisible
	private static final String ASSET_SOBJECT = 'Asset';
	@TestVisible
	private static final String LEAD_SOBJECT = 'Lead';
	private static final Integer ASSET_IDENTIFICATION_TYPE = 6;
	private static final Integer ACCOUNT_IDENTIFICATION_TYPE = 4;


	//inputs from findRecords method
	@TestVisible
	private static String lastName;
	@TestVisible
	private static String birthNumber;
	@TestVisible
	private static String compRegNum;
	@TestVisible
	private static String assetNumber;
	@TestVisible
	private static String searchAmong = CLIENTS;
	@TestVisible
	private static SearchCriteriaDTO searchCriteriaObject = new SearchCriteriaDTO();

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
	public static List<SearchResultDTO> findRecords(SearchCriteriaDTO searchCriteria) {
		searchCriteriaObject = searchCriteria == null ? searchCriteriaObject : searchCriteria;
		lastName = searchCriteria.lastName;
		birthNumber = searchCriteria.birthNumber;
		compRegNum = searchCriteria.compRegNum;
		assetNumber = searchCriteria.assetNumber;
		searchAmong = String.isBlank(searchCriteria.searchAmong) ? searchAmong : searchCriteria.searchAmong; //if searchAmong not provided, we use search among clients by default

		List<SearchResultDTO> finalResults = new List<SearchResultDTO>();

		//one of compRegNum, assetNumber and birthNumber needs to be filled in
		// if birthNumber is filled in, one of fistName or lastName needs to be filled in
		if (validateInputs()) {
			String query = getQueryString();
			List<SObject> searchResults = String.isNotBlank(query) ? runSosl(query) : new List<SObject>();
			if (searchResults.size() > 1 && searchResults.getSObjectType() == Account.sObjectType) {
				searchResults = getRelevantAccount(searchResults);
			}
			if (!searchResults.isEmpty()) {
				finalResults = getFilteredResults(searchResults);
			}
			if (finalResults.isEmpty()) {
				//if we do not find any result, we will change the scope of search if still possible or return empty list
				finalResults = callSearchAgainForDifferentScope();
			}
		}

		return finalResults;
	}

	public static List<Account> getRelevantAccount(List<Account> accounts) {
		List<Account> accountWithFalseCSOBSNonClient = new List<Account>();
		List<Account> accountWithTrueCSOBSNonClient = new List<Account>();
		for (Account acc : accounts) {
			if (acc.CSOBSNonClient__c == false) {
				accountWithFalseCSOBSNonClient.add(acc);
			} else {
				accountWithTrueCSOBSNonClient.add(acc);
			}
		}
		if (accountWithFalseCSOBSNonClient.size() > 0) {
			return accountWithFalseCSOBSNonClient;
		}
		return accountWithTrueCSOBSNonClient;
	}

	private static Boolean isActualUserAdmin() {
		Id actualUserProfileId = UserInfo.getProfileId();
		String actualUserProfileName = [SELECT Name FROM Profile WHERE Id = :actualUserProfileId].Name;
		return actualUserProfileName == 'System Administrator';
	}

	private static String getHiddenRecordsOwnerUserId() {
		Id hiddenRecordsOwnerId = [SELECT Id FROM User WHERE Name = 'Hidden Records Owner'].Id;
		return hiddenRecordsOwnerId;
	}
	@AuraEnabled
	public static void assignSearchAccess(String accountId) {
		User currentUser = UserDao.getUserById(UserInfo.getUserId());
		String sObjectName = Utils.getObjectNameByRecordId(accountId);

		AccessShareController.getSearchAccess(currentUser, accountId, sObjectName);
	}

	@AuraEnabled
	public static Boolean riskDetectionCallout(Id accountId, SearchCriteriaDTO searchCriteria) {
		Integer identificationType;
		System.debug('riskDetectionCallout -searchCriteria: ' + searchCriteria);
		if (searchCriteria.assetNumber != null) {
			identificationType = ASSET_IDENTIFICATION_TYPE;
		} else if (searchCriteria.compRegNum != null || searchCriteria.birthNumber != null) {
			identificationType = ACCOUNT_IDENTIFICATION_TYPE;
		} else {
			throw new AuraHandledException(Label.UnsupportedIdentificationType);
		}
		RiskDetectionService service = new RiskDetectionService(accountId, identificationType, null);
		RiskDetectionResponseDto riskDetectionResponseDto = service.callRiskDetectionService();
		System.debug('risk detection service response: ' + riskDetectionResponseDto);
		if (!riskDetectionResponseDto.isSuccess()) {
			service.logoutUser();
			return false;
		}

		return true;
	}

	/**
	 * @description method to validate whether the parametres of findRecords method are valid and @return true if valid, false if not
	 * @author Andrea Olexova
	 */
	@TestVisible
	private static Boolean validateInputs() {
		return ((String.isNotBlank(compRegNum) || String.isNotBlank(assetNumber) || String.isNotBlank(birthNumber)) &&
			(String.isNotBlank(lastName)));
	}

	/**
	 * @description method to build and @return complete text of the query to be used by SOSL search
	 * @author Andrea Olexova
	 */
	@TestVisible
	private static String getQueryString() {
		String query = '';
		String searchTerm = '';
		String returningString = '';

		searchTerm = getSearchTerm();
		returningString = getReturningString();

		if (String.isNotBlank(searchTerm) && String.isNotBlank(returningString)) {
			query = 'FIND ' + searchTerm + ' IN ALL FIELDS RETURNING ' + returningString;
		}

		return query;
	}

	/**
	 * @description method to build and @return search term for the sosl query
	 * @author Andrea Olexova
	 */
	@TestVisible
	private static String getSearchTerm() {
		String searchTerm = '\'';

		if (String.isNotBlank(birthNumber)) {
			searchTerm += birthNumber;
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
	@TestVisible
	private static final String ACCOUNT_OBJECT_STRING =
		ACCOUNT_SOBJECT +
			'(Id,PersonalIdentificationNr__c,CompanyRegistrationNumber__c,Name,FirstName,LastName,BillingCity,BillingPostalCode, IsPersonAccount, PersonEmail,CSOBSNonClient__c, CompanyEmail__c, AccountStatus__c,OwnerId, GlobalId__c WHERE ';
	@TestVisible
	private static final String LEAD_OBJECT_STRING =
		LEAD_SOBJECT + '(Id,FirstName,LastName,Name,Email,PersonalIdentificationNr__c,City,PostalCode)';
	@TestVisible
	private static final String ASSET_OBJECT_STRING =
		ASSET_SOBJECT +
			'(Id,Name,AccountId,Account.Name,Account.BillingCity,Account.BillingPostalCode,Account.PersonalIdentificationNr__c,Account.CompanyRegistrationNumber__c, Account.IsPersonAccount, Account.PersonEmail, Account.CompanyEmail__c, Account.GlobalId__c WHERE ';
	/**
	 * @description method to build and @return text to be used in the SOSL query after RETURNING keyword based on the sObject Type for which we need the string
	 * @author Andrea Olexova
	 */
	@TestVisible
	private static String getReturningString() {
		String whereCondition = String.isBlank(birthNumber) ? '' : 'IsPersonAccount = true' + ' AND ';
		whereCondition += String.isBlank(assetNumber) ? 'AccountStatus__c ' : 'Account.AccountStatus__c ';

		if (CLIENTS == searchAmong) {
			whereCondition += '= ';
		} else if (PROSPECTS == searchAmong) {
			whereCondition += '!= ';
		}
		whereCondition += '\'1\'';

		Boolean queryChildObject = String.isNotBlank(assetNumber) || searchAmong == LEADS;
		if (String.isNotBlank(LastName)) {
			whereCondition += queryChildObject
				? ' AND Account.LastName =\'' + LastName + '\''
				: ' AND LastName =\'' + LastName + '\'';
		}

		if (LEADS == searchAmong) {
			return LEAD_OBJECT_STRING;
		} else if (String.isNotBlank(assetNumber)) {
			return ASSET_OBJECT_STRING + whereCondition + ')';
		}
		return ACCOUNT_OBJECT_STRING + whereCondition + ')';
	}

	/**
	 * @description method to run SOSL search using @param query provided
	 * @return the first List<SObject> from the results of SOSL search - as we always search within one sobject type
	 * @author Andrea Olexova
	 */
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
	private static List<SearchResultDTO> getFilteredResults(List<SObject> searchResults) {
		Boolean isAdminUser = isActualUserAdmin();
		String hiddenRecordsOwnerUserId = getHiddenRecordsOwnerUserId();
		Boolean accessToRecord = true;
		List<SearchResultDTO> filteredResults = new List<SearchResultDTO>();
		if (searchResults != null && !searchResults.isEmpty()) {
			String sObjectType = String.valueOf(searchResults.get(0).getSObjectType());
			if (sObjectType.equalsIgnoreCase(ACCOUNT_SOBJECT)) {
				for (Account accountResult : (List<Account>) searchResults) {
					if (
						(String.isNotBlank(birthNumber) && birthNumber == accountResult.PersonalIdentificationNr__c) ||
							(String.isNotBlank(compRegNum) && compRegNum == accountResult.CompanyRegistrationNumber__c)
					) {
						if (
							accountResult.AccountStatus__c == '5' &&
								(accountResult.OwnerId == hiddenRecordsOwnerUserId) &&
								!isAdminUser
						) {
							accessToRecord = false;
						}

						String email = accountResult.isPersonAccount
							? accountResult.PersonEmail
							: accountResult.CompanyEmail__c;
						filteredResults.add(
							new SearchResultDTO(
								accessToRecord,
								accountResult.Id,
								null,
								accountResult.Name,
								accountResult.PersonalIdentificationNr__c,
								accountResult.CompanyRegistrationNumber__c,
								null,
								accountResult.BillingCity,
								accountResult.BillingPostalCode,
								email,
								accountResult.GlobalId__c,
								ACCOUNT_SOBJECT
							)
						);
					}
				}
			} else if (sObjectType.equalsIgnoreCase(ASSET_SOBJECT)) {
				for (Asset assetResult : (List<Asset>) searchResults) {
					if (
						String.isNotBlank(assetNumber) &&
							(assetNumber == assetResult.Name || assetResult.Name.startsWithIgnoreCase(assetNumber))
					) {
						String email = assetResult.Account.isPersonAccount
							? assetResult.Account.PersonEmail
							: assetResult.Account.CompanyEmail__c;
						filteredResults.add(
							new SearchResultDTO(
								null,
								assetResult.AccountId,
								assetResult.Id,
								assetResult.Account.Name,
								assetResult.Account.PersonalIdentificationNr__c,
								assetResult.Account.CompanyRegistrationNumber__c,
								assetResult.Name,
								assetResult.Account.BillingCity,
								assetResult.Account.BillingPostalCode,
								email,
								assetResult.Account.GlobalId__c,
								ASSET_SOBJECT
							)
						);
					}
				}
			} else if (sObjectType.equalsIgnoreCase(LEAD_SOBJECT)) {
				for (Lead leadResult : (List<Lead>) searchResults) {
					if (
						(String.isNotBlank(birthNumber) && birthNumber == leadResult.PersonalIdentificationNr__c) &&
							((String.isNotBlank(lastName) && leadResult.LastName.startsWithIgnoreCase(lastName)))
					) {
						filteredResults.add(
							new SearchResultDTO(
								null,
								leadResult.Id,
								null,
								leadResult.Name,
								leadResult.PersonalIdentificationNr__c,
								null,
								null,
								leadResult.City,
								leadResult.PostalCode,
								leadResult.Email,
								null,
								LEAD_SOBJECT
							)
						);
					}
				}
			}
		}
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
	private static List<SearchResultDTO> callSearchAgainForDifferentScope() {
		String searchAmongNewValue = '';
		if (CLIENTS == searchAmong) {
			searchAmongNewValue = PROSPECTS;
		} else if (PROSPECTS == searchAmong && String.isNotBlank(birthNumber)) {
			searchAmongNewValue = LEADS;
		}
		//we will check  whether it is filled and whether it is not CLIENTS, so we avoid having infinite loop
		if (String.isNotBlank(searchAmongNewValue) && CLIENTS != searchAmongNewValue) {
			searchCriteriaObject.searchAmong = searchAmongNewValue;
			return findRecords(searchCriteriaObject);
		}
		return null;
	}
}
