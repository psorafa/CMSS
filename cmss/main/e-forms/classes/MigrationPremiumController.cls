global class MigrationPremiumController {
	private static final String TYPE_INPUT_WITH_BACKGROUND_QUERY = 'Input With Background Query';
	private static final String TYPE_SELECT_WITH_BACKGROUND_QUERY = 'Select With Background Query';
	private static final String TYPE_MULTIPLE_INPUT_WITH_BACKGROUND_QUERY = 'Multiple Input With Background Query';
	private static final String TYPE_INPUT = 'Input parameters';
	private static final String TYPE_FORMULA = 'Formula';
	private static final String TYPE_INPUT_WITH_SOQL = 'Input with SOQL';
	@TestVisible
	private static final String TYPE_EXTERNAL_LINK = 'External Link';
	private static final String TYPE_HIDDEN = 'Hidden';
	private static final String TYPE_DATE = 'Date';
	@TestVisible
	private static final String SUBFLOW_CREATE_NEW_PROSPECT_TRANSACTION_ID = '202214';
	private static final String INVESTMENT_CALCULATOR_CONFIG_REC_TYPE = 'Investment_Calculator_Config';
	private static final String BASE_STR = 'Base';
	private static final String SUPL_STR = 'Supplement';
	private static final String THEME_STR = 'Theme';
	private static final String REGINV_STR = 'Regular Investment';
	private static final List<String> TYPE_LABELS = new List<String>{ BASE_STR, SUPL_STR, THEME_STR, REGINV_STR };
	private static final String MIGRATION_PROCESS_QUEUES_QUERY = 'SELECT Id,Case_subject__c,L2_CST_Value_ID__c,PR_Default_Name__c,Priority__c,PR_From_Product__c,Case_Branch_Data_ID__c,Case_Queue_Name__c FROM Migration_Process_Queues__r';
	private static final String DOCUMENT_CONFIGURATIONS_QUERY = 'SELECT Data_ID__c, Template_Code__c, Label_CZ__c, Label_EN__c, URL__c, Order__c, Message_Before_Print__c, Pre_contract_document__c, Biometric_Signature__c, Open_In_New_Window__c, Local_Upload__c FROM Document_Configurations__r ORDER BY Order__c ASC';
	private static final String MIGRATION_PROCESS_METADATA_QUERY =
		'SELECT Id, Save_for_Later__c, DeveloperName, Icon_Path__c, Do_Not_Create_a_Case__c, Do_Not_Load_PretermDoc_From_CST__c, Store_Last_Generated_Doc_To_JSK_OnSubmit__c, Title_CZ__c, Title_EN__c, New_Product_Button_SOQL__c, Assets_In_Migration_Data_ID__c, Show_Current_Account_Products__c, Hide_Remove_Buttons__c, Show_Configuration_Subtab__c, Final_Step_Validation__c, New_Subproduct_Button_SOQL__c,Case_Content__c, Case_Record_Type_Developer_Name__c, Case_Status__c, Send_To_BAW_After_Document_Pairing__c, Case_Subject__c, Case_Type__c, DMS_Document_Type_Data_ID__c, Representative_Relation_ID__c,Case_Branch_Data_Id__c, Product_Relation_Record_Type_Name__c, Sidebar_Main_Title_CZ__c,Sidebar_Main_Title_EN__c, Show_KC_Authenticator__c, Selected_Tab_Default__c,All_DMS_Document_IDs__c, Required_DMS_Document_IDs__c, Show_File_Selector__c,Show_General_Subtab__c, Left_Panel_Hidator__c, General_Subtab_CZ_Label__c, General_Subtab_EN_Label__c,Show_FO_Products_on_FOP__c, Show_FOP_Products_on_FO__c, Case_Queue_Name__c, Blacklisted_Products__c, Load_Parent_Product_Config__c,At_Least_One_Attachment_Is_Required__c, Hide_Transition_Subtab__c, Transition_Subtab_CZ_Label__c, Transition_Subtab_EN_Label__c,Configuration_Subtab_CZ_Label__c, Configuration_Subtab_EN_Label__c, Overview_Tab_CZ_Label__c, Overview_Tab_EN_Label__c,Configuration_Tab_CZ_Label__c, Configuration_Tab_EN_Label__c, Default_Selected_Products__c,Case_Sent_Message__c, Print_Button_Label__c, Use_Preterm_Document_List__c, Button_Generate_Label__c, Button_Send_Label__c, Assets_In_Migration_Data_ID_Read_only__c, Assets_In_Migration_Card_ID__c, Asset_From_Case__c, Assign_To_User__c, Assign_To_User_Always__c, Use_Already_Created_Case__c, Send_Output_On_Submit__c, Sent_OutputType__c, (' +
		DOCUMENT_CONFIGURATIONS_QUERY +
		') FROM Migration_Process__mdt';
	private static final String INNER_SOQL_SEPARATOR = '--soqlSeparator--';
	private static final String INNER_SOQL_ID_SEPARATOR = '--soqlIdSeparator--';
	private static final Map<String, String> PPF_TEMPLATE_CODE_MAP = new Map<String, String>{
		'2248' => 'ASSET_001CZ',
		'2252' => 'ASSET_002CZ',
		'2250' => 'ASSET_003CZ',
		'2251' => 'ASSET_005CZ',
		'2255' => 'ASSET_006CZ',
		'2249' => 'ASSET_007CZ',
		'2253' => 'ASSET_008CZ',
		'2257' => 'ASSET_013CZ',
		'2488' => 'ASSET_015CZ'
	};
	private static Integer prodCounter;
	private static List<Id> migrationProductIds = new List<Id>();
	private static Map<Id, Product2> migrationProductsMap;
	private static Object assetMerchFieldValue = '';
	private static Object accountMerchFieldValue = '';
	private static Object productMerchFieldValue = '';

	private String migrationProcessName;

	public static Map<String, String> typeTranslationMap {
		get {
			if (typeTranslationMap == null) {
				typeTranslationMap = new Map<String, String>();
				for (String t : TYPE_LABELS) {
					typeTranslationMap.put(t, getTransLabel('Product_Parameter__c', 'Type__c', t));
				}
			}
			return typeTranslationMap;
		}
		private set;
	}

	/*    public static String cstProdDocMapJSON {
        get {
            if (String.isBlank(cstProdDocMapJSON)) {
                cstProdDocMapJSON = JSON.serialize(cstProdDocMap);
            }
            return cstProdDocMapJSON;
        }
        private set;
    }*/

	/*//Bagetta
	public static String sipoId {
		get {
			if (String.isBlank(sipoId)) {
				sipoId = ISTS_Bagetta__c.getInstance('Sipo').Product_Parameter_Id__c;
			}
			return sipoId;
		}
		private set;
	}

	public static String duchodId {
		get {
			if (String.isBlank(duchodId)) {
				duchodId = ISTS_Bagetta__c.getInstance('Duchod').Product_Parameter_Id__c;
			}
			return duchodId;
		}
		private set;
	}

	public static String datumPodaniId {
		get {
			if (String.isBlank(datumPodaniId)) {
				datumPodaniId = ISTS_Bagetta__c.getInstance('Datum Podani').Product_Parameter_Id__c;
			}
			return datumPodaniId;
		}
		private set;
	}

	public static String bagettaDateId {
		get {
			if (String.isBlank(bagettaDateId)) {
				bagettaDateId = ISTS_Bagetta__c.getInstance('Bagetta Date').Product_Parameter_Id__c;
			}
			return bagettaDateId;
		}
		private set;
	}*/
	//Bagetta

	public static String baseUrl {
		get {
			if (String.isBlank(baseUrl)) {
				baseUrl = URL.getSalesforceBaseUrl().getHost();
			}
			return baseUrl;
		}
		private set;
	}

	/*    private static Map<String, List<cstProdDocWrapper>> cstProdDocMap {
        get {
            if (cstProdDocMap == null) {
                cstProdDocMap = new Map<String, List<cstProdDocWrapper>>();
                for (CST_Value__c cv : [SELECT Id, Related_Value__r.CST_Value_ID__c, Related_Value_2__r.CST_Value_ID__c, Related_Value_2__r.Multipurpose_Text_1__c, Related_Value_2__r.Czech_Full_Description__c FROM CST_Value__c WHERE CST_List_of_Values__r.CST_Code__c = '2225']) {
                    if (cstProdDocMap.containsKey(cv.Related_Value__r.CST_Value_ID__c)) {
                        cstProdDocMap.get(cv.Related_Value__r.CST_Value_ID__c).add(new cstProdDocWrapper(cv.Related_Value_2__r.CST_Value_ID__c, cv.Related_Value_2__r.Multipurpose_Text_1__c, cv.Related_Value_2__r.Czech_Full_Description__c));
                    } else {
                        List<cstProdDocWrapper> cl = new List<cstProdDocWrapper>();
                        cl.add(new cstProdDocWrapper(cv.Related_Value_2__r.CST_Value_ID__c, cv.Related_Value_2__r.Multipurpose_Text_1__c, cv.Related_Value_2__r.Czech_Full_Description__c));
                        System.debug('*** cstProdWrappers: ' + cl);
                        cstProdDocMap.put(cv.Related_Value__r.CST_Value_ID__c, cl);
                    }
                }
                System.debug('*** ALL MAP: ' + cstProdDocMap);
            }
            return cstProdDocMap;
        }
        private set;
    }*/

	/*    global class cstProdDocWrapper {
        global String cstValueId;
        global String guid;
        global String docDesc;
        global cstProdDocWrapper(String cstValueId, String guid, String docDesc) {
            this.cstValueId = cstValueId;
            this.guid = guid;
            this.docDesc = docDesc;
        }
    }*/

	public String caseIdFromPage { get; set; }

	public String originalCaseId { get; private set; }
	/*
    public String baseStr {
        get {
            return BASE_STR;
        }
        private set;
    }
    public String suplStr {
        get {
            return SUPL_STR;
        }
        private set;
    }
    public String themeStr {
        get {
            return THEME_STR;
        }
        private set;
    }
    public String reginvStr {
        get {
            return REGINV_STR;
        }
        private set;
    }*/

	/*    public String linkToScube {
        get {
            if (String.isBlank(linkToScube)) {
                linkToScube = Utils.getLinkToScube();
            }
            return linkToScube;
        }
        private set;
    }*/

	//    public Map<String, String> mapOfTerminationFeePerProduct{
	//        get{
	//            if(mapOfTerminationFeePerProduct == null){
	//                mapOfTerminationFeePerProduct = new Map<String, String>();
	//            }
	//            return mapOfTerminationFeePerProduct;
	//        }
	//        private set;
	//    }

	/*    public String linkToCRIF {
        get {
            if (String.isBlank(linkToCRIF)) {
                linkToCRIF = Utils.getLinkToCRIF();
            }
            return linkToCRIF;
        }
        private set;
    }*/

	/*    @TestVisible
    private static String accountCuid {
        get {
            if (String.isBlank(accountCuid) && theAccount != null) {
                accountCuid = theAccount.CUID__c;
            }
            return accountCuid;
        }
        set;
    }*/

	private static Set<String> typeOfRelation;

	private static final String SHOW_ALL = 'All';

	// Private properties
	private static String accountId { get; set; }

	private static User theUser {
		get {
			if (theUser == null) {
				theUser = [
					SELECT Id, Username, /* Preferred_Branch__c, Preferred_Branch_ID__c,*/ Profile.Name
					/*Organization_Unit_ID__c*/ FROM User
					WHERE Id = :UserInfo.getUserId()
					LIMIT 1
				];
			}
			return theUser;
		}
		set;
	}

	@TestVisible
	private static String theUserId {
		get {
			return UserInfo.getUserId();
		}
	}

	public String userName {
		get {
			return theUser.Username;
		}
	}

	public String mapOfReadOnlyProductsPerId {
		get {
			if (mapOfReadOnlyProductsPerId == null) {
				mapOfReadOnlyProductsPerId = '';
			}
			return mapOfReadOnlyProductsPerId;
		}
		set;
	}

	public Map<String, Boolean> mapOfProducts { get; set; }

	/*    public String userOrgUnitId {
        get {
            return theUser.Organization_Unit_ID__c;
        }
    }

    public boolean isWdeUser {
        get {
            return Utils.hasCustomPermission('Genesys_WDE_User');
        }
    }*/

	public Set<String> allDmsDocumentIdSet {
		get {
			if (allDmsDocumentIdSet == null) {
				if (!String.isBlank(migrationProcessConfiguration.All_DMS_Document_IDs__c)) {
					allDmsDocumentIdSet = new Set<String>(
						migrationProcessConfiguration.All_DMS_Document_IDs__c.split(';')
					);
				}
			}
			return allDmsDocumentIdSet;
		}
		set;
	}

	public Set<String> requiredDmsDocumentIdSet {
		get {
			if (requiredDmsDocumentIdSet == null) {
				if (!String.isBlank(migrationProcessConfiguration.Required_DMS_Document_IDs__c)) {
					requiredDmsDocumentIdSet = new Set<String>(
						migrationProcessConfiguration.Required_DMS_Document_IDs__c.split(';')
					);
				}
			}
			return requiredDmsDocumentIdSet;
		}
		set;
	}

	public Boolean requiredButtonMapIsNotEmpty {
		get {
			return requiredDmsDocumentIdSet != null && !requiredDmsDocumentIdSet.isEmpty();
		}
	}

	public Integer numOfDocumentsForPrint {
		get {
			if (numOfDocumentsForPrint == null) {
				if (
					migrationProcessConfiguration == null ||
					migrationProcessConfiguration.Document_Configurations__r == null ||
					migrationProcessConfiguration.Document_Configurations__r.isEmpty()
				) {
					numOfDocumentsForPrint = 0;
				} else {
					numOfDocumentsForPrint = migrationProcessConfiguration.Document_Configurations__r.size();
				}
			}
			return numOfDocumentsForPrint;
		}
		set;
	}

	public String firstTemplateCodeOfDmsDocument {
		get {
			if (String.isBlank(firstTemplateCodeOfDmsDocument)) {
				if (
					migrationProcessConfiguration != null &&
					!migrationProcessConfiguration.Document_Configurations__r.isEmpty()
				)
					firstTemplateCodeOfDmsDocument = migrationProcessConfiguration.Document_Configurations__r.get(0)
						.Template_Code__c;
			}
			return firstTemplateCodeOfDmsDocument;
		}
		set;
	}

	public String firstDataIdOfDmsDocument {
		get {
			if (String.isBlank(firstDataIdOfDmsDocument)) {
				if (
					migrationProcessConfiguration != null &&
					!migrationProcessConfiguration.Document_Configurations__r.isEmpty()
				)
					firstDataIdOfDmsDocument = migrationProcessConfiguration.Document_Configurations__r.get(0)
						.Data_ID__c;
			}
			return firstDataIdOfDmsDocument;
		}
		set;
	}

	public String metadataDocumentsJSON {
		get {
			if (
				String.isBlank(metadataDocumentsJSON) &&
				migrationProcessConfiguration != null &&
				!migrationProcessConfiguration.Document_Configurations__r.isEmpty()
			) {
				metadataDocumentsJSON = JSON.serialize(migrationProcessConfiguration.Document_Configurations__r);
			} else {
				metadataDocumentsJSON = '{}';
			}
			return metadataDocumentsJSON;
		}
		set;
	}

	public String firstMessageBeforePrint {
		get {
			if (String.isBlank(firstMessageBeforePrint)) {
				if (
					migrationProcessConfiguration != null &&
					!migrationProcessConfiguration.Document_Configurations__r.isEmpty()
				)
					firstMessageBeforePrint = migrationProcessConfiguration.Document_Configurations__r.get(0)
						.Message_Before_Print__c;
			}
			return firstMessageBeforePrint;
		}
		set;
	}

	public String firstUrlOfDmsDocument {
		get {
			if (String.isBlank(firstUrlOfDmsDocument)) {
				if (
					migrationProcessConfiguration != null &&
					!migrationProcessConfiguration.Document_Configurations__r.isEmpty()
				)
					firstUrlOfDmsDocument = migrationProcessConfiguration.Document_Configurations__r.get(0).URL__c;
			}
			return firstUrlOfDmsDocument;
		}
		set;
	}

	public Boolean bioSigns {
		get {
			if (
				migrationProcessConfiguration != null &&
				!migrationProcessConfiguration.Document_Configurations__r.isEmpty()
			) {
				for (Document_Configuration__mdt d : migrationProcessConfiguration.Document_Configurations__r) {
					if (d.Biometric_Signature__c) {
						return true;
					}
				}
			}
			return false;
		}
		set;
	}
	/*public Boolean localUploads {
		get {
			if (migrationProcessConfiguration != null && !migrationProcessConfiguration.Document_Configurations__r.isEmpty()) {
				for (Document_Configuration__mdt d : migrationProcessConfiguration.Document_Configurations__r) {
					if (d.Local_Upload__c) {
						return true;
					}
				}
			}
			return false;
		}
		set;
	}*/

	private Map<String, Boolean> printButtonMap {
		get {
			if (printButtonMap == null) {
				printButtonMap = new Map<String, Boolean>();
				if (requiredDmsDocumentIdSet != null) {
					for (String key : requiredDmsDocumentIdSet) {
						printButtonMap.put(key, false);
					}
				}
			}
			return printButtonMap;
		}
		set;
	}
	/*    public String printButtonMapJSON {
        get {
            System.debug(printButtonMap);
            return JSON.serialize(printButtonMap);
        }
    }*/

	/*    @TestVisible
    private static String userPreferredBranchId {
        get {
            if (userPreferredBranchId == null) {
                userPreferredBranchId = theUser.Preferred_Branch_ID__c;
            }
            return userPreferredBranchId;
        }
        set;
    }*/

	// Public properties
	global static Account theAccount {
		get {
			if (theAccount == null && String.isNotBlank(accountId)) {
				/*Migration_Process_General_SOQLs__c migrationSoql = Migration_Process_General_SOQLs__c.getValues('Migration Account');
				if (migrationSoql != null && String.isNotBlank(migrationSoql.SOQL__c)) {
					theAccount = Database.query(migrationSoql.SOQL__c);
				} else {*/
				theAccount = [
					SELECT Id, Name, FirstName, LastName, PersonalIdentificationNr__c
					FROM Account
					WHERE Id = :accountId
					LIMIT 1
				];
				//}
			}
			return theAccount;
		}
		set;
	}

	/*global static Asset migrationAsset {
		get {
			if (migrationAsset == null && String.isNotBlank(assetId)) {
				Migration_Process_General_SOQLs__c migrationSoql = Migration_Process_General_SOQLs__c.getValues('Migration Asset');
				if (migrationSoql != null && String.isNotBlank(migrationSoql.SOQL__c)) {
					migrationAsset = Database.query(migrationSoql.SOQL__c);
				} else {
					migrationAsset = [SELECT Id, External_ID__c FROM Asset WHERE Id = :assetId LIMIT 1];
				}
			}
			return migrationAsset;
		}
		set;
	}

	global static Product2 migrationProduct {
		get {
			if (migrationProduct == null && String.isNotBlank(product2Id)) {
				Migration_Process_General_SOQLs__c migrationSoql = Migration_Process_General_SOQLs__c.getValues('Migration Product');
				if (migrationSoql != null && String.isNotBlank(migrationSoql.SOQL__c)) {
					migrationProduct = Database.query(migrationSoql.SOQL__c);
				} else {
					migrationProduct = [SELECT Id, Name FROM Product2 WHERE Id = :product2Id LIMIT 1];
				}
			}
			return migrationProduct;
		}
		set;
	}*/

	global String editMode { get; set; }
	global static String caseFromEdit { get; set; }
	global static String assetId { get; set; }
	//global static String verificationAssetId { get; set; }
	global static String product2Id { get; set; }
	global MigrationPremiumTypes.ItemsWrapper allItems { get; set; }
	global MigrationPremiumTypes.ItemsWrapper selectedItems { get; set; }
	global Boolean savedConfiguration { get; set; }
	global Boolean pcfUnfinished {
		get {
			if (pcfUnfinished == null) {
				pcfUnfinished = false;
			}
			return pcfUnfinished;
		}
		private set;
	}
	global String savedProductRelationsData { get; set; }
	global String defaultNoteText { get; set; }
	global String selectedAssetMainElement { get; set; }
	global String selectedAssetChildElement { get; set; }
	global Boolean isCzech {
		get {
			if (isCzech == null) {
				isCzech = UserInfo.getLanguage() == 'cs' ? true : false;
			}
			return isCzech;
		}
		private set;
	}
	global String uniqueId {
		get {
			if (String.isBlank(uniqueId)) {
				uniqueId = EncodingUtil.convertToHex(
					Crypto.generateDigest('MD5', Blob.valueOf(Crypto.getRandomLong().format()))
				);
			}
			return uniqueId;
		}
		set;
	}
	/*global MigrationValidation.Result finalStepValidation {
		get {
			if (finalStepValidation == null) {
				if (savedConfiguration) {
					finalStepValidation = MigrationValidation.okResult();
					return finalStepValidation;
				}

				if (migrationProcessConfiguration.Final_Step_Validation__c == 'ELB' || (migrationProcessConfiguration.Final_Step_Validation__c == 'ELB + Email' && !pretermDocSwitch)) {
					system.debug('*** ' + theAccount);
					system.debug('*** ' + accountId);
					finalStepValidation = MigrationValidation.getElbErrorValidation(theAccount != null ? theAccount.Id : null, savedConfiguration, System.Label.Migration_Premium_ELB_Validation_Error);
				} else if (migrationProcessConfiguration.Final_Step_Validation__c == 'ELB + Electronical Statement Group') {
					finalStepValidation = MigrationValidation.getSavingAccountValidation(theAccount != null ? theAccount.Id : null, assetId, savedConfiguration, migrationProcessName);
				} else if (migrationProcessConfiguration.Final_Step_Validation__c == 'ELB + Email') {
					finalStepValidation = MigrationValidation.getElbEmailErrorValidation(theAccount != null ? theAccount.Id : null, savedConfiguration, System.Label.Migration_Premium_ELB_Validation_Error, System.Label.Migration_Premium_Email_Validation_Error);
				}
			}
			return finalStepValidation;
		}
		set;
	}*/

	public List<String> cancellatonValidation {
		get {
			if (cancellatonValidation == null) {
				cancellatonValidation = new List<String>();
			}
			return cancellatonValidation;
		}
		set;
	}

	/*global boolean isValid {
		get;
		set;
	}

	public String finalStepValEmail {
		get {
			if (finalStepValidation != null) {
				return finalStepValidation.email;
			}
			return null;
		}
		set;
	}

	public Integer finalStepValErrSize {
		get {
			return finalStepValidation == null || finalStepValidation.messageList == null ? 0 : finalStepValidation.messageList.size();
		}
		set;
	}*/

	public Boolean showElDistribAgreement {
		get {
			return showElDistribAgreement == null ? false : showElDistribAgreement;
		}
		set;
	}

	public Boolean elDistribAgreement {
		get {
			return elDistribAgreement == null || !showElDistribAgreement ? true : elDistribAgreement;
		}
		set;
	}

	//    global static Map<String, String> decryptedAssetNameByIdMap {get; set;}
	//    global static Map<String, String> decryptedAssetNumberByIdMap {get; set;}
	global static Map<String, String> assetNumberByIdMap { get; set; }
	global final string CONFIG = 'config';
	global Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> assetProductRelationMap {
		get {
			System.debug('assetProductRelationMap getter');
			if (assetProductRelationMap == null) {
				assetProductRelationMap = new Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>();
				Set<String> productIdSet = new Set<String>();
				for (MigrationPremiumTypes.Item theItem : selectedItems.itemMap.values()) {
					System.debug(theItem);
					System.debug(theItem.theProduct);
					productIdSet.add(theItem.theProduct.Id);
					if (theItem.childItemMap != null) {
						for (MigrationPremiumTypes.Item theChildItem : theItem.childItemMap.values()) {
							productIdSet.add(theChildItem.theProduct.Id);
						}
					}
				}
				List<Product_Relation__c> allProductRelationList = [
					SELECT
						Id,
						Default_Name__c,
						From__c,
						From__r.Name,
						/*From__r.CST_Value_ID__c,*/ To__r.Name,
						To__c,
						/*To__r.CST_Value_ID__c,*/ Is_Owner_Default__c,
						Is_Dispatcher_Default__c,
						Type__c,
						Record_Type_Name__c,
						Order__c
					FROM Product_Relation__c
					WHERE
						From__c = :productIdSet
						AND RecordType.DeveloperName = :migrationProcessConfiguration.Product_Relation_Record_Type_Name__c
						AND Product_Config_Type__c = :CONFIG
					ORDER BY Order__c
				];
				Map<String, List<Product_Relation__c>> productRelationPerProductMap = new Map<String, List<Product_Relation__c>>();
				for (Product_Relation__c theProductRelation : allProductRelationList) {
					if (
						theProductRelation.From__c == theProductRelation.To__c &&
						(migrationProcessConfiguration.DeveloperName != 'Account_Migration' ||
						theProductRelation.Type__c == 'Create')
					) {
						continue;
					}
					if (productRelationPerProductMap.containsKey(theProductRelation.From__c)) {
						productRelationPerProductMap.get(theProductRelation.From__c).add(theProductRelation);
					} else {
						List<Product_Relation__c> productRelationList = new List<Product_Relation__c>();
						productRelationList.add(theProductRelation);
						productRelationPerProductMap.put(theProductRelation.From__c, productRelationList);
					}
				}
				if (Test.isRunningTest())
					migrationProcessConfiguration.Load_Parent_Product_Config__c = true;
				if (migrationProcessConfiguration.Load_Parent_Product_Config__c) {
					Map<String, String> parentProductIdSet = new Map<String, String>();
					for (String productId : productIdSet) {
						for (MigrationPremiumTypes.Item theChildItem : selectedItems.itemMap.values()) {
							if (productId == theChildItem.theProduct.id) {
								/*if (theChildItem.theAsset.Product2.Product__c != null) {
									boolean b = false;
									if (!String.isBlank(migrationProcessConfiguration.Blacklisted_Products__c)) {
										for (String s : migrationProcessConfiguration.Blacklisted_Products__c.split(',')) {
											if (s == theChildItem.theAsset.Product2.Product__r.CST_Value_ID__c) {
												b = true;
											}
										}
										if (!b) {
											parentProductIdSet.put(productId, theChildItem.theAsset.Product2.Product__r.Id);
										}
									} else {
										parentProductIdSet.put(productId, theChildItem.theAsset.Product2.Product__r.Id);
									}
								}*/
							} else {
								/*for (MigrationPremiumTypes.Item childchild : theChildItem.childItemMap.values()) {
									if (childchild.theAsset.Product2Id == productId) {
										System.debug(migrationProcessConfiguration.Blacklisted_Products__c);
										if (!String.isBlank(migrationProcessConfiguration.Blacklisted_Products__c)) {
											boolean b = false;
											for (String s : migrationProcessConfiguration.Blacklisted_Products__c.split(',')) {
												if (s == childchild.theProduct.CST_Value_ID__c) {
													b = true;
												}
											}
											if (!b) {
												parentProductIdSet.put(productId, childchild.theAsset.Product2.Product__r.Id);
											}
										} else {
											parentProductIdSet.put(productId, childchild.theAsset.Product2.Product__r.Id);
										}
									}
								}*/
							}
						}
					}
					Map<String, List<Product_Relation__c>> allParentProductRelationList = new Map<String, List<Product_Relation__c>>();
					if (!parentProductIdSet.isEmpty()) {
						for (Product_Relation__c p : [
							SELECT
								Id,
								Default_Name__c,
								From__c,
								From__r.Name,
								/* From__r.CST_Value_ID__c,*/ To__r.Name,
								To__c,
								/*To__r.CST_Value_ID__c,*/ Is_Owner_Default__c,
								Is_Dispatcher_Default__c,
								Type__c,
								Record_Type_Name__c,
								Order__c
							FROM Product_Relation__c
							WHERE
								From__c = :parentProductIdSet.values()
								AND RecordType.DeveloperName = :migrationProcessConfiguration.Product_Relation_Record_Type_Name__c
								AND Product_Config_Type__c = :CONFIG
							ORDER BY Order__c
						]) {
							if (allParentProductRelationList.get(p.From__c) != null) {
								allParentProductRelationList.get(p.From__c).add(p);
							} else {
								List<Product_Relation__c> prList = new List<Product_Relation__c>();
								prList.add(p);
								allParentProductRelationList.put(p.From__c, prList);
							}
						}
					}
					if (!allParentProductRelationList.isEmpty()) {
						for (String prodID : productIdSet) {
							if (productRelationPerProductMap.containsKey(prodID)) {
								continue;
							} else {
								List<Product_Relation__c> productRelationList = new List<Product_Relation__c>();
								if (
									parentProductIdSet.containsKey(prodID) &&
									allParentProductRelationList.containsKey(parentProductIdSet.get(prodID))
								) {
									productRelationList.addAll(
										allParentProductRelationList.get(parentProductIdSet.get(prodID))
									);
									productRelationPerProductMap.put(prodID, productRelationList);
								}
							}
						}
					}
				}

				for (MigrationPremiumTypes.Item theItem : selectedItems.itemMap.values()) {
					Integer j = 0;
					Map<String, MigrationPremiumTypes.TransitionItem> productParameterGroupMap = new Map<String, MigrationPremiumTypes.TransitionItem>();
					MigrationPremiumTypes.TransitionItem theTransitionItem = new MigrationPremiumTypes.TransitionItem();
					theTransitionItem.productName = theItem.theProduct.Name;
					theTransitionItem.productId = theItem.theProduct.Id;
					//theTransitionItem.setAssetId(theItem.getAssetId());
					/*if(productRelationPerProductMap.get(theItem.theProduct.Id) != null){
						if(productRelationPerProductMap.get(theItem.theProduct.Id).get(0).From__r.CST_Value_ID__c == '551-294'){ //OS: change Owner_Defaut__c logic for kontokorent
							for(Product_Relation__c pr : productRelationPerProductMap.get(theItem.theProduct.Id)){
								pr.Is_Owner_Default__c = false;
							}
							if(theItem.theAsset.Expiry_Date__c != null || theItem.theAsset.Limit_Amount__c == 0){
								for(Product_Relation__c pr : productRelationPerProductMap.get(theItem.theProduct.Id)){
									if(pr.Name == 'PR-691'){
										pr.Is_Owner_Default__c = true;
									}
								}
							}else if(theItem.theAsset.GTDUE__c != null){
								for(Product_Relation__c pr : productRelationPerProductMap.get(theItem.theProduct.Id)) {
									if (pr.Name == 'PR-690') {
										pr.Is_Owner_Default__c = true;
									} else {
										pr.Is_Owner_Default__c = true;
									}
								}
							}else{
								if(theItem.theAsset.Limit_Amount__c > 999){
									String prForLimit = roundToThousandAndSelectRelation(theItem.theAsset.Limit_Amount__c, theItem.theAsset.Quantity_in_Base_Currency__c);
									for(Product_Relation__c pr : productRelationPerProductMap.get(theItem.theProduct.Id)){
										if(pr.Name == prForLimit){
											pr.Is_Owner_Default__c = true;
										}
									}
								}else{
									//todo
								}
							}
						}
					}*/
					theTransitionItem.productRelationList = productRelationPerProductMap.get(theItem.theProduct.Id);
					theTransitionItem.isCard = false;
					//theTransitionItem.isOwner = (theItem.theAsset == null || theItem.theAsset.AccountId == (theAccount != null ? theAccount.Id : null));
					/*if (!theTransitionItem.isOwner) {
						theTransitionItem.disponentText = getDisponentTextFromAsset(theItem.theAsset);
						system.debug('load1');
					}*/
					productParameterGroupMap.put(j + '-' + theItem.theProduct.Id, theTransitionItem);
					if (theItem.getAssetId() == assetId) {
						System.debug('match');
						selectedAssetMainElement = theItem.index + '-' + theItem.theProduct.Id;
						selectedAssetChildElement = j + '-' + theItem.theProduct.Id;
						System.debug(selectedAssetMainElement);
						System.debug(selectedAssetChildElement);
					}
					/*if (theItem.theAsset != null) {
						theTransitionItem.assetBankSystem = theItem.theAsset.Bank_System__c;
					}*/
					if (theItem.childItemMap != null) {
						for (MigrationPremiumTypes.Item childItem : theItem.childItemMap.values()) {
							System.debug('===>> ' + childItem);
							j++;
							MigrationPremiumTypes.TransitionItem theTransitionItemChild = new MigrationPremiumTypes.TransitionItem();
							theTransitionItemChild.productName = childItem.Name;
							theTransitionItemChild.productId = theItem.theProduct.Id;
							//theTransitionItemChild.setAssetId(childItem.getAssetId());
							theTransitionItemChild.productRelationList = productRelationPerProductMap.get(
								childItem.theProduct.Id
							);
							//theTransitionItemChild.isOwner = (childItem.theAsset != null && childItem.theAsset.AccountId == (theAccount != null ? theAccount.Id : null));
							theTransitionItemChild.isCard = true;
							//theTransitionItemChild.setParrentAccNumber(theItem.getAssetId());
							/*if (!theTransitionItemChild.isOwner) {
								theTransitionItemChild.disponentText = getDisponentTextFromAsset(childItem.theAsset);
								system.debug('load2');
							}*/
							/*if (childItem.theAsset != null) {
								theTransitionItem.assetBankSystem = childItem.theAsset.Bank_System__c;
							}*/
							productParameterGroupMap.put(j + '-' + childItem.theProduct.Id, theTransitionItemChild);
						}
					}
					assetProductRelationMap.put(theItem.index + '-' + theItem.theProduct.Id, productParameterGroupMap);
				}
				if (generalProductRelationMap != null && !generalProductRelationMap.isEmpty()) {
					assetProductRelationMap.put('GENERAL', generalProductRelationMap);
				}
			}
			return assetProductRelationMap;
		}
		set;
	}

	global Map<String, MigrationPremiumTypes.TransitionItem> generalProductRelationMap {
		get {
			if (generalProductRelationMap == null) {
				generalProductRelationMap = new Map<String, MigrationPremiumTypes.TransitionItem>();
				List<Product_Relation__c> generalProductRelationList = [
					SELECT Id, Default_Name__c, Order__c
					FROM Product_Relation__c
					WHERE
						RecordType.DeveloperName = :migrationProcessConfiguration.Product_Relation_Record_Type_Name__c
						AND From__c = NULL
						AND To__c = NULL
					ORDER BY Order__c
				];
				for (Product_Relation__c theRelation : generalProductRelationList) {
					MigrationPremiumTypes.TransitionItem theTransitionItem = new MigrationPremiumTypes.TransitionItem();
					theTransitionItem.productName = 'NAME';
					theTransitionItem.isCard = false;
					//theTransitionItemChild.productId = theItem.theProduct.Id;
					//theTransitionItemChild.setAssetId(childItem.getAssetId());
					List<Product_Relation__c> relationList = new List<Product_Relation__c>();
					relationList.add(theRelation);
					theTransitionItem.productRelationList = relationList;
					generalProductRelationMap.put(theRelation.Id, theTransitionItem);
				}
			}
			return generalProductRelationMap;
		}
		set;
	}

	global String assetProductRelationMapJSON {
		get {
			if (selectedItems != null && assetProductRelationMap != null) {
				return JSON.serialize(assetProductRelationMap);
			} else {
				return '{}';
			}
		}
	}
	global String selectedItemsWrapperJSON {
		get {
			if (selectedItems == null) {
				return '{}';
			}
			return JSON.serialize(selectedItems).replace('\'', '&apos;');
		}
	}
	global String allItemsJSON {
		get {
			if (allItems == null) {
				return '{}';
			}
			return JSON.serialize(allItems).replace('\'', '&apos;');
		}
	}
	global static List<Product2> productsTosHow { get; set; }
	global List<Product2> debetCardsList {
		get {
			if (
				debetCardsList == null && !String.isBlank(migrationProcessConfiguration.New_Subproduct_Button_SOQL__c)
			) {
				debetCardsList = Database.query(migrationProcessConfiguration.New_Subproduct_Button_SOQL__c);
			} else if (debetCardsList == null) {
				debetCardsList = new List<Product2>();
			}
			return debetCardsList;
		}
		set;
	}

	global Migration_Process__mdt migrationProcessConfiguration { get; set; }
	global Boolean pretermDocSwitch { get; set; }

	// private properties

	global MigrationPremiumController() {
		savedConfiguration = false;
		migrationProcessName = ApexPages.currentPage().getParameters().get('migration_process');
		accountId = ApexPages.currentPage().getParameters().get('accountId');
		system.debug('***XXX ' + migrationProcessName);
		system.debug('***XXX ' + ApexPages.currentPage().getParameters().get('accountId'));
		assetId = ApexPages.currentPage().getParameters().get('assetId');
		if (String.isBlank(accountId) && String.isNotBlank(assetId)) {
			List<Asset> al = [SELECT AccountId FROM Asset WHERE Id = :assetId];
			if (!al.isEmpty()) {
				accountId = al.get(0).AccountId;
			}
		}

		//verificationAssetId = ApexPages.currentPage().getParameters().get('ver_assetId');
		String caseId = ApexPages.currentPage().getParameters().get('caseId');
		caseIdFromPage = caseId;
		Case theCase;
		if (String.isNotBlank(caseId)) {
			theCase = [
				SELECT
					Id,
					AccountId,
					Migration_Premium_Product_List_Conf__c,
					Migration_Premium_Product_Relations_Conf__c,
					Description,
					PCF_Unfinished__c,
					Type_of_Process__c
				FROM Case
				WHERE Id = :caseId
				LIMIT 1
			];
			migrationProcessName = theCase.Type_of_Process__c;
		}
		originalCaseId = ApexPages.currentPage().getParameters().get('originalCaseId');
		//String productId = ApexPages.currentPage().getParameters().get('productId');
		System.debug(ApexPages.currentPage().getParameters());
		System.debug(migrationProcessName);
		migrationProcessConfiguration = getProcessConfigurationByName(migrationProcessName);
		System.debug(migrationProcessConfiguration);
		pretermDocSwitch = this.migrationProcessConfiguration.Use_Preterm_Document_List__c;
		System.debug('*** pretermDocSwitch: ' + pretermDocSwitch);
		System.debug(
			'*** migrationProcessConfiguration.Representative_Relation_ID__c: ' +
			migrationProcessConfiguration.Representative_Relation_ID__c
		);
		typeOfRelation = getSetFromStringCommaDelimited(migrationProcessConfiguration.Representative_Relation_ID__c);
		editMode = ApexPages.currentPage().getParameters().get('edit');
		if (String.isBlank(migrationProcessConfiguration.New_Product_Button_SOQL__c)) {
			productsTosHow = new List<Product2>();
		} else {
			productsTosHow = Database.query(migrationProcessConfiguration.New_Product_Button_SOQL__c);
		}
		selectedItems = new MigrationPremiumTypes.ItemsWrapper();
		selectedItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();

		/*if (!String.isBlank(productId)) {
			system.debug('prod');
			Product2 theProduct = [SELECT Id, Name, Subproduct_SOQL__c, CST_Value_ID__c,Product2.Product__r.Id FROM Product2 WHERE Id = :productId];
			allItems = new MigrationPremiumTypes.ItemsWrapper();
			allItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
			selectedItems = new MigrationPremiumTypes.ItemsWrapper();
			selectedItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
			addProductToAllAndSelectedMap(theProduct, accountId, 0);
		} else if (String.isNotBlank(assetId) || String.isBlank(caseId)) {
			system.debug('asset');
			Set<String> assetDataIdList;
			if (!String.isBlank(migrationProcessConfiguration.Assets_In_Migration_Data_ID__c)) {
				assetDataIdList = new Set<String>(migrationProcessConfiguration.Assets_In_Migration_Data_ID__c.split(';'));
			}
			System.debug('assetDataIdList: ' + assetDataIdList);

			Set<Id> accountIds = new Set<Id>();
			if (theAccount != null) {
				accountIds.add(theAccount.Id);
			}

			if (migrationProcessConfiguration.Show_FO_Products_on_FOP__c && theAccount != null && String.isNotBlank(theAccount.Related_FO__c)) {
				accountIds.add(theaccount.Related_FO__c);
			} else if (migrationProcessConfiguration.Show_FOP_Products_on_FO__c && theAccount != null && String.isBlank(theAccount.Related_FO__c)) {
				List<Account> fopAccountList = [SELECT Id FROM Account WHERE Related_FO__c = :theAccount.Id LIMIT 1];
				if (fopAccountList != null && !fopAccountList.isEmpty()) {
					accountIds.add(fopAccountList.get(0).Id);
				}
			}

			String assetBaseQuery = 'SELECT Id,Product2Id, Card_Status__c, Product2.Product__c, Product2.Product__r.CST_Value_ID__c, Product2.CST_Value_ID__c, Product2.Name, AccountId, Account.Name, Account.CUID__c, Account_Number__c, Bank_System__c, Brand__c, Expiry_Date__c, GTDUE__c, Limit_Amount__c, Quantity_in_Base_Currency__c, (' +
					'SELECT Id, Name, Product2.Name, AccountId, Card_Status__c, Account.Name, Account.CUID__c, Account_Number__c, Bank_System__c, Product2.Product__r.Id, Product2.CST_Value_ID__c, Product2.Product__r.CST_Value_ID__c, Brand__c' +
					' FROM Assets__r' +
					' WHERE Status_ID__c = \'1\'' +
					' AND (Product2.Product__r.CST_Value_ID__c = :assetDataIdList)' +
					')' +
					' FROM Asset';
			if (migrationProcessConfiguration.Asset_From_Case__c) {
				assetBaseQuery += ' WHERE Id =: assetId';
			} else {
				assetBaseQuery += ' WHERE AccountId IN :accountIds';
				assetBaseQuery += ' AND (Product2.Product__r.CST_Value_ID__c = :assetDataIdList) AND Parent_Asset__c = null AND Status_ID__c = \'1\'';
			}
			List<Asset> assetList = Database.query(assetBaseQuery);

			System.debug(assetList);
			Map<String, Asset> assetMap = new Map<String, Asset>(assetList);
			// method adding all the name related to the dispatcher account to the Map.
			// This map is using in the methods which are responsible for creatin of dispatcher text/wrapper
//            addAllDecryptedDispatcherAssetsName(assetList, accountId);
			addAllAssetsNumber(assetList);

			Set<String> defaultSelectedProductSet = new Set<String>();
			Map<String, String> defaultSelectedProductOnlyForBranchMap = new Map<String, String>();
			if (!String.isBlank(migrationProcessConfiguration.Default_Selected_Products__c)) {
				defaultSelectedProductSet = new Set<String>(migrationProcessConfiguration.Default_Selected_Products__c.split(';'));
				for (String p : defaultSelectedProductSet) {
					System.debug('*** processing p: ' + p);
					if (p.contains(':')) {
						List<String> parts = p.split(':');
						defaultSelectedProductSet.remove(p);
						p = parts.get(0);
						defaultSelectedProductOnlyForBranchMap.put(p, parts.get(1));
						defaultSelectedProductSet.add(p);
					}
				}
			}

			System.debug('*** defaultSelectedProductOnlyForBranchMap: ' + defaultSelectedProductOnlyForBranchMap);
			System.debug('*** defaultSelectedProductSet: ' + defaultSelectedProductSet);
			//for(Default_Selected_Products_In_Migration__c theItem : Default_Selected_Products_In_Migration__c.getAll().values()){
			//    defaultSelectedProductSet.add(theItem.Value__c);
			//}
			allItems = new MigrationPremiumTypes.ItemsWrapper();
			allItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
			selectedItems = new MigrationPremiumTypes.ItemsWrapper();
			selectedItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
			Integer i = 0;
			System.debug('*** Assets!: ' + assetList);
			String theAssetBrand = '';
			for (Asset theAsset : assetList) {
				System.debug(theAsset);
				System.debug(defaultSelectedProductSet.contains(theAsset.Product2.CST_Value_ID__c));
//                if (defaultSelectedProductSet.contains(theAsset.Product2.CST_Value_ID__c)) {
				migrationProductIds.add(theAsset.Product2Id);
//                }
				if (assetId == theAsset.Id) {
					theAssetBrand = theAsset.Brand__c;
				}
			}
			migrationProductsMap = new Map<Id, Product2>([SELECT Id, Subproduct_SOQL__c, CST_Value_ID__c FROM Product2 WHERE Id IN :migrationProductIds]);
			if (String.isNotBlank(assetId)) {
				Id assetObjectId = Id.valueOf(assetId);
				if (assetMap != null) {
					if (assetMap.containsKey(assetId)) {
						addToAllAndSelectedMap(assetMap.get(assetId), accountId, i);
						i++;
					} else if (assetMap.containsKey((String) assetObjectId)) {
						addToAllAndSelectedMap(assetMap.get((String) assetObjectId), accountId, i);
						i++;
					}
				}
			}
			for (Asset theAsset : assetList) {
				System.debug('*** ASSET: ');
				System.debug(theAsset.Id);
				if (assetId == theAsset.Id) {
					continue;
				}
				if (defaultSelectedProductSet.contains(theAsset.Product2.CST_Value_ID__c) && (!defaultSelectedProductOnlyForBranchMap.containsKey(theAsset.Product2.CST_Value_ID__c) || defaultSelectedProductOnlyForBranchMap.get(theAsset.Product2.CST_Value_ID__c) == theAssetBrand)) {
					System.debug('*** SELECTED');
					addToAllAndSelectedMap(theAsset, accountId, i);
				} else {
					System.debug('*** ALL');
					addToAllMap(theAsset, accountId, i);
				}
				i++;
			}
			system.debug('allItems.itemMap: ' + allItems.itemMap);
			system.debug('selectedItems: ' + selectedItems);
			system.debug('selectedItems.itemMap: ' + selectedItems.itemMap);
		} else */ if (
			String.isNotBlank(caseId)
		) {
			system.debug('case');
			if (!theCase.PCF_Unfinished__c) {
				if (editMode == '1') {
					pcfUnfinished = true;
				} else {
					savedConfiguration = true;
				}
			} else {
				pcfUnfinished = true;
			}
			system.debug('case ' + theCase);
			system.debug('pcfUnfinished ' + pcfUnfinished);
			system.debug('savedConfiguration ' + savedConfiguration);
			system.debug(
				'theCase.Migration_Premium_Product_List_Conf__c ' + theCase.Migration_Premium_Product_List_Conf__c
			);
			accountId = theCase.AccountId;
			//theAccount = [SELECT Id, Name, CUID__c FROM Account WHERE Id = :theCase.AccountId LIMIT 1];
			//accountCuid = theAccount != null ? theAccount.CUID__c : null;
			selectedItems = (MigrationPremiumTypes.ItemsWrapper) JSON.deserialize(
				theCase.Migration_Premium_Product_List_Conf__c,
				MigrationPremiumTypes.ItemsWrapper.class
			);
			//Map<String, Boolean> mapOfIdsPerBoolean = new Map<String, Boolean>();
			mapOfProducts = new Map<String, Boolean>();
			/*            if (pcfUnfinished && migrationProcessConfiguration.DeveloperName == 'Account_Cancellation') {
                List<MigrationPremiumTypes.CancellationInfo> infoList = (List<MigrationPremiumTypes.CancellationInfo>) JSON.deserialize(theCase.Case_Cancellation_Info__c, List<MigrationPremiumTypes.CancellationInfo>.class);
                for (MigrationPremiumTypes.CancellationInfo theCancel : infoList) {
                    boolean moreThanFiveDays = false;
                    system.debug('theCancel: ' + theCancel);
                    String dateFromConfiguration = theCancel.dateOfCancellation;
                    List<String> listOFSplittedDate = dateFromConfiguration.split('\\.');
                    system.debug('lsit: ' + listOFSplittedDate);
                    Date dateToCompare = Date.newInstance(Integer.valueOf(listOFSplittedDate[2]), Integer.valueOf(listOFSplittedDate[1]), Integer.valueOf(listOFSplittedDate[0]));
                    Integer daysDifference = dateToCompare.daysBetween(Date.today().addDays(5));
                    if (daysDifference < 5 && daysDifference < 0) {
                        moreThanFiveDays = true;
                        mapOfProducts.put(theCancel.id, moreThanFiveDays);
                    } else {
                        mapOfProducts.put(theCancel.id, moreThanFiveDays);
                    }
                }
            }*/
			if (!mapOfProducts.isEmpty()) {
				mapOfReadOnlyProductsPerId = JSON.serialize(mapOfProducts);
			} else {
				mapOfReadOnlyProductsPerId = '';
			}
			/*if (String.isNotBlank(verificationAssetId)) {
				for (String i : selectedItems.itemMap.keySet()) {
					MigrationPremiumTypes.Item item = selectedItems.itemMap.get(i);
					if (item.theAsset.Id != verificationAssetId) {
						selectedItems.itemMap.remove(i);
					}
				}
			} else {
				selectedAssetMainElement = getAssetElementsForReadOnlyMode(selectedItems);
				selectedAssetChildElement = selectedAssetMainElement;
			}*/
			//assetId = getAssetIdForReadOnlyMode(selectedItems);
			System.debug(selectedItems);
			System.debug(JSON.serialize(selectedItems));
			//pairAssetIdToAssetAccountNumber(selectedItems);
			/*System.debug(selectedItems);
			 System.debug(JSON.serialize(selectedItems));*/
			String prConf = theCase.Migration_Premium_Product_Relations_Conf__c;
			String elDistribAgreementStr = prConf.substringAfterLast('}');
			if (String.isNotBlank(elDistribAgreementStr)) {
				if (elDistribAgreementStr == '1') {
					showElDistribAgreement = true;
					prConf = prConf.removeEnd('1');
				} else if (elDistribAgreementStr == '2') {
					showElDistribAgreement = true;
					prConf = prConf.removeEnd('2');
					elDistribAgreement = false;
				} else {
					prConf = prConf.removeEnd('0');
				}
			} else {
				Map<String, Product_Parameter__c> elDistribAgreementPPMap = new Map<String, Product_Parameter__c>(
					[SELECT Id FROM Product_Parameter__c WHERE ISTS_Element_Name__c = 'docDistAgreement']
				);
				Set<String> elDistribAgrPPSet = elDistribAgreementPPMap.keySet();
				for (String s : elDistribAgrPPSet) {
					if (prConf.contains(s)) {
						showElDistribAgreement = true;
					}
				}
			}
			assetProductRelationMap = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>) JSON.deserialize(
				prConf,
				Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class
			);
			savedProductRelationsData = prConf;
			//defaultNoteText = String.isBlank(theCase.Description) ? theCase.Description : String.escapeSingleQuotes(theCase.Description.stripHtmlTags());
			defaultNoteText = theCase.Description;

			/*System.debug('Pred needitmode ifem pro ruseni');
			if (editMode != '1' && migrationProcessConfiguration.DeveloperName == 'Account_Cancellation') {
				System.debug('Ruseni needitmode if');
				Set<String> defaultSelectedProductSet = new Set<String>();
				Map<String, String> defaultSelectedProductOnlyForBranchMap = new Map<String, String>();
				if (!String.isBlank(migrationProcessConfiguration.Default_Selected_Products__c)) {
					defaultSelectedProductSet = new Set<String>(migrationProcessConfiguration.Default_Selected_Products__c.split(';'));
					for (String p : defaultSelectedProductSet) {
						System.debug('*** processing p: ' + p);
						if (p.contains(':')) {
							List<String> parts = p.split(':');
							defaultSelectedProductSet.remove(p);
							p = parts.get(0);
							defaultSelectedProductOnlyForBranchMap.put(p, parts.get(1));
							defaultSelectedProductSet.add(p);
						}
					}
				}
				Set<String> assetDataIdList;
				if (!String.isBlank(migrationProcessConfiguration.Assets_In_Migration_Data_ID__c)) {
					assetDataIdList = new Set<String>(migrationProcessConfiguration.Assets_In_Migration_Data_ID__c.split(';'));
				}
				System.debug('assetDataIdList: ' + assetDataIdList);

				Set<Id> accountIds = new Set<Id>();
				if (theAccount != null) {
					accountIds.add(theAccount.Id);
				}

				if (migrationProcessConfiguration.Show_FO_Products_on_FOP__c && theAccount != null && String.isNotBlank(theAccount.Related_FO__c)) {
					accountIds.add(theaccount.Related_FO__c);
				} else if (migrationProcessConfiguration.Show_FOP_Products_on_FO__c && theAccount != null && String.isBlank(theAccount.Related_FO__c)) {
					List<Account> fopAccountList = [SELECT Id FROM Account WHERE Related_FO__c = :theAccount.Id LIMIT 1];
					if (fopAccountList != null && !fopAccountList.isEmpty()) {
						accountIds.add(fopAccountList.get(0).Id);
					}
				}
				List<Asset> assetList = [
						SELECT Id,Product2Id, Card_Status__c, Product2.Product__c, Product2.Product__r.CST_Value_ID__c, Product2.CST_Value_ID__c, Product2.Name, AccountId, Account.Name, Account.CUID__c, Account_Number__c, Bank_System__c, Brand__c, Expiry_Date__c, GTDUE__c, Limit_Amount__c, Quantity_in_Base_Currency__c, (
								SELECT Id, Name, Product2.Name, AccountId, Card_Status__c, Account.Name, Account.CUID__c, Account_Number__c, Bank_System__c, Product2.Product__r.Id, Product2.CST_Value_ID__c, Product2.Product__r.CST_Value_ID__c, Brand__c
								FROM Assets__r
								WHERE Status_ID__c = '1'
								AND (Product2.Product__r.CST_Value_ID__c = :assetDataIdList)
						)
						FROM Asset
						WHERE AccountId IN :accountIds
						AND (Product2.Product__r.CST_Value_ID__c = :assetDataIdList) AND Parent_Asset__c = null AND Status_ID__c = '1'
				];
				if (!Test.isRunningTest()) {
//                    addAllDecryptedDispatcherAssetsName(assetList, accountId);
					addAllAssetsNumber(assetList);
				}
				Integer i = 0;

				System.debug(assetList);
				allItems = new MigrationPremiumTypes.ItemsWrapper();
				allItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
				//selectedItems = new MigrationPremiumTypes.ItemsWrapper();
				// selectedItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
				String theAssetBrand = '';
				for (Asset theAsset : assetList) {
					System.debug(theAsset);
					System.debug(defaultSelectedProductSet.contains(theAsset.Product2.CST_Value_ID__c));
//                if (defaultSelectedProductSet.contains(theAsset.Product2.CST_Value_ID__c)) {
					migrationProductIds.add(theAsset.Product2Id);
//                }
					if (assetId == theAsset.Id) {
						theAssetBrand = theAsset.Brand__c;
					}
//                    //CRMCNCP-8051
//                    if (theAsset.Account.Name != null) {
//                        theAsset.Account.Name = theAsset.Account.Name.escapeHtml4();
//                    }
				}
				for (Asset theAsset : assetList) {
					System.debug('*** ASSET: ');
					System.debug(theAsset.Id);
					if (assetId == theAsset.Id) {
						continue;
					}
					if (defaultSelectedProductSet.contains(theAsset.Product2.CST_Value_ID__c) && (!defaultSelectedProductOnlyForBranchMap.containsKey(theAsset.Product2.CST_Value_ID__c) || defaultSelectedProductOnlyForBranchMap.get(theAsset.Product2.CST_Value_ID__c) == theAssetBrand)) {
						System.debug('*** SELECTED');

						MigrationPremiumTypes.Item theItem;
						system.debug('migrationProductsMap: ' + migrationProductsMap);
						system.debug('theAsset.Product2Id: ' + theAsset.Product2Id);
						system.debug('migrationProductsMap.get(theAsset.Product2Id): ' + migrationProductsMap.get(theAsset.Product2Id));
						Boolean hasSubProducts = migrationProductsMap.containsKey(theAsset.Product2Id) && String.isNotBlank(migrationProductsMap.get(theAsset.Product2Id).Subproduct_SOQL__c) ? true : false;
						System.debug('*** hasSubProducts (' + theAsset.Product2Id + '): ' + hasSubProducts);
						if (selectedItems.itemMap.isEmpty()) {
							theItem = new MigrationPremiumTypes.Item(migrationProcessConfiguration, hasSubProducts, theAsset, true, i, true);
						} else {
							theItem = new MigrationPremiumTypes.Item(migrationProcessConfiguration, hasSubProducts, theAsset, true, i);
						}
						Integer j = 0;
						for (Asset childAsset : theAsset.Assets__r) {
							theItem.childItemMap.put(j + '-' + childAsset.Product2Id, new MigrationPremiumTypes.Item(migrationProcessConfiguration, childAsset, accountId, j));
							j++;
						}
						selectedItems.itemMap.put(i + '-' + theAsset.Product2Id, theItem);
						allItems.itemMap.put(i + '-' + theAsset.Product2Id, theItem);
						//addToAllAndSelectedMap(theAsset, accountId, i);
					} else {
						System.debug('*** ALL');
						addToAllMap(theAsset, accountId, i);
					}
					i++;
				}
				system.debug('allItems.itemMap: ' + allItems.itemMap);
				system.debug('selectedItems: ' + selectedItems);
				system.debug('selectedItems.itemMap: ' + selectedItems.itemMap);
			}*/
		}
	}

	/*    @RemoteAction
    global static String getTerminationFee(String assetId, String productCstValueId) {
        String cst564 = '3';
        Set<String> cst566 = new Set<String>();
        Set<String> cst3 = new Set<String>();
        Set<String> cst394 = new Set<String>();
        Set<String> cst229 = new Set<String>();
        Asset theAsset;
        List<CST_Value__c> listOfValues = new List<CST_Value__c>();
        Map <String, String> mapOfStrings = new Map<String, String>();
        List<Asset> listOfAssets = new List<Asset>();
        if (String.isNotBlank(assetId)) {
            theAsset = [select id, Quantity, Currency_Code__c, CST_Value__r.Related_Value_4__r.Data_ID__c from asset where id = :assetId].get(0);
        }
        //sporaky
        system.debug('theAsset: ' + theAsset);
        if (productCstValueId == '1816-24' && theAsset != null) {
            cst3.add(theAsset.Currency_Code__c);
            if (theAsset.Currency_Code__c == '39') {
                //ceske
                cst566.add('32');
                cst394.add('7');
            } else {
                //zahranicni
                cst566.add('32');
                cst394.add('13');
            }
            cst229.add(String.isNotBlank(theAsset.CST_Value__r.Related_Value_4__r.Data_ID__c) ? theAsset.CST_Value__r.Related_Value_4__r.Data_ID__c : '1');
        }
        //terminaky
        if (productCstValueId == '1816-29' && theAsset != null) {
            cst3.add(theAsset.Currency_Code__c);
            cst566.add('20');
            cst394.add('7');
            cst229.add(String.isNotBlank(theAsset.CST_Value__r.Related_Value_4__r.Data_ID__c) ? theAsset.CST_Value__r.Related_Value_4__r.Data_ID__c : '1');
        }
        system.debug('cst3: ' + cst3);
        system.debug('cst566: ' + cst566);
        system.debug('cst394: ' + cst394);
        system.debug('cst229: ' + cst229);
        if (!cst3.isEmpty() && !cst566.isEmpty() && !cst394.isEmpty() && !cst229.isEmpty()) {
            listOfValues = [
                    select id, Related_Value__r.Data_ID__c, Multipurpose_Number_1__c, Multipurpose_Text_1__c, Multipurpose_Text_2__c, Multipurpose_Text_3__c, Multipurpose_Text_4__c
                    from CST_Value__c
                    where CST_List_of_Values__r.CST_Code__c = '567' AND
                    Related_Value__r.Data_ID__c in :cst3 and Multipurpose_Text_4__c = :cst564 and Multipurpose_Text_3__c in:cst566 and Multipurpose_Text_2__c in:cst394 and Multipurpose_Text_1__c in:cst229
            ];
        }
        system.debug('listOfValues: ' + listOfValues);

        if ((productCstValueId == '1816-24' || productCstValueId == '1816-29')) {
            system.debug('som tu1: ');
            for (CST_Value__c theValue : listOfValues) {
                system.debug('som tu2 theValue.Related_Value__r.Data_ID__c: ' + theValue.Related_Value__r.Data_ID__c);
                system.debug('som tu2 theAsset.Currency_Code__c: ' + theAsset.Currency_Code__c);
                system.debug('som tu2: theValue.Multipurpose_Text_1__c ' + theValue.Multipurpose_Text_1__c);
                system.debug('som tu2: theAsset.CST_Value__r.Related_Value_4__r.Data_ID__c ' + theAsset.CST_Value__r.Related_Value_4__r.Data_ID__c);
                if (theValue.Related_Value__r.Data_ID__c == theAsset.Currency_Code__c */ /*&& theValue.Multipurpose_Text_1__c == theAsset.CST_Value__r.Related_Value_4__r.Data_ID__c*/ /*) {
                    system.debug('som tu3: ');
                    //sporak vim ze obsahy ifu jsou stejne ale davam to tu dopredu kdyby bylo potreba rozlisit terminaky a sporaky
                    system.debug('som tu4 sporak: ');
                    Decimal theNumber = theValue.Multipurpose_Number_1__c / 100;
                    Decimal theQuantity = (theAsset.Quantity * theNumber).setScale(2);
                    return String.valueOf(theQuantity);
                    //return '0';
                }
            }
        }
        return null;
    }*/

	/*    private static String getAssetElementsForReadOnlyMode(MigrationPremiumTypes.ItemsWrapper items) {
        Integer minIndex = 999999;
        String index = '';
        for (String s : items.itemMap.keySet()) {
            Integer i = Integer.valueOf(s.substringBefore('-'));
            if (minIndex >= i) {
                minIndex = i;
                index = s;
            }
        }
//        return String.valueOf(items.itemMap.get(index).theAsset.Id);
        return index;
    }*/

	/*    @RemoteAction
    global static MigrationValidation.Result getCancellationValidation(List<String> assetIds, String accountId) {
        MigrationValidation.Result result = MigrationValidation.getAccountCancellationValidation(accountId, assetIds, false, System.Label.Migration_Premium_Signature_Error, System.Label.Migration_Premium_Investment_Error, System.Label.Migration_Premium_ELB_Validation_Error);
        return result;
    }*/

	// ------------------------------------------------------------------------------------------------------------
	// ---------------------------------------   REMOTE ACTIONS   -------------------------------------------------
	// ------------------------------------------------------------------------------------------------------------

	/**
	 * [getRelationsOfMigratedProduct description]
	 * @param  accountId [description]
	 * @param  productId [description]
	 * @param  assetId   [description]
	 * @param  index     [index of the field in the UI]
	 * @return           [JSON representation of TransitionData object]
	 */
	@RemoteAction
	global static String getRelationsOfMigratedProduct(
		String accountId,
		String productId,
		String parentProductId,
		String assetId,
		Integer index,
		Boolean addedProductIsCard,
		String metadataConfigurationId
	) {
		Migration_Process__mdt migrationProcessConfiguration = getProcessConfigurationById(metadataConfigurationId);
		MigrationPremiumTypes.TransitionData result = new MigrationPremiumTypes.TransitionData();
		if (String.isBlank(parentProductId)) {
			result.productId = productId;
		} else {
			result.productId = parentProductId;
		}

		Product2 theProduct;
		Asset theAsset;
		Set<String> productIdSet = new Set<String>();
		Map<String, string> productParentIdMap = new Map<String, string>();
		// ProductId - AccountId from Asset
		Map<String, Asset> productIdToAssetMap = new Map<String, Asset>();
		Integer i = 0;
		if (!String.isBlank(assetId)) {
			theAsset = [
				SELECT
					Id,
					Product2Id,
					Product2.Name,
					AccountId,
					Account.Name /*, (SELECT Id, Name, Product2.Name, AccountId, Account.Name, Product2.Product__r.Id FROM Assets__r)*/
				FROM Asset
				WHERE Id = :assetId
				LIMIT 1
			];
			// method adding all the name related to the dispatcher account to the Map.
			// This map is using in the methods which are responsible for creatin of dispatcher text/wrapper
			List<Asset> assetList = new List<Asset>();
			assetList.add(theAsset);
			System.debug(theAsset);
			//            addAllDecryptedDispatcherAssetsName(assetList, accountId);
			//addAllAssetsNumber(assetList);

			productIdToAssetMap.put(i + '-' + theAsset.Product2Id, theAsset);
			productIdSet.add(theAsset.Product2Id);
			//productIdList.add(theAsset.Product2Id);
			/*if (migrationProcessConfiguration.DeveloperName != 'Heritage') {
				for (Asset childAsset : theAsset.Assets__r) {
					i++;
					productIdToAssetMap.put(i + '-' + childAsset.Product2Id, childAsset);
					productIdSet.add(childAsset.Product2Id);
					//productParentIdMap.put(childAsset.Product2Id, childAsset.Product2.Product__r.Id);
				}
			}*/
		} else {
			productIdToAssetMap.put(i + '-' + productId, null);
			productIdSet.add(productId);
		}
		//Map<String, Product2> productMap = new Map<String, Product2>([SELECT id, Name, Product__r.Id FROM Product2 WHERE Id = :productIdSet]);
		//theProduct = productMap.containsKey(productId) ? productMap.get(productId) : null;

		/*if (productMap.containsKey(productId)) {
			result.productName = productMap.get(productId).Name;
			productParentIdMap.put(productMap.get(productId).Id, productMap.get(productId).Product__r.Id);
		}*/

		System.debug(productIdSet);
		System.debug(productParentIdMap);
		List<Product_Relation__c> productRelationList;
		if (String.isBlank(assetId)) {
			productRelationList = [
				SELECT
					Id,
					Default_Name__c,
					From__c,
					From__r.Name,
					To__c,
					To__r.Name,
					Is_Owner_Default__c,
					Is_Dispatcher_Default__c,
					Record_Type_Name__c,
					Type__c,
					Order__c
				FROM Product_Relation__c
				WHERE
					From__c = :productIdSet
					AND Type__c = 'Create'
					AND RecordType.DeveloperName = :migrationProcessConfiguration.Product_Relation_Record_Type_Name__c
				ORDER BY Order__c
			];
		} else {
			productRelationList = [
				SELECT
					Id,
					Default_Name__c,
					From__c,
					From__r.Name,
					To__c,
					To__r.Name,
					Is_Owner_Default__c,
					Is_Dispatcher_Default__c,
					Record_Type_Name__c,
					Type__c,
					Order__c
				FROM Product_Relation__c
				WHERE
					From__c = :productIdSet
					AND To__c != :productId
					AND RecordType.DeveloperName = :migrationProcessConfiguration.Product_Relation_Record_Type_Name__c
				ORDER BY Order__c
			];
		}

		List<Product_Relation__c> parentProductRelationsList;
		Map<String, List<Product_Relation__c>> parentProductRelationsMap = new Map<String, List<Product_Relation__c>>();
		if (Test.isRunningTest())
			migrationProcessConfiguration.Load_Parent_Product_Config__c = true;
		if (migrationProcessConfiguration.Load_Parent_Product_Config__c) {
			parentProductRelationsList = [
				SELECT
					Id,
					Default_Name__c,
					From__c,
					From__r.Name,
					To__c,
					To__r.Name,
					Is_Owner_Default__c,
					Is_Dispatcher_Default__c,
					Record_Type_Name__c,
					Type__c,
					Order__c
				FROM Product_Relation__c
				WHERE
					From__c = :productParentIdMap.values()
					AND To__c != :productId
					AND RecordType.DeveloperName = :migrationProcessConfiguration.Product_Relation_Record_Type_Name__c
				ORDER BY Order__c
			];

			for (String key : productParentIdMap.keySet()) {
				for (Product_Relation__c pr : parentProductRelationsList) {
					if (productParentIdMap.get(key) == pr.From__c) {
						if (parentProductRelationsMap.get(key) != null) {
							parentProductRelationsMap.get(key).add(pr);
						} else {
							List<Product_Relation__c> prList = new List<Product_Relation__c>();
							prList.add(pr);
							parentProductRelationsMap.put(key, prList);
						}
					}
				}
			}
		}

		System.debug(productRelationList);
		System.debug(productParentIdMap);
		System.debug(parentProductRelationsMap);

		Map<String, List<Product_Relation__c>> productRelationMap = new Map<String, List<Product_Relation__c>>();

		for (Product_Relation__c theRelation : productRelationList) {
			if (!String.isBlank(assetId) && theRelation.From__c == theRelation.To__c) {
				continue;
			} else if (String.isBlank(assetId) && theRelation.From__c != theRelation.To__c) {
				continue;
			}
			if (productRelationMap.containsKey(theRelation.From__c)) {
				productRelationMap.get(theRelation.From__c).add(theRelation);
			} else {
				List<Product_Relation__c> data = new List<Product_Relation__c>();
				data.add(theRelation);
				productRelationMap.put(theRelation.From__c, data);
			}
		}

		for (String key : productParentIdMap.keySet()) {
			if (productRelationMap.containsKey(key)) {
				continue;
			} else {
				List<Product_Relation__c> prList = new List<Product_Relation__c>();
				if (parentProductRelationsMap.containsKey(key)) {
					prList.addAll(parentProductRelationsMap.get(key));
					productRelationMap.put(key, prList);
				}
			}
		}

		String transitionItemIndex = index + '-' + productId;
		result.transitionItemMap.put(transitionItemIndex, new Map<String, MigrationPremiumTypes.TransitionItem>());
		for (String productItemId : productIdToAssetMap.keySet()) {
			Asset itemAsset = productIdToAssetMap.get(productItemId);
			String parsedProductId = productItemId.split('-').get(1);
			MigrationPremiumTypes.TransitionItem theTransitionItem = new MigrationPremiumTypes.TransitionItem();
			theTransitionItem.isCard = addedProductIsCard;
			Product2 theItemProduct;
			/*if (productMap.containsKey(parsedProductId)) {
				theItemProduct = productMap.get(parsedProductId);
			} else {
				continue;
			}*/
			//theTransitionItem.productName = theItemProduct.Name;
			/*if (String.isBlank(parentProductId)) {
				theTransitionItem.productId = theItemProduct.Id;
			} else {
				theTransitionItem.productId = parentProductId;
			}*/
			if (itemAsset == null) {
				theTransitionItem.isOwner = true;
			} else {
				//theTransitionItem.setAssetId(itemAsset.Id);
				if (itemAsset.AccountId == accountId) {
					theTransitionItem.isOwner = true;
				} else {
					theTransitionItem.isOwner = false;
					theTransitionItem.disponentText = getDisponentTextFromAsset(itemAsset);
					theTransitionItem.disponentId = itemAsset.AccountId;
					system.debug('load3');
				}
			}
			/*if (itemAsset != null) {
				theTransitionItem.assetBankSystem = itemAsset.Bank_System__c;
			}*/
			System.debug('AAA0.5');
			System.debug(parsedProductId);
			System.debug(productRelationMap);
			System.debug(productRelationMap.containsKey(parsedProductId));
			if (productRelationMap.containsKey(parsedProductId)) {
				theTransitionItem.productRelationList = productRelationMap.get(parsedProductId);
			}
			result.transitionItemMap.get(transitionItemIndex).put(productItemId, theTransitionItem);
		}

		result.theItem = new MigrationPremiumTypes.Item(
			migrationProcessConfiguration,
			theAsset,
			false,
			index,
			false,
			theProduct
		);
		/*        if (theAsset != null && theAsset.Assets__r != null && migrationProcessConfiguration.DeveloperName != 'Heritage') {
            Integer j = 0;
            for (Asset childAsset : theAsset.Assets__r) {
                result.theItem.childItemMap.put(j + '-' + childAsset.Product2Id, new MigrationPremiumTypes.Item(migrationProcessConfiguration, childAsset, accountId, j));
                j++;
            }
        }*/

		return JSON.serialize(result);
	}

	//dedictvi
	/* @RemoteAction
	 global static List<Product2> removeSelectedProducts(String productList, String migrationConfigurationProccessName) {
		 List<Product2> finalList = new List<Product2>();*/
	/*if(migrationConfigurationProccessName == 'Heritage') {
		Set<String> setOfProductToRemove = new Set<String>();
		List<Product2> listOfProducts = Database.query(getProcessConfigurationByName(migrationConfigurationProccessName).New_Product_Button_SOQL__c);
		if (listOfProducts != null && !listOfProducts.isEmpty()) {
			MigrationPremiumTypes.ItemsWrapper itemsFromPage = (MigrationPremiumTypes.ItemsWrapper) JSON.deserialize(productList, MigrationPremiumTypes.ItemsWrapper.class);
			for (MigrationPremiumTypes.Item theItem : itemsFromPage.itemMap.values()) {
				for (Product2 theProd : listOfProducts) {
					if (theProd.Id == theItem.theProduct.Id && theItem.theProduct.Name != 'Vkladní knížky') {
						setOfProductToRemove.add(theProd.Id);
					}
				}
			}
		}
		for (Product2 theProd : listOfProducts) {
			if (!setOfProductToRemove.contains(theProd.Id)) {
				finalList.add(theProd);
			}
		}
	}*/
	/*        return finalList;
	 }*/

	/*    @RemoteAction
    global static List<Product2> loadChildProducts(String parentProductId) {
        List<Product2> childProducts = new List<Product2>();
        Product2 prod = [SELECT Requires_Product_Category__c FROM Product2 WHERE Id = :parentProductId];
        if (!prod.Requires_Product_Category__c) {
            childProducts = [
                    SELECT Lx__c, Id, Name, Product__r.Id, CST_Code__c, ProductCode, CST_Value_ID__c
                    FROM Product2
                    WHERE Product__r.Id = :parentProductId AND IsActive = true AND Lx__c = 'L3' AND Used_In_Calc__c = true
                    ORDER BY Name
            ];
        }
        return childProducts;
    }*/

	@TestVisible
	private static Case fillCaseFieldsForExistingCase(
		Migration_Process__mdt migrationProcessConfiguration,
		String productListConf,
		String productRelationsConf,
		/* String selectedAssetMainElement, String selectedAssetChildElement,*/ String elDocDistrib
	) {
		Case theCase = new Case();
		theCase.Migration_Premium_Product_List_Conf__c = productListConf;
		theCase.Migration_Premium_Product_Relations_Conf__c = productRelationsConf + elDocDistrib;
		/*        theCase.Migration_Premium_Parent_Id__c = selectedAssetMainElement;
		 theCase.Migration_Premium_Child_Id__c = selectedAssetChildElement;*/
		theCase.Type_of_Process__c = migrationProcessConfiguration.DeveloperName;
		return theCase;
	}

	private static Case createCaseQueueFromMetadata(
		Migration_Process__mdt migrationProcessConfiguration,
		String accountId,
		String productListConf,
		String productRelationsConf /*, String selectedAssetMainElement, String selectedAssetChildElement*/,
		String elDocDistrib,
		String note,
		String assetId,
		String selectedProductRelationId,
		String lowestPriority,
		List<String> docIdList,
		String typeOfOperation,
		String pdfTemplateItemsJSON
	) {
		/*, Boolean forVerification, String assetsForVerification*/
		Case theCase = new Case();
		System.debug(accountId);
		theCase.AccountId = String.isNotBlank(accountId) ? accountId : null;
		//theCase.Case_Content__c = migrationProcessConfiguration.Case_Content__c;
		theCase.Status = migrationProcessConfiguration.Case_Status__c;
		//theCase.Type = migrationProcessConfiguration.Case_Type__c;
		theCase.RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PCF', 'Case');
		//theCase.Expiration_Date__c = Date.today();
		if (String.isNotBlank(productListConf)) {
			System.debug('productconf: ' + productListConf);
			productListConf = productListConf.replaceAll('\\\\n', '\\\\\\\\n');
		}
		if (String.isNotBlank(productRelationsConf)) {
			System.debug('productRelationsConf: ' + productRelationsConf);
			productRelationsConf = productRelationsConf.replaceAll('\\\\n', '\\\\\\\\n');
		}
		System.debug('pak: ' + productListConf);
		System.debug('pak2: ' + productRelationsConf);
		theCase.Migration_Premium_Product_List_Conf__c = productListConf;
		theCase.Migration_Premium_Product_Relations_Conf__c = productRelationsConf + elDocDistrib;
		/*        theCase.Migration_Premium_Parent_Id__c = selectedAssetMainElement;
		 theCase.Migration_Premium_Child_Id__c = selectedAssetChildElement;*/
		theCase.Description = note;
		//theCase.Receive_Date__c = Date.today();
		theCase.Type_of_Process__c = migrationProcessConfiguration.DeveloperName;
		if (String.isNotBlank(pdfTemplateItemsJSON)) {
			theCase.Template__c = pdfTemplateItemsJSON;
		}
		/*theCase.Contains_Product_For_Verification__c = forVerification;
		 theCase.Assets_For_Verification__c = assetsForVerification;*/
		//List<Asset> assetList = [SELECT Id,Product2.CST_Value_ID__c, Product2.Product__r.CST_Value_ID__c FROM Asset WHERE Id = :assetId];
		//Asset asset = assetList != null && !assetList.isEmpty() ? assetList.get(0) : null;
		/*        String L2CSTValueId = asset != null && asset.Product2 != null && asset.Product2.Product__r != null ? asset.Product2.Product__r.CST_Value_ID__c : null;
        String L3CSTValueID = asset != null && asset.Product2 != null ? asset.Product2.CST_Value_ID__c : null;
        List<Product_Relation__c> productRelations = [SELECT Id,From__r.CST_Value_ID__c,Default_Name__c, Order__c FROM Product_Relation__c WHERE Id = :selectedProductRelationId ORDER BY Order__c];
        Product_Relation__c productRelation = productRelations != null && !productRelations.isEmpty() ? productRelations.get(0) : null;
        String prDefaultName = productRelation != null ? productRelation.Default_Name__c : null;
        String prFromProductCstValueId = productRelation != null && productRelation.From__r != null ? productRelation.From__r.CST_Value_ID__c : null;
        Decimal sufoPriority = lowestPriority == null ? null : Decimal.valueOf(lowestPriority);
        fillCaseQueueAndCaseSubjectFromQueueMetadata(theCase, migrationProcessConfiguration, L2CSTValueId, L3CSTValueID, prDefaultName, prFromProductCstValueId, sufoPriority, typeOfOperation);*/

		/*if (migrationProcessConfiguration.DeveloperName == 'Account_Cancellation' || migrationProcessConfiguration.DeveloperName == 'SUFO') {
			List<MigrationPremiumTypes.CancellationInfo> infoList = new List<MigrationPremiumTypes.CancellationInfo>();
			Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelationsMap = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>) JSON.deserialize(productRelationsConf, Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class);
			//if (!Test.isRunningTest()) {
			enhanceTransitionItemForCancellation(productRelationsMap);
			//}
			for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelationsMap.values()) {
				for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {
					if (theItem.assetId != null) {
						for (Product_Relation__c productRel : theItem.productRelationList) {
							if (theItem.selectedRelationId == productRel.Id) {
								String cancellationDate;
								if (theItem.enhancedProductParameterDefaults.containsKey('CRM_003D.CancelDateSaving')) {
									if (theItem.enhancedProductParameterDefaults.get('CRM_003D.CancelDateSaving').value == 's dodržením výp. doby') {
										DateTime dt = DateTime.now().addMonths(1);
										String dateTimeStr = dt.format('dd.MM.yyyy');
										cancellationDate = dateTimeStr;
									} else {
										DateTime dt = DateTime.now();
										String dateTimeStr = dt.format('dd.MM.yyyy');
										cancellationDate = dateTimeStr;
									}
								} else if (theItem.enhancedProductParameterDefaults.containsKey('CRM_003D.CancelDateOneMonth')) {
									DateTime dt = DateTime.now().addMonths(1);
									String dateTimeStr = dt.format('dd.MM.yyyy');
									cancellationDate = dateTimeStr;
								} else if (theItem.enhancedProductParameterDefaults.containsKey('CRM_003D.CloseDate')) {
									cancellationDate = theItem.enhancedProductParameterDefaults.get('CRM_003D.CloseDate').value;
								} else {
									DateTime dt = DateTime.now();
									String dateTimeStr = dt.format('dd.MM.yyyy');
									cancellationDate = dateTimeStr;
								}
								if (cancellationDate == null && String.isEmpty(cancellationDate)) {
									cancellationDate = '';
								}
								infoList.add(new MigrationPremiumTypes.CancellationInfo(theItem.assetId, theItem.productName, cancellationDate));
							}
						}
					}
				}
			}
			if (infoList != null && !infoList.isEmpty()) {
				theCase.Case_Cancellation_Info__c = JSON.serialize(infoList);
			}
		}*/
		return theCase;
	}

	/*    private static void fillCaseOwner(Case theCase, Id ownerId) {
        if (ownerId.getSobjectType() == Branch__c.getSObjectType()) {
            theCase.OwnerId = UserUtils.getUtvarUserId();
            theCase.Branch__c = ownerId;
        } else {
            theCase.OwnerId = ownerId;
        }
    }*/

	/*    private static Migration_Process_Queue__mdt getMigrationProcessQueuesMetadataForSUFO(Migration_Process__mdt migrationProcessConfiguration, String L2ProductDataId, String L3ProductDataID, String prDefaultName, String prFromProductCstValueId, Decimal SufoPriority) {
        Migration_Process_Queue__mdt L2queueMetadata;
        if (migrationProcessConfiguration.Migration_Process_Queues__r != null && !migrationProcessConfiguration.Migration_Process_Queues__r.isEmpty()) {
            for (Migration_Process_Queue__mdt qMdt : migrationProcessConfiguration.Migration_Process_Queues__r) {
                if (qMdt.PR_Default_Name__c == prDefaultName && qMdt.PR_From_Product__c == prFromProductCstValueId && qMdt.Priority__c == SufoPriority) {
                    if (qMdt.L2_CST_Value_ID__c == L3ProductDataID) {
                        return qMdt;
                    } else if (qMdt.L2_CST_Value_ID__c == L2ProductDataId) {
                        L2queueMetadata = qMdt;
                    }
                }
            }
        }
        return L2queueMetadata;
    }*/

	/*    private static Map<String, Id> getBranchIDsByDataIds(List<String> dataIds) {
        return getIdsByStrings(dataIds, Branch__c.getSObjectType(), 'Data_ID__c', null);
    }

    private static Map<String, Id> getQueueIDsByDeveloperNames(List<String> developerNames) {
        return getIdsByStrings(developerNames, Group.getSObjectType(), 'DeveloperName', 'Type = \'Queue\'');
    }*/

	/*    private static Map<String, Id> getIdsByStrings(List<String> values, SObjectType sObjectType, String fieldName, String additionalCondition) {
        Set<String> filteredValues = new Set<String>();
        for (String val : values) {
            if (String.isNotBlank(val)) {
                filteredValues.add(val);
            }
        }
        List<SObject> sObjects = new List<SObject>();
        if (filteredValues != null && !filteredValues.isEmpty()) {
            sObjects = Database.query('SELECT Id,' + fieldName + ' FROM ' + sObjectType + ' WHERE ' + fieldName + ' IN :filteredValues ' + (additionalCondition != null ? 'AND ' + additionalCondition : ''));
        }
        Map<String, Id> result = new Map<String, Id>();
        for (SObject sObj : sObjects) {
            result.put((String) sObj.get(fieldName), sObj.Id);
        }
        return result;
    }*/

	/* private static void fillCaseQueueAndCaseSubjectFromQueueMetadata(Case theCase, Migration_Process__mdt migrationProcessConfiguration, String L2ProductDataId, String L3ProductDataID, String prDefaultName, String prFromProductCstValueId, Decimal SufoPriority, String typeOfOperation) {
		 system.debug('tu som fillCaseQueueAndCaseSubjectFromQueueMetadata: ' + migrationProcessConfiguration);
		 Migration_Process_Queue__mdt queueMetadata = getMigrationProcessQueuesMetadataForSUFO(migrationProcessConfiguration, L2ProductDataId, L3ProductDataID, prDefaultName, prFromProductCstValueId, SufoPriority);
		 Migration_Premium_Defaults__c defaultCustomSetting = Migration_Premium_Defaults__c.getInstance();
		 String userId = UserInfo.getUserId();
		 Map<String, Id> branchIDs = getBranchIDsByDataIds(new List<String>{
				 queueMetadata != null ? queueMetadata.Case_Branch_Data_ID__c : null, migrationProcessConfiguration != null ? migrationProcessConfiguration.Case_Branch_Data_Id__c : null, defaultCustomSetting != null ? defaultCustomSetting.Branch_Data_Id__c : null
		 });
		 Map<String, Id> queueIDs = getQueueIDsByDeveloperNames(new List<String>{
				 queueMetadata != null ? queueMetadata.Case_Queue_Name__c : null, migrationProcessConfiguration != null ? migrationProcessConfiguration.Case_Queue_Name__c : null
		 });
		 if (queueMetadata != null) {
			 theCase.Subject = queueMetadata.Case_Subject__c;
			 if (String.isBlank(theCase.OwnerId) && String.isNotBlank(queueMetadata.Case_Queue_Name__c) && queueIDs.containsKey(queueMetadata.Case_Queue_Name__c)) {
				 fillCaseOwner(theCase, queueIDs.get(queueMetadata.Case_Queue_Name__c));
			 }
			 if (String.isBlank(theCase.OwnerId) && String.isNotBlank(queueMetadata.Case_Branch_Data_ID__c) && branchIDs.containsKey(queueMetadata.Case_Branch_Data_ID__c)) {
				 fillCaseOwner(theCase, branchIDs.get(queueMetadata.Case_Branch_Data_ID__c));
			 }
		 } else if (migrationProcessConfiguration != null) {
			 theCase.Subject = migrationProcessConfiguration.Case_Subject__c;
			 System.debug('### migrationProcessConfiguration.Assign_To_User__c ' + migrationProcessConfiguration.Assign_To_User__c);
			 if ((migrationProcessConfiguration.Assign_To_User__c == true && typeOfOperation == 'draft') || migrationProcessConfiguration.Assign_To_User_Always__c == true) {
				 fillCaseOwner(theCase, userId);
			 }
		 }
		 if (String.isBlank(theCase.OwnerId) && String.isNotBlank(migrationProcessConfiguration.Case_Queue_Name__c) && queueIDs.containsKey(migrationProcessConfiguration.Case_Queue_Name__c)) {
			 fillCaseOwner(theCase, queueIDs.get(migrationProcessConfiguration.Case_Queue_Name__c));
		 }
		 if (String.isBlank(theCase.OwnerId) && String.isNotBlank(migrationProcessConfiguration.Case_Branch_Data_Id__c) && branchIDs.containsKey(migrationProcessConfiguration.Case_Branch_Data_Id__c)) {
			 fillCaseOwner(theCase, branchIDs.get(migrationProcessConfiguration.Case_Branch_Data_Id__c));
		 }
		 if (String.isBlank(theCase.OwnerId) && defaultCustomSetting != null && branchIDs.containsKey(defaultCustomSetting.Branch_Data_Id__c)) {
			 fillCaseOwner(theCase, branchIDs.get(defaultCustomSetting.Branch_Data_Id__c));
		 }
	 }*/

	@RemoteAction
	global static OppWrapper updateOpp(String oppId, String apiFields) {
		//try {
		Map<String, MigrationPremiumTypes.ApiFieldWrapper> apiFieldsMap;
		if (String.isNotBlank(oppId) && String.isNotBlank(apiFields)) {
			apiFieldsMap = (Map<String, MigrationPremiumTypes.ApiFieldWrapper>) JSON.deserialize(
				apiFields,
				Map<String, MigrationPremiumTypes.ApiFieldWrapper>.class
			);
		}
		Map<String, Schema.SObjectField> oppFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
		Opportunity theOpp = new Opportunity();
		theOpp.Id = oppId;
		if (apiFieldsMap != null) {
			for (MigrationPremiumTypes.ApiFieldWrapper f : apiFieldsMap.values()) {
				if (String.isNotBlank(f.value)) {
					Schema.SObjectField field = oppFieldMap.get(f.fieldName);
					Schema.DisplayType FldType = field.getDescribe().getType();
					if (FldType == Schema.DisplayType.BOOLEAN) {
						Boolean val = f.value == 'true' ? true : false;
						theOpp.put(f.fieldName, val);
					} else if (FldType == Schema.DisplayType.REFERENCE) {
						Id theId = Id.valueOf(f.value);
						theOpp.put(f.fieldName, theId);
					} else {
						theOpp.put(f.fieldName, f.value);
					}
				}
			}
		}
		update theOpp;
		return new OppWrapper(oppId, null);
		//        } catch (Exception ex) {
		//            return new OppWrapper(oppId, ex.getMessage());
		//        }
	}

	/*@RemoteAction
	 global static String checkElbValid(String productConfigFromPage, boolean savedConfig) {*/
	/*Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelations = null;
	if (String.isNotBlank(productConfigFromPage)) {
		System.debug('SOM TU, TAKZE JE TU NECO PROHNILEHO...');
		productRelations = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>) JSON.deserialize(
				productConfigFromPage, Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class
		);
		System.debug(productConfigFromPage.substring(0, 50));
		System.debug(productConfigFromPage.substring(productConfigFromPage.length()-50));
		System.debug(productRelations);
		System.debug(productRelations.size());

		enhanceTransitionItemForCancellation(productRelations);
		System.debug(productConfigFromPage.substring(0, 50));
		System.debug(productConfigFromPage.substring(productConfigFromPage.length()-50));
		System.debug(productRelations);
		System.debug(productRelations.size());
		for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelations.values()) {
			System.debug('JSEM VE VNEJSIM FORU');
			for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {
				System.debug('JSEM VE VNITRNIM FORU');
				String heirType = '';
				if (theItem.enhancedProductParameterDefaults.containsKey('heirType') && String.isNotBlank(theItem.enhancedProductParameterDefaults.get('heirType').value)) {
					heirType = theItem.enhancedProductParameterDefaults.get('heirType').value;
				}
				if (String.isNotBlank(heirType)) {
					if (heirType == 'Klient banky') {
						String cuidFromConfig = theItem.enhancedProductParameterDefaults.get('rcCUID') != null ? theItem.enhancedProductParameterDefaults.get('rcCUID').value : '';
						List<Account> listOfAcc = new List<Account>();
						if (Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT)) {
							listOfAcc = [SELECT Id,name, PersonBirthdate , Date_of_Birth__c, FirstName, LastName, fict_birth_number__c, Full_Registration__c  FROM Account WHERE cuid__c =: cuidFromConfig];
							if (listOfAcc.isEmpty()) {
								SOSLBuilder builder = new SOSLBuilder('');
								builder.addField('Account', 'Id');
								builder.addField('Account', 'Name');
								builder.addField('Account', 'Date_of_Birth__c');
								builder.addField('Account', 'FirstName');
								builder.addField('Account', 'LastName');
								builder.addField('Account', 'Fict_Birth_Number__c');
								builder.addField('Account', 'Full_Registration__c');

								builder.addFilterCondition('Account',
										'Fict_Birth_Number__c',
										Condition.IN_LIST,
										new List<String>{cuidFromConfig},
										ConditionDataType.STRING_TYPE, true
								);
								builder.updateSearchString(cuidFromConfig, false);

								List<Account> accountsByBirthNumber = (List<Account>) builder.runSearch();
								for (Account a : accountsByBirthNumber) {
									listOfAcc.add(a);
								}
							}
						} else {
							//List<Account> listOfAcc = [SELECT Id,name, PersonBirthdate , FirstName, LastName, fict_birth_number__c, Full_Registration__c  FROM Account WHERE cuid__c =: cuidFromConfig or fict_birth_number__c =: cuidFromConfig limit 1];
							String query = 'SELECT Id,name, PersonBirthdate , Date_of_Birth__c, FirstName, LastName, fict_birth_number__c, Full_Registration__c  FROM Account WHERE cuid__c =\'' + cuidFromConfig + '\' OR fict_birth_number__c =\'' + cuidFromConfig + '\' LIMIT 1';
							listOfAcc = (List<Account>) Database.query(query);
						}
						MigrationValidation.Result finalStepValidation = MigrationValidation.getElbErrorValidation(listOfAcc[0].Id, savedConfig, System.Label.Heir_or_non_client_missing_elb);
						if(finalStepValidation.isVisible){
							return 'nok';
						}else{
							return 'ok';
						}
					}
					if (heirType == 'Neklient') {
						return 'nok';
					}
				}
			}
		}
	}*/
	/*        return 'error';
	 }*/

	/*@RemoteAction
	global static String checkHeirsData(String productConfigFromPage, String accountCuidFromPage, boolean checkDraftCase) {
		*/ /*Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelations = null;
        String cuidFromConfig = '';
        String nameOfClient = '';
        String surnameOfClient = '';
        String dateOfBirth = '';
        List<Heritage_cuid_PP__c> heritagePPCuidId = Heritage_cuid_PP__c.getall().values();
        List<Heritage_nonclient_PP__c> heritagePPNonclient = Heritage_nonclient_PP__c.getall().values();
        String ppFirstNameId = '';
        String ppLastNameId = '';
        String ppBirthDateId = '';
        List<NonClientWrapper> nonClientWrapperList = new List<NonClientWrapper>();
        for(Heritage_nonclient_PP__C her : heritagePPNonclient){
            if(her.Label__c == 'FirstName'){
                ppFirstNameId = her.Name;
            }
            if(her.Label__c == 'Surname'){
                ppLastNameId = her.Name;
            }
            if(her.Label__c == 'DateOfBirth'){
                ppBirthDateId = her.Name;
            }
        }
        boolean incomingIsCSOBAccount = false;
        String ppCuidId = heritagePPCuidId[0].Name;
        Set <String> setOfCuidOrBirthNumbers = new Set<String>();
        Account theAccountFromPage = new Account();
        List<Case> listOfCasesHeritage = new List<Case>();
        Case draftCaseToUpdate = new Case();
        if (String.isNotBlank(productConfigFromPage)) {
            productRelations = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>) JSON.deserialize(
                    productConfigFromPage, Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class
            );
            enhanceTransitionItemForCancellation(productRelations);
            for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelations.values()) {
                for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {
                    String heirType = '';
                    if (theItem.enhancedProductParameterDefaults.containsKey('heirType') && String.isNotBlank(theItem.enhancedProductParameterDefaults.get('heirType').value)) {
                        heirType = theItem.enhancedProductParameterDefaults.get('heirType').value;
                    }
                    if (String.isNotBlank(heirType)) {
                        if (heirType == 'Klient banky') {
                            cuidFromConfig = theItem.enhancedProductParameterDefaults.get('rcCUID') != null ? theItem.enhancedProductParameterDefaults.get('rcCUID').value : '';
                            incomingIsCSOBAccount = true;
                            break;
                        }
                        if (heirType == 'Neklient') {
                            nameOfClient = theItem.enhancedProductParameterDefaults.get('heirFirstname') != null ? theItem.enhancedProductParameterDefaults.get('heirFirstname').value : '';
                            surnameOfClient = theItem.enhancedProductParameterDefaults.get('heirSurname') != null ? theItem.enhancedProductParameterDefaults.get('heirSurname').value : '';
                            dateOfBirth = theItem.enhancedProductParameterDefaults.get('OST_003CRMCZ.13') != null ? theItem.enhancedProductParameterDefaults.get('OST_003CRMCZ.13').value : '';
                            break;
                        }
                    }
                }
            }
            if(String.isNotBlank(cuidFromConfig)){
                if (Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT)) {
                    List<Account> accsFromPage = [SELECT Id,name, PersonBirthdate , Date_of_Birth__c, FirstName, LastName, fict_birth_number__c, Full_Registration__c  FROM Account WHERE cuid__c =: cuidFromConfig];
                    if (accsFromPage.isEmpty()) {
                        SOSLBuilder builder = new SOSLBuilder('');
                        builder.addField('Account', 'Id');
                        builder.addField('Account', 'Name');
                        builder.addField('Account', 'Date_of_Birth__c');
                        builder.addField('Account', 'FirstName');
                        builder.addField('Account', 'LastName');
                        builder.addField('Account', 'Fict_Birth_Number__c');
                        builder.addField('Account', 'Full_Registration__c');

                        builder.addFilterCondition('Account',
                                'Fict_Birth_Number__c',
                                Condition.IN_LIST,
                                new List<String>{cuidFromConfig},
                                ConditionDataType.STRING_TYPE, true
                        );
                        builder.updateSearchString(cuidFromConfig, false);

                        List<Account> accountsByBirthNumber = (List<Account>) builder.runSearch();
                        for (Account a : accountsByBirthNumber) {
                            accsFromPage.add(a);
                        }
                    }
                    theAccountFromPage = !accsFromPage.isEmpty() ? accsFromPage.get(0) : null;
                } else {
                    //theAccountFromPage = [SELECT Id,name, PersonBirthdate , FirstName, LastName, fict_birth_number__c, Full_Registration__c  FROM Account WHERE cuid__c =: cuidFromConfig or fict_birth_number__c =: cuidFromConfig limit 1];
                    String query = 'SELECT Id,name, PersonBirthdate , Date_of_Birth__c, FirstName, LastName, fict_birth_number__c, Full_Registration__c  FROM Account WHERE cuid__c =\'' + cuidFromConfig + '\' OR fict_birth_number__c =\'' + cuidFromConfig + '\' LIMIT 1';
                    List<Account> accsFromPage = (List<Account>) Database.query(query);
                    theAccountFromPage = !accsFromPage.isEmpty() ? accsFromPage.get(0) : null;
                }
            }
            if(checkDraftCase){
                listOfCasesHeritage = [select id, Status, Migration_Premium_Product_List_Conf__c, Migration_Premium_Product_Relations_Conf__c from Case where Account.Cuid__c =: accountCuidFromPage and status = '10' and Type_of_Process__c = 'Heritage'];
                draftCaseToUpdate = listOfCasesHeritage[0];
            } else{
                listOfCasesHeritage = [select id, Migration_Premium_Product_List_Conf__c, Migration_Premium_Product_Relations_Conf__c from Case where Account.Cuid__c =: accountCuidFromPage and status not in ('21','10','34') and Type_of_Process__c = 'Heritage'];
            }
            for(Case theCase : listOfCasesHeritage){
                if(String.isNotBlank(theCase.Migration_Premium_Product_Relations_Conf__c)){
                    Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelations2 = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>) JSON.deserialize(
                            theCase.Migration_Premium_Product_Relations_Conf__c, Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class
                    );
                    for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelations2.values()) {
                        for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {

                            if(theItem.productParameterDefaults != null && !theItem.productParameterDefaults.isEmpty() && String.isNotBlank(ppCuidId) && theItem.productParameterDefaults.containsKey(ppCuidId) && String.isNotBlank(theItem.productParameterDefaults.get(ppCuidId).value)){
                                //klienti
                                setOfCuidOrBirthNumbers.add(theItem.productParameterDefaults.get(ppCuidId).value);
                            } else if(theItem.productParameterDefaults != null && !theItem.productParameterDefaults.isEmpty() && String.isNotBlank(ppFirstNameId) && String.isNotBlank(ppLastNameId) && String.isNotBlank(ppBirthDateId)){
                                //neklienti
                                if(theItem.productParameterDefaults.containsKey(ppFirstNameId) && String.isNotBlank(theItem.productParameterDefaults.get(ppFirstNameId).value) && theItem.productParameterDefaults.containsKey(ppLastNameId) && String.isNotBlank(theItem.productParameterDefaults.get(ppLastNameId).value) && theItem.productParameterDefaults.containsKey(ppBirthDateId) && String.isNotBlank(theItem.productParameterDefaults.get(ppBirthDateId).value)){
                                    nonClientWrapperList.add(new NonClientWrapper(theItem.productParameterDefaults.get(ppFirstNameId).value, theItem.productParameterDefaults.get(ppLastNameId).value, theItem.productParameterDefaults.get(ppBirthDateId).value));
                                }
                            }
                        }
                    }
                }
            }

            List<Account> listOfAccountToCheck = new List<Account>();
            if (!Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT)) {
                //listOfAccountToCheck = [SELECT Id,name, PersonBirthdate, FirstName, LastName, fict_birth_number__c, Full_Registration__c FROM Account WHERE cuid__c in:setOfCuidOrBirthNumbers or fict_birth_number__c in:setOfCuidOrBirthNumbers];
                String numSet = '';
                Boolean first = true;
                for (String s : setOfCuidOrBirthNumbers) {
                    if (!first) {
                        numSet += ', ';
                        first = false;
                    }
                    numSet += '\'' + s + '\'';
                }
                String query = 'SELECT Id,name, PersonBirthdate, Date_of_Birth__c, FirstName, LastName, fict_birth_number__c, Full_Registration__c FROM Account WHERE cuid__c in (' + numSet + ') or fict_birth_number__c in (' + numSet + ')';
                listOfAccountToCheck = (List<Account>) Database.query(query);
            } else {
                if(!setOfCuidOrBirthNumbers.isEmpty()) {
                    listOfAccountToCheck = [SELECT Id,name, PersonBirthdate, Date_of_Birth__c, FirstName, LastName, fict_birth_number__c, Full_Registration__c FROM Account WHERE cuid__c in:setOfCuidOrBirthNumbers];

                    if (listOfAccountToCheck.isEmpty()) {
                        SOSLBuilder builder = new SOSLBuilder('');
                        builder.addField('Account', 'Id');
                        builder.addField('Account', 'Name');
                        builder.addField('Account', 'Date_of_Birth__c');
                        builder.addField('Account', 'FirstName');
                        builder.addField('Account', 'LastName');
                        builder.addField('Account', 'Fict_Birth_Number__c');
                        builder.addField('Account', 'Full_Registration__c');

                        builder.addFilterCondition('Account',
                                'Fict_Birth_Number__c',
                                Condition.IN_LIST,
                                new List<String>(setOfCuidOrBirthNumbers),
                                ConditionDataType.STRING_TYPE, true
                        );

                        for (String s : setOfCuidOrBirthNumbers) {
                            builder.updateSearchString(s, false);
                        }

                        List<Account> accountsByBirthNumber = (List<Account>) builder.runSearch();
                        for (Account a : accountsByBirthNumber) {
                            listOfAccountToCheck.add(a);
                        }
                    }
                }
            }

            // DPAAS--
            Map < String, String > decryptionDictionaryMap = new Map<String, String>();
            List < String > valuesToTranslateList = new List < String > ();
            if (!Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT)) {
                if(theAccountFromPage != null){
                    valuesToTranslateList.add(theAccountFromPage.FirstName);
                    valuesToTranslateList.add(theAccountFromPage.LastName);
                    if(theAccountFromPage.PersonBirthdate != null){
                        valuesToTranslateList.add(String.valueOf(theAccountFromPage.PersonBirthdate));
                    }
                }

                for (Account theAcc : listOfAccountToCheck) {
                    valuesToTranslateList.add(theAcc.FirstName);
                    valuesToTranslateList.add(theAcc.LastName);
                    if (theAcc.PersonBirthdate != null) {
                        valuesToTranslateList.add(String.valueOf(theAcc.PersonBirthdate));
                    }
                }

                DpaaSSoapWebService.DataProtectionWebServiceImplPort dpaasSoapApi = new DpaaSSoapWebService.DataProtectionWebServiceImplPort();
                if(!valuesToTranslateList.isEmpty()) {
                    decryptionDictionaryMap = Utils.detokenizeTextValues(valuesToTranslateList, dpaasSoapApi);
                }
            }
            // --DPAAS

            if(!setOfCuidOrBirthNumbers.isEmpty()){
                for(Account theAcc : listOfAccountToCheck){
                    if(incomingIsCSOBAccount){
                        if(
                                (!Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT) &&
                                        decryptionDictionaryMap.containsKey(theAcc.FirstName) && decryptionDictionaryMap.containsKey(theAccountFromPage.FirstName) && decryptionDictionaryMap.get(theAcc.FirstName) == decryptionDictionaryMap.get(theAccountFromPage.FirstName)
                                        && decryptionDictionaryMap.containsKey(theAcc.LastName) && decryptionDictionaryMap.containsKey(theAccountFromPage.LastName) && decryptionDictionaryMap.get(theAcc.LastName) == decryptionDictionaryMap.get(theAccountFromPage.LastName)
                                        && theAcc.PersonBirthdate != null && theAccountFromPage.PersonBirthdate != null && decryptionDictionaryMap.containsKey(String.valueOf(theAcc.PersonBirthdate)) && decryptionDictionaryMap.get(String.valueOf(theAcc.PersonBirthdate)) == decryptionDictionaryMap.get(String.valueOf(theAccountFromPage.PersonBirthdate)))

                                        ||

                                        (Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT) &&
                                                String.isNotBlank(theAcc.FirstName) && String.isNotBlank(theAcc.LastName) && theAcc.FirstName == theAccountFromPage.FirstName && theAcc.LastName == theAccountFromPage.LastName
                                                && theAcc.Date_of_Birth__c != null && theAccountFromPage.Date_of_Birth__c != null && theAcc.Date_of_Birth__c == theAccountFromPage.Date_of_Birth__c)
                                ){
                            updateCaseStatusAndReturnNok(draftCaseToUpdate, checkDraftCase && draftCaseToUpdate != null && !listOfCasesHeritage.isEmpty());
                        }
                    }else{
                        if(
                                (!Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT) &&
                                        String.isNotBlank(nameOfClient) && String.isNotBlank(surnameOfClient) &&  String.isNotBlank(dateOfBirth) && decryptionDictionaryMap.containsKey(theAcc.FirstName) && decryptionDictionaryMap.get(theAcc.FirstName) == nameOfClient &&
                                        decryptionDictionaryMap.containsKey(theAcc.LastName) && decryptionDictionaryMap.get(theAcc.LastName) == surnameOfClient && theAcc.PersonBirthdate != null && decryptionDictionaryMap.containsKey(String.valueOf(theAcc.PersonBirthdate)) &&
                                        formatStringDate(decryptionDictionaryMap.get(String.valueOf(theAcc.PersonBirthdate)))  == dateOfBirth)
                                        ||
                                        (Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT) &&
                                                String.isNotBlank(nameOfClient) && String.isNotBlank(surnameOfClient) &&  String.isNotBlank(dateOfBirth) && theAcc.FirstName == nameOfClient &&
                                                theAcc.LastName == surnameOfClient && theAcc.Date_of_Birth__c != null &&
                                                formatStringDate(String.valueOf(theAcc.Date_of_Birth__c))  == dateOfBirth)
                                ){
                            updateCaseStatusAndReturnNok(draftCaseToUpdate, checkDraftCase && draftCaseToUpdate != null && !listOfCasesHeritage.isEmpty());
                        }
                    }
                }
            }
            if(!nonClientWrapperList.isEmpty()){
                for(NonClientWrapper theWrap : nonClientWrapperList){
                    if(incomingIsCSOBAccount){
                        if(
                                (!Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT) &&
                                        decryptionDictionaryMap.containsKey(theAccountFromPage.FirstName) && decryptionDictionaryMap.containsKey(theAccountFromPage.LastName) && theAccountFromPage.PersonBirthdate != null &&
                                        decryptionDictionaryMap.containsKey(String.valueOf(theAccountFromPage.PersonBirthdate)) && decryptionDictionaryMap.get(theAccountFromPage.FirstName) == theWrap.FirstName &&
                                        decryptionDictionaryMap.get(theAccountFromPage.LastName) == theWrap.LastName && formatStringDate(decryptionDictionaryMap.get(String.valueOf(theAccountFromPage.PersonBirthdate))) == theWrap.birthDate)
                                        ||
                                        (Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT) &&
                                                String.isNotBlank(theAccountFromPage.FirstName) && String.isNotBlank(theAccountFromPage.LastName) && theAccountFromPage.Date_of_Birth__c != null &&
                                                theAccountFromPage.FirstName == theWrap.firstName && theAccountFromPage.LastName == theWrap.lastName && formatStringDate(String.valueOf(theAccountFromPage.Date_of_Birth__c)) == theWrap.birthDate)
                                ){
                            updateCaseStatusAndReturnNok(draftCaseToUpdate, checkDraftCase && draftCaseToUpdate != null && !listOfCasesHeritage.isEmpty());
                        }
                    }else{
                        if(String.isNotBlank(nameOfClient) && String.isNotBlank(surnameOfClient) &&  String.isNotBlank(dateOfBirth) && theWrap.FirstName == nameOfClient && theWrap.LastName == surnameOfClient && theWrap.birthDate != null && theWrap.birthDate == dateOfBirth){
                            updateCaseStatusAndReturnNok(draftCaseToUpdate, checkDraftCase && draftCaseToUpdate != null && !listOfCasesHeritage.isEmpty());
                        }
                    }
                }
            }
            return 'ok';
        }*/ /*
        return 'ok';
    }*/

	/*    private static String updateCaseStatusAndReturnNok(Case c, Boolean check) {
        if (check) {
            c.Status = '34';
            update c;
        }
        return 'nok';
    }*/

	/*    public static String formatStringDate(String d) {
        List<String> listOfStringsDate = new List<String>();
        listOfStringsDate = d.split('-');
        return listOfStringsDate[2] + '.' + listOfStringsDate[1] + '.' + listOfStringsDate[0];
    }*/

	@RemoteAction
	global static CreateCaseWrapper createCase(
		String accountId,
		String assetId,
		String productListConf,
		String productRelationsConf,
		String apiFields,
		String note,
		String generatedDocumentMapJSON,
		String selectedAssetMainElement,
		String exceptionDate,
		String exceptionType,
		String selectedAssetChildElement,
		String migrationProcessConfigurationId,
		String elDocDistrib,
		String mobilityCourierBranch,
		String selectedProductRelationId,
		String lowestPriority,
		String caseIdFromUrl,
		String typeOfOperation,
		String editMode,
		String pdfTemplateItemsJSON
	) {
		/*, Boolean forVerification, String assetsForVerification*/
		/*if (!Utils.isCreatableObject(Case.class.getName()) || !Utils.isUpdateableObject(Case.class.getName())) {
			return new CreateCaseWrapper(null, null, Label.NotSufficientPrivileges);
		}*/
		Map<String, MigrationPremiumTypes.ApiFieldWrapper> apiFieldsMap;
		if (String.isNotBlank(apiFields)) {
			apiFieldsMap = (Map<String, MigrationPremiumTypes.ApiFieldWrapper>) JSON.deserialize(
				apiFields,
				Map<String, MigrationPremiumTypes.ApiFieldWrapper>.class
			);
		}
		System.debug(generatedDocumentMapJSON);
		Map<String, String> generatedDocumentMap = new Map<String, String>();
		if (String.isNotBlank(generatedDocumentMapJSON)) {
			generatedDocumentMap = (Map<String, String>) JSON.deserialize(
				generatedDocumentMapJSON,
				Map<String, String>.class
			);
		}
		Migration_Process__mdt migrationProcessConfiguration = getProcessConfigurationById(
			migrationProcessConfigurationId
		);
		Case theCase;
		if (migrationProcessConfiguration.Use_Already_Created_Case__c) {
			theCase = fillCaseFieldsForExistingCase(
				migrationProcessConfiguration,
				productListConf,
				productRelationsConf /*, selectedAssetMainElement, selectedAssetChildElement*/,
				elDocDistrib
			);
		} else {
			theCase = createCaseQueueFromMetadata(
				migrationProcessConfiguration,
				accountId,
				productListConf,
				productRelationsConf,
				/*selectedAssetMainElement, selectedAssetChildElement, */ elDocDistrib,
				note,
				assetId,
				selectedProductRelationId,
				lowestPriority,
				generatedDocumentMap.values(),
				typeOfOperation,
				pdfTemplateItemsJSON /*, forVerification, assetsForVerification*/
			);
		}
		/*
        if (String.isNotBlank(mobilityCourierBranch)) {
            List<Branch__c> bList = [SELECT Id FROM Branch__c WHERE Data_ID__c = :mobilityCourierBranch];
            System.debug(bList);
            if (!bList.isEmpty()) {
                fillCaseOwner(theCase, bList.get(0).Id);
            }
        }
*/

		Map<String, Schema.SObjectField> caseFieldMap = Schema.SObjectType.Case.fields.getMap();
		System.debug('caseFieldMap: ' + caseFieldMap);
		if (apiFieldsMap != null) {
			for (MigrationPremiumTypes.ApiFieldWrapper f : apiFieldsMap.values()) {
				if (String.isNotBlank(f.value)) {
					System.debug('fneco: ' + f);
					Schema.SObjectField field = caseFieldMap.get(f.fieldName);
					System.debug('field: ' + field);
					Schema.DisplayType FldType = field.getDescribe().getType();
					if (FldType == Schema.DisplayType.BOOLEAN) {
						Boolean val = f.value == 'true' ? true : false;
						theCase.put(f.fieldName, val);
					} else if (FldType == Schema.DisplayType.REFERENCE) {
						Id theId = Id.valueOf(f.value);
						theCase.put(f.fieldName, theId);
					} else {
						theCase.put(f.fieldName, getValueForCaseField(f.value));
					}
				}
			}
		}
		System.debug('*** INSERT FOLLOWS HERE');
		System.debug(theCase);
		System.debug(typeOfOperation);
		System.debug(caseIdFromUrl);
		if (typeOfOperation == 'submit') {
			if (String.isNotBlank(caseIdFromUrl)) {
				// if (editMode == '1') {
				//     //theCase.Account_Cancellation_Parent__c = caseIdFromUrl;
				//     theCase.PCF_Unfinished__c = false;
				//     insert theCase;
				//     Case caseFromUrl = [select id, ParentId from Case where id = :caseIdFromUrl limit 1];
				//     caseFromUrl.ParentId = theCase.Id;
				//     update caseFromUrl;
				// } else {
				theCase.Id = caseIdFromUrl;
				theCase.PCF_Unfinished__c = false;
				update theCase;
				System.debug('case updated: ' + theCase.Id);
				// }
			} else {
				insert theCase;
			}
		} else {
			theCase.Status = '10'; //this is not submit, status should be 'draft'
			if (String.isNotBlank(caseIdFromUrl)) {
				theCase.Id = caseIdFromUrl;
				theCase.PCF_Unfinished__c = true;
				update theCase;
			} else {
				theCase.PCF_Unfinished__c = true;
				insert theCase;
			}
		}
		/*        if (String.isNotBlank(exceptionDate) && String.isNotBlank(exceptionType)) {
            MigrationPremiumUtils.insertFlag(exceptionDate, exceptionType, assetId);
        }*/

		//        if(!String.isBlank(generatedDocumentId)){
		//            List<DMS_Document__c> docList = [SELECT Id, Case__c FROM DMS_Document__c WHERE Id =: generatedDocumentId];
		//            if (docList != null && !docList.isEmpty()) {
		//                for (DMS_Document__c doc : docList) {
		//                    doc.Case__c = theCase.Id;
		//                }
		//                update docList;
		//            }
		//        }

		//      not just one document, but multiple docs can be generated

		/*        if (!generatedDocumentMap.isEmpty()) {
            List<DMS_Document__c> docsForUpdate = new List<DMS_Document__c>();
            for (String d : generatedDocumentMap.values()) {
                DMS_Document__c doc = new DMS_Document__c();
                doc.Id = d;
                doc.Case__c = theCase.Id;
                docsForUpdate.add(doc);
            }
            if (!docsForUpdate.isEmpty()) {
                update docsForUpdate;
            }
        }*/
		return new CreateCaseWrapper(theCase.Id);
	}

	// @RemoteAction
	// global static CreateCaseWrapper prepareCaseForTemplate (String migrationProcessName, String pdfTemplateItemsJSON, String accId){ //, MigrationPremiumTypes.File barcodeFile) {
	//     Case theCase = new Case();
	//     theCase.AccountId = accId;
	//     theCase.Template__c = pdfTemplateItemsJSON;
	//     theCase.PCF_Unfinished__c = true;
	//     theCase.Type_of_Process__c = migrationProcessName;
	//     theCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PCF').getRecordTypeId();
	//     insert theCase;

	//     return new CreateCaseWrapper(theCase.Id);//, saveFile(barcodeFile, theCase.Id));
	// }

	@AuraEnabled
	global static ReturnObjectWrapper getRecord(String recordId, String objectName) {
		String soqlQuery = 'SELECT Id, Status, AccountId FROM ' + objectName + ' WHERE Id = \'' + recordId + '\'';
		List<SObject> returnedObjects = Database.query(soqlQuery);
		for (SObject agg : returnedObjects) {
			if (objectName == 'Asset') {
				return new ReturnObjectWrapper((String) agg.get('AccountId'), null);
			} else {
				return new ReturnObjectWrapper((String) agg.get('AccountId'), (String) agg.get('Status'));
			}
		}
		return new ReturnObjectWrapper(null, null);
	}

	/**
	 * @author PJ
	 * @description If input parameter value is id of the Product_Parameter__c object, returns String_Value__c field of that object, otherwise returns the same value of input parameter.
	 * @param String value
	 * @returns String_Value__c field of the corresponding Product_Parameter__c object if the input parameter value is id of the Product_Parameter__c object. Otherwise returns the same value of the input parameter.
	 */
	@TestVisible
	private static String getValueForCaseField(String val) {
		if (val.length() == 18 && ((Id) val).getSobjectType().getDescribe().getName() == 'Product_Parameter__c') {
			Product_Parameter__c pp = [SELECT Id, String_Value__c FROM Product_Parameter__c WHERE Id = :val];
			return pp.String_Value__c;
		}
		return val;
	}

	/*   @RemoteAction
	   global static DeactivationCardsWrapper deactivateCreditCards2(String selectedItems, String productRelationsConf) {
		   system.debug('selitems: ' + selectedItems);
		   MigrationPremiumTypes.ItemsWrapper itemsFromPage = null;
		   Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelations = null;
		   Map<String, DeactivateDataWrapper> mapOfDeactivateDataPerCardId = new Map<String, DeactivateDataWrapper>();
		   Set<String> setOfAssetIds = new Set<String>();
		   List<Asset> listOfAssets = new List<Asset>();
		   Map<String, Asset> mapOfParentAccNumberPerChildAssetId = new Map<String, Asset>();
		   if(String.isNotBlank(productRelationsConf)){
			   productRelations = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>)JSON.deserialize(
					   productRelationsConf, Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class
			   );
			   enhanceTransitionItemForCancellation(productRelations);
		   }
		   if(String.isNotBlank(selectedItems)){
			   itemsFromPage = (MigrationPremiumTypes.ItemsWrapper) JSON.deserialize(selectedItems, MigrationPremiumTypes.ItemsWrapper.class);
		   }

		   if(productRelations != null){
			   for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelations.values()) {
				   for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {
					   System.debug('theItem: ' + theItem.selectedRelationId);
					   for (Product_Relation__c productRel : theItem.productRelationList) {
						   if (theItem.selectedRelationId == productRel.Id) {
							   System.debug('productRel name: ' + productRel.Default_Name__c);
						   }
					   }
					   boolean canDeactivateCard = false;
					   if(theItem.enhancedProductParameterDefaults.containsKey('CRM_003D.CancelDateSaving')){
						   String stringEndDate = theItem.enhancedProductParameterDefaults.get('CRM_003D.CancelDateSaving').value;
						   if(String.isNotBlank(stringEndDate) && stringEndDate == 's dodržením výp. doby'){
							   canDeactivateCard = true;
						   }
					   }else if(theItem.enhancedProductParameterDefaults.containsKey('CRM_003D.CancelDateOneMonth')){
						   canDeactivateCard = true;
					   } else  if(theItem.enhancedProductParameterDefaults.containsKey('CRM_003D.CloseDate')){
						   List<String> splittedEndDate = theItem.enhancedProductParameterDefaults.get('CRM_003D.CloseDate').value.split('\\.');
						   Date dateFromPcf = Date.newInstance(Integer.valueOf(splittedEndDate[2]), Integer.valueOf(splittedEndDate[1]) + 1, Integer.valueOf(splittedEndDate[0]));
						   Date todaysDate = Date.today();
						   Integer daysBetween = todaysDate.daysBetween(dateFromPcf);
						   if(daysBetween == 30){
							   canDeactivateCard = true;
						   }
					   }
					   if(String.isNotBlank(theItem.assetId) && theItem.enhancedProductParameterDefaults != null && theItem.enhancedProductParameterDefaults.isEmpty()){
						   canDeactivateCard = true;
					   }
					   if(String.isNotBlank(theItem.assetId)){
						   setOfAssetIds.add(theItem.assetId);
					   }
					   if(String.isNotBlank(theItem.assetId)){
						   String selectedIdFromPcf = theItem.selectedRelationId;
						   for(Product_Relation__c prodRel : theItem.productRelationList){
							   if(prodRel.Id == selectedIdFromPcf){
								   DeactivateDataWrapper wrap = new DeactivateDataWrapper(prodRel.Default_Name__c, canDeactivateCard);
								   mapOfDeactivateDataPerCardId.put(theItem.assetId, wrap);
							   }
						   }
					   }
				   }
			   }
		   }
		   if(!setOfAssetIds.isEmpty()){
			   listOfAssets = [select id, Card_Status__c, purchasedate, Parent_Asset__r.Account_Number__c from Asset where id in: setOfAssetIds];
			   for(Asset theAss : listOfAssets){
				   if(String.isNotBlank(theAss.Card_Status__c)){
					   mapOfParentAccNumberPerChildAssetId.put(theAss.id, theAss);
				   }
			   }
		   }
		   system.debug('mapOfDeactivateDataPerCardId: ' + mapOfDeactivateDataPerCardId);
		   system.debug('itemsFromPage: ' + itemsFromPage);
		   if(itemsFromPage != null && itemsFromPage.itemMap != null) {
			   //                if(itemInMap.childItemMap.isEmpty() && itemInChildMap.theAsset != null && itemInMap.theAsset.Card_Status__c != null){
			   User u = [SELECT Id, Data_ID__c, Preferred_Branch__c FROM User WHERE Id = :UserInfo.getUserId()];
			   String currentInfo = Utils.getCurrentUserScubeInfo().brand;
			   PermanentBlockCardApiTypes.CardList_element request = new PermanentBlockCardApiTypes.CardList_element();
			   List<PermanentBlockCardApiTypes.Card_element> listToRequest = new List<PermanentBlockCardApiTypes.Card_element>();
			   for (MigrationPremiumTypes.Item itemInMap : itemsFromPage.itemMap.values()) {
				   if(itemInMap.theAsset.Card_Status__c != null){
					   system.debug('itemInMap: ' + itemInMap);
					   DeactivationCardsWrapper returnedTheWrap = getCardDetailFromData(true, u, itemInMap, itemInMap, currentInfo, listToRequest, mapOfParentAccNumberPerChildAssetId);
					   if(returnedTheWrap != null && String.isNotBlank(returnedTheWrap.errorMessage)){
						   return returnedTheWrap;
					   }
				   } else{
					   for(MigrationPremiumTypes.Item itemInChildMap : itemInMap.childItemMap.values()){
						   if(itemInChildMap.theAsset != null && itemInChildMap.theAsset.Card_Status__c != null){
							   boolean isValidToCancel = false;
							   if(mapOfDeactivateDataPerCardId.containsKey(itemInChildMap.theAsset.Id)) {
								   String defaultName = mapOfDeactivateDataPerCardId.get(itemInChildMap.theAsset.Id).stateOfGivingCard;
								   if(defaultName == 'Odevzdal' || (defaultName == 'Neodevzdal' && mapOfDeactivateDataPerCardId.get(itemInMap.theAsset.Id).canSendToDeactivate)) {
									   isValidToCancel = true;
								   }
							   }
							   DeactivationCardsWrapper returnedTheWrap = getCardDetailFromData(isValidToCancel, u, itemInMap, itemInChildMap, currentInfo, listToRequest, mapOfParentAccNumberPerChildAssetId);
							   if(returnedTheWrap != null && String.isNotBlank(returnedTheWrap.errorMessage)){
								   return returnedTheWrap;
							   }
						   }
					   }
				   }
			   }

			   PermanentBlockCardApi.PermanentBlockCard_v1_Dir2_PortTypeBindingHttpPort port = new PermanentBlockCardApi.PermanentBlockCard_v1_Dir2_PortTypeBindingHttpPort();
			   try{
				   if(listToRequest != null && !listToRequest.isEmpty()){
					   request.Card = listToRequest;
					   system.debug('request.Card: ' + request.Card);
					   if(!Test.isRunningTest()){
						   PermanentBlockCardApiTypes.CardListRes_element responseFromDeactivation = port.PermanentBlockCard_v1(request);
						   system.debug('responseFromDeactivation: ' + responseFromDeactivation);
					   }
					   DeactivationCardsWrapper theWrap = new DeactivationCardsWrapper('success', null);
					   IntegrationLogger.flushOutboundV2(null, null, 'Asset', 'UNICARD', 'PermanentBlockCard_v1', GlobalConstants.WEBSERVICE_OK_CODE, 'OK', port.MetaHeader_v2);
					   return theWrap;
				   }
			   } catch(Exception ex){
				   Integer resultCode = 0; // OK assumed
				   String resultDescription = null;
				   IntegrationLogger.flushOutboundV2(null, null, 'Asset', 'UNICARD', 'PermanentBlockCard_v1', resultCode, resultDescription, port.MetaHeader_v2);
				   resultCode = IntegrationExceptions.getErrorCodeForExceptionType(ex);
				   resultDescription = ex.getMessage();
				   DeactivationCardsWrapper theWrap = new DeactivationCardsWrapper(null, 'error ' + port.MetaHeader_v2.CallContext.Sid + ' ex: ' +ex);
				   return theWrap;
			   }
		   }
		   return new DeactivationCardsWrapper('no credit cards deactivated', null);
	}*/

	//    @RemoteAction
	//    global static DeactivationCardsWrapper deactivateCreditCards(String selectedItems, String productRelationsConf) {
	//        system.debug('selitems: ' + selectedItems);
	//        MigrationPremiumTypes.ItemsWrapper itemsFromPage = null;
	//        Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelations = null;
	//        Set<String> setOfAssetIds = new Set<String>();
	//        PermanentBlockCardApiTypes.CardList_element request = new PermanentBlockCardApiTypes.CardList_element();
	//        List<PermanentBlockCardApiTypes.Card_element> listToRequest = new List<PermanentBlockCardApiTypes.Card_element>();
	//        Map<String, Asset> mapOfParentAccNumberPerChildAssetId = new Map<String, Asset>();
	//        if (String.isNotBlank(productRelationsConf)) {
	//            productRelations = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>) JSON.deserialize(
	//                    productRelationsConf, Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class
	//            );
	//            enhanceTransitionItemForCancellation(productRelations);
	//        }
	//        if (String.isNotBlank(selectedItems)) {
	//            itemsFromPage = (MigrationPremiumTypes.ItemsWrapper) JSON.deserialize(selectedItems, MigrationPremiumTypes.ItemsWrapper.class);
	//        }
	//
	//        if (productRelations != null) {
	//            for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelations.values()) {
	//                for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {
	//                    for (Product_Relation__c productRel : theItem.productRelationList) {
	//                        if (String.isNotBlank(theItem.assetId) && theItem.selectedRelationId == productRel.Id && productRel.Default_Name__c != 'Výpověď') {
	//                            setOfAssetIds.add(theItem.assetId);
	//                        }
	//                    }
	//                }
	//            }
	//        }
	//        if (itemsFromPage != null && itemsFromPage.itemMap != null) {
	//            User theUser = [SELECT Id, Data_ID__c, Preferred_Branch__c FROM User WHERE Id = :UserInfo.getUserId()];
	//            String currentInfo = Utils.getCurrentUserScubeInfo().brand;
	//            for (MigrationPremiumTypes.Item itemFromPageMap : itemsFromPage.itemMap.values()) {
	//                for (MigrationPremiumTypes.Item itemInChildMap : itemFromPageMap.childItemMap.values()) {
	//                    if (itemInChildMap.theAsset != null && itemInChildMap.theAsset.Card_Status__c != null && setOfAssetIds.contains(itemInChildMap.theAsset.Parent_Asset__c)) {
	//                        DeactivationCardsWrapper returnedTheWrap = getCardDetailFromData(theUser, itemFromPageMap, itemInChildMap, currentInfo, listToRequest, mapOfParentAccNumberPerChildAssetId);
	//                        if (returnedTheWrap != null && String.isNotBlank(returnedTheWrap.errorMessage)) {
	//                            return returnedTheWrap;
	//                        }
	//                    }
	//                }
	//            }
	//            PermanentBlockCardApi.PermanentBlockCard_v1_Dir2_PortTypeBindingHttpPort port = new PermanentBlockCardApi.PermanentBlockCard_v1_Dir2_PortTypeBindingHttpPort();
	//            try {
	//                if (listToRequest != null && !listToRequest.isEmpty()) {
	//                    request.Card = listToRequest;
	//                    system.debug('request.Card: ' + request.Card);
	//                    if (!Test.isRunningTest()) {
	//                        PermanentBlockCardApiTypes.CardListRes_element responseFromDeactivation = port.PermanentBlockCard_v1(request);
	//                        system.debug('responseFromDeactivation: ' + responseFromDeactivation);
	//                    }
	//                    DeactivationCardsWrapper theWrap = new DeactivationCardsWrapper('success', null);
	//                    IntegrationLogger.flushOutboundV2(null, null, 'Asset', 'UNICARD', 'PermanentBlockCard_v1', GlobalConstants.WEBSERVICE_OK_CODE, 'OK', port.MetaHeader_v2);
	//                    return theWrap;
	//                }
	//            } catch (Exception ex) {
	//                Integer resultCode = 0; // OK assumed
	//                String resultDescription = null;
	//                IntegrationLogger.flushOutboundV2(null, null, 'Asset', 'UNICARD', 'PermanentBlockCard_v1', resultCode, resultDescription, port.MetaHeader_v2);
	//                resultCode = IntegrationExceptions.getErrorCodeForExceptionType(ex);
	//                resultDescription = ex.getMessage();
	//                DeactivationCardsWrapper theWrap = new DeactivationCardsWrapper(null, 'error ' + port.MetaHeader_v2.CallContext.Sid + ' ex: ' + ex);
	//                return theWrap;
	//            }
	//        }
	//        return new DeactivationCardsWrapper('no credit cards deactivated', null);
	//    }

	/* public static DeactivationCardsWrapper getCardDetailFromData(User u, MigrationPremiumTypes.Item itemInMap, MigrationPremiumTypes.Item itemInChildMap, String currentInfo, List<PermanentBlockCardApiTypes.Card_element> listToRequest, Map<String, Asset> mapOfParentAccNumberPerChildAssetId) {
		 //if(isValidToCancel){
		 String userDataId = (String.isNotBlank(u.Data_ID__c)) ? u.Data_ID__c : Utils.getDefaultMetaHeaderUser();
		 String userPreferredBranch = Utils.getUserBranchDataId();
		 Long cuidLong = Long.valueOf(itemInMap.theAsset.Account.CUID__c);
		 String languageId = null;       // not used
		 Long userBranch = Long.valueOf(userPreferredBranch);
		 Integer clientInstanceBankSystem = 12;     // constant, means we send CUID as client identifier
		 String cardUnicardId = null;    // not required
		 Long cardBrandLong = Long.valueOf(itemInChildMap.theAsset.Brand__c);
		 Boolean ahead = false;          // default
		 GetCardDetailV1ApiTypes.CardPartyKey_element cardInfo = new GetCardDetailV1ApiTypes.CardPartyKey_element();
		 cardInfo.Cuid = cuidLong;
		 if (mapOfParentAccNumberPerChildAssetId != null && !mapOfParentAccNumberPerChildAssetId.isEmpty() && mapOfParentAccNumberPerChildAssetId.containsKey(itemInMap.theAsset.Id)) {
			 cardInfo.AccountNumber = mapOfParentAccNumberPerChildAssetId.get(itemInMap.theAsset.Id).Parent_Asset__r.Account_Number__c;
		 } else {
			 cardInfo.AccountNumber = itemInMap.theAsset.Account_Number__c;
		 }
		 cardInfo.CardNumberFromRight = itemInChildMap.theAsset.Account_Number__c;
		 cardInfo.RightLength = 4;

		 GetCardDetailV1Api.GetCardDetail_v1_PortTypeBindingHttpPort port;
		 GetCardDetailV1ApiTypes.GetCardDetailRes_element response;
		 Integer resultCode = 0; // OK assumed
		 String resultDescription = null;
		 try {
			 PermanentBlockCardApiTypes.Card_element oneCardReq = new PermanentBlockCardApiTypes.Card_element();
			 system.debug('test cardInfo: ' + cardInfo);

			 port = new GetCardDetailV1Api.GetCardDetail_v1_PortTypeBindingHttpPort();
			 response = port.GetCardDetail_v1('CARD_DETAIL', 'SF', userDataId, clientInstanceBankSystem,
					 userBranch, '1', cardUnicardId, cardBrandLong, ahead, cardInfo, String.valueOf(cuidLong), Integer.valueOf(userPreferredBranch));
			 system.debug('test');
			 oneCardReq.RqtType = 'PERMANENTBLOCK';
			 oneCardReq.SrcId = 'FORCE';
			 oneCardReq.MdfUser = userDataId;
			 oneCardReq.BrhCd = Long.valueOf(currentInfo);
			 oneCardReq.CardNo = response.CardNumber;
			 oneCardReq.CardUniId = response.CardUnicardId;
			 oneCardReq.Ahead = response.Ahead;
			 oneCardReq.PinShr = false;
			 oneCardReq.CardShr = true;
			 oneCardReq.CmtKnd = 1;
			 oneCardReq.LstMdfDt = response.LastLogicalStatusChangeDate;
			 oneCardReq.Vld = Datetime.now();
			 */ /*if(mapOfParentAccNumberPerChildAssetId != null && !mapOfParentAccNumberPerChildAssetId.isEmpty() && mapOfParentAccNumberPerChildAssetId.containsKey(itemInMap.theAsset.Id)){
                oneCardReq.Vld = mapOfParentAccNumberPerChildAssetId.get(itemInMap.theAsset.Id).PurchaseDate;
                //oneCardReq.Vld = '20200827000000';
            } else{
                if(mapOfParentAccNumberPerChildAssetId != null && !mapOfParentAccNumberPerChildAssetId.isEmpty() && mapOfParentAccNumberPerChildAssetId.containsKey(itemInChildMap.theAsset.Id)) {
                    oneCardReq.Vld = mapOfParentAccNumberPerChildAssetId.get(itemInChildMap.theAsset.Id).PurchaseDate;
                    //oneCardReq.Vld = '20200827000000';

                }
            }*/ /*
            listToRequest.add(oneCardReq);
            resultDescription = 'CardUnicardId: ' + response.CardUnicardId + ', CardNumber: ' + response.CardNumber + ', AccountNumber: ' + response.AccountNumber;
            return new DeactivationCardsWrapper('success', null);
        } catch (Exception ex) {
            IntegrationLogger.flushOutboundV2(itemInMap.theAsset.Id, itemInMap.theAsset.External_ID__c, 'Asset', 'UNICARD', 'GetCardDetail_v3', resultCode, resultDescription, port.MetaHeader_v3);
            resultCode = IntegrationExceptions.getErrorCodeForExceptionType(ex);
            resultDescription = ex.getMessage();
            DeactivationCardsWrapper theWrap = new DeactivationCardsWrapper(null, 'error in GetCardDetail_v3 ' + port.MetaHeader_v3.Sid + ' resultDescription: ' + resultDescription);
            return theWrap;
        }
        //}
    }*/

	/*global class DeactivationCardsWrapper {
		global String successMessage;
		global String errorMessage;
		global DeactivationCardsWrapper(String successMessage, String errorMessage) {
			this.successMessage = successMessage;
			this.errorMessage = errorMessage;
		}
	}*/

	global class CreateCaseWrapper {
		global String theCaseId;
		global String barcodeUrl;
		global String errorMessage;
		global CreateCaseWrapper(String theCaseId) {
			this.theCaseId = theCaseId;
		}
		/*global CreateCaseWrapper(String theCaseId, String barcodeUrl) {
			this.theCaseId = theCaseId;
			this.barcodeUrl = barcodeUrl;
		}
		global CreateCaseWrapper(String theCaseId, String barcodeUrl, String errorMessage) {
			this.theCaseId = theCaseId;
			this.barcodeUrl = barcodeUrl;
			this.errorMessage = errorMessage;
		}*/
	}

	global class OppWrapper {
		global String theOppId;
		global String errorMessage;
		global OppWrapper(String theOppId, String errorMessage) {
			this.theOppId = theOppId;
			this.errorMessage = errorMessage;
		}
	}

	global class ReturnObjectWrapper {
		@AuraEnabled
		global String objectId;
		@AuraEnabled
		global String objectStatus;
		global ReturnObjectWrapper(String objId, String objStatus) {
			this.objectId = objId;
			this.objectStatus = objStatus;
		}
	}

	/*    global class NonClientWrapper {
        global String firstName;
        global String lastName;
        global String birthDate;
        global NonClientWrapper(String firstNameString, String lastNameString, String birthDateString) {
            this.firstName = firstNameString;
            this.lastName = lastNameString;
            this.birthDate = birthDateString;
        }
    }*/

	//    @RemoteAction
	//    global static String assignCase(String caseId, String migrationProcessConfigurationId){
	//        List<Case> caseList = [SELECT Id FROM Case WHERE Id = :caseId];
	//        if (caseList != null && !caseList.isEmpty()) {
	//            Case theCase = caseList.get(0);
	//            Migration_Process__mdt migrationProcessConfiguration = getProcessConfigurationById(migrationProcessConfigurationId);
	//            if (String.isNotBlank(migrationProcessConfiguration.Case_Queue_Name__c)) {
	//                List<Group> qList = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = :migrationProcessConfiguration.Case_Queue_Name__c LIMIT 1];
	//                if (qList != null && !qList.isEmpty()) {
	//                    theCase.OwnerId = qList.get(0).Id;
	//                }
	//            } else {
	//                theCase.OwnerId = Utils.getUtvarUserId();
	//            }
	//            theCase.PCF_Unfinished__c = false;
	//            update theCase;
	//            return theCase.Id;
	//        }
	//        return null;
	//    }

	@RemoteAction
	global static String saveCaseAttachment(String serializedAttachment, String caseId) {
		MigrationPremiumTypes.File theFile;
		if (!String.isBlank(serializedAttachment)) {
			theFile = (MigrationPremiumTypes.File) JSON.deserialize(
				serializedAttachment,
				MigrationPremiumTypes.File.class
			);
		}
		// Attachment caseAttachment = new Attachment();
		// if(theFile != null){
		//     caseAttachment.Body = EncodingUtil.base64Decode(theFile.data);
		//     caseAttachment.Name = theFile.name;
		//     caseAttachment.ParentId = caseId;
		//     insert caseAttachment;
		// }

		return theFile != null && saveFile(theFile, caseId) != null ? theFile.size : null;
	}

	/**
	 * @author PJ
	 * @description Method saves the file and links it to the parent object.
	 * @param MigrationPremiumTypes.File theFile
	 * @param String parentIdR
	 * @returns the downloadable file url if the file was saved, null otherwise
	 */
	private static String saveFile(MigrationPremiumTypes.File theFile, String parentId) {
		try {
			ContentVersion cv = [
				SELECT Id, ContentDocumentId
				FROM ContentVersion
				WHERE Id = :createContentVersion(theFile)
			]; // creates ContentVersion and gets ContentDocumentId
			// create ContentDocumentLink - link between created ContentDocument and parent object (Case in our case)
			ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.ContentDocumentId = cv.ContentDocumentId;
			cdl.LinkedEntityId = parentId;
			cdl.ShareType = 'I'; // 'I' = Inferred permission (determined by the related record), 'C' = Collaborator permission (the user can explicitly view and edit the shared file), 'V' = Viewer permission (the user can explicitly view but not edit the shared file)
			insert cdl;
			insert new ContentDistribution(
				name = theFile.name,
				contentVersionId = cv.id,
				PreferencesAllowViewInBrowser = true,
				PreferencesNotifyOnVisit = false
			);
			ContentDistribution cd = [
				SELECT Id, ContentDocumentId, ContentDownloadUrl, DistributionPublicUrl
				FROM ContentDistribution
				WHERE ContentDocumentId = :cv.ContentDocumentId
			];
			return encodingUtil.urlEncode(cd.ContentDownloadUrl, 'UTF-8');
		} catch (Exception e) {
			System.debug('Filesaving failed: ' + e.getMessage());
		}
		return null;
	}

	/**
	 * @author PJ
	 * @description Method creates ContentVersion from the MigrationPremiumTypes.File parameter. Creation of ContentVersion also automatically creates ContentDocument and links it with ContentVersion. Note: ContentVersion.ContentDocumentId is not populated automatically after insert of ContentVersion; it must be selected afterwards.
	 * @param MigrationPremiumTypes.File theFile
	 * @returns Id of inserted ContentVersion
	 */
	private static String createContentVersion(MigrationPremiumTypes.File theFile) {
		ContentVersion cv = new ContentVersion();
		cv.ContentLocation = 'S'; // 'S' = document in SF, 'E' = external document
		cv.PathOnClient = theFile.name;
		cv.Title = theFile.name;
		if (Test.isRunningTest()) {
			cv.VersionData = EncodingUtil.convertFromHex(theFile.data);
		} else {
			cv.VersionData = EncodingUtil.base64Decode(theFile.data);
		}
		insert cv;
		return cv.Id;
	}

	@RemoteAction
	global static List<MigrationPremiumTypes.ProductParameterWrapper> getProductParameters(
		String productRelationId,
		String ppAssetId,
		String metadataConfigurationId,
		Id accountIdParam,
		String disponentId,
		String productId
	) {
		Set<String> l2ProductParameterIdSet = new Set<String>();
		Map<String, List<Product_Parameter__c>> l2ProductParameterPerParentIdMap = new Map<String, List<Product_Parameter__c>>();
		Map<String, Product_Parameter__c> sectionParameterMap = getL1ProductParameterMap(productRelationId);
		Map<String, Product_Parameter__c> productParameterL2WithChildMap = getL2ProductParameterWithChildMap(
			productRelationId,
			sectionParameterMap.keySet()
		);

		System.debug('getting parameters');
		System.debug('L1: ' + sectionParameterMap);
		System.debug('L2: ' + productParameterL2WithChildMap);
		for (Product_Parameter__c theProductParameter : productParameterL2WithChildMap.values()) {
			l2ProductParameterIdSet.add(theProductParameter.Id);
			if (l2ProductParameterPerParentIdMap.containsKey(theProductParameter.Product_Parameter__c)) {
				l2ProductParameterPerParentIdMap.get(theProductParameter.Product_Parameter__c).add(theProductParameter);
			} else {
				List<Product_Parameter__c> dataList = new List<Product_Parameter__c>();
				dataList.add(theProductParameter);
				l2ProductParameterPerParentIdMap.put(theProductParameter.Product_Parameter__c, dataList);
			}
		}

		Migration_Process__mdt migrationProcessConfiguration = getProcessConfigurationById(metadataConfigurationId);
		if (!String.isBlank(disponentId) && disponentId != 'null') {
			accountId = disponentId;
		} else {
			accountId = accountIdParam;
		}
		assetId = ppAssetId;
		product2Id = productId;
		typeOfRelation = getSetFromStringCommaDelimited(migrationProcessConfiguration.Representative_Relation_ID__c);
		Asset assetFromProductParameter = getAssetsFromProductParameterFormula(
			productParameterL2WithChildMap.values(),
			ppAssetId
		);
		MigrationPremiumTypes.ThresholdWrapper thresholdToProductParameter = getThresholdWrapper(
			l2ProductParameterIdSet
		);

		Map<String, MigrationPremiumTypes.ProductParameterWrapper> productParameterResultMap = new Map<String, MigrationPremiumTypes.ProductParameterWrapper>();
		for (Product_Parameter__c l1ProductParameter : sectionParameterMap.values()) {
			List<Product_Parameter__c> l2ProductParameterList = l2ProductParameterPerParentIdMap.get(
				l1ProductParameter.Id
			);
			if (productParameterResultMap.containsKey(l1ProductParameter.Id)) {
				productParameterResultMap.get(l1ProductParameter.Id).productParameter = l1ProductParameter;
			} else {
				MigrationPremiumTypes.ProductParameterWrapper data = new MigrationPremiumTypes.ProductParameterWrapper(
					l1ProductParameter
				);
				data.setVisibility(getVisibilityTypeFromParameter(l1ProductParameter, theUser.Profile.Name));
				productParameterResultMap.put(l1ProductParameter.Id, data);
			}
			if (l2ProductParameterList == null || l2ProductParameterList.isEmpty()) {
				continue;
			}
			for (Product_Parameter__c l2ProductParameter : l2ProductParameterList) {
				System.debug('-------------------------');
				System.debug(l2ProductParameter.Name);
				String defaultValueFromAsset;
				if (l2ProductParameter.Type__c == TYPE_FORMULA) {
					l2ProductParameter.String_Value__c = (String) l2ProductParameter.get(l2ProductParameter.Formula__c);
				}
				System.debug(l2ProductParameter.Algorithm_Mapping__c);
				System.debug(assetFromProductParameter);
				if (!String.isBlank(l2ProductParameter.Algorithm_Mapping__c) && assetFromProductParameter != null) {
					System.debug('TUTUTU!');
					defaultValueFromAsset = getDefaultValueFromAsset(l2ProductParameter, assetFromProductParameter);
					System.debug(defaultValueFromAsset);
				}
				if (
					l2ProductParameter.Type__c == TYPE_INPUT_WITH_SOQL ||
					((l2ProductParameter.Type__c == TYPE_HIDDEN && String.isNotBlank(l2ProductParameter.SOQL__c) ||
					(l2ProductParameter.Type__c == TYPE_DATE && String.isNotBlank(l2ProductParameter.SOQL__c))) &&
					String.isNotBlank(l2ProductParameter.SOQL_Field_Name__c))
				) {
					defaultValueFromAsset = getInputWithSOQLValue(l2ProductParameter);
				}
				MigrationPremiumTypes.ProductParameterWrapper wrapper = new MigrationPremiumTypes.ProductParameterWrapper(
					l2ProductParameter,
					defaultValueFromAsset
				);
				/*if (l2ProductParameter.Type__c == TYPE_EXTERNAL_LINK) {
					wrapper.data = getExternalLinkData(l2ProductParameter);
				}*/
				wrapper.setVisibility(getVisibilityTypeFromParameter(l2ProductParameter, theUser.Profile.Name));
				System.debug(wrapper.visibility);
				if (thresholdToProductParameter.parentByMap.containsKey(l2ProductParameter.Id)) {
					wrapper.hasDependencies = true;
				}
				wrapper.setVisibility(
					getVisibilityType(
						thresholdToProductParameter,
						productParameterL2WithChildMap,
						l2ProductParameter,
						assetFromProductParameter,
						wrapper.visibility
					)
				);
				System.debug(wrapper.visibility);
				if (
					(l2ProductParameter.Type__c == 'Calculated Select' ||
					l2ProductParameter.Type__c == 'Multi Select') && !String.isBlank(l2ProductParameter.Soql__c)
				) {
					system.debug('*** CS: ' + l2ProductParameter.Name);
					system.debug(assetId);
					wrapper.childParameterList = getChildProductParametersFromSOQL(l2ProductParameter);
				}
				if (productParameterResultMap.containsKey(l2ProductParameter.Product_Parameter__c)) {
					productParameterResultMap.get(l2ProductParameter.Product_Parameter__c).addChildParameter(wrapper);
				} else {
					MigrationPremiumTypes.ProductParameterWrapper data = new MigrationPremiumTypes.ProductParameterWrapper();
					data.addChildParameter(wrapper);
					productParameterResultMap.put(l2ProductParameter.Product_Parameter__c, data);
				}
				/*if (migrationProcessConfiguration.DeveloperName == 'Account_Cancellation' && l2ProductParameter.Sync_Element_Name__c == 'terminationFee') {
					l2ProductParameter.String_Value__c = getTerminationFee(assetId, l2ProductParameter.Product_Relation__r.From__r.CST_Value_ID__c);
				}*/

				for (Product_Parameter__c l3ProductParameter : l2ProductParameter.Product_Parameters__r) {
					if (productParameterResultMap.containsKey(l1ProductParameter.Id)) {
						MigrationPremiumTypes.ProductParameterWrapper sectionWrapper = productParameterResultMap.get(
							l1ProductParameter.Id
						);
						sectionWrapper.setVisibility(
							getVisibilityTypeFromParameter(l3ProductParameter, theUser.Profile.Name)
						);
						if (sectionWrapper.childParameterList.containsKey(l2ProductParameter.Id)) {
							MigrationPremiumTypes.ProductParameterWrapper parentParameter = sectionWrapper.childParameterList.get(
								l2ProductParameter.Id
							);
							parentParameter.addChildParameter(
								new MigrationPremiumTypes.ProductParameterWrapper(l3ProductParameter)
							);
						} else {
							System.debug(
								'Product parameter with ID: ' +
								l2ProductParameter.Id +
								' did not found in the map.'
							);
						}
					} else {
						System.debug(
							'Product parameter with ID: ' +
							l1ProductParameter.Id +
							' did not found in the map.'
						);
					}
				}
			}
		}
		return productParameterResultMap.values();
	}

	/*    @RemoteAction
    global static boolean checkHeritageCasesDraft(String accountIdFromPage) {
        */ /*List<Case> listOfCases = new List<Case>();
        listOfCases = [select id from Case where Type_of_Process__c = 'Heritage' and Status = '10' and AccountId = :accountIdFromPage];
        if(!listOfCases.isEmpty() && listOfCases.size() > 0){
            return true;
        }else{
            return false;
        }*/ /*
        return false;
    }*/

	@RemoteAction
	global static List<MigrationPremiumTypes.DependencyWrapper> checkDependencies(
		String parentProductParameter,
		String parentProductId,
		String productId,
		String valueId,
		String valueText,
		Boolean hasBackgroundQuery,
		Boolean hideAllDependentParams,
		String accId
	) {
		System.debug('checking dependencies for: ' + valueId + ' - ' + valueText);
		System.debug('parentProdParam: ' + parentProductParameter);
		System.debug('parentProductId: ' + parentProductId);
		System.debug('productId: ' + productId);
		List<MigrationPremiumTypes.DependencyWrapper> dependencyList = new List<MigrationPremiumTypes.DependencyWrapper>();
		List<sObject> backgroundSoqlResult;
		Product_Parameter__c theProductParameter;
		String value = String.isBlank(valueId) ? valueText : valueId;

		Set<String> parameterIdSet = new Set<String>();
		parameterIdSet.add(parentProductParameter);
		MigrationPremiumTypes.ThresholdWrapper theThresholdWrapper = getThresholdWrapper(parameterIdSet);

		if (theThresholdWrapper.parentByMap.containsKey(parentProductParameter)) {
			System.debug('1');
			if (hasBackgroundQuery) {
				System.debug('2');
				List<Product_Parameter__c> productParameterList = [
					SELECT
						Id,
						Type__c,
						SOQL_Background_Query__c,
						SOQL_Filter_Query__c,
						SOQL_Background_Query_Search_Using_DPaaS__c
					FROM Product_Parameter__c
					WHERE Id = :parentProductParameter
				];
				if (productParameterList != null && !productParameterList.isEmpty()) {
					System.debug('3');
					theProductParameter = productParameterList.get(0);
					if (!String.isEmpty(theProductParameter.SOQL_Background_Query__c)) {
						/* && !String.isEmpty(theProductParameter.SOQL_Background_Query__c)*/
						System.debug('4');
						/*if (!Utils.isJiraEnabled(GlobalConstants.JIRA_SHIELD) && theProductParameter.SOQL_Background_Query_Search_Using_DPaaS__c) {
							System.debug('5');
							if (!theProductParameter.SOQL_Background_Query__c.contains(':value')) {
								System.debug('6');
								System.debug('SOQL_Background_Query__c is not valid. The query does not contains the placeholder ":value". Query is: ' + theProductParameter.SOQL_Background_Query__c);
							} else {
								System.debug('7');
								String query = theProductParameter.SOQL_Background_Query__c.replaceAll(':value', '\'' + value + '\'');
								DpaasWebServiceSearchClient client = new DpaasWebServiceSearchClient();
								client.createCS();
								client.applicationName = Cipher_Cloud_App_Name__c.getInstance(GlobalConstants.CC_APP_NAME_CS_KEY).App_Name__c;
								backgroundSoqlResult = client.dpaasSoqlQuery(query);
							}
						} else {*/
						System.debug('8');
						System.debug(value);
						if (theProductParameter.SOQL_Background_Query__c.toLowerCase().contains('select ')) {
							backgroundSoqlResult = Database.query(theProductParameter.SOQL_Background_Query__c);
						} else if (theProductParameter.SOQL_Background_Query__c.toLowerCase().contains('find ')) {
							String o = theProductParameter.SOQL_Background_Query__c.toLowerCase()
								.substringAfter('returning ')
								.substringBefore('(');
							List<String> soslParts = theProductParameter.SOQL_Background_Query__c.split('\\|');
							String sosl = soslParts.get(0);
							System.debug(theProductParameter.SOQL_Background_Query__c);
							System.debug(soslParts);
							List<String> conditions;
							if (soslParts.size() > 1) {
								conditions = soslParts.get(1).split(',');
							}
							Search.SearchResults searchResults = Search.find(sosl);
							List<Search.SearchResult> searchList = searchResults.get(o);
							backgroundSoqlResult = new List<SObject>();
							for (Search.SearchResult sr : searchList) {
								if (conditions != null && !conditions.isEmpty()) {
									for (String condField : conditions) {
										if (sr.getSObject().get(condField) == value) {
											backgroundSoqlResult.add(sr.getSObject());
											break;
										}
									}
								} else {
									backgroundSoqlResult.add(sr.getSObject());
								}
							}
							if (String.isNotBlank(theProductParameter.SOQL_Filter_Query__c)) {
								Set<String> idSet = new Set<String>();
								for (SObject so : backgroundSoqlResult) {
									idSet.add(String.valueOf(so.get('id')));
								}
								backgroundSoqlResult = Database.query(
									theProductParameter.SOQL_Filter_Query__c + ' WHERE Id IN :idSet'
								);
							}
						}
						//}
					}
				}
			}
			for (
				List<Threshold_Product_Parameter__c> thresholdList : theThresholdWrapper.parentByMap.get(
						parentProductParameter
					)
					.values()
			) {
				if (hasBackgroundQuery) {
					for (Threshold_Product_Parameter__c threshold : thresholdList) {
						List<sObject> dependentSoqlResult;
						if (String.isNotBlank(threshold.Dependent_Product_Parameter__r.Soql__c)) {
							String soql = threshold.Dependent_Product_Parameter__r.Soql__c.replaceFirst(
								': *[a-zA-Z]*',
								':value'
							);

							System.debug('*** SOQL: ' + soql);
							dependentSoqlResult = Database.query(soql);
						} else {
							dependentSoqlResult = backgroundSoqlResult == null
								? new List<sObject>()
								: backgroundSoqlResult;
						}
						System.debug('9: ' + dependentSoqlResult);
						System.debug(threshold.Id);
						MigrationPremiumTypes.DependencyWrapper item = new MigrationPremiumTypes.DependencyWrapper();
						item.hasBackgroundQuery = hasBackgroundQuery;
						if (hasBackgroundQuery) {
							System.debug('10');
							System.debug(theProductParameter);
							if (
								theProductParameter.Type__c ==
								TYPE_INPUT_WITH_BACKGROUND_QUERY /*|| theProductParameter.Type__c == TYPE_SELECT_WITH_BACKGROUND_QUERY*/
							) {
								System.debug('11');
								item.visibilityType = MigrationPremiumTypes.VISIBILITY_TYPE_DISABLE;
								if (backgroundSoqlResult != null && !backgroundSoqlResult.isEmpty()) {
									System.debug('12');
									item.initialValue = getResultFromSOQLOfThresholdValue(
										threshold,
										backgroundSoqlResult.get(0)
									);
								}
							} else if (
								theProductParameter.Type__c == TYPE_MULTIPLE_INPUT_WITH_BACKGROUND_QUERY ||
								theProductParameter.Type__c == TYPE_SELECT_WITH_BACKGROUND_QUERY
							) {
								System.debug('13');
								item.visibilityType = MigrationPremiumTypes.VISIBILITY_TYPE_SHOW;
								item.multipleInitialValueList = new List<MigrationPremiumTypes.DependencyValueWrapper>();
								for (sObject theItem : dependentSoqlResult) {
									System.debug('14');
									String thresholdSoqlResult = getResultFromSOQLOfThresholdValue(threshold, theItem);
									if (
										thresholdSoqlResult != null &&
										thresholdSoqlResult.contains('[[') &&
										thresholdSoqlResult.contains(']]') &&
										thresholdSoqlResult.contains(INNER_SOQL_SEPARATOR) &&
										thresholdSoqlResult.contains(INNER_SOQL_ID_SEPARATOR)
									) {
										List<String> thresholdSoqlResults = thresholdSoqlResult.removeStart('[[')
											.removeEnd(']]')
											.removeEnd(INNER_SOQL_SEPARATOR)
											.split(INNER_SOQL_SEPARATOR);
										for (String tsr : thresholdSoqlResults) {
											List<String> tsrp = tsr.split(INNER_SOQL_ID_SEPARATOR);
											MigrationPremiumTypes.DependencyValueWrapper newItem = new MigrationPremiumTypes.DependencyValueWrapper();
											newItem.value = tsrp.get(0);
											newItem.text = tsrp.get(1);
											item.multipleInitialValueList.add(newItem);
										}
									} else {
										MigrationPremiumTypes.DependencyValueWrapper newItem = new MigrationPremiumTypes.DependencyValueWrapper();
										newItem.value = getValueFromSObject(theItem, 'Id');
										newItem.text = thresholdSoqlResult;
										item.multipleInitialValueList.add(newItem);
									}
								}
							}
						}
						item.composedId =
							parentProductId +
							'-' +
							productId +
							'-' +
							threshold.Dependent_Product_Parameter__c;
						item.isHidden = hideAllDependentParams;
						dependencyList.add(item);
					}
				} else {
					MigrationPremiumTypes.DependencyWrapper item = new MigrationPremiumTypes.DependencyWrapper();
					item.hasBackgroundQuery = hasBackgroundQuery;
					System.debug('15');
					Integer counter = 0;
					for (Threshold_Product_Parameter__c threshold : thresholdList) {
						counter++;
						System.debug(threshold.Threshold_Value__r.Text_Value__c);
						System.debug(valueText);
						System.debug(counter);
						System.debug(thresholdList.size());
						if (threshold.Threshold_Value__r.Text_Value__c == valueText) {
							MigrationPremiumTypes.DependencyWrapper result = getResultThresholdVsValue(
								threshold,
								valueText
							);
							item.visibilityType = result.visibilityType;
							item.initialValue = result.initialValue;
							item.composedId =
								parentProductId +
								'-' +
								productId +
								'-' +
								threshold.Dependent_Product_Parameter__c;
							item.isHidden = hideAllDependentParams;
							if (threshold.Dependent_Product_Parameter__r.Type__c == TYPE_INPUT_WITH_SOQL) {
								accountId = Id.valueOf(accId);
								item.initialValue = getInputWithSOQLValue(threshold.Dependent_Product_Parameter__r);
							}
							System.debug('Adding Item: ' + item);
							dependencyList.add(item);
							break;
						} else if (thresholdList.size() == counter) {
							System.debug('----------');
							MigrationPremiumTypes.DependencyWrapper result = getResultThresholdVsValue(
								threshold,
								valueText
							);
							item.visibilityType = result.visibilityType;
							item.initialValue = result.initialValue;
							item.composedId =
								parentProductId +
								'-' +
								productId +
								'-' +
								threshold.Dependent_Product_Parameter__c;
							item.isHidden = hideAllDependentParams;
							if (threshold.Dependent_Product_Parameter__r.Type__c == TYPE_INPUT_WITH_SOQL) {
								accountId = Id.valueOf(accId);
								item.initialValue = getInputWithSOQLValue(threshold.Dependent_Product_Parameter__r);
							}
							dependencyList.add(item);
							System.debug(item);
						}
					}
				}
			}
		}
		System.debug('Dependecy Wrapper:');
		for (MigrationPremiumTypes.DependencyWrapper dw : dependencyList) {
			System.debug(dw);
		}

		return dependencyList;
	}

	/*    @RemoteAction
    global static void sendOutput(String cuid, Integer typeId, String contact, String offerType, String outputType, String processName, List<CebNotificationUtils.FileListWrapper> fileList) {
        if (!fileList.isEmpty()) {
            SendOutputV3Api.SendOutput_v3_Dir2_PortTypeBindingHttpPort port = new SendOutputV3Api.SendOutput_v3_Dir2_PortTypeBindingHttpPort();
            SendOutputV3ApiTypes.Subject_element Subject = CebNotificationUtils.getSubject(cuid);
            SendOutputV3ApiTypes.Output_element Output = CebNotificationUtils.getOutput(cuid, typeId, contact, offerType, outputType, processName, fileList);
            SendOutputV3ApiTypes.SendOutputRes_element res = port.SendOutput_v3(Subject, Output);
        }
    }*/

	/*@RemoteAction
	global static String generateIstsDocument(
			String accountId, String assetId, String dmsDocumentId, String templateCode, String productListConf, String productRelationsConf,
			String selectedAssetMainElement, String selectedAssetChildElement, String migrationProcessId, String elDocDistAgr, String caseIdFromUrl, String editMode
	) {
		Migration_Process__mdt configuration = getProcessConfigurationById(migrationProcessId);
		IMigrationIsts extension;
		system.debug('configuration: ' + configuration);
		system.debug('productListConf: ' + productListConf);
		system.debug('productRelationsConf: ' + productRelationsConf);
		system.debug('selectedAssetMainElement: ' + selectedAssetMainElement);
		system.debug('selectedAssetChildElement: ' + selectedAssetChildElement);
		system.debug('dmsDOcument: ' + dmsDocumentId);
		system.debug('templateCode: ' + templateCode);
		system.debug('editMode: ' + editMode);
		if (configuration != null) {
//            if(dmsDocumentId == '1022') {
//                extension = new MigrationPremiumFIDIsts();
//            } else if(configuration.DeveloperName == 'Premium' && dmsDocumentId == '357') {
//                extension = new MigrationPremiumInsuranceReceivablesIsts();
//            } else
			if (templateCode == 'UVE_006CRMNCZ') { //129, Premium
				extension = new MigrationCreditCardIsts();
			} else if (templateCode == 'UVE_006CRMPSNCZ') { //228
				extension = new MigrationCancelOverDraft();
			} else if (templateCode == 'PREMIUM_001DCZ') { //214
				extension = new MigrationPremiumIstsExtension();
			} else if (templateCode == 'UBS_082S3CZ') { //42
				extension = new MigrationSavingAccountIsts();
			} else if (templateCode == 'LIS_009DCZ') { //188
				extension = new MigrationPPPIsts();
			} else if (templateCode == 'LIS_010DCZ') { //189
				extension = new MigrationPPPWithoutDataIsts();
			} else if (templateCode == 'ZPS_022PSV4NCZ') { //3
				extension = new IstsAccountCreationRequest();
			} else if (templateCode == 'OST_003CRMCZ') { //817
				extension = new IstsHeritage();
			} else if (templateCode == 'UBS_080PSS3CZ') { //357
				extension = new IstsDepositInsurance();
			} else if (templateCode == 'FID_010PSS3CZ') { //1021
				extension = new HeritageFIDIsts();
			} else if (templateCode == 'UVE_007CRMNCZ') { //129, Sufo
				extension = new IstsSufo();
				//} else if (templateCode == 'MIGRATION_001DCZ') { //840
				//    extension = new IstsAccountMigration();
			} else if (templateCode == 'CRM_003D') { //1933
				extension = new IstsAccountCancellation();
			} else if (templateCode == 'CRM_004D') { //1933
				extension = new IstsCancelAccountCancellation();
				//} else if (templateCode == 'MIGRATION_002DCZ') { //1562
				//    extension = new IstsFopAccountMigration();
			} else if (templateCode == 'DKA_006S3NCZ') {
				extension = new IstsOSU(templateCode);
			} else if (templateCode == 'MOBILITA_001CZ') { //1907
				extension = new IstsMobilita();
			} else if (templateCode == 'ASSET_014CZ') { //
				extension = new IstsPPFRegularOrder();
			} else if (PPF_TEMPLATE_CODE_MAP.values().contains(templateCode)) {
				extension = new IstsPPF(templateCode);
			} else {
				return null;
			}
		} else {
			return null;
		}
		system.debug('extension: ' + extension);
		extension.setData(accountId, assetId, productListConf, productRelationsConf, elDocDistAgr, caseIdFromUrl, editMode);
		PushDocumentApiTypes.PushDocumentRes_element response = extension.callIsts(selectedAssetMainElement, selectedAssetChildElement);
		system.debug('*** Response: ' + response);
		if (response != null) {
			if (response.Barcode == 'CANCEL_ACC_CANCEL_ERROR' && String.isBlank(response.PrintId)) {
				return 'CANCEL_ACC_CANCEL_ERROR';
			}
			DMS_Document__c doc = new DMS_Document__c();
			doc.Type_Of_Document__c = dmsDocumentId;
			doc.Account__c = accountId;
			doc.Print_ID__c = response.PrintId;
			doc.Document_URL__c = response.IstsPrintingComponentUrl;
			doc.Barcode__c = response.Barcode;
			if (String.isNotBlank(response.DmsDocExternalId)) {
				doc.External_ID__c = response.DmsDocExternalId;
			} else {
				doc.External_ID__c = IstsUtils.getUniqueKey();
			}
			system.debug('budeme vytvaret dmsDocument');
			insert doc;
			system.debug('a document mame, vracime: ' + doc.Id);
			return doc.Id;
		}
		system.debug('a jeje, mame tady null :(');
		return null;
	}*/

	/*    @RemoteAction
    global static String storeJsonToCache(string json) {
        return IntegrationUtils.storeJsonToCache(json);
    }*/

	@RemoteAction
	global static List<Product2> getSubProductList(String parentProductId, String metadataConfigurationId) {
		Migration_Process__mdt migrationProcessConfiguration = getProcessConfigurationById(metadataConfigurationId);
		List<Product2> emptyList = new List<Product2>();
		if (String.isBlank(parentProductId)) {
			return emptyList;
		}
		Product2 theProduct = [
			SELECT Id
			/* Subproduct_SOQL__c, CST_Value_ID__c*/ FROM Product2
			WHERE Id = :parentProductId
		];
		if (theProduct == null /*|| String.isBlank(theProduct.Subproduct_SOQL__c)*/) {
			return emptyList;
		}

		String recType = '';
		if (migrationProcessConfiguration != null) {
			recType =
				'RecordType.DeveloperName = \'' +
				migrationProcessConfiguration.Product_Relation_Record_Type_Name__c +
				'\' AND ';
		}
		//and ' + recType + 'From__c IN (' + theProduct.Subproduct_SOQL__c + ')
		String query = 'SELECT To__c FROM Product_Relation__c WHERE Type__c=\'Create\' ';
		System.debug('-------------------------------');
		System.debug('------------SELECT-------------');
		System.debug(query);
		System.debug('-------------------------------');

		List<Product_Relation__c> prList = Database.query(query);
		Set<String> prodIds = new Set<String>();
		for (Product_Relation__c pr : prList) {
			prodIds.add(pr.To__c);
		}
		List<Product2> res = [SELECT Id, Name FROM Product2 WHERE Id IN :prodIds];

		return res;
	}

	private static MigrationPremiumTypes.DependencyWrapper getResultThresholdVsValue(
		Threshold_Product_Parameter__c theThreshold,
		String value
	) {
		MigrationPremiumTypes.DependencyWrapper result = new MigrationPremiumTypes.DependencyWrapper();
		if (
			theThreshold.Dependent_Product_Parameter__r.Value__c != null ||
			!String.isBlank(theThreshold.Dependent_Product_Parameter__r.String_Value__c)
		) {
			if (theThreshold.Dependent_Product_Parameter__r.Value__c != null) {
				result.initialValue = String.valueOf(theThreshold.Dependent_Product_Parameter__r.Value__c);
			} else {
				result.initialValue = theThreshold.Dependent_Product_Parameter__r.String_Value__c;
			}
		}
		System.debug(theThreshold.Threshold_Value__r.Text_Value__c);
		System.debug(value);
		if (theThreshold.Threshold_Value__r.Text_Value__c == value) {
			result.visibilityType = theThreshold.Threshold_Value__r.Type__c;
		} else {
			result.visibilityType = 'Show';
		}
		System.debug(result);
		return result;
	}

	private static String getResultFromSOQLOfThresholdValue(
		Threshold_Product_Parameter__c theThreshold,
		sObject theItem
	) {
		if (theItem == null || String.isBlank(theThreshold.Threshold_Value__r.Text_Value__c)) {
			return '';
		} else {
			return getValueFromSObject(theItem, theThreshold.Threshold_Value__r.Text_Value__c);
		}
	}

	/*    @TestVisible
    private static String getDefaultBranchId() {
        Branch__c defaultBranch;
        List<Branch__c> branchList = [select Name from Branch__c WHERE Data_Id__c = :theUser.Preferred_Branch__c];
        if (branchList != null && !branchList.isEmpty()) {
            defaultBranch = branchList.get(0);
        }

        return defaultBranch == null ? null : defaultBranch.Id;
    }*/

	@TestVisible
	private static String getSObjectRec(SObject theSObject, List<String> fieldList) {
		System.debug(theSObject);
		System.debug(fieldList);
		if (theSObject != null && !fieldList.isEmpty()) {
			String fieldName = fieldList.remove(0);
			if (fieldList.isEmpty()) {
				System.debug('returning');
				return String.valueOf(theSObject.get(fieldName));
			}
			System.debug('recursing');
			System.debug('recursing theSObject: ' + theSObject);
			System.debug('recursing fieldName: ' + fieldName);
			return getSObjectRec(theSObject.getSObject(fieldName), fieldList);
		}
		System.debug('nulling');
		return null;
	}

	@TestVisible
	private static String getValueFromSObject(sObject item, String fieldName) {
		System.debug(item);
		System.debug(fieldName);
		if (String.isBlank(fieldName)) {
			return null;
		}

		String objValue = '';
		String separator = '';
		List<String> fieldValuesList = fieldName.split('[^\\.\\w]+');
		Integer sizeFieldValuesList = fieldValuesList.size();
		if (sizeFieldValuesList > 1) {
			separator = fieldName.substringBetween(fieldValuesList.get(0), fieldValuesList.get(1));
		}
		Integer i = 0;
		System.debug(fieldValuesList);
		System.debug(separator);

		for (String val : fieldValuesList) {
			if (++i == sizeFieldValuesList) {
				separator = '';
			}
			if (val.contains('.')) {
				List<String> fieldNameList = val.split('\\.');
				System.debug(fieldNameList);
				String ff = fieldNameList.get(0);
				try {
					if (item != null) {
						//System.debug(item.getSObject(fieldNameList.get(0)));
						objValue += getSObjectRec(item, fieldNameList) + separator;
					}
				} catch (SObjectException ex) {
					system.debug('exxeption: ' + ex);
					List<SObject> soList = item.getSObjects(ff);
					if (soList != null && !soList.isEmpty()) {
						objValue += '[[';
						for (SObject theSObject : soList) {
							List<String> fieldBuffer = new List<String>(fieldNameList);
							objValue +=
								getSObjectRec(theSObject, new List<String>{ 'Id' }) +
								INNER_SOQL_ID_SEPARATOR +
								getSObjectRec(theSObject, fieldNameList) +
								INNER_SOQL_SEPARATOR;
							fieldNameList = new List<String>(fieldBuffer);
						}
						//objValue = objValue.removeEnd(INNER_SOQL_SEPARATOR);
						objValue += ']]' + separator;
					}
				}
			} else {
				Map<String, Schema.SObjectField> fieldMap = item.getSObjectType().getDescribe().fields.getMap();
				//                System.debug(JSON.serialize(fieldMap));
				System.debug(JSON.serialize(item));
				System.debug('*** fieldMap.get(' + val + '): ' + fieldMap.get(val));
				Schema.DisplayType fieldType = fieldMap.get(val) != null
					? fieldMap.get(val).getDescribe().getType()
					: null;
				if (fieldType == Schema.DisplayType.DATE) {
					Date d = (Date) item.get(val);
					if (d != null) {
						Datetime retDate = Datetime.newInstance(d.year(), d.month(), d.day());
						objValue += retDate.format('dd.MM.yyyy') + separator;
					}
				} else {
					objValue += String.valueOf(item.get(val)) + separator;
				}
			}
		}
		System.debug(objValue);
		return objValue == 'null' ? '' : objValue;
	}

	@TestVisible
	private static String getEnhancedSoqlForMigrationObject(String soql) {
		assetMerchFieldValue = '';
		accountMerchFieldValue = '';
		productMerchFieldValue = '';
		System.debug(soql);
		System.debug(assetMerchFieldValue);
		System.debug(accountMerchFieldValue);
		System.debug(productMerchFieldValue);

		if (soql.contains('migrationAsset') || soql.contains('theAccount') || soql.contains('migrationProduct')) {
			List<String> stringParts = soql.split(':');
			System.debug(stringParts);
			System.debug(stringParts.size());
			for (Integer i = 1; i < stringParts.size(); i++) {
				List<String> merchParts = stringParts[i].trim().split('\\.');
				if (merchParts.size() > 1) {
					String obj = merchParts.get(0);
					String field = merchParts.get(1).split(' ').get(0);
					if (obj == 'migrationAsset') {
						//assetMerchFieldValue = migrationAsset.get(field);
						soql = soql.replaceAll('migrationAsset\\.\\w+', 'assetMerchFieldValue');
					} else if (obj == 'theAccount') {
						//accountMerchFieldValue = theAccount != null ? theAccount.get(field) : '';
						soql = soql.replaceAll('theAccount\\.\\w+', 'accountMerchFieldValue');
					} else if (obj == 'migrationProduct') {
						//productMerchFieldValue = migrationProduct.get(field);
						soql = soql.replaceAll('migrationProduct\\.\\w+', 'productMerchFieldValue');
					}
				}
			}
		}
		return soql;
	}

	@TestVisible
	private static Map<String, MigrationPremiumTypes.ProductParameterWrapper> getChildProductParametersFromSOQL(
		Product_Parameter__c theProductParameter
	) {
		/*, String defaultValue*/
		Map<String, MigrationPremiumTypes.ProductParameterWrapper> result = new Map<String, MigrationPremiumTypes.ProductParameterWrapper>();

		String soql;
		List<String> encNullChecks = new List<String>();
		List<String> soqlParts = theProductParameter.SOQL__c.split('\\|');
		soql = soqlParts.get(0);
		List<sObject> dataList = new List<sObject>();
		if (soqlParts.size() > 1) {
			encNullChecks = soqlParts.get(1).split(',');
			List<sObject> tempdataList = Database.query(getEnhancedSoqlForMigrationObject(soql));
			for (String encNullCheck : encNullChecks) {
				for (sObject sobj : tempdataList) {
					if (encNullCheck.startsWith('!')) {
						if (sobj.get(encNullCheck.substring(1)) != null) {
							dataList.add(sobj);
						}
					} else {
						System.debug(sobj.get(encNullCheck));
						if (sobj.get(encNullCheck) == null) {
							dataList.add(sobj);
						}
					}
				}
			}
		} else {
			dataList = Database.query(getEnhancedSoqlForMigrationObject(soql));
		}

		System.debug('*** inputSOQL: ' + theProductParameter.Soql__c);
		System.debug('*** soqlRes: ' + dataList);
		for (sObject theItem : dataList) {
			String idValue = getValueFromSObject(theItem, theProductParameter.SOQL_Field_ID__c);
			String nameValue = getValueFromSObject(theItem, theProductParameter.SOQL_Field_Name__c);
			MigrationPremiumTypes.ProductParameterWrapper wrapper = new MigrationPremiumTypes.ProductParameterWrapper();
			Product_Parameter__c theParameter = new Product_Parameter__c();
			theParameter.Parameter_Label__c = nameValue;
			/*if (idValue == defaultValue) {
				theParameter.Is_Default__c = true;
			} else {
				theParameter.Is_Default__c = false;
			}*/
			wrapper.idOfParameter = idValue;
			wrapper.productParameter = theParameter;
			result.put(idValue, wrapper);
		}
		return result;
	}

	@TestVisible
	private static String getInputWithSOQLValue(Product_Parameter__c theProductParameter) {
		List<sObject> dataList = Database.query(getEnhancedSoqlForMigrationObject(theProductParameter.Soql__c));
		System.debug('*** inputSOQL: ' + dataList);
		for (sObject theItem : dataList) {
			return getValueFromSObject(theItem, theProductParameter.SOQL_Field_Name__c);
		}
		return null;
	}

	@TestVisible
	public static MigrationPremiumTypes.ThresholdWrapper getThresholdWrapper(Set<String> productParameterSet) {
		MigrationPremiumTypes.ThresholdWrapper result = new MigrationPremiumTypes.ThresholdWrapper();
		List<Threshold_Product_Parameter__c> thresholdList = [
			SELECT
				Id,
				Threshold_Value__r.Text_Value__c,
				Dependent_Product_Parameter__c,
				Product_Parameter__c,
				Product_Parameter__r.Product_Parameter__c,
				Threshold_Value__r.Type__c,
				Dependent_Product_Parameter__r.SOQL_Field_Name__c,
				Dependent_Product_Parameter__r.Type__c,
				Dependent_Product_Parameter__r.Value__c,
				Dependent_Product_Parameter__r.SOQL__c,
				Dependent_Product_Parameter__r.String_Value__c
			FROM Threshold_Product_Parameter__c
			WHERE Product_Parameter__c = :productParameterSet
		];

		system.debug('getting thresholds: ' + thresholdList);

		Map<String, List<Threshold_Product_Parameter__c>> dependentByMap = new Map<String, List<Threshold_Product_Parameter__c>>();
		Map<String, Map<String, List<Threshold_Product_Parameter__c>>> parentByMap = new Map<String, Map<String, List<Threshold_Product_Parameter__c>>>();
		for (Threshold_Product_Parameter__c threshold : thresholdList) {
			if (!String.isBlank(threshold.Threshold_Value__r.Type__c)) {
				if (dependentByMap.containsKey(threshold.Dependent_Product_Parameter__c)) {
					dependentByMap.get(threshold.Dependent_Product_Parameter__c).add(threshold);
				} else {
					List<Threshold_Product_Parameter__c> data = new List<Threshold_Product_Parameter__c>();
					data.add(threshold);
					dependentByMap.put(threshold.Dependent_Product_Parameter__c, data);
				}
			}
			if (parentByMap.containsKey(threshold.Product_Parameter__c)) {
				if (
					parentByMap.get(threshold.Product_Parameter__c)
						.containsKey(threshold.Dependent_Product_Parameter__c)
				) {
					parentByMap.get(threshold.Product_Parameter__c)
						.get(threshold.Dependent_Product_Parameter__c)
						.add(threshold);
				} else {
					Map<String, List<Threshold_Product_Parameter__c>> data = new Map<String, List<Threshold_Product_Parameter__c>>();
					List<Threshold_Product_Parameter__c> dataList = new List<Threshold_Product_Parameter__c>();
					dataList.add(threshold);
					parentByMap.get(threshold.Product_Parameter__c)
						.put(threshold.Dependent_Product_Parameter__c, dataList);
				}
				//parentByMap.get(threshold.Product_Parameter__c).add(threshold);
			} else {
				Map<String, List<Threshold_Product_Parameter__c>> data = new Map<String, List<Threshold_Product_Parameter__c>>();
				List<Threshold_Product_Parameter__c> dataList = new List<Threshold_Product_Parameter__c>();
				dataList.add(threshold);
				data.put(threshold.Dependent_Product_Parameter__c, dataList);
				parentByMap.put(threshold.Product_Parameter__c, data);
			}
		}

		result.dependentByMap = dependentByMap;
		result.parentByMap = parentByMap;
		return result;
	}

	@TestVisible
	private static Asset getAssetsFromProductParameterFormula(
		List<Product_Parameter__c> l2ProductParameterList,
		String assetId
	) {
		if (String.isBlank(assetId)) {
			return null;
		}
		String startOfSoql = 'SELECT ';
		String endOfSoql = ' FROM Asset WHERE Id = \'' + assetId + '\'';
		String innerStartOfSoql = ',(SELECT ';
		String innerEndOfSoql = '  FROM Assets__r)';

		Set<String> soqlColumnsSet = new Set<String>();
		for (Product_Parameter__c theProductParameter : l2ProductParameterList) {
			if (String.isNotBlank(theProductParameter.Algorithm_Mapping__c)) {
				/*if(!validateAlgorithmMapping(theProductParameter.Algorithm_Mapping__c)){
					continue;
				}*/
				//                if (String.isBlank(theProductParameter.Algorithm_Mapping__c)) {
				//                    continue;
				//                }
				List<String> fieldList = theProductParameter.Algorithm_Mapping__c.split('\\.');
				if (fieldList.size() == 1) {
					soqlColumnsSet.add(fieldList.get(0));
				} else {
					soqlColumnsSet.add(fieldList.get(1));
					String firstPart = fieldList.get(0).substringBetween('[', ']');
					soqlColumnsSet.add(firstPart.split('=').get(0));
				}
			}
		}

		if (!soqlColumnsSet.isEmpty()) {
			List<String> soqlColumnsList = new List<String>();
			soqlColumnsList.addAll(soqlColumnsSet);
			String soqlColumns = String.join(soqlColumnsList, ',');
			String soql = startOfSoql + soqlColumns + innerStartOfSoql + soqlColumns + innerEndOfSoql + endOfSoql;
			List<Asset> assetList = Database.query(soql);
			if (assetList != null && !assetList.isEmpty()) {
				return assetList.get(0);
			}
		}

		return null;
	}

	@TestVisible
	private static String getDefaultValueFromAsset(
		Product_Parameter__c theProductParameter,
		Asset assetFromProductParameter
	) {
		theProductParameter.Algorithm_Mapping__c = theProductParameter.Algorithm_Mapping__c.toLowerCase();
		if (theProductParameter.Algorithm_Mapping__c.contains('.')) {
			List<String> conditionChunksList = theProductParameter.Algorithm_Mapping__c.split('\\.');
			String childRelationWithCondition = conditionChunksList.get(0);
			String fieldName = conditionChunksList.get(1);
			String condition = childRelationWithCondition.substringBetween('[', ']');
			conditionChunksList = condition.split('=');
			String conditionField = conditionChunksList.get(0);
			String conditionValue = conditionChunksList.get(1);
			/*for (Asset childAsset : assetFromProductParameter.Assets__r) {
				if ((String) childAsset.get(conditionField.trim()) == conditionValue) {
					if (fieldName.contains('tolabel')) {
						fieldName = fieldName.replace('tolabel(', '');
						fieldName = fieldName.replace(')', '');
						return (String) childAsset.get(fieldName);
					} else {
						return (String) childAsset.get(fieldName);
					}
				}
			}*/
		} else {
			String fieldName;
			if (
				String.isNotBlank(theProductParameter.Algorithm_Mapping__c) &&
				theProductParameter.Algorithm_Mapping__c.contains('tolabel')
			) {
				fieldName = theProductParameter.Algorithm_Mapping__c.replace('tolabel(', '');
				fieldName = fieldName.replace(')', '');
			} else {
				fieldName = theProductParameter.Algorithm_Mapping__c;
			}
			Map<String, Schema.SObjectField> fieldMap = assetFromProductParameter.getSObjectType()
				.getDescribe()
				.fields.getMap();
			Schema.DisplayType fieldType = fieldMap.get(fieldName).getDescribe().getType();
			if (fieldType == Schema.DisplayType.DATE && (Date) assetFromProductParameter.get(fieldName) != null) {
				System.debug('fieldName: ' + fieldName);
				Date d = (Date) assetFromProductParameter.get(fieldName);
				System.debug(
					'(Date)assetFromProductParameter.get(fieldName);' + (Date) assetFromProductParameter.get(fieldName)
				);
				Datetime retDate = Datetime.newInstance(d.year(), d.month(), d.day());
				return retDate.format('dd.MM.yyyy');
			}
			return String.valueOf(assetFromProductParameter.get(fieldName));
		}
		return null;
	}

	@TestVisible
	private static String getDisponentTextFromAsset(Asset theAsset) {
		return theAsset.Account.Name /*+ ' (CUID: ' + theAsset.Account.CUID__c + ')'*/;
	}

	//    private static Map<String, String> addAllDecryptedDispatcherAssetsName(List<Asset> assetList, String accountId){
	//        DpaaSSoapWebService.DataProtectionWebServiceImplPort dpaasSoapApi = new DpaaSSoapWebService.DataProtectionWebServiceImplPort();
	//        Map<String, String> encryptedValuesMap = new Map<String, String>();
	//        decryptedAssetNameByIdMap = new Map<String, String>();
	//        for(Asset theAsset : assetList){
	//            getEncryptedDispatcherAssetsName(theAsset, accountId, encryptedValuesMap);
	//        }
	//
	//        if(encryptedValuesMap != null && !encryptedValuesMap.isEmpty()){
	//            Map<String, String> decryptionDictionaryMap = Utils.detokenizeTextValues(encryptedValuesMap.values(), dpaasSoapApi);
	//            for(String encryptedAAccountId : encryptedValuesMap.keySet()){
	//                String encryptedValue = encryptedValuesMap.get(encryptedAAccountId);
	//                decryptedAssetNameByIdMap.put(encryptedAAccountId, decryptionDictionaryMap.get(encryptedValue));
	//            }
	//            //this.accountName = decryptionDictionaryMap.get(rel.Second_Party__r.Name);
	//        }
	//
	//        return decryptedAssetNameByIdMap;
	//    }
	//
	//    private static void getEncryptedDispatcherAssetsName(Asset theAsset, String accountId, Map<String, String> encryptedValuesMap){
	//        encryptedValuesMap.put(theAsset.AccountId, theAsset.Account.Name);
	//        for(Asset childAsset : theAsset.Assets__r){
	//            if(childAsset.AccountId != accountId){
	//                encryptedValuesMap.put(childAsset.AccountId, childAsset.Account.Name);
	//            }
	//        }
	//    }

	/*    private static Map<String, String> addAllAssetsNumber(List<Asset> assetList) {
        assetNumberByIdMap = new Map<String, String>();
        for (Asset theAsset : assetList) {
            assetNumberByIdMap.put(theAsset.Id, theAsset.Account_Number__c);
            for (Asset childAsset : theAsset.Assets__r) {
                assetNumberByIdMap.put(childAsset.Id, childAsset.Account_Number__c);
            }
        }
        return assetNumberByIdMap;
    }*/

	//    private static Map<String, String> addAllDecryptedAssetsNumber(List<Asset> assetList){
	//        DpaaSSoapWebService.DataProtectionWebServiceImplPort dpaasSoapApi = new DpaaSSoapWebService.DataProtectionWebServiceImplPort();
	//        Map<String, String> encryptedValuesMap = new Map<String, String>();
	//        decryptedAssetNumberByIdMap = new Map<String, String>();
	//        for(Asset theAsset : assetList){
	//            getEncryptedAssetsNumber(theAsset, encryptedValuesMap);
	//        }
	//
	//        if(encryptedValuesMap != null && !encryptedValuesMap.isEmpty()){
	//            Map<String, String> decryptionDictionaryMap = Utils.detokenizeTextValues(encryptedValuesMap.values(), dpaasSoapApi);
	//            for(String encryptedAssetId : encryptedValuesMap.keySet()){
	//                String encryptedValue = encryptedValuesMap.get(encryptedAssetId);
	//                decryptedAssetNumberByIdMap.put(encryptedAssetId, decryptionDictionaryMap.get(encryptedValue));
	//            }
	//            //this.accountName = decryptionDictionaryMap.get(rel.Second_Party__r.Name);
	//        }
	//
	//        return decryptedAssetNumberByIdMap;
	//    }

	//    private static void getEncryptedAssetsNumber(Asset theAsset, Map<String, String> encryptedValuesMap){
	//        encryptedValuesMap.put(theAsset.Id, theAsset.Account_Number__c);
	//        for(Asset childAsset : theAsset.Assets__r){
	//            encryptedValuesMap.put(childAsset.Id, childAsset.Account_Number__c);
	//        }
	//    }

	private static Migration_Process__mdt getProcessConfigurationByName(String name) {
		return getProcessConfiguration(null, name);
	}

	private static Migration_Process__mdt getProcessConfigurationById(String processId) {
		return getProcessConfiguration(processId, null);
	}

	private static Migration_Process__mdt getProcessConfiguration(String processId, String processName) {
		processName = String.isBlank(processName) ? 'Premium' : processName;
		String migrationProcessCondition = String.isNotBlank(processId)
			? 'Id = :processId'
			: 'DeveloperName = :processName';
		List<Migration_Process__mdt> processList = (List<Migration_Process__mdt>) Database.query(
			MIGRATION_PROCESS_METADATA_QUERY +
			' WHERE ' +
			(!String.isBlank(processId) ? 'Id = :processId' : 'DeveloperName = :processName')
		);
		return processList == null || processList.isEmpty() ? null : processList.get(0);
	}

	private static Set<String> getSetFromStringCommaDelimited(String input) {
		if (String.isBlank(input)) {
			return null;
		}
		if (input.contains(',')) {
			return new Set<String>(input.split(','));
		} else {
			Set<String> result = new Set<String>();
			result.add(input);
			return result;
		}
	}

	private static String getValueWithHighPriority(String assetValue, String paramStringValue, String paramValue) {
		if (!String.isBlank(assetValue)) {
			return assetValue;
		} else if (!String.isBlank(paramStringValue)) {
			return paramStringValue;
		} else {
			return paramValue;
		}
	}

	/*private void addToAllAndSelectedMap(Asset theAsset, String accountId, Integer i) {

		//assetProductRelationList = [SELECT Id, From__r.Name, To__r.Name, To__c FROM Product_Relation__c WHERE From__c = :theAsset.Product2Id];
		MigrationPremiumTypes.Item theItem;
		Boolean hasSubProducts = migrationProductsMap.containsKey(theAsset.Product2Id) && String.isNotBlank(migrationProductsMap.get(theAsset.Product2Id).Subproduct_SOQL__c) ? true : false;
		System.debug('*** hasSubProducts (' + theAsset.Product2Id + '): ' + hasSubProducts);
		if (selectedItems.itemMap.isEmpty()) {
			theItem = new MigrationPremiumTypes.Item(migrationProcessConfiguration, hasSubProducts, theAsset, true, i, true);
		} else {
			theItem = new MigrationPremiumTypes.Item(migrationProcessConfiguration, hasSubProducts, theAsset, true, i);
		}
		Integer j = 0;
		for (Asset childAsset : theAsset.Assets__r) {
			theItem.childItemMap.put(j + '-' + childAsset.Product2Id, new MigrationPremiumTypes.Item(migrationProcessConfiguration, childAsset, accountId, j));
			j++;
		}
		selectedItems.itemMap.put(i + '-' + theAsset.Product2Id, theItem);
		allItems.itemMap.put(i + '-' + theAsset.Product2Id, theItem);
	}*/

	/*    private void addProductToAllAndSelectedMap(Product2 theProduct, String accountId, Integer i) {
        MigrationPremiumTypes.Item theItem;
        Boolean hasSubProducts = String.isNotBlank(theProduct.Subproduct_SOQL__c) ? true : false;
        System.debug('*** hasSubProducts (' + theProduct + '): ' + hasSubProducts);
        if (selectedItems.itemMap.isEmpty()) {
            theItem = new MigrationPremiumTypes.Item(migrationProcessConfiguration, hasSubProducts, theProduct, true, i, true);
        } else {
            theItem = new MigrationPremiumTypes.Item(migrationProcessConfiguration, hasSubProducts, theProduct, true, i, false);
        }
        selectedItems.itemMap.put(i + '-' + theProduct.Id, theItem);
        allItems.itemMap.put(i + '-' + theProduct.Id, theItem);
    }*/

	/*@TestVisible
	private void addToAllMap(Asset theAsset, String accountId, Integer i) {
		MigrationPremiumTypes.Item theItem = new MigrationPremiumTypes.Item(migrationProcessConfiguration, theAsset, false, i);
		Integer j = 0;
		for (Asset childAsset : theAsset.Assets__r) {
			theItem.childItemMap.put(j + '-' + childAsset.Product2Id, new MigrationPremiumTypes.Item(migrationProcessConfiguration, childAsset, accountId, j));
			j++;
		}
		system.debug('allitems: ' + allItems);
		system.debug('i: ' + i);
		system.debug('theAsset: ' + theAsset);
		system.debug('theItem: ' + theItem);
		allItems.itemMap.put(i + '-' + theAsset.Product2Id, theItem);
	}*/

	/*    @TestVisible
    private String getAssetIdForReadOnlyMode(MigrationPremiumTypes.ItemsWrapper selectedItems) {
        for (MigrationPremiumTypes.Item theItem : selectedItems.itemMap.values()) {
            if (theItem.defaultSelected && theItem.theAsset != null) {
                return theItem.theAsset.Id;
            }
        }
        return null;
    }*/

	/*    @TestVisible
    private void pairAssetIdToAssetAccountNumber(MigrationPremiumTypes.ItemsWrapper selectedItems) {
        Set<String> assetIdSet = new Set<String>();
        System.debug('UUUIIIIII: ');
        for (MigrationPremiumTypes.Item theItem : selectedItems.itemMap.values()) {
            if (theItem.theAsset != null) {
                System.debug(theItem.theAsset.Id);
                System.debug(theItem);
                assetIdSet.add(theItem.theAsset.Id);
                if (theItem.childItemMap != null) {
                    for (MigrationPremiumTypes.Item childItem : theItem.childItemMap.values()) {
                        if (childItem.theAsset != null) {
                            assetIdSet.add(childItem.theAsset.Id);
                        }
                    }
                }
            }
        }

        Map<String, Asset> assetMap = new Map<String, Asset>([SELECT Id, Account_Number__c, Product2.CST_Value_ID__c FROM Asset WHERE Id = :assetIdSet]);
        addAllAssetsNumber(assetMap.values());

        for (MigrationPremiumTypes.Item theItem : selectedItems.itemMap.values()) {
            if (theItem.theAsset != null) {
                theItem.theAsset.Account_Number__c = assetNumberByIdMap.get(theItem.theAsset.Id);
                for (MigrationPremiumTypes.Item childItem : theItem.childItemMap.values()) {
                    if (childItem.theAsset != null) {
                        childItem.theAsset.Account_Number__c = assetNumberByIdMap.get(childItem.theAsset.Id);
                    }
                }
            }
        }
    }*/

	private static Map<String, Product_Parameter__c> getL1ProductParameterMap(String productRelationId) {
		Id confRecTypeId;
		RecordTypeInfo rti = Schema.getGlobalDescribe()
			.get('Product_Parameter__c')
			.getDescribe()
			.getRecordTypeInfosByDeveloperName()
			.get(INVESTMENT_CALCULATOR_CONFIG_REC_TYPE);
		if (rti != null) {
			confRecTypeId = rti.getRecordTypeId();
		}

		return new Map<String, Product_Parameter__c>(
			[
				SELECT
					Id,
					Name,
					Parameter_Label__c,
					Value__c,
					Type__c,
					Field_API__c,
					Encrypt_Api_Field_Data__c,
					Product_Parameter__r.Name,
					Product_Parameter__r.Value__c,
					Is_Default__c,
					Required__c,
					Initial_State__c,
					Lx__c,
					Product_Parameter__c,
					Product_Parameter__r.Product_Parameter__c,
					Algorithm_Mapping__c,
					Load_Hidden_RO__c,
					Soql__c,
					SOQL_Field_ID__c,
					SOQL_Field_Name__c,
					Is_Read_Only__c,
					Load_Hidden__c,
					Priority_SUFO__c,
					Is_For_Final_Validation__c,
					String_Value__c,
					Visibility__c,
					Formula__c,
					sync_element_name__c,
					Cleave_Type__c,
					Cleave_Data__c,
					ISTS_Element_Name__c,
					SyblingPP__c,
					Min__c,
					Max__c
				FROM Product_Parameter__c
				WHERE
					Product_Relation__c = :productRelationId
					AND Lx__c = 'L1'
					AND (Valid_From__c = NULL
					OR Valid_From__c < :Date.today())
					AND (Valid_To__c = NULL
					OR Valid_To__c > :Date.today())
					AND RecordTypeId != :confRecTypeId
					AND (Visibility__c INCLUDES ('All')
					OR Visibility__c INCLUDES (:theUser.Profile.Name))
				ORDER BY Lx__c, Order_in_section__c
			]
		);
		//AND (Visibility__c =: typeOfLoggedUser OR Visibility__c =: SHOW_ALL OR Visibility__c = '')
	}

	private static Map<String, Product_Parameter__c> getL2ProductParameterWithChildMap(
		String productRelationId,
		Set<String> l1ProductParameterIdSet
	) {
		return new Map<String, Product_Parameter__c>(
			[
				SELECT
					Id,
					Name,
					Parameter_Label__c,
					Value__c,
					Type__c,
					Field_API__c,
					Product_Parameter__r.Name,
					Product_Parameter__r.Value__c,
					Encrypt_Api_Field_Data__c,
					Is_Default__c,
					Required__c,
					Initial_State__c,
					Lx__c,
					Product_Parameter__c,
					Product_Parameter__r.Product_Parameter__c,
					Algorithm_Mapping__c,
					Load_Hidden_RO__c,
					Soql__c,
					SOQL_Field_ID__c,
					SOQL_Field_Name__c,
					Is_Read_Only__c,
					Load_Hidden__c,
					Priority_SUFO__c,
					Is_For_Final_Validation__c,
					String_Value__c,
					Visibility__c,
					Formula__c,
					SOQL_Background_Query__c,
					System__c,
					Transaction_ID__c,
					Specific_External_Link__c,
					SCUBE_Transaction_Type__c,
					Help_Text__c,
					sync_element_name__c,
					Csv_Export_Column__c,
					Cleave_Type__c,
					Cleave_Data__c,
					ISTS_Element_Name__c,
					Show_ElDistrib_Agreement__c,
					SyblingPP__c,
					Min__c,
					Max__c,
					/*Product_Relation__r.From__r.CST_Value_ID__c,*/ (
						SELECT
							Id,
							Name,
							Parameter_Label__c,
							Value__c,
							Type__c,
							Field_API__c,
							Product_Parameter__r.Name,
							Product_Parameter__r.Value__c,
							Encrypt_Api_Field_Data__c,
							Is_Default__c,
							Required__c,
							Initial_State__c,
							Lx__c,
							Product_Parameter__c,
							Product_Parameter__r.Product_Parameter__c,
							Algorithm_Mapping__c,
							Load_Hidden_RO__c,
							Soql__c,
							SOQL_Field_ID__c,
							SOQL_Field_Name__c,
							Is_Read_Only__c,
							Load_Hidden__c,
							Priority_SUFO__c,
							Is_For_Final_Validation__c,
							String_Value__c,
							Visibility__c,
							Formula__c,
							sync_element_name__c,
							Cleave_Type__c,
							Cleave_Data__c,
							ISTS_Element_Name__c,
							/*Product__r.CST_Value_ID__c,*/ Product__r.Name,
							Show_ElDistrib_Agreement__c,
							SyblingPP__c,
							Min__c,
							Max__c
						FROM Product_Parameters__r
						WHERE
							Product_Relation__c = :productRelationId
							AND (Valid_From__c = NULL
							OR Valid_From__c < :Date.today())
							AND (Valid_To__c = NULL
							OR Valid_To__c > :Date.today())
						ORDER BY Lx__c, Order_in_section__c
					),
					(
						SELECT Id
						FROM Syblings__r
					)
				FROM Product_Parameter__c
				WHERE
					Product_Relation__c = :productRelationId
					AND Product_Parameter__c = :l1ProductParameterIdSet
					AND (Valid_From__c = NULL
					OR Valid_From__c < :Date.today())
					AND (Valid_To__c = NULL
					OR Valid_To__c > :Date.today())
				ORDER BY Lx__c, Order_in_section__c
			]
		);
	}

	@TestVisible
	private static MigrationPremiumTypes.VisibilityWrapper getVisibilityType(
		MigrationPremiumTypes.ThresholdWrapper thresholdToProductParameter,
		Map<String, Product_Parameter__c> l2ProductParameterMap,
		Product_Parameter__c theProductParameter,
		Asset theAsset,
		MigrationPremiumTypes.VisibilityWrapper result
	) {
		System.debug('Sosam visibilitu');
		System.debug(theProductParameter.Name + ': ' + theProductParameter.Id);
		System.debug(thresholdToProductParameter.dependentByMap);
		System.debug(thresholdToProductParameter.parentByMap);
		if (thresholdToProductParameter.dependentByMap.containsKey(theProductParameter.Id)) {
			//Threshold_Product_Parameter__c theThreshold = thresholdToProductParameter.dependentByMap.get(theProductParameter.Id).get(0);
			//System.debug(theThreshold);
			//System.debug('Parent: ' + theThreshold.Product_Parameter__c);
			Integer counter = 0;
			Boolean tresholdValueAlreadyMatched = false;
			Integer thresholdListSize = thresholdToProductParameter.dependentByMap.get(theProductParameter.Id).size();
			for (
				Threshold_Product_Parameter__c theThreshold : thresholdToProductParameter.dependentByMap.get(
					theProductParameter.Id
				)
			) {
				counter++;
				System.debug(theThreshold);
				System.debug('Parent: ' + theThreshold.Product_Parameter__c);
				System.debug('Counter: ' + counter);
				if (l2ProductParameterMap.containsKey(theThreshold.Product_Parameter__c)) {
					System.debug('Som v l2prodparmap.contains ifu');
					Product_Parameter__c parentProductParameter = l2ProductParameterMap.get(
						theThreshold.Product_Parameter__c
					);
					String defaultValueFromAsset;
					if (String.isNotBlank(parentProductParameter.Algorithm_Mapping__c) && theAsset != null) {
						defaultValueFromAsset = getDefaultValueFromAsset(parentProductParameter, theAsset);
					}
					if (parentProductParameter.Type__c != 'Select' || String.isNotBlank(defaultValueFromAsset)) {
						System.debug('nejsem select nebo jsem, ale mam defaultValueFromAsset');
						System.debug(defaultValueFromAsset);
						System.debug(parentProductParameter.String_Value__c);
						System.debug(String.valueOf(parentProductParameter.Value__c));
						String value;
						if (parentProductParameter.Type__c == 'Checkbox') {
							System.debug('JSEM CHECKBOX, JUPI');
							System.debug(parentProductParameter.Parameter_Label__c);
							if (parentProductParameter.Value__c == 1) {
								System.debug(':o) A JSEM ZAPLEJ CHECKBOX!');
								value = 'true';
							} else {
								System.debug(':o( A JSEM VYPLEJ CHECKBOX!');
								value = 'false';
							}
						} else {
							System.debug('NEJSEM CHECKBOX...');
							value = getValueWithHighPriority(
								defaultValueFromAsset,
								parentProductParameter.String_Value__c,
								String.valueOf(parentProductParameter.Value__c)
							);
						}
						if (theThreshold.Threshold_Value__r.Text_Value__c == value) {
							tresholdValueAlreadyMatched = true;
							MigrationPremiumTypes.DependencyWrapper typeRes = getResultThresholdVsValue(
								theThreshold,
								value
							);
							system.debug('puvodni result: ' + result);
							result.visibilityType = typeRes.visibilityType;
							system.debug('nastavuji visType na: ' + result.visibilityType);
							if (typeRes.visibilityType == MigrationPremiumTypes.VISIBILITY_TYPE_SHOW) {
								if (counter != 1) {
									result.visibilityCount++;
								}
								system.debug('zvysuji visCount na: ' + result.visibilityCount);
							}
						}
					} else {
						/* Default value is from the parameter regard this rules:
						 ** If the select contains parameter with Is_Default__c flag marked as true
						 ** If not, the default value is choose base on the order in section - first item in the list - the sorting is made in the SOQL
						 */
						System.debug('jsem select a to me netankuje');
						String defaultValueFromParameter;
						Boolean isDefaultIsSetted = false;
						for (
							Product_Parameter__c selectProductParameter : parentProductParameter.Product_Parameters__r
						) {
							if (selectProductParameter.Is_Default__c) {
								isDefaultIsSetted = true;
								defaultValueFromParameter = getValueWithHighPriority(
									null,
									null,
									selectProductParameter.Parameter_Label__c
								);
								break;
							}
						}
						if (!isDefaultIsSetted) {
							if (!parentProductParameter.Product_Parameters__r.isEmpty()) {
								defaultValueFromParameter = getValueWithHighPriority(
									null,
									null,
									parentProductParameter.Product_Parameters__r[0].Parameter_Label__c
								);
							}
						}
						System.debug(defaultValueFromParameter);
						System.debug(theThreshold);
						System.debug('----');
						if (
							theThreshold.Threshold_Value__r.Text_Value__c == defaultValueFromParameter ||
							(thresholdListSize == counter && !tresholdValueAlreadyMatched)
						) {
							tresholdValueAlreadyMatched = true;
							MigrationPremiumTypes.DependencyWrapper typeRes = getResultThresholdVsValue(
								theThreshold,
								defaultValueFromParameter
							);
							system.debug('puvodni result: ' + result);
							result.visibilityType = typeRes.visibilityType;
							system.debug('nastavuji visType na: ' + result.visibilityType);
							if (typeRes.visibilityType == MigrationPremiumTypes.VISIBILITY_TYPE_SHOW) {
								if (counter != 1) {
									result.visibilityCount++;
									system.debug('zvysuji visCount na: ' + result.visibilityCount);
								}
							}
						}
					}
				}
			}
		}
		return result;
	}

	private static String getVisibilityTypeFromParameter(
		Product_Parameter__c theProductParameter,
		String currentUserProfile
	) {
		system.debug('*** getting visibilityTypeFrom for profile: ' + currentUserProfile);
		system.debug(theProductParameter);
		system.debug(theProductParameter.Visibility__c);
		if (String.isBlank(theProductParameter.Visibility__c)) {
			system.debug('Returning Show');
			return MigrationPremiumTypes.VISIBILITY_TYPE_SHOW;
		}
		Set<String> visibilityTypeSet = new Set<String>(theProductParameter.Visibility__c.split(';'));
		if (visibilityTypeSet.contains(SHOW_ALL)) {
			system.debug('Returning Show');
			return MigrationPremiumTypes.VISIBILITY_TYPE_SHOW;
		} else {
			system.debug('Returning Show / Hide');
			return visibilityTypeSet.contains(currentUserProfile)
				? MigrationPremiumTypes.VISIBILITY_TYPE_SHOW
				: MigrationPremiumTypes.VISIBILITY_TYPE_HIDE;
		}
	}

	/*    @TestVisible
    private static IntegrationUtils.jsonWithEndpoint getExternalLinkData(Product_Parameter__c theProductParameter) {
        if (theProductParameter.Type__c != TYPE_EXTERNAL_LINK) {
            return null;
        }
        if (!String.isBlank(theProductParameter.Transaction_ID__c) && !String.isBlank(theProductParameter.SCUBE_Transaction_Type__c)) {
            if (theProductParameter.SCUBE_Transaction_Type__c == GlobalConstants.SCUBE_TRANSACTION_CALL_TYPE_SWITCH) {
                System.Debug('MM1');
                return IntegrationUtils.getjsonWithEndpointWrapper(IntegrationUtils.getSwitchToScubeContext(theProductParameter.Transaction_ID__c, theProductParameter.SCUBE_Transaction_Type__c, accountCuid));
            } else if (theProductParameter.SCUBE_Transaction_Type__c == GlobalConstants.SCUBE_TRANSACTION_CALL_TYPE_SUBFLOW && theProductParameter.Transaction_ID__c == SUBFLOW_CREATE_NEW_PROSPECT_TRANSACTION_ID) {
                System.Debug('MM2');
                return IntegrationUtils.getjsonWithEndpointWrapper(IntegrationUtils.getSwitchToScubeContext(theProductParameter.Transaction_ID__c, GlobalConstants.SCUBE_TRANSACTION_CALL_TYPE_SUBFLOW, null, null, null,
                        null, null, null, null, null));
            }
        }
        return null;
    }*/

	@RemoteAction
	global static List<Product_Relation__c> getInvestmentRelations() {
		List<Product_Relation__c> investmentRelations = [
			SELECT
				id,
				name,
				Type__c,
				Base__c,
				Supplement__c,
				Theme__c,
				Default_Name__c,
				(
					SELECT
						id,
						name,
						Parameter_Label__c,
						toLabel(Type__c),
						Calc_Max_Percentage__c,
						Calc_Min_Value__c,
						Order_in_Section__c,
						sync_element_name__c
					FROM Product_Parameters__r
					ORDER BY Type__c, Order_in_Section__c ASC
				)
			FROM Product_Relation__c
			WHERE RecordType.Name = 'Investment Calculator Config'
			ORDER BY Default_Name__c
		];
		return investmentRelations;
	}

	/*@RemoteAction
	global static String generateQuoteForPrinting(String oppId, List<MigrationPremiumTypes.PrintingProductParameter> pppList, Decimal totalAmount, String accId, String template) {
		if (String.isBlank(oppId)) {
			String errorMsg = 'Neznámé Opportunity Id. Otevřete prosím Investiční kalkulačku přes tlačítko na obchodním případu.';
			return errorMsg;
		}
		if (String.isBlank(accId)) {
			String errorMsg = 'Neznámý klient. Otevřete prosím Investiční kalkulačku přes tlačítko na obchodním případu.';
			return errorMsg;
		}

		final String DEFAULT_HEADER_HEIGHT = '100';
		final String DEFAULT_FOOTER_HEIGHT = '100';
		final String QUOTE_NAME_PATTERN = 'Investiční kalkulačka - Nabídka%';

		Savepoint sp;
		try {
			List<Account> accList = [SELECT Id, toLabel(Title_Before__c), toLabel(Title_Behind__c), FirstName, LastName FROM Account WHERE Id = :accId LIMIT 1];
			String accName = '';
			if (accList != null && !accList.isEmpty()) {
				Account acc = accList.get(0);
				accName = String.isNotBlank(acc.Title_Before__c) ? acc.Title_Before__c + ' ' : '';

				if (!Utils.isJiraEnabled(GlobalConstants.SHIELD_ACCOUNT)) {
					DpaaSSoapWebService.DataProtectionWebServiceImplPort dpaasSoapApi = new DpaaSSoapWebService.DataProtectionWebServiceImplPort();
					List<String> valuesToTranslateList = new List<String>();
					valuesToTranslateList.add(acc.FirstName);
					valuesToTranslateList.add(acc.LastName);
					Map<String, String> decryptionDictionaryMap = Utils.detokenizeTextValues(valuesToTranslateList, dpaasSoapApi);
					accName += decryptionDictionaryMap.get(acc.FirstName) + ' ' + decryptionDictionaryMap.get(acc.LastName);
				} else {
					accName += acc.FirstName + ' ' + acc.LastName;
				}
				accName += String.isNotBlank(acc.Title_Behind__c) ? ', ' + acc.Title_Behind__c : '';
				System.debug('*** ACCNAME: ' + accName);
			}

			sp = Database.setSavePoint();

			String headerHeight = ICalc_Printing_Properties__c.getAll().get('Header_Height').value__c;
			String footerHeight = ICalc_Printing_Properties__c.getAll().get('Footer_Height').value__c;
			final String templateId = ICalc_Printing_Properties__c.getAll().get('Template_Id').value__c;
			final String template2Id = ICalc_Printing_Properties__c.getAll().get('Template2_Id').value__c;
			final String quoteTemplateDataViewerUrl = ICalc_Printing_Properties__c.getAll().get('Quote_Template_Data_Viewer_URL').value__c;
			if ((String.isBlank(templateId) && String.isBlank(template2Id)) || String.isBlank(quoteTemplateDataViewerUrl)) {
				String errorMsg = 'error: Invoice Template Id or Quote Template Data Viewer URL are blank, please review their values in ICalc Printing Properties custom setting.';
				return errorMsg;
			}
			if (String.isBlank(headerHeight)) headerHeight = DEFAULT_HEADER_HEIGHT;
			if (String.isBlank(footerHeight)) footerHeight = DEFAULT_FOOTER_HEIGHT;

			List<Quote> quoteList = [SELECT Id, Name FROM Quote WHERE OpportunityId = :oppId AND Name LIKE :QUOTE_NAME_PATTERN];
			Quote q = new Quote();
			q.Name = QUOTE_NAME_PATTERN.replace('%', ' ' + String.valueOf(getNextOfferNumber(quoteList)));
			q.OpportunityId = oppId;
			q.Total_Amount__c = totalAmount;
			q.Unstructured_additional_info__c = '<div style="margin-left:100px;"><h2 style="color:#003366;text-align:center;">' + accName + '</h2></div>';
			Set<Id> pppProdParamIds = new Set<Id>();
			List<MigrationPremiumTypes.PrintingProductParameter> pppBase = new List<MigrationPremiumTypes.PrintingProductParameter>();
			List<MigrationPremiumTypes.PrintingProductParameter> pppSupl = new List<MigrationPremiumTypes.PrintingProductParameter>();
			List<MigrationPremiumTypes.PrintingProductParameter> pppTheme = new List<MigrationPremiumTypes.PrintingProductParameter>();
			List<MigrationPremiumTypes.PrintingProductParameter> pppRegInv = new List<MigrationPremiumTypes.PrintingProductParameter>();
			for (MigrationPremiumTypes.PrintingProductParameter ppp : pppList) {
				pppProdParamIds.add(ppp.productParameterId);
				if (typeTranslationMap.get(BASE_STR) == ppp.type) {
					pppBase.add(ppp);
				} else if (typeTranslationMap.get(SUPL_STR) == ppp.type) {
					pppSupl.add(ppp);
				} else if (typeTranslationMap.get(THEME_STR) == ppp.type) {
					pppTheme.add(ppp);
				} else if (typeTranslationMap.get(REGINV_STR) == ppp.type) {
					pppRegInv.add(ppp);
				}
			}
			Map<Id, Product_Parameter__c> ppMap = new Map<Id, Product_Parameter__c>([SELECT Id, Product__r.Investment_Description__c, sync_element_name__c FROM Product_Parameter__c WHERE Id IN :pppProdParamIds]);
			Boolean isSvet = template == 'tpl1';
			String templateColor = isSvet ? '#f08700' : template == 'tpl2' ? '#00b0f0' : '#002060';
			System.debug('TEMPLATE: ' + template);
			System.debug('TCOLOR: ' + templateColor);
			String tableHeader = '<h2 style="color: #002060; margin:0;padding:0;line-height:16px;">{0}</h2><table style="width:100%; margin:0;" border="1"><tr style="background-color: #002060; color: #ffffff;"><th>Název produktu</th><th align="center">Částka k investici</th></tr>';
			String tableRow = '<tr><td style="width:75%;"><span style="color: {3};">{0}</span><br /><span style="color: #002060;">{1}</span></td><td style="width:25%;color: {3};font-size: 14px;" align="center">{2}&nbsp;Kč</td></tr>';
			String pppTable = pppBase.isEmpty() ? '' : String.format(tableHeader, new List<String>{
					typeTranslationMap.get(BASE_STR)
			});
			prodCounter = 0;
			for (MigrationPremiumTypes.PrintingProductParameter ppp : pppBase) {
				if (checkPageSpace(isSvet)) {
					pppTable += pageBreak(true);
				}
				pppTable += String.format(tableRow, new List<String>{
						ppp.label, ppMap.get(ppp.productParameterId).Product__r.Investment_Description__c, ppp.amount.format(), templateColor
				});
				prodCounter++;
			}
			pppTable += checkPageSpace(isSvet) ? pageBreak(false) : '</table>';
			pppTable += pppBase.size() < 5 ? '<br/><br/><br/><br/><br/><br/><br/>' : '';
			pppTable += pppSupl.isEmpty() ? '' : String.format(tableHeader, new List<String>{
					typeTranslationMap.get(SUPL_STR)
			});
			for (MigrationPremiumTypes.PrintingProductParameter ppp : pppSupl) {
				if (checkPageSpace(isSvet)) {
					pppTable += pageBreak(true);
				}
				pppTable += String.format(tableRow, new List<String>{
						ppp.label, ppMap.get(ppp.productParameterId).Product__r.Investment_Description__c, ppp.amount.format(), templateColor
				});
				prodCounter++;
			}
			pppTable += checkPageSpace(isSvet) ? pageBreak(false) : '</table>';
			pppTable += pppTheme.isEmpty() ? '' : String.format(tableHeader, new List<String>{
					typeTranslationMap.get(THEME_STR)
			});
			for (MigrationPremiumTypes.PrintingProductParameter ppp : pppTheme) {
				if (checkPageSpace(isSvet)) {
					pppTable += pageBreak(true);
				}
				pppTable += String.format(tableRow, new List<String>{
						ppp.label, ppMap.get(ppp.productParameterId).Product__r.Investment_Description__c, ppp.amount.format(), templateColor
				});
				prodCounter++;
			}
			pppTable += checkPageSpace(isSvet) ? pageBreak(false) : '</table>';
			pppTable += pppRegInv.isEmpty() ? '' : String.format(tableHeader, new List<String>{
					typeTranslationMap.get(REGINV_STR)
			});
			for (MigrationPremiumTypes.PrintingProductParameter ppp : pppRegInv) {
				if (checkPageSpace(isSvet)) {
					pppTable += pageBreak(true);
				}
				pppTable += String.format(tableRow, new List<String>{
						ppp.label, ppMap.get(ppp.productParameterId).Product__r.Investment_Description__c, ppp.amount.format(), templateColor
				});
				prodCounter++;
			}

			pppTable += String.isNotBlank(pppTable.substringAfterLast('</table>')) ? '</table>' : '';

			q.Products_in_offer__c = pppTable;
			q.Print_Output_Type__c = isSvet ? 'Svět' : template == 'tpl2' ? 'Start' : null;
			insert q;
			System.debug('*** QUOTE: ' + q.Id);

			String tmplId = isSvet ? templateId : template == 'tpl2' ? template2Id : null;
			PageReference pdfPageRef = new PageReference(
					quoteTemplateDataViewerUrl.replace('{!QuoteId}', q.Id)
							.replace('{!HeaderHeight}', headerHeight)
							.replace('{!FooterHeight}', footerHeight)
							.replace('{!TemplateId}', tmplId)
			);

			List<Printing_Product_Parameter__c> pppListForInsert = new List<Printing_Product_Parameter__c>();
			for (MigrationPremiumTypes.PrintingProductParameter ppp : pppList) {
				Printing_Product_Parameter__c pppForInsert = new Printing_Product_Parameter__c();
				pppForInsert.Name = ppp.label;
				pppForInsert.Product_Parameter__c = ppp.productParameterId;
				pppForInsert.Amount__c = ppp.amount;
				pppForInsert.Quote__c = q.Id;
				pppForInsert.Type__c = ppp.type;
				pppListForInsert.add(pppForInsert);
			}
			insert pppListForInsert;

//            List<Attachment> attList = new List<Attachment>();
//            Blob attBody = pdfPageRef.getContent();
//            System.debug('attBody: ' + attBody);
//            attList.add(new Attachment(
//                Name = q.Name + '.pdf',
//                Body = attBody,
//                ParentId = oppId
//            ));
//            if (!attList.isEmpty()) {
//                insert attList;
//            }

			return pdfPageRef.getUrl();

		} catch (Exception e) {
			Database.rollback(sp);
			System.debug(LoggingLevel.ERROR, e.getMessage());
			final String errorMsg = 'An error has occured while generating the pdf. Details:\n\n' +
					e.getMessage() + '\n\n' +
					e.getStackTraceString();
			return errorMsg;
		}
	}*/

	/*    private static Boolean checkPageSpace(Boolean breakable) {
        if (prodCounter >= 5) {
            prodCounter = 0;
            return true;
        }
        return false;
    }*/

	/*    private static String pageBreak(Boolean inTable) {
        String endTableBrString = '</table><br /><br /><br /><br />';
        return inTable ? endTableBrString + '<br /><br /><br /><br /><table style="width:100%; margin:0;" border="1">' : endTableBrString;
    }*/

	/*    private static Integer getNextOfferNumber(List<Quote> quoteList) {
        Integer i = 0;
        for (Quote q : quoteList) {
            List<String> quoteNameParts = q.Name.split(' ');
            Integer qNumber = Integer.valueOf(quoteNameParts.get(quoteNameParts.size() - 1));
            i = qNumber > i ? qNumber : i;
        }
        return ++i;
    }*/

	/*    @TestVisible
    private static String getCaseStatusForSendingToBAW(List<String> docIdList) {
        if (docIdList != null && !docIdList.isEmpty()) {
            List<DMS_Document__c> docList = [SELECT Id, Document_Version_ID__c FROM DMS_Document__c WHERE ID IN :docIdList];
            for (DMS_Document__c doc : docList) {
                if (String.isBlank(doc.Document_Version_ID__c)) {
                    return GlobalConstants.CASE_DRAFT_CST;
                }
            }
        }
        return GlobalConstants.CASE_OPEN_CST;
    }*/

	//    @RemoteAction
	//    public static String getGetResourceURL(String resourceName) {
	//        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
	//        //Checking if the result is returned or not
	//        if(resourceList.size() == 1) {
	//            //Getting namespace
	//            String namespace = resourceList[0].NamespacePrefix;
	//            //Resource URL
	//            return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
	//        }
	//        else return '';
	//    }

	/* TODO: Place this method to Utils if possible
	 */
	private static String getTransLabel(String objName, String picklistField, String value) {
		SObjectType obj = Schema.getGlobalDescribe().get(objName);
		DescribeSObjectResult objRes = obj.getDescribe();
		SObjectField field = objRes.fields.getMap().get(picklistField);
		if (field != null) {
			List<Schema.PicklistEntry> picklistValues = field.getDescribe().getPicklistValues();
			for (Schema.PicklistEntry pe : picklistValues) {
				if (value.toLowerCase() == pe.getValue().toLowerCase())
					return pe.getLabel();
			}
		}
		return value;
	}

	/**
	 * @author Ondrej Srom
	 * @description Method for round down to thousands of limit for kontokorent. Then check BALCMP__c field and choose product relation.
	 * @param value -  Limit_Account__c
	 * @param value -  BALCMP__c
	 * Update: Commented 25.07.2019 on BOBOT command.
	 */
	/*private static String roundToThousandAndSelectRelation(Decimal accLimit, Decimal balcmp){
		List<String> splitString;
		String s = String.valueOf(accLimit/1000);
		String s2;

		if(s.contains('.')){
			splitString = s.split('\\.');
			System.debug(splitString);
			s = splitString.get(0);
			s2 = splitString.get(1);
		}
		accLimit = Decimal.valueOf(s)*1000;
		if(!String.isBlank(s2)){
			accLimit = Decimal.valueOf(s);
			if(balcmp <= accLimit) {
				return 'PR-689';
			}else{
				return 'PR-636';
			}
		}else{
			return 'PR-689';
		}
	}*/

	/*public static void enhanceTransitionItemForCancellation(Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelations) {
		Map<String, MigrationPremiumTypes.TransitionItemDefault> result = new Map<String, MigrationPremiumTypes.TransitionItemDefault>();
		Map<String, Product_Parameter__c> parentProductParameter;
		Map<String, Product_Parameter__c> valueProductParameter;
		Map<String, Asset> assetFromParameterMap;
		Set<String> productParameterParentIdSet = new Set<String>();
		Set<String> productParameterValueIdSet = new Set<String>();
		for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelations.values()) {
			for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {
				if (theItem.productParameterDefaults != null && !theItem.productParameterDefaults.isEmpty()) {
					productParameterParentIdSet.addAll(theItem.productParameterDefaults.keySet());
					for (MigrationPremiumTypes.TransitionItemDefault data : theItem.productParameterDefaults.values()) {
						productParameterValueIdSet.add(data.value);
					}
				}
			}
		}
		System.debug('productParameterValueIdSet: ' + productParameterValueIdSet);
		parentProductParameter = new Map<String, Product_Parameter__c>([SELECT Id, Type__c, ISTS_Element_Name__c, Parameter_Label__c, String_Value__c FROM Product_Parameter__c WHERE Id = :productParameterParentIdSet]);
		valueProductParameter = new Map<String, Product_Parameter__c>([SELECT Id, Parameter_Label__c, ISTS_Element_Name__c, String_Value__c FROM Product_Parameter__c WHERE Id = :productParameterValueIdSet]);
		assetFromParameterMap = new Map<String, Asset>([select Id, Account_Number__c from Asset where id = :productParameterValueIdSet]);
		System.debug('valueProductParameter: ' + valueProductParameter);
		for (Map<String, MigrationPremiumTypes.TransitionItem> theItemMap : productRelations.values()) {
			for (MigrationPremiumTypes.TransitionItem theItem : theItemMap.values()) {
				theItem.enhancedProductParameterDefaults = new Map<String, MigrationPremiumTypes.TransitionItemDefault>();
				if (theItem.productParameterDefaults != null && !theItem.productParameterDefaults.isEmpty()) {
					for (String parentProductParameterId : theItem.productParameterDefaults.keySet()) {
						MigrationPremiumTypes.TransitionItemDefault transitionItem = theItem.productParameterDefaults.get(parentProductParameterId);
						Product_Parameter__c parent = parentProductParameter.get(parentProductParameterId);
						System.debug('parent: ' + parent);
						System.debug('transitionItem: ' + transitionItem);
						if (parent == null) {
							continue;
						}
						if (String.isBlank(parent.ISTS_Element_Name__c)) {
							continue;
						}
						String stringValue;
						String value;
						String transValue;
						if (parent.Type__c == 'Select' || parent.Type__c == 'Calculated Select') {
							if (valueProductParameter.containsKey(transitionItem.value)) {
								value = valueProductParameter.get(transitionItem.value).Parameter_Label__c;
								transValue = valueProductParameter.get(transitionItem.value).ISTS_Element_Name__c;
							}
						} else if (parent.Type__c == 'Checkbox') {
							stringValue = parent.String_value__c;
							value = transitionItem.value;
						} else {
							value = transitionItem.value;
						}
						MigrationPremiumTypes.TransitionItemDefault dataEntry = new MigrationPremiumTypes.TransitionItemDefault();
						dataEntry.value = value;
						dataEntry.productParameterId = parent.Id;
						dataEntry.transValue = transValue;
						dataEntry.stringValue = valueProductParameter != null && valueProductParameter.get(transitionItem.value) != null ? valueProductParameter.get(transitionItem.value).String_Value__c : stringValue;
						dataEntry.assetValue = transitionItem.assetValue;
						dataEntry.syncElementName = transitionItem.syncElementName;
						System.debug('dataEntry: ' + dataEntry);
						theItem.enhancedProductParameterDefaults.put(parent.ISTS_Element_Name__c, dataEntry);
					}
				}
			}
		}
	}*/

	/*    public class DeactivateDataWrapper{
        public String stateOfGivingCard { get; set; }
        public boolean canSendToDeactivate { get; set; }

        public DeactivateDataWrapper(String state, boolean canSend) {
            this.stateOfGivingCard = state;
            this.canSendToDeactivate = canSend;
        }
    }*/

	/*    @RemoteAction
    global static String calculateBagettaDate(String appDate, Boolean sipo, Boolean pension) {
        Date inputDate = Date.parse(appDate);
        Date outputDate = BagettaDayController.getBagettaDay(inputDate, sipo, pension, false);
        return outputDate != null ? outputDate.format() : null;
    }*/

	/*    @RemoteAction
    global static StoreDocumentApiTypes.Result_element storeToJSK(String dmsDocId, Boolean reservation, String prodNumber, Boolean showToClient) {
        List<DMS_Document__c> jskDocList = [SELECT Id, Document_URL__c, Print_ID__c, Type_Of_Document__c, Account__c, Account__r.CUID__c, Case__c, Case__r.Account.CUID__c, LastModifiedDate FROM DMS_Document__c WHERE Id = :dmsDocId];
        if (!jskDocList.isEmpty()) {
            DMS_Document__c jskDoc = jskDocList.get(0);
            StoreDocumentApiTypes.Result_element res = IstsIframeGdprPageController.getDocumentUrlIstsWithoutTimeValidation(jskDoc.Print_ID__c, dmsDocId, reservation, prodNumber, showToClient);
            return res;
        }
        return null;
    }*/

	/*@RemoteAction
	global static WebserviceResult callSignBiometricEnvelope(List<String> documentIds, String assetId, String cuid, String accFirstName, String accLastName) {
		String ERROR_STRING = 'Vyskytl se problém, kontaktujte CRM IT. ';
		String CONSOLE_ERROR_STRING = 'callSignBiometricEnvelope: ';
		String accName = String.isNotBlank(accFirstName) && String.isNotBlank(accLastName) ? accFirstName + ' ' + accLastName : null;
		try {
			User theUser = [SELECT Id,Data_ID__c,GlowId__c,Preferred_Branch__c FROM User WHERE Id = :UserInfo.getUserId()];
			List<Asset> assetList = [SELECT Id,Account_Number__c,Account.CUID__c,Account.Name, Product2.Product__r.CST_Value_ID__c, Parent_Asset__r.Account_Number__c FROM Asset WHERE Id = :assetId];
			Asset theAsset = !assetList.isEmpty() ? assetList.get(0) : null;
			List<DMS_Document__c> DMSDocuments = [SELECT Id,Print_ID__c,Document_URL__c,Type_Of_Document__c,External_ID__c FROM DMS_Document__c WHERE Id IN :documentIds];
			if (documentIds.size() != DMSDocuments.size()) {
				return WebserviceResult.getErrorResult(System.Label.PCF_BioSign_CancelDocError, CONSOLE_ERROR_STRING + 'docIdsList size: ' + documentIds.size() + ', DMSDocList size: ' + DMSDocuments.size());
			}
			DMSDocuments = BSSPCFUtils.getDmsDocumentsWithValidPdfUrls(DMSDocuments);
			if (DMSDocuments == null) {
				return WebserviceResult.getErrorResult(System.Label.PCF_BioSign_NotGeneratedPdf, CONSOLE_ERROR_STRING + 'Not generated pdf problem.');
			}
			BiometricEnvelopeApi.BiometricEnvelopeRequest request = BSSPCFUtils.buildRequest(theUser, cuid, accName, DMSDocuments, theAsset);
			BiometricEnvelopeApi.SignBiometricEnvelope_v2_MetaHeader2_PortTypeBindingHttpPort port = new BiometricEnvelopeApi.SignBiometricEnvelope_v2_MetaHeader2_PortTypeBindingHttpPort();
			port.SignBiometricEnvelope_v2(request);
			if (port.resultCode != GlobalConstants.WEBSERVICE_OK_CODE) {
				return WebserviceResult.getErrorResult(ERROR_STRING + 'SID: ' + port.MetaHeader_v2.CallContext.Sid, CONSOLE_ERROR_STRING + port.resultDescription);
			}
		} catch (Exception e) {
			return WebserviceResult.getErrorResult(ERROR_STRING + 'Neznámá chyba.', CONSOLE_ERROR_STRING + e.getMessage() + '\n' + e.getStackTraceString());
		}
		return new WebserviceResult();
	}*/

	/* @RemoteAction
	 global static Boolean checkIfPpfDraft(String accId) {
		 List<Case> theCases = new List<Case>();
		 try {
			 theCases = [SELECT Id FROM Case WHERE Type_of_Process__c = 'PPF' AND Status = '10' AND AccountId = :accId];
			 return (theCases.size() > 0 && !theCases.isEmpty()) ? true : false;
		 } catch (Exception e) {
			 throw new AuraHandledException(LightningError.of('Error: ', e));
		 }
	 }*/
}
