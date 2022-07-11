global class MigrationPremiumTypes {

    public static final String VISIBILITY_TYPE_SHOW = 'Show';
    public static final String VISIBILITY_TYPE_HIDE = 'Hide';
    public static final String VISIBILITY_TYPE_DISABLE = 'Disable';

    global class Item {
        global Integer index {get; set;}
        global String name {get; set;}
        global Boolean defaultSelected {get; set;}
        global Product2 theProduct {get; set;}
        global Asset theAsset {
            get;
            set;
        }
        global DispatcherWrapper dispatcher {get; set;}
        global Integer lastIndex {
            get{
                return childItemMap != null ? childItemMap.size() : 0;
            }
        }
        global Map<String, Item> childItemMap {
            get {
                if(childItemMap == null){
                    childItemMap = new Map<String, Item>();
                }
                return childItemMap;
            }
            set;
        }
        global Boolean isSelected {
            get{
                if(isSelected == null){
                    isSelected = false;
                }
                return isSelected;
            }
            set;
        }

       /* global Boolean isReadOnly {
            get{
                if(isReadOnly == null && migrationProcess != null && theProduct != null && theProduct.Product__r != null && migrationProcess.Assets_In_Migration_Data_ID_Read_only__c != null){
                    List<String> forbiddenDataIds = migrationProcess.Assets_In_Migration_Data_ID_Read_only__c.split(';');
                    isReadOnly = forbiddenDataIds.contains(theProduct.Product__r.CST_Value_ID__c);
                }
                return isReadOnly == null ? false : isReadOnly;
            }
            private set;
        }
        global Boolean isMigrationCard {
            get {
                if(isMigrationCard == null && migrationProcess != null && theProduct != null && theProduct.Product__r != null && migrationProcess.Assets_In_Migration_Card_ID__c != null){
                    List<String> forbiddenDataIds = migrationProcess.Assets_In_Migration_Card_ID__c.split(';');
                    isMigrationCard = forbiddenDataIds.contains(theProduct.Product__r.CST_Value_ID__c);
                }
                return isMigrationCard == null ? false : isMigrationCard;
            }
            private set;
        }*/

        global Boolean hasSubProducts {
            get{
                if(hasSubProducts == null){
                    hasSubProducts = false;
                }
                return hasSubProducts;
            }
            set;
        }

        global Migration_Process__mdt migrationProcess { get; set; }

        global Item(Migration_Process__mdt migrationProcess, Asset theAsset, Integer index){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theAsset.Product2.Name;
            this.theProduct = theAsset.Product2;
            this.theAsset = theAsset;
        }

       /* global Item(Migration_Process__mdt migrationProcess, Product2 theProduct, Boolean isSelected, Integer index){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theProduct.Name;
            this.theProduct = theProduct;
            this.isSelected = isSelected;
            this.defaultSelected = false;
        }

        global Item(Migration_Process__mdt migrationProcess, Product2 theProduct, Boolean isSelected, Integer index, Boolean defaultSelected){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theProduct.Name;
            this.theProduct = theProduct;
            this.isSelected = isSelected;
            this.defaultSelected = defaultSelected;
        }

        global Item(Migration_Process__mdt migrationProcess, Boolean hasSubproducts, Product2 theProduct, Boolean isSelected, Integer index, Boolean defaultSelected){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theProduct.Name;
            this.theProduct = theProduct;
            this.isSelected = isSelected;
            this.defaultSelected = defaultSelected;
            this.hasSubProducts = hasSubProducts;
        }*/

        global Item(Migration_Process__mdt migrationProcess, Asset theAsset, String accountId, Integer index){
            this.migrationProcess = migrationProcess;
            /*if(accountId != theAsset.AccountId){
                createDispatcherData(theAsset);
            }*/
            this.index = index;
            this.name = theAsset.Product2.Name;
            this.theProduct = theAsset.Product2;
            this.theAsset = theAsset;
        }

        global Item(Migration_Process__mdt migrationProcess, Asset theAsset, Boolean isSelected, Integer index){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theAsset.Product2.Name;
            this.theProduct = theAsset.Product2;
            this.theAsset = theAsset;
            this.isSelected = isSelected;
            this.defaultSelected = false;
        }

       /* global Item(Migration_Process__mdt migrationProcess, Boolean hasSubProducts, Asset theAsset, Boolean isSelected, Integer index){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theAsset.Product2.Name;
            this.theProduct = theAsset.Product2;
            this.theAsset = theAsset;
            this.isSelected = isSelected;
            this.defaultSelected = false;
            this.hasSubProducts = hasSubProducts;
        }*/

        global Item(Migration_Process__mdt migrationProcess, Asset theAsset, Boolean isSelected, Integer index, Boolean defaultSelected){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theAsset.Product2.Name;
            this.theProduct = theAsset.Product2;
            this.theAsset = theAsset;
            this.isSelected = isSelected;
            this.defaultSelected = defaultSelected;
        }

       /* global Item(Migration_Process__mdt migrationProcess, Boolean hasSubProducts, Asset theAsset, Boolean isSelected, Integer index, Boolean defaultSelected){
            this.migrationProcess = migrationProcess;
            this.index = index;
            this.name = theAsset.Product2.Name;
            this.theProduct = theAsset.Product2;
            this.theAsset = theAsset;
            this.isSelected = isSelected;
            this.defaultSelected = defaultSelected;
            this.hasSubProducts = hasSubProducts;
        }*/

        global Item(Migration_Process__mdt migrationProcess, Asset theAsset, Boolean isSelected, Integer index, Boolean defaultSelected, Product2 theProduct){
            this.migrationProcess = migrationProcess;
            this.index = index;
            if(theProduct != null){
                this.name = theProduct.Name;
            }
            this.theProduct = theProduct;
            this.theAsset = theAsset;
            this.isSelected = isSelected;
            this.defaultSelected = defaultSelected;
        }

        public String getAssetId(){
            return theAsset == null ? null : theAsset.Id;
        }

/*        private void createDispatcherData(Asset theAsset){
            dispatcher = new DispatcherWrapper(theAsset.AccountId, theAsset.Account.Name, theAsset.Account.CUID__c);
        }*/
    }

    global class DispatcherWrapper {
        global String theId {get; set;}
        global String name {get; set;}
        global String cuid {get; set;}

        global DispatcherWrapper(String theId, String name, String cuid){
            this.theId = theId;
            /*if(MigrationPremiumController.decryptedAssetNameByIdMap != null && MigrationPremiumController.decryptedAssetNameByIdMap.containsKey(theId)){
                this.name = MigrationPremiumController.decryptedAssetNameByIdMap.get(theId);
            }else{
                this.name = name;
            }*/
            this.name = name;
            this.cuid = cuid;
        }
    }

    global class ItemsWrapper {
        global Integer lastIndex {
            get{
                return itemMap != null ? itemMap.size() : 0;
            }
        }
        global String selectedRow {get; set;}
        global Map<String, Item> itemMap {get; set;}
    }

    global class TransitionData {
        global String productId {get; set;}
        global String productName {get; set;}
        global Boolean isOwner {get; set;}
        global Map<String, Map<String, TransitionItem>> transitionItemMap {
            get{
                if(transitionItemMap == null){
                    transitionItemMap = new Map<String, Map<String, TransitionItem>>();
                }
                return transitionItemMap;
            }
            set;
        }
        global Item theItem {get; set;}
    }

    global class TransitionItemDefault {
        global String productParameterId {get;set;}
        global String value {get;set;}
        global String transValue {get; set;}
        global String stringValue {get; set;}
        global List<MultiValueItemDetail> multiValue {get;set;}
        global String assetValue {get;set;}
        global String syncElementName {get;set;}
    }

    global class MultiValueItemDetail {
        global String id {get;set;}
        global String label {get;set;}
    }

    global class TransitionItem {
        global String productId {get;set;}
        global String productName {get; set;}
        global Boolean isOwner {get; set;}
        global String disponentText {get; set;}
        global String disponentId {get; set;}
        global String assetId {get; set;}
        global String assetAccountNumber {get; set;}
        global String parentAssetAccNumber {get; set;}
        global String selectedRelationId {get;set;}
        global Boolean isCard {get; set;}
        global String assetBankSystem {get; set;}
        global Map<String, TransitionItemDefault> productParameterDefaults {get;set;}
        global Map<String, TransitionItemDefault> enhancedProductParameterDefaults {get;set;}
        global List<Product_Relation__c> productRelationList {
            get{
                if(productRelationList == null){
                    productRelationList = new List<Product_Relation__c>();
                }
                return productRelationList;
            }
            set;
        }

        public TransitionItem(){}

        public TransitionItem(Asset theAsset, String accountId, String productName, String productId, List<Product_Relation__c> productRelationList){
            this.productId = productId;
            this.productName = productName;
            this.productRelationList = productRelationList;
        }

        /*public void setAssetId(String assetId){
            this.assetId = assetId;
            if(String.isNotBlank(assetId) && MigrationPremiumController.assetNumberByIdMap.containsKey(assetId)){
                assetAccountNumber = MigrationPremiumController.assetNumberByIdMap.get(assetId);
            }
        }

        public void setParrentAccNumber(String parentAssetId){
            if (String.isNotBlank(parentAssetId) && MigrationPremiumController.assetNumberByIdMap.containsKey(parentAssetId)){
                parentAssetAccNumber = MigrationPremiumController.assetNumberByIdMap.get(parentAssetId);
            }
        }*/
    }

    global class ProductParameterWrapper {
        global Boolean isFirst {get;set;}
        global VisibilityWrapper visibility {get; set;}
        global Boolean hasDependencies {get;set;}
        global String defaultValueFromAsset {get; set;}
        //global IntegrationUtils.jsonWithEndpoint data {get; set;}
        global String fieldAPI {get; set;}
        global String typeOfParameter {get; set;}
        global String idOfParameter {get;set;}
        global Boolean wantEncryptFields {get;set;}
        global Boolean loadHidden {get;set;}
        global Boolean loadHiddenRO {get;set;}

        global Product_Parameter__c productParameter {
            get;
            set{
                productParameter = value;
                typeOfParameter = value.Type__c;
            }
        }
        global Map<String, ProductParameterWrapper> childParameterList {get; set;}

        global ProductParameterWrapper() {
            this.visibility = new VisibilityWrapper(VISIBILITY_TYPE_SHOW, 1);
            this.hasDependencies = false;
            this.isFirst = false;
            this.wantEncryptFields = false;
            this.loadHidden = false;
            this.loadHiddenRO = false;
        }

        global ProductParameterWrapper(Product_Parameter__c theProductParameter){
            this.isFirst = false;
            this.visibility = new VisibilityWrapper(VISIBILITY_TYPE_SHOW, 1);
            this.hasDependencies = false;
            this.productParameter = theProductParameter;
            this.typeOfParameter = theProductParameter.Type__c;
            this.fieldAPI = theProductParameter.Field_API__c;
            this.wantEncryptFields = theProductParameter.Encrypt_Api_Field_Data__c;
            this.loadHidden = theProductParameter.Load_Hidden__c;
            this.loadHiddenRO = theProductParameter.Load_Hidden_RO__c;
        }

        global ProductParameterWrapper(Product_Parameter__c theProductParameter, String defaultValueFromAsset){
            this.visibility = new VisibilityWrapper(VISIBILITY_TYPE_SHOW, 1);
            this.isFirst = false;
            this.hasDependencies = false;
            this.productParameter = theProductParameter;
            this.typeOfParameter = theProductParameter.Type__c;
            this.fieldAPI = theProductParameter.Field_API__c;
            this.defaultValueFromAsset = defaultValueFromAsset;
            this.wantEncryptFields = theProductParameter.Encrypt_Api_Field_Data__c;
            this.loadHidden = theProductParameter.Load_Hidden__c;
            this.loadHiddenRO = theProductParameter.Load_Hidden_RO__c;
        }

        global void addChildParameter(ProductParameterWrapper theProductParameterWrapper){
            if(childParameterList == null){
                childParameterList = new Map<String, ProductParameterWrapper>();
            }
            childParameterList.put(theProductParameterWrapper.productParameter.Id, theProductParameterWrapper);
        }

//        orig code:
//        global void setVisibilityType(String visibilityType){
//            if(!String.isBlank(visibilityType)){
//                this.visibilityType = visibilityType;
//            }
//        }

        global void setVisibility(VisibilityWrapper visibilityWrapper){
            this.visibility = visibilityWrapper;
        }

        global void setVisibility(String visibilityType){
            if (this.visibility != null) {
                this.visibility.visibilityType = visibilityType;
            } else {
                if(visibilityType == VISIBILITY_TYPE_SHOW) {
                    this.visibility = new VisibilityWrapper(visibilityType, 1);
                } else {
                    this.visibility = new VisibilityWrapper(visibilityType, 0);
                }
            }
        }

        global void setFieldApi(String fieldApi) {
            this.fieldAPI = fieldAPI;
        }
    }

    global class VisibilityWrapper{
        global String visibilityType {
            get {
                if (visibilityType == null && visibilityCount == 0) {
                    visibilityType = VISIBILITY_TYPE_HIDE;
                }
                return visibilityType;
            }
            set {
                this.visibilityType = value;
                if (visibilityType == VISIBILITY_TYPE_HIDE) {
                    this.visibilityCount = 0;
                }
            }
        }
        global Integer visibilityCount {get; set;}

        global VisibilityWrapper(){
            this.visibilityCount = 0;
            this.visibilityType = VISIBILITY_TYPE_HIDE;
        }

        global VisibilityWrapper(String type, Integer count){
            this.visibilityType = type;
            this.visibilityCount = count;
        }
    }

    global class CaseValidationWrapper{
        global Boolean isValid {get; set;}
        global String caseId {get; set;}
        global String validationErrorMessage {get; set;}
    }

    public class ThresholdWrapper {
        public Map<String, List<Threshold_Product_Parameter__c>> dependentByMap {get;set;}
        public Map<String, Map<String, List<Threshold_Product_Parameter__c>>> parentByMap {get;set;}
    }

    global class ApiFieldWrapper {
        global String fieldName {get; set;}
        global String value {get; set;}
        global String wantEncryptFields {get; set;}
    }

    global class DependencyWrapper {
        global String composedId {get; set;}
        global String initialValue {get; set;}
        global List<DependencyValueWrapper> multipleInitialValueList {get; set;}
        global Boolean isVisible {get;set;}
        global String visibilityType {get; set;}
        global Boolean isHidden {get; set;}
        global Boolean hasBackgroundQuery {
            get {
                if(hasBackgroundQuery == null){
                    return false;
                }

                return hasBackgroundQuery;
            }
            set;
        }
    }

    global class DependencyValueWrapper {
        global String value {get; set;}
        global String text {get; set;}
    }

    global class File {
        global String uniqueId {get; set;}
        global String name {get; set;}
        global String data {get; set;}
        global String size {get; set;}
    }

    global class PrintingProductParameter {
        global String label {get; set;}
        global String productParameterId {get; set;}
        global Integer amount {get; set;}
        global String type {get; set;}

        global PrintingProductParameter(String label, String ppId, String amount, String type){
            this.label = label;
            this.productParameterId = ppId;
            this.amount = Integer.valueOf(amount);
            this.type = type;
        }
    }

    global class CancellationInfo {
        global String id;
        global String productName;
        global String dateOfCancellation;

        global CancellationInfo(String id, String productName, String dateOfCancellation){
            this.id = id;
            this.productName = productName;
            this.dateOfCancellation = dateOfCancellation;
        }
    }

    global class PdfTemplateItem {
        global String title;
        global String value;
    }
}