public class PersonManagementSOAPServiceTypes {
	private static final String s_ns0 = 'http://service.cmss.cz/person/PersonManagementService/v10';
	public static DateTime parseDateTime(String nodeText) {
		String iso8601 = nodeText;
		JSONParser parser = JSON.createParser('{"t":"' + iso8601 + '"}');
		parser.nextToken();
		parser.nextValue();
		DateTime dt = parser.getDateTimeValue();
		//System.debug('dt: ' + dt);
		return dt;
	}
	public class AddressType {
		public DateTime dateLastUpdate;
		public Long subType;
		public Long contactType;
		public String city;
		public Long country;
		public String streetNumber;
		public String zipCode;
		public String street;
		// Restriction enumeration:
		public Date validFrom;
		// Restriction enumeration:
		public Date validUntil;
		public Boolean technicalStatus;
		public String addressMCSBGUID;
		public Long contactFlag;
		public Long contactId;
		public Long addressID;
		public String addressGUID;
		public String POBox;
		public String addNameInfo;
		public String addAddressInfo;
		public String poznamkaNote;
		public String TINTaxNumber;
		public String TINNote;
		public String sourceApp;
		public Long dataSource;
		private transient String[] dateLastUpdate_type_info = new List<String>{
			'dateLastUpdate',
			s_ns0,
			'CommonDateTimeType',
			'0',
			'1',
			'false'
		};
		private transient String[] subType_type_info = new List<String>{
			'subType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactType_type_info = new List<String>{
			'contactType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] city_type_info = new List<String>{
			'city',
			s_ns0,
			'CityNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] country_type_info = new List<String>{
			'country',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] streetNumber_type_info = new List<String>{
			'streetNumber',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] zipCode_type_info = new List<String>{
			'zipCode',
			s_ns0,
			'PostCodeType',
			'0',
			'1',
			'false'
		};
		private transient String[] street_type_info = new List<String>{
			'street',
			s_ns0,
			'StreetNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] validFrom_type_info = new List<String>{
			'validFrom',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] validUntil_type_info = new List<String>{
			'validUntil',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] technicalStatus_type_info = new List<String>{
			'technicalStatus',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] addressMCSBGUID_type_info = new List<String>{
			'addressMCSBGUID',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactFlag_type_info = new List<String>{
			'contactFlag',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactId_type_info = new List<String>{
			'contactId',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] addressID_type_info = new List<String>{
			'addressID',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] addressGUID_type_info = new List<String>{
			'addressGUID',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] POBox_type_info = new List<String>{
			'POBox',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] addNameInfo_type_info = new List<String>{
			'addNameInfo',
			s_ns0,
			'OtherNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] addAddressInfo_type_info = new List<String>{
			'addAddressInfo',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] poznamkaNote_type_info = new List<String>{
			'poznamkaNote',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] TINTaxNumber_type_info = new List<String>{
			'TINTaxNumber',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] TINNote_type_info = new List<String>{
			'TINNote',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] sourceApp_type_info = new List<String>{
			'sourceApp',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] dataSource_type_info = new List<String>{
			'dataSource',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'dateLastUpdate',
			'subType',
			'contactType',
			'city',
			'country',
			'streetNumber',
			'zipCode',
			'street',
			'validFrom',
			'validUntil',
			'technicalStatus',
			'addressMCSBGUID',
			'contactFlag',
			'contactId',
			'addressID',
			'addressGUID',
			'POBox',
			'addNameInfo',
			'addAddressInfo',
			'poznamkaNote',
			'TINTaxNumber',
			'TINNote',
			'sourceApp',
			'dataSource'
		};
		public AddressType() {
		}
		public AddressType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode dateLastUpdateNode = responseNode.getChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateLastUpdate = (dateLastUpdateNode == null)
				? null
				: PersonManagementSOAPServiceTypes.parseDateTime(dateLastUpdateNode.getText());
			nodesParsed.add(dateLastUpdateNode);
			//System.debug(this.dateLastUpdate);
			DOM.XmlNode subTypeNode = responseNode.getChildElement(
				'subType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.subType = (subTypeNode == null) ? null : Long.valueOf(subTypeNode.getText());
			nodesParsed.add(subTypeNode);
			//System.debug(this.subType);
			DOM.XmlNode contactTypeNode = responseNode.getChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactType = (contactTypeNode == null) ? null : Long.valueOf(contactTypeNode.getText());
			nodesParsed.add(contactTypeNode);
			//System.debug(this.contactType);
			DOM.XmlNode cityNode = responseNode.getChildElement(
				'city',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.city = (cityNode == null) ? null : cityNode.getText();
			nodesParsed.add(cityNode);
			//System.debug(this.city);
			DOM.XmlNode countryNode = responseNode.getChildElement(
				'country',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.country = (countryNode == null) ? null : Long.valueOf(countryNode.getText());
			nodesParsed.add(countryNode);
			//System.debug(this.country);
			DOM.XmlNode streetNumberNode = responseNode.getChildElement(
				'streetNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.streetNumber = (streetNumberNode == null) ? null : streetNumberNode.getText();
			nodesParsed.add(streetNumberNode);
			//System.debug(this.streetNumber);
			DOM.XmlNode zipCodeNode = responseNode.getChildElement(
				'zipCode',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.zipCode = (zipCodeNode == null) ? null : zipCodeNode.getText();
			nodesParsed.add(zipCodeNode);
			//System.debug(this.zipCode);
			DOM.XmlNode streetNode = responseNode.getChildElement(
				'street',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.street = (streetNode == null) ? null : streetNode.getText();
			nodesParsed.add(streetNode);
			//System.debug(this.street);
			DOM.XmlNode validFromNode = responseNode.getChildElement(
				'validFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validFrom = (validFromNode == null) ? null : Date.valueOf(validFromNode.getText());
			nodesParsed.add(validFromNode);
			//System.debug(this.validFrom);
			DOM.XmlNode validUntilNode = responseNode.getChildElement(
				'validUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validUntil = (validUntilNode == null) ? null : Date.valueOf(validUntilNode.getText());
			nodesParsed.add(validUntilNode);
			//System.debug(this.validUntil);
			DOM.XmlNode technicalStatusNode = responseNode.getChildElement(
				'technicalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.technicalStatus = (technicalStatusNode == null)
				? null
				: Boolean.valueOf(technicalStatusNode.getText());
			nodesParsed.add(technicalStatusNode);
			//System.debug(this.technicalStatus);
			DOM.XmlNode addressMCSBGUIDNode = responseNode.getChildElement(
				'addressMCSBGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.addressMCSBGUID = (addressMCSBGUIDNode == null) ? null : addressMCSBGUIDNode.getText();
			nodesParsed.add(addressMCSBGUIDNode);
			//System.debug(this.addressMCSBGUID);
			DOM.XmlNode contactFlagNode = responseNode.getChildElement(
				'contactFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactFlag = (contactFlagNode == null) ? null : Long.valueOf(contactFlagNode.getText());
			nodesParsed.add(contactFlagNode);
			//System.debug(this.contactFlag);
			DOM.XmlNode contactIdNode = responseNode.getChildElement(
				'contactId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactId = (contactIdNode == null) ? null : Long.valueOf(contactIdNode.getText());
			nodesParsed.add(contactIdNode);
			//System.debug(this.contactId);
			DOM.XmlNode addressIDNode = responseNode.getChildElement(
				'addressID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.addressID = (addressIDNode == null) ? null : Long.valueOf(addressIDNode.getText());
			nodesParsed.add(addressIDNode);
			//System.debug(this.addressID);
			DOM.XmlNode addressGUIDNode = responseNode.getChildElement(
				'addressGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.addressGUID = (addressGUIDNode == null) ? null : addressGUIDNode.getText();
			nodesParsed.add(addressGUIDNode);
			//System.debug(this.addressGUID);
			DOM.XmlNode POBoxNode = responseNode.getChildElement(
				'POBox',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.POBox = (POBoxNode == null) ? null : POBoxNode.getText();
			nodesParsed.add(POBoxNode);
			//System.debug(this.POBox);
			DOM.XmlNode addNameInfoNode = responseNode.getChildElement(
				'addNameInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.addNameInfo = (addNameInfoNode == null) ? null : addNameInfoNode.getText();
			nodesParsed.add(addNameInfoNode);
			//System.debug(this.addNameInfo);
			DOM.XmlNode addAddressInfoNode = responseNode.getChildElement(
				'addAddressInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.addAddressInfo = (addAddressInfoNode == null) ? null : addAddressInfoNode.getText();
			nodesParsed.add(addAddressInfoNode);
			//System.debug(this.addAddressInfo);
			DOM.XmlNode poznamkaNoteNode = responseNode.getChildElement(
				'poznamkaNote',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.poznamkaNote = (poznamkaNoteNode == null) ? null : poznamkaNoteNode.getText();
			nodesParsed.add(poznamkaNoteNode);
			//System.debug(this.poznamkaNote);
			DOM.XmlNode TINTaxNumberNode = responseNode.getChildElement(
				'TINTaxNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.TINTaxNumber = (TINTaxNumberNode == null) ? null : TINTaxNumberNode.getText();
			nodesParsed.add(TINTaxNumberNode);
			//System.debug(this.TINTaxNumber);
			DOM.XmlNode TINNoteNode = responseNode.getChildElement(
				'TINNote',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.TINNote = (TINNoteNode == null) ? null : TINNoteNode.getText();
			nodesParsed.add(TINNoteNode);
			//System.debug(this.TINNote);
			DOM.XmlNode sourceAppNode = responseNode.getChildElement(
				'sourceApp',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.sourceApp = (sourceAppNode == null) ? null : sourceAppNode.getText();
			nodesParsed.add(sourceAppNode);
			//System.debug(this.sourceApp);
			DOM.XmlNode dataSourceNode = responseNode.getChildElement(
				'dataSource',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dataSource = (dataSourceNode == null) ? null : Long.valueOf(dataSourceNode.getText());
			nodesParsed.add(dataSourceNode);
			//System.debug(this.dataSource);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode dateLastUpdateNode = outerNode.addChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateLastUpdateNode.addTextNode((this.dateLastUpdate == null) ? '' : String.valueOf(this.dateLastUpdate));
			Dom.XmlNode subTypeNode = outerNode.addChildElement(
				'subType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			subTypeNode.addTextNode((this.subType == null) ? '' : String.valueOf(this.subType));
			Dom.XmlNode contactTypeNode = outerNode.addChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactTypeNode.addTextNode((this.contactType == null) ? '' : String.valueOf(this.contactType));
			Dom.XmlNode cityNode = outerNode.addChildElement(
				'city',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cityNode.addTextNode((this.city == null) ? '' : this.city);
			Dom.XmlNode countryNode = outerNode.addChildElement(
				'country',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			countryNode.addTextNode((this.country == null) ? '' : String.valueOf(this.country));
			Dom.XmlNode streetNumberNode = outerNode.addChildElement(
				'streetNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			streetNumberNode.addTextNode((this.streetNumber == null) ? '' : this.streetNumber);
			Dom.XmlNode zipCodeNode = outerNode.addChildElement(
				'zipCode',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			zipCodeNode.addTextNode((this.zipCode == null) ? '' : this.zipCode);
			Dom.XmlNode streetNode = outerNode.addChildElement(
				'street',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			streetNode.addTextNode((this.street == null) ? '' : this.street);
			Dom.XmlNode validFromNode = outerNode.addChildElement(
				'validFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validFromNode.addTextNode((this.validFrom == null) ? '' : String.valueOf(this.validFrom));
			Dom.XmlNode validUntilNode = outerNode.addChildElement(
				'validUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validUntilNode.addTextNode((this.validUntil == null) ? '' : String.valueOf(this.validUntil));
			Dom.XmlNode technicalStatusNode = outerNode.addChildElement(
				'technicalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			technicalStatusNode.addTextNode((this.technicalStatus == null) ? '' : String.valueOf(this.technicalStatus));
			Dom.XmlNode addressMCSBGUIDNode = outerNode.addChildElement(
				'addressMCSBGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			addressMCSBGUIDNode.addTextNode((this.addressMCSBGUID == null) ? '' : this.addressMCSBGUID);
			Dom.XmlNode contactFlagNode = outerNode.addChildElement(
				'contactFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactFlagNode.addTextNode((this.contactFlag == null) ? '' : String.valueOf(this.contactFlag));
			Dom.XmlNode contactIdNode = outerNode.addChildElement(
				'contactId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactIdNode.addTextNode((this.contactId == null) ? '' : String.valueOf(this.contactId));
			Dom.XmlNode addressIDNode = outerNode.addChildElement(
				'addressID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			addressIDNode.addTextNode((this.addressID == null) ? '' : String.valueOf(this.addressID));
			Dom.XmlNode addressGUIDNode = outerNode.addChildElement(
				'addressGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			addressGUIDNode.addTextNode((this.addressGUID == null) ? '' : this.addressGUID);
			Dom.XmlNode POBoxNode = outerNode.addChildElement(
				'POBox',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			POBoxNode.addTextNode((this.POBox == null) ? '' : this.POBox);
			Dom.XmlNode addNameInfoNode = outerNode.addChildElement(
				'addNameInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			addNameInfoNode.addTextNode((this.addNameInfo == null) ? '' : this.addNameInfo);
			Dom.XmlNode addAddressInfoNode = outerNode.addChildElement(
				'addAddressInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			addAddressInfoNode.addTextNode((this.addAddressInfo == null) ? '' : this.addAddressInfo);
			Dom.XmlNode poznamkaNoteNode = outerNode.addChildElement(
				'poznamkaNote',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			poznamkaNoteNode.addTextNode((this.poznamkaNote == null) ? '' : this.poznamkaNote);
			Dom.XmlNode TINTaxNumberNode = outerNode.addChildElement(
				'TINTaxNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			TINTaxNumberNode.addTextNode((this.TINTaxNumber == null) ? '' : this.TINTaxNumber);
			Dom.XmlNode TINNoteNode = outerNode.addChildElement(
				'TINNote',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			TINNoteNode.addTextNode((this.TINNote == null) ? '' : this.TINNote);
			Dom.XmlNode sourceAppNode = outerNode.addChildElement(
				'sourceApp',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			sourceAppNode.addTextNode((this.sourceApp == null) ? '' : this.sourceApp);
			Dom.XmlNode dataSourceNode = outerNode.addChildElement(
				'dataSource',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dataSourceNode.addTextNode((this.dataSource == null) ? '' : String.valueOf(this.dataSource));
		}
	}

	public class ClientDetailType {
		public Long personNumber;
		public String firstName;
		public String lastName;
		public String prefixTitle;
		public String suffixTitle;
		public String personalIdentityNumber;
		public String salutation;
		// Restriction enumeration:
		public Date birthDate;
		public String birthPlace;
		public String birthState;
		public Long maritalStatus;
		public Long gender;
		public PersonManagementSOAPServiceTypes.ForeignerIDType foreignerIdentityDocument;
		public Long profession;
		public PersonManagementSOAPServiceTypes.IdentityCardType identityCard;
		public String citizenship;
		public String dataShareLevel;
		public String personType;
		// Restriction enumeration:
		public Date deathDate;
		public PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityData;
		public Boolean isPoliticallyExposed;
		public Boolean isCrResident;
		public Long incomeSource;
		public Long industry;
		public Boolean cryptoCurrFlag;
		public String cryptoCurrList;
		public String cryptoCurrPlatform;
		public String employerIco;
		public Long monthlyIncomeRange;
		public String documentUid;
		public Long identificationType;
		// Restriction enumeration:
		public Date personalDataUpdateDate;
		public Boolean signedElectronically;
		public String agentCPU;
		private transient String[] personNumber_type_info = new List<String>{
			'personNumber',
			s_ns0,
			'PersonNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] firstName_type_info = new List<String>{
			'firstName',
			s_ns0,
			'FirstNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] lastName_type_info = new List<String>{
			'lastName',
			s_ns0,
			'LastNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] prefixTitle_type_info = new List<String>{
			'prefixTitle',
			s_ns0,
			'NamePrefixType',
			'0',
			'1',
			'false'
		};
		private transient String[] suffixTitle_type_info = new List<String>{
			'suffixTitle',
			s_ns0,
			'NameSuffixType',
			'0',
			'1',
			'false'
		};
		private transient String[] personalIdentityNumber_type_info = new List<String>{
			'personalIdentityNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] salutation_type_info = new List<String>{
			'salutation',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] birthDate_type_info = new List<String>{
			'birthDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] birthPlace_type_info = new List<String>{
			'birthPlace',
			s_ns0,
			'CityNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] birthState_type_info = new List<String>{
			'birthState',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] maritalStatus_type_info = new List<String>{
			'maritalStatus',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] gender_type_info = new List<String>{
			'gender',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] foreignerIdentityDocument_type_info = new List<String>{
			'foreignerIdentityDocument',
			s_ns0,
			'ForeignerIDType',
			'0',
			'1',
			'false'
		};
		private transient String[] profession_type_info = new List<String>{
			'profession',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] identityCard_type_info = new List<String>{
			'identityCard',
			s_ns0,
			'IdentityCardType',
			'0',
			'1',
			'false'
		};
		private transient String[] citizenship_type_info = new List<String>{
			'citizenship',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] dataShareLevel_type_info = new List<String>{
			'dataShareLevel',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personType_type_info = new List<String>{
			'personType',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] deathDate_type_info = new List<String>{
			'deathDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] legalEntityData_type_info = new List<String>{
			'legalEntityData',
			s_ns0,
			'LegalEntityDataType',
			'0',
			'1',
			'false'
		};
		private transient String[] isPoliticallyExposed_type_info = new List<String>{
			'isPoliticallyExposed',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] isCrResident_type_info = new List<String>{
			'isCrResident',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] incomeSource_type_info = new List<String>{
			'incomeSource',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] industry_type_info = new List<String>{
			'industry',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrFlag_type_info = new List<String>{
			'cryptoCurrFlag',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrList_type_info = new List<String>{
			'cryptoCurrList',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrPlatform_type_info = new List<String>{
			'cryptoCurrPlatform',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] employerIco_type_info = new List<String>{
			'employerIco',
			s_ns0,
			'ICOType',
			'0',
			'1',
			'false'
		};
		private transient String[] monthlyIncomeRange_type_info = new List<String>{
			'monthlyIncomeRange',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] documentUid_type_info = new List<String>{
			'documentUid',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] identificationType_type_info = new List<String>{
			'identificationType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personalDataUpdateDate_type_info = new List<String>{
			'personalDataUpdateDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] signedElectronically_type_info = new List<String>{
			'signedElectronically',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] agentCPU_type_info = new List<String>{
			'agentCPU',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'personNumber',
			'firstName',
			'lastName',
			'prefixTitle',
			'suffixTitle',
			'personalIdentityNumber',
			'salutation',
			'birthDate',
			'birthPlace',
			'birthState',
			'maritalStatus',
			'gender',
			'foreignerIdentityDocument',
			'profession',
			'identityCard',
			'citizenship',
			'dataShareLevel',
			'personType',
			'deathDate',
			'legalEntityData',
			'isPoliticallyExposed',
			'isCrResident',
			'incomeSource',
			'industry',
			'cryptoCurrFlag',
			'cryptoCurrList',
			'cryptoCurrPlatform',
			'employerIco',
			'monthlyIncomeRange',
			'documentUid',
			'identificationType',
			'personalDataUpdateDate',
			'signedElectronically',
			'agentCPU'
		};
		public ClientDetailType() {
		}
		public ClientDetailType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode personNumberNode = responseNode.getChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personNumber = (personNumberNode == null) ? null : Long.valueOf(personNumberNode.getText());
			nodesParsed.add(personNumberNode);
			//System.debug(this.personNumber);
			DOM.XmlNode firstNameNode = responseNode.getChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.firstName = (firstNameNode == null) ? null : firstNameNode.getText();
			nodesParsed.add(firstNameNode);
			//System.debug(this.firstName);
			DOM.XmlNode lastNameNode = responseNode.getChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.lastName = (lastNameNode == null) ? null : lastNameNode.getText();
			nodesParsed.add(lastNameNode);
			//System.debug(this.lastName);
			DOM.XmlNode prefixTitleNode = responseNode.getChildElement(
				'prefixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.prefixTitle = (prefixTitleNode == null) ? null : prefixTitleNode.getText();
			nodesParsed.add(prefixTitleNode);
			//System.debug(this.prefixTitle);
			DOM.XmlNode suffixTitleNode = responseNode.getChildElement(
				'suffixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.suffixTitle = (suffixTitleNode == null) ? null : suffixTitleNode.getText();
			nodesParsed.add(suffixTitleNode);
			//System.debug(this.suffixTitle);
			DOM.XmlNode personalIdentityNumberNode = responseNode.getChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalIdentityNumber = (personalIdentityNumberNode == null)
				? null
				: personalIdentityNumberNode.getText();
			nodesParsed.add(personalIdentityNumberNode);
			//System.debug(this.personalIdentityNumber);
			DOM.XmlNode salutationNode = responseNode.getChildElement(
				'salutation',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.salutation = (salutationNode == null) ? null : salutationNode.getText();
			nodesParsed.add(salutationNode);
			//System.debug(this.salutation);
			DOM.XmlNode birthDateNode = responseNode.getChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthDate = (birthDateNode == null) ? null : Date.valueOf(birthDateNode.getText());
			nodesParsed.add(birthDateNode);
			//System.debug(this.birthDate);
			DOM.XmlNode birthPlaceNode = responseNode.getChildElement(
				'birthPlace',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthPlace = (birthPlaceNode == null) ? null : birthPlaceNode.getText();
			nodesParsed.add(birthPlaceNode);
			//System.debug(this.birthPlace);
			DOM.XmlNode birthStateNode = responseNode.getChildElement(
				'birthState',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthState = (birthStateNode == null) ? null : birthStateNode.getText();
			nodesParsed.add(birthStateNode);
			//System.debug(this.birthState);
			DOM.XmlNode maritalStatusNode = responseNode.getChildElement(
				'maritalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.maritalStatus = (maritalStatusNode == null) ? null : Long.valueOf(maritalStatusNode.getText());
			nodesParsed.add(maritalStatusNode);
			//System.debug(this.maritalStatus);
			DOM.XmlNode genderNode = responseNode.getChildElement(
				'gender',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.gender = (genderNode == null) ? null : Long.valueOf(genderNode.getText());
			nodesParsed.add(genderNode);
			//System.debug(this.gender);
			DOM.XmlNode foreignerIdentityDocumentNode = responseNode.getChildElement(
				'foreignerIdentityDocument',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (foreignerIdentityDocumentNode == null) {
				this.foreignerIdentityDocument = null;
			} else {
				PersonManagementSOAPServiceTypes.ForeignerIDType foreignerIdentityDocumentObj = new PersonManagementSOAPServiceTypes.ForeignerIDType(
					foreignerIdentityDocumentNode
				);
				nodesParsed.add(foreignerIdentityDocumentNode);
				this.foreignerIdentityDocument = foreignerIdentityDocumentObj;
			}
			//System.debug(this.foreignerIdentityDocument);
			DOM.XmlNode professionNode = responseNode.getChildElement(
				'profession',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.profession = (professionNode == null) ? null : Long.valueOf(professionNode.getText());
			nodesParsed.add(professionNode);
			//System.debug(this.profession);
			DOM.XmlNode identityCardNode = responseNode.getChildElement(
				'identityCard',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (identityCardNode == null) {
				this.identityCard = null;
			} else {
				PersonManagementSOAPServiceTypes.IdentityCardType identityCardObj = new PersonManagementSOAPServiceTypes.IdentityCardType(
					identityCardNode
				);
				nodesParsed.add(identityCardNode);
				this.identityCard = identityCardObj;
			}
			//System.debug(this.identityCard);
			DOM.XmlNode citizenshipNode = responseNode.getChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.citizenship = (citizenshipNode == null) ? null : citizenshipNode.getText();
			nodesParsed.add(citizenshipNode);
			//System.debug(this.citizenship);
			DOM.XmlNode dataShareLevelNode = responseNode.getChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dataShareLevel = (dataShareLevelNode == null) ? null : dataShareLevelNode.getText();
			nodesParsed.add(dataShareLevelNode);
			//System.debug(this.dataShareLevel);
			DOM.XmlNode personTypeNode = responseNode.getChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personType = (personTypeNode == null) ? null : personTypeNode.getText();
			nodesParsed.add(personTypeNode);
			//System.debug(this.personType);
			DOM.XmlNode deathDateNode = responseNode.getChildElement(
				'deathDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.deathDate = (deathDateNode == null) ? null : Date.valueOf(deathDateNode.getText());
			nodesParsed.add(deathDateNode);
			//System.debug(this.deathDate);
			DOM.XmlNode legalEntityDataNode = responseNode.getChildElement(
				'legalEntityData',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (legalEntityDataNode == null) {
				this.legalEntityData = null;
			} else {
				PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityDataObj = new PersonManagementSOAPServiceTypes.LegalEntityDataType(
					legalEntityDataNode
				);
				nodesParsed.add(legalEntityDataNode);
				this.legalEntityData = legalEntityDataObj;
			}
			//System.debug(this.legalEntityData);
			DOM.XmlNode isPoliticallyExposedNode = responseNode.getChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.isPoliticallyExposed = (isPoliticallyExposedNode == null)
				? null
				: Boolean.valueOf(isPoliticallyExposedNode.getText());
			nodesParsed.add(isPoliticallyExposedNode);
			//System.debug(this.isPoliticallyExposed);
			DOM.XmlNode isCrResidentNode = responseNode.getChildElement(
				'isCrResident',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.isCrResident = (isCrResidentNode == null) ? null : Boolean.valueOf(isCrResidentNode.getText());
			nodesParsed.add(isCrResidentNode);
			//System.debug(this.isCrResident);
			DOM.XmlNode incomeSourceNode = responseNode.getChildElement(
				'incomeSource',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.incomeSource = (incomeSourceNode == null) ? null : Long.valueOf(incomeSourceNode.getText());
			nodesParsed.add(incomeSourceNode);
			//System.debug(this.incomeSource);
			DOM.XmlNode industryNode = responseNode.getChildElement(
				'industry',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.industry = (industryNode == null) ? null : Long.valueOf(industryNode.getText());
			nodesParsed.add(industryNode);
			//System.debug(this.industry);
			DOM.XmlNode cryptoCurrFlagNode = responseNode.getChildElement(
				'cryptoCurrFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrFlag = (cryptoCurrFlagNode == null) ? null : Boolean.valueOf(cryptoCurrFlagNode.getText());
			nodesParsed.add(cryptoCurrFlagNode);
			//System.debug(this.cryptoCurrFlag);
			DOM.XmlNode cryptoCurrListNode = responseNode.getChildElement(
				'cryptoCurrList',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrList = (cryptoCurrListNode == null) ? null : cryptoCurrListNode.getText();
			nodesParsed.add(cryptoCurrListNode);
			//System.debug(this.cryptoCurrList);
			DOM.XmlNode cryptoCurrPlatformNode = responseNode.getChildElement(
				'cryptoCurrPlatform',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrPlatform = (cryptoCurrPlatformNode == null) ? null : cryptoCurrPlatformNode.getText();
			nodesParsed.add(cryptoCurrPlatformNode);
			//System.debug(this.cryptoCurrPlatform);
			DOM.XmlNode employerIcoNode = responseNode.getChildElement(
				'employerIco',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.employerIco = (employerIcoNode == null) ? null : employerIcoNode.getText();
			nodesParsed.add(employerIcoNode);
			//System.debug(this.employerIco);
			DOM.XmlNode monthlyIncomeRangeNode = responseNode.getChildElement(
				'monthlyIncomeRange',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.monthlyIncomeRange = (monthlyIncomeRangeNode == null)
				? null
				: Long.valueOf(monthlyIncomeRangeNode.getText());
			nodesParsed.add(monthlyIncomeRangeNode);
			//System.debug(this.monthlyIncomeRange);
			DOM.XmlNode documentUidNode = responseNode.getChildElement(
				'documentUid',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.documentUid = (documentUidNode == null) ? null : documentUidNode.getText();
			nodesParsed.add(documentUidNode);
			//System.debug(this.documentUid);
			DOM.XmlNode identificationTypeNode = responseNode.getChildElement(
				'identificationType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.identificationType = (identificationTypeNode == null)
				? null
				: Long.valueOf(identificationTypeNode.getText());
			nodesParsed.add(identificationTypeNode);
			//System.debug(this.identificationType);
			DOM.XmlNode personalDataUpdateDateNode = responseNode.getChildElement(
				'personalDataUpdateDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalDataUpdateDate = (personalDataUpdateDateNode == null)
				? null
				: Date.valueOf(personalDataUpdateDateNode.getText());
			nodesParsed.add(personalDataUpdateDateNode);
			//System.debug(this.personalDataUpdateDate);
			DOM.XmlNode signedElectronicallyNode = responseNode.getChildElement(
				'signedElectronically',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.signedElectronically = (signedElectronicallyNode == null)
				? null
				: Boolean.valueOf(signedElectronicallyNode.getText());
			nodesParsed.add(signedElectronicallyNode);
			//System.debug(this.signedElectronically);
			DOM.XmlNode agentCPUNode = responseNode.getChildElement(
				'agentCPU',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.agentCPU = (agentCPUNode == null) ? null : agentCPUNode.getText();
			nodesParsed.add(agentCPUNode);
			//System.debug(this.agentCPU);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode personNumberNode = outerNode.addChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personNumber != null) {
				personNumberNode.addTextNode(String.valueOf(this.personNumber));
			}
			Dom.XmlNode firstNameNode = outerNode.addChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			firstNameNode.addTextNode((this.firstName == null) ? '' : this.firstName);
			Dom.XmlNode lastNameNode = outerNode.addChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			lastNameNode.addTextNode((this.lastName == null) ? '' : this.lastName);
			Dom.XmlNode prefixTitleNode = outerNode.addChildElement(
				'prefixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			prefixTitleNode.addTextNode((this.prefixTitle == null) ? '' : this.prefixTitle);
			Dom.XmlNode suffixTitleNode = outerNode.addChildElement(
				'suffixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			suffixTitleNode.addTextNode((this.suffixTitle == null) ? '' : this.suffixTitle);
			Dom.XmlNode personalIdentityNumberNode = outerNode.addChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personalIdentityNumberNode.addTextNode(
				(this.personalIdentityNumber == null) ? '' : this.personalIdentityNumber
			);
			Dom.XmlNode salutationNode = outerNode.addChildElement(
				'salutation',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			salutationNode.addTextNode((this.salutation == null) ? '' : this.salutation);
			Dom.XmlNode birthDateNode = outerNode.addChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			birthDateNode.addTextNode((this.birthDate == null) ? '' : String.valueOf(this.birthDate));
			Dom.XmlNode birthPlaceNode = outerNode.addChildElement(
				'birthPlace',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			birthPlaceNode.addTextNode((this.birthPlace == null) ? '' : this.birthPlace);
			Dom.XmlNode birthStateNode = outerNode.addChildElement(
				'birthState',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			birthStateNode.addTextNode((this.birthState == null) ? '' : this.birthState);
			Dom.XmlNode maritalStatusNode = outerNode.addChildElement(
				'maritalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			maritalStatusNode.addTextNode((this.maritalStatus == null) ? '' : String.valueOf(this.maritalStatus));
			Dom.XmlNode genderNode = outerNode.addChildElement(
				'gender',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			genderNode.addTextNode((this.gender == null) ? '' : String.valueOf(this.gender));

			PersonManagementSOAPServiceTypes.ForeignerIDType foreignerIdentityDocumentObj = this.foreignerIdentityDocument;
			Dom.XmlNode foreignerIdentityDocumentNode = outerNode.addChildElement(
				'foreignerIdentityDocument',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (foreignerIdentityDocumentObj != null) {
				foreignerIdentityDocumentObj.populateXmlNode(foreignerIdentityDocumentNode);
			}
			Dom.XmlNode professionNode = outerNode.addChildElement(
				'profession',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			professionNode.addTextNode((this.profession == null) ? '' : String.valueOf(this.profession));

			PersonManagementSOAPServiceTypes.IdentityCardType identityCardObj = this.identityCard;
			Dom.XmlNode identityCardNode = outerNode.addChildElement(
				'identityCard',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (identityCardObj != null) {
				identityCardObj.populateXmlNode(identityCardNode);
			}
			Dom.XmlNode citizenshipNode = outerNode.addChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			citizenshipNode.addTextNode((this.citizenship == null) ? '' : this.citizenship);
			Dom.XmlNode dataShareLevelNode = outerNode.addChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dataShareLevelNode.addTextNode((this.dataShareLevel == null) ? '' : this.dataShareLevel);
			Dom.XmlNode personTypeNode = outerNode.addChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personTypeNode.addTextNode((this.personType == null) ? '' : this.personType);
			Dom.XmlNode deathDateNode = outerNode.addChildElement(
				'deathDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			deathDateNode.addTextNode((this.deathDate == null) ? '' : String.valueOf(this.deathDate));

			PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityDataObj = this.legalEntityData;
			Dom.XmlNode legalEntityDataNode = outerNode.addChildElement(
				'legalEntityData',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (legalEntityDataObj != null) {
				legalEntityDataObj.populateXmlNode(legalEntityDataNode);
			}
			Dom.XmlNode isPoliticallyExposedNode = outerNode.addChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			isPoliticallyExposedNode.addTextNode(
				(this.isPoliticallyExposed == null) ? '' : String.valueOf(this.isPoliticallyExposed)
			);
			Dom.XmlNode isCrResidentNode = outerNode.addChildElement(
				'isCrResident',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			isCrResidentNode.addTextNode((this.isCrResident == null) ? '' : String.valueOf(this.isCrResident));
			Dom.XmlNode incomeSourceNode = outerNode.addChildElement(
				'incomeSource',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			incomeSourceNode.addTextNode((this.incomeSource == null) ? '' : String.valueOf(this.incomeSource));
			Dom.XmlNode industryNode = outerNode.addChildElement(
				'industry',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			industryNode.addTextNode((this.industry == null) ? '' : String.valueOf(this.industry));
			Dom.XmlNode cryptoCurrFlagNode = outerNode.addChildElement(
				'cryptoCurrFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrFlagNode.addTextNode((this.cryptoCurrFlag == null) ? '' : String.valueOf(this.cryptoCurrFlag));
			Dom.XmlNode cryptoCurrListNode = outerNode.addChildElement(
				'cryptoCurrList',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrListNode.addTextNode((this.cryptoCurrList == null) ? '' : this.cryptoCurrList);
			Dom.XmlNode cryptoCurrPlatformNode = outerNode.addChildElement(
				'cryptoCurrPlatform',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrPlatformNode.addTextNode((this.cryptoCurrPlatform == null) ? '' : this.cryptoCurrPlatform);
			Dom.XmlNode employerIcoNode = outerNode.addChildElement(
				'employerIco',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			employerIcoNode.addTextNode((this.employerIco == null) ? '' : this.employerIco);
			Dom.XmlNode monthlyIncomeRangeNode = outerNode.addChildElement(
				'monthlyIncomeRange',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			monthlyIncomeRangeNode.addTextNode(
				(this.monthlyIncomeRange == null) ? '' : String.valueOf(this.monthlyIncomeRange)
			);
			Dom.XmlNode documentUidNode = outerNode.addChildElement(
				'documentUid',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			documentUidNode.addTextNode((this.documentUid == null) ? '' : this.documentUid);
			Dom.XmlNode identificationTypeNode = outerNode.addChildElement(
				'identificationType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			identificationTypeNode.addTextNode(
				(this.identificationType == null) ? '' : String.valueOf(this.identificationType)
			);
			Dom.XmlNode personalDataUpdateDateNode = outerNode.addChildElement(
				'personalDataUpdateDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personalDataUpdateDateNode.addTextNode(
				(this.personalDataUpdateDate == null) ? '' : String.valueOf(this.personalDataUpdateDate)
			);
			Dom.XmlNode signedElectronicallyNode = outerNode.addChildElement(
				'signedElectronically',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			signedElectronicallyNode.addTextNode(
				(this.signedElectronically == null) ? '' : String.valueOf(this.signedElectronically)
			);
			Dom.XmlNode agentCPUNode = outerNode.addChildElement(
				'agentCPU',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			agentCPUNode.addTextNode((this.agentCPU == null) ? '' : this.agentCPU);
		}
	}

	public class ClientDetailValidateType {
		public Long personNumber;
		public String firstName;
		public String lastName;
		public String prefixTitle;
		public String suffixTitle;
		public String personalIdentityNumber;
		public String salutation;
		// Restriction enumeration:
		public Date birthDate;
		public String birthPlace;
		public String birthState;
		public Long maritalStatus;
		public Long gender;
		public PersonManagementSOAPServiceTypes.ForeignerIDType foreignerIdentityDocument;
		public Long profession;
		public PersonManagementSOAPServiceTypes.IdentityCardType identityCard;
		public String citizenship;
		public String dataShareLevel;
		public String personType;
		// Restriction enumeration:
		public Date deathDate;
		public PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityData;
		public Boolean isPoliticallyExposed;
		public Boolean isCrResident;
		public Long incomeSource;
		public Long industry;
		public Boolean cryptoCurrFlag;
		public String cryptoCurrList;
		public String cryptoCurrPlatform;
		public String employerIco;
		public Long monthlyIncomeRange;
		public String documentUid;
		public Long identificationType;
		// Restriction enumeration:
		public Date personalDataUpdateDate;
		public Boolean signedElectronically;
		public String agentCPU;
		private transient String[] personNumber_type_info = new List<String>{
			'personNumber',
			s_ns0,
			'PersonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] firstName_type_info = new List<String>{
			'firstName',
			s_ns0,
			'FirstNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] lastName_type_info = new List<String>{
			'lastName',
			s_ns0,
			'LastNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] prefixTitle_type_info = new List<String>{
			'prefixTitle',
			s_ns0,
			'NamePrefixType',
			'0',
			'1',
			'false'
		};
		private transient String[] suffixTitle_type_info = new List<String>{
			'suffixTitle',
			s_ns0,
			'NameSuffixType',
			'0',
			'1',
			'false'
		};
		private transient String[] personalIdentityNumber_type_info = new List<String>{
			'personalIdentityNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] salutation_type_info = new List<String>{
			'salutation',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] birthDate_type_info = new List<String>{
			'birthDate',
			s_ns0,
			'CommonDateType',
			'1',
			'1',
			'false'
		};
		private transient String[] birthPlace_type_info = new List<String>{
			'birthPlace',
			s_ns0,
			'CityNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] birthState_type_info = new List<String>{
			'birthState',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] maritalStatus_type_info = new List<String>{
			'maritalStatus',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] gender_type_info = new List<String>{
			'gender',
			s_ns0,
			'CodeListItemIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] foreignerIdentityDocument_type_info = new List<String>{
			'foreignerIdentityDocument',
			s_ns0,
			'ForeignerIDType',
			'0',
			'1',
			'false'
		};
		private transient String[] profession_type_info = new List<String>{
			'profession',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] identityCard_type_info = new List<String>{
			'identityCard',
			s_ns0,
			'IdentityCardType',
			'0',
			'1',
			'false'
		};
		private transient String[] citizenship_type_info = new List<String>{
			'citizenship',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] dataShareLevel_type_info = new List<String>{
			'dataShareLevel',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personType_type_info = new List<String>{
			'personType',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] deathDate_type_info = new List<String>{
			'deathDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] legalEntityData_type_info = new List<String>{
			'legalEntityData',
			s_ns0,
			'LegalEntityDataType',
			'0',
			'1',
			'false'
		};
		private transient String[] isPoliticallyExposed_type_info = new List<String>{
			'isPoliticallyExposed',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] isCrResident_type_info = new List<String>{
			'isCrResident',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] incomeSource_type_info = new List<String>{
			'incomeSource',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] industry_type_info = new List<String>{
			'industry',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrFlag_type_info = new List<String>{
			'cryptoCurrFlag',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrList_type_info = new List<String>{
			'cryptoCurrList',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrPlatform_type_info = new List<String>{
			'cryptoCurrPlatform',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] employerIco_type_info = new List<String>{
			'employerIco',
			s_ns0,
			'ICOType',
			'0',
			'1',
			'false'
		};
		private transient String[] monthlyIncomeRange_type_info = new List<String>{
			'monthlyIncomeRange',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] documentUid_type_info = new List<String>{
			'documentUid',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] identificationType_type_info = new List<String>{
			'identificationType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personalDataUpdateDate_type_info = new List<String>{
			'personalDataUpdateDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] signedElectronically_type_info = new List<String>{
			'signedElectronically',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] agentCPU_type_info = new List<String>{
			'agentCPU',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'personNumber',
			'firstName',
			'lastName',
			'prefixTitle',
			'suffixTitle',
			'personalIdentityNumber',
			'salutation',
			'birthDate',
			'birthPlace',
			'birthState',
			'maritalStatus',
			'gender',
			'foreignerIdentityDocument',
			'profession',
			'identityCard',
			'citizenship',
			'dataShareLevel',
			'personType',
			'deathDate',
			'legalEntityData',
			'isPoliticallyExposed',
			'isCrResident',
			'incomeSource',
			'industry',
			'cryptoCurrFlag',
			'cryptoCurrList',
			'cryptoCurrPlatform',
			'employerIco',
			'monthlyIncomeRange',
			'documentUid',
			'identificationType',
			'personalDataUpdateDate',
			'signedElectronically',
			'agentCPU'
		};
		public ClientDetailValidateType() {
		}
		public ClientDetailValidateType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode personNumberNode = responseNode.getChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personNumber = (personNumberNode == null) ? null : Long.valueOf(personNumberNode.getText());
			nodesParsed.add(personNumberNode);
			//System.debug(this.personNumber);
			DOM.XmlNode firstNameNode = responseNode.getChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.firstName = (firstNameNode == null) ? null : firstNameNode.getText();
			nodesParsed.add(firstNameNode);
			//System.debug(this.firstName);
			DOM.XmlNode lastNameNode = responseNode.getChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.lastName = (lastNameNode == null) ? null : lastNameNode.getText();
			nodesParsed.add(lastNameNode);
			//System.debug(this.lastName);
			DOM.XmlNode prefixTitleNode = responseNode.getChildElement(
				'prefixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.prefixTitle = (prefixTitleNode == null) ? null : prefixTitleNode.getText();
			nodesParsed.add(prefixTitleNode);
			//System.debug(this.prefixTitle);
			DOM.XmlNode suffixTitleNode = responseNode.getChildElement(
				'suffixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.suffixTitle = (suffixTitleNode == null) ? null : suffixTitleNode.getText();
			nodesParsed.add(suffixTitleNode);
			//System.debug(this.suffixTitle);
			DOM.XmlNode personalIdentityNumberNode = responseNode.getChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalIdentityNumber = (personalIdentityNumberNode == null)
				? null
				: personalIdentityNumberNode.getText();
			nodesParsed.add(personalIdentityNumberNode);
			//System.debug(this.personalIdentityNumber);
			DOM.XmlNode salutationNode = responseNode.getChildElement(
				'salutation',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.salutation = (salutationNode == null) ? null : salutationNode.getText();
			nodesParsed.add(salutationNode);
			//System.debug(this.salutation);
			DOM.XmlNode birthDateNode = responseNode.getChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthDate = (birthDateNode == null) ? null : Date.valueOf(birthDateNode.getText());
			nodesParsed.add(birthDateNode);
			//System.debug(this.birthDate);
			DOM.XmlNode birthPlaceNode = responseNode.getChildElement(
				'birthPlace',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthPlace = (birthPlaceNode == null) ? null : birthPlaceNode.getText();
			nodesParsed.add(birthPlaceNode);
			//System.debug(this.birthPlace);
			DOM.XmlNode birthStateNode = responseNode.getChildElement(
				'birthState',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthState = (birthStateNode == null) ? null : birthStateNode.getText();
			nodesParsed.add(birthStateNode);
			//System.debug(this.birthState);
			DOM.XmlNode maritalStatusNode = responseNode.getChildElement(
				'maritalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.maritalStatus = (maritalStatusNode == null) ? null : Long.valueOf(maritalStatusNode.getText());
			nodesParsed.add(maritalStatusNode);
			//System.debug(this.maritalStatus);
			DOM.XmlNode genderNode = responseNode.getChildElement(
				'gender',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.gender = (genderNode == null) ? null : Long.valueOf(genderNode.getText());
			nodesParsed.add(genderNode);
			//System.debug(this.gender);
			DOM.XmlNode foreignerIdentityDocumentNode = responseNode.getChildElement(
				'foreignerIdentityDocument',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (foreignerIdentityDocumentNode == null) {
				this.foreignerIdentityDocument = null;
			} else {
				PersonManagementSOAPServiceTypes.ForeignerIDType foreignerIdentityDocumentObj = new PersonManagementSOAPServiceTypes.ForeignerIDType(
					foreignerIdentityDocumentNode
				);
				nodesParsed.add(foreignerIdentityDocumentNode);
				this.foreignerIdentityDocument = foreignerIdentityDocumentObj;
			}
			//System.debug(this.foreignerIdentityDocument);
			DOM.XmlNode professionNode = responseNode.getChildElement(
				'profession',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.profession = (professionNode == null) ? null : Long.valueOf(professionNode.getText());
			nodesParsed.add(professionNode);
			//System.debug(this.profession);
			DOM.XmlNode identityCardNode = responseNode.getChildElement(
				'identityCard',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (identityCardNode == null) {
				this.identityCard = null;
			} else {
				PersonManagementSOAPServiceTypes.IdentityCardType identityCardObj = new PersonManagementSOAPServiceTypes.IdentityCardType(
					identityCardNode
				);
				nodesParsed.add(identityCardNode);
				this.identityCard = identityCardObj;
			}
			//System.debug(this.identityCard);
			DOM.XmlNode citizenshipNode = responseNode.getChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.citizenship = (citizenshipNode == null) ? null : citizenshipNode.getText();
			nodesParsed.add(citizenshipNode);
			//System.debug(this.citizenship);
			DOM.XmlNode dataShareLevelNode = responseNode.getChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dataShareLevel = (dataShareLevelNode == null) ? null : dataShareLevelNode.getText();
			nodesParsed.add(dataShareLevelNode);
			//System.debug(this.dataShareLevel);
			DOM.XmlNode personTypeNode = responseNode.getChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personType = (personTypeNode == null) ? null : personTypeNode.getText();
			nodesParsed.add(personTypeNode);
			//System.debug(this.personType);
			DOM.XmlNode deathDateNode = responseNode.getChildElement(
				'deathDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.deathDate = (deathDateNode == null) ? null : Date.valueOf(deathDateNode.getText());
			nodesParsed.add(deathDateNode);
			//System.debug(this.deathDate);
			DOM.XmlNode legalEntityDataNode = responseNode.getChildElement(
				'legalEntityData',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (legalEntityDataNode == null) {
				this.legalEntityData = null;
			} else {
				PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityDataObj = new PersonManagementSOAPServiceTypes.LegalEntityDataType(
					legalEntityDataNode
				);
				nodesParsed.add(legalEntityDataNode);
				this.legalEntityData = legalEntityDataObj;
			}
			//System.debug(this.legalEntityData);
			DOM.XmlNode isPoliticallyExposedNode = responseNode.getChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.isPoliticallyExposed = (isPoliticallyExposedNode == null)
				? null
				: Boolean.valueOf(isPoliticallyExposedNode.getText());
			nodesParsed.add(isPoliticallyExposedNode);
			//System.debug(this.isPoliticallyExposed);
			DOM.XmlNode isCrResidentNode = responseNode.getChildElement(
				'isCrResident',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.isCrResident = (isCrResidentNode == null) ? null : Boolean.valueOf(isCrResidentNode.getText());
			nodesParsed.add(isCrResidentNode);
			//System.debug(this.isCrResident);
			DOM.XmlNode incomeSourceNode = responseNode.getChildElement(
				'incomeSource',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.incomeSource = (incomeSourceNode == null) ? null : Long.valueOf(incomeSourceNode.getText());
			nodesParsed.add(incomeSourceNode);
			//System.debug(this.incomeSource);
			DOM.XmlNode industryNode = responseNode.getChildElement(
				'industry',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.industry = (industryNode == null) ? null : Long.valueOf(industryNode.getText());
			nodesParsed.add(industryNode);
			//System.debug(this.industry);
			DOM.XmlNode cryptoCurrFlagNode = responseNode.getChildElement(
				'cryptoCurrFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrFlag = (cryptoCurrFlagNode == null) ? null : Boolean.valueOf(cryptoCurrFlagNode.getText());
			nodesParsed.add(cryptoCurrFlagNode);
			//System.debug(this.cryptoCurrFlag);
			DOM.XmlNode cryptoCurrListNode = responseNode.getChildElement(
				'cryptoCurrList',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrList = (cryptoCurrListNode == null) ? null : cryptoCurrListNode.getText();
			nodesParsed.add(cryptoCurrListNode);
			//System.debug(this.cryptoCurrList);
			DOM.XmlNode cryptoCurrPlatformNode = responseNode.getChildElement(
				'cryptoCurrPlatform',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrPlatform = (cryptoCurrPlatformNode == null) ? null : cryptoCurrPlatformNode.getText();
			nodesParsed.add(cryptoCurrPlatformNode);
			//System.debug(this.cryptoCurrPlatform);
			DOM.XmlNode employerIcoNode = responseNode.getChildElement(
				'employerIco',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.employerIco = (employerIcoNode == null) ? null : employerIcoNode.getText();
			nodesParsed.add(employerIcoNode);
			//System.debug(this.employerIco);
			DOM.XmlNode monthlyIncomeRangeNode = responseNode.getChildElement(
				'monthlyIncomeRange',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.monthlyIncomeRange = (monthlyIncomeRangeNode == null)
				? null
				: Long.valueOf(monthlyIncomeRangeNode.getText());
			nodesParsed.add(monthlyIncomeRangeNode);
			//System.debug(this.monthlyIncomeRange);
			DOM.XmlNode documentUidNode = responseNode.getChildElement(
				'documentUid',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.documentUid = (documentUidNode == null) ? null : documentUidNode.getText();
			nodesParsed.add(documentUidNode);
			//System.debug(this.documentUid);
			DOM.XmlNode identificationTypeNode = responseNode.getChildElement(
				'identificationType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.identificationType = (identificationTypeNode == null)
				? null
				: Long.valueOf(identificationTypeNode.getText());
			nodesParsed.add(identificationTypeNode);
			//System.debug(this.identificationType);
			DOM.XmlNode personalDataUpdateDateNode = responseNode.getChildElement(
				'personalDataUpdateDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalDataUpdateDate = (personalDataUpdateDateNode == null)
				? null
				: Date.valueOf(personalDataUpdateDateNode.getText());
			nodesParsed.add(personalDataUpdateDateNode);
			//System.debug(this.personalDataUpdateDate);
			DOM.XmlNode signedElectronicallyNode = responseNode.getChildElement(
				'signedElectronically',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.signedElectronically = (signedElectronicallyNode == null)
				? null
				: Boolean.valueOf(signedElectronicallyNode.getText());
			nodesParsed.add(signedElectronicallyNode);
			//System.debug(this.signedElectronically);
			DOM.XmlNode agentCPUNode = responseNode.getChildElement(
				'agentCPU',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.agentCPU = (agentCPUNode == null) ? null : agentCPUNode.getText();
			nodesParsed.add(agentCPUNode);
			//System.debug(this.agentCPU);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode personNumberNode = outerNode.addChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personNumberNode.addTextNode((this.personNumber == null) ? '' : String.valueOf(this.personNumber));
			Dom.XmlNode firstNameNode = outerNode.addChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.firstName != null) {
				firstNameNode.addTextNode(this.firstName);
			}
			Dom.XmlNode lastNameNode = outerNode.addChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.lastName != null) {
				lastNameNode.addTextNode(this.lastName);
			}
			Dom.XmlNode prefixTitleNode = outerNode.addChildElement(
				'prefixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			prefixTitleNode.addTextNode((this.prefixTitle == null) ? '' : this.prefixTitle);
			Dom.XmlNode suffixTitleNode = outerNode.addChildElement(
				'suffixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			suffixTitleNode.addTextNode((this.suffixTitle == null) ? '' : this.suffixTitle);
			Dom.XmlNode personalIdentityNumberNode = outerNode.addChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personalIdentityNumber != null) {
				personalIdentityNumberNode.addTextNode(this.personalIdentityNumber);
			}
			Dom.XmlNode salutationNode = outerNode.addChildElement(
				'salutation',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			salutationNode.addTextNode((this.salutation == null) ? '' : this.salutation);
			Dom.XmlNode birthDateNode = outerNode.addChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.birthDate != null) {
				birthDateNode.addTextNode(String.valueOf(this.birthDate));
			}
			Dom.XmlNode birthPlaceNode = outerNode.addChildElement(
				'birthPlace',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.birthPlace != null) {
				birthPlaceNode.addTextNode(this.birthPlace);
			}
			Dom.XmlNode birthStateNode = outerNode.addChildElement(
				'birthState',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.birthState != null) {
				birthStateNode.addTextNode(this.birthState);
			}
			Dom.XmlNode maritalStatusNode = outerNode.addChildElement(
				'maritalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			maritalStatusNode.addTextNode((this.maritalStatus == null) ? '' : String.valueOf(this.maritalStatus));
			Dom.XmlNode genderNode = outerNode.addChildElement(
				'gender',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.gender != null) {
				genderNode.addTextNode(String.valueOf(this.gender));
			}

			PersonManagementSOAPServiceTypes.ForeignerIDType foreignerIdentityDocumentObj = this.foreignerIdentityDocument;
			Dom.XmlNode foreignerIdentityDocumentNode = outerNode.addChildElement(
				'foreignerIdentityDocument',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (foreignerIdentityDocumentObj != null) {
				foreignerIdentityDocumentObj.populateXmlNode(foreignerIdentityDocumentNode);
			}
			Dom.XmlNode professionNode = outerNode.addChildElement(
				'profession',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			professionNode.addTextNode((this.profession == null) ? '' : String.valueOf(this.profession));

			PersonManagementSOAPServiceTypes.IdentityCardType identityCardObj = this.identityCard;
			Dom.XmlNode identityCardNode = outerNode.addChildElement(
				'identityCard',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (identityCardObj != null) {
				identityCardObj.populateXmlNode(identityCardNode);
			}
			Dom.XmlNode citizenshipNode = outerNode.addChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.citizenship != null) {
				citizenshipNode.addTextNode(this.citizenship);
			}
			Dom.XmlNode dataShareLevelNode = outerNode.addChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dataShareLevelNode.addTextNode((this.dataShareLevel == null) ? '' : this.dataShareLevel);
			Dom.XmlNode personTypeNode = outerNode.addChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personType != null) {
				personTypeNode.addTextNode(this.personType);
			}
			Dom.XmlNode deathDateNode = outerNode.addChildElement(
				'deathDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			deathDateNode.addTextNode((this.deathDate == null) ? '' : String.valueOf(this.deathDate));

			PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityDataObj = this.legalEntityData;
			Dom.XmlNode legalEntityDataNode = outerNode.addChildElement(
				'legalEntityData',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (legalEntityDataObj != null) {
				legalEntityDataObj.populateXmlNode(legalEntityDataNode);
			}
			Dom.XmlNode isPoliticallyExposedNode = outerNode.addChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			isPoliticallyExposedNode.addTextNode(
				(this.isPoliticallyExposed == null) ? '' : String.valueOf(this.isPoliticallyExposed)
			);
			Dom.XmlNode isCrResidentNode = outerNode.addChildElement(
				'isCrResident',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			isCrResidentNode.addTextNode((this.isCrResident == null) ? '' : String.valueOf(this.isCrResident));
			Dom.XmlNode incomeSourceNode = outerNode.addChildElement(
				'incomeSource',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			incomeSourceNode.addTextNode((this.incomeSource == null) ? '' : String.valueOf(this.incomeSource));
			Dom.XmlNode industryNode = outerNode.addChildElement(
				'industry',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			industryNode.addTextNode((this.industry == null) ? '' : String.valueOf(this.industry));
			Dom.XmlNode cryptoCurrFlagNode = outerNode.addChildElement(
				'cryptoCurrFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrFlagNode.addTextNode((this.cryptoCurrFlag == null) ? '' : String.valueOf(this.cryptoCurrFlag));
			Dom.XmlNode cryptoCurrListNode = outerNode.addChildElement(
				'cryptoCurrList',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrListNode.addTextNode((this.cryptoCurrList == null) ? '' : this.cryptoCurrList);
			Dom.XmlNode cryptoCurrPlatformNode = outerNode.addChildElement(
				'cryptoCurrPlatform',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrPlatformNode.addTextNode((this.cryptoCurrPlatform == null) ? '' : this.cryptoCurrPlatform);
			Dom.XmlNode employerIcoNode = outerNode.addChildElement(
				'employerIco',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			employerIcoNode.addTextNode((this.employerIco == null) ? '' : this.employerIco);
			Dom.XmlNode monthlyIncomeRangeNode = outerNode.addChildElement(
				'monthlyIncomeRange',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			monthlyIncomeRangeNode.addTextNode(
				(this.monthlyIncomeRange == null) ? '' : String.valueOf(this.monthlyIncomeRange)
			);
			Dom.XmlNode documentUidNode = outerNode.addChildElement(
				'documentUid',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			documentUidNode.addTextNode((this.documentUid == null) ? '' : this.documentUid);
			Dom.XmlNode identificationTypeNode = outerNode.addChildElement(
				'identificationType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			identificationTypeNode.addTextNode(
				(this.identificationType == null) ? '' : String.valueOf(this.identificationType)
			);
			Dom.XmlNode personalDataUpdateDateNode = outerNode.addChildElement(
				'personalDataUpdateDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personalDataUpdateDateNode.addTextNode(
				(this.personalDataUpdateDate == null) ? '' : String.valueOf(this.personalDataUpdateDate)
			);
			Dom.XmlNode signedElectronicallyNode = outerNode.addChildElement(
				'signedElectronically',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			signedElectronicallyNode.addTextNode(
				(this.signedElectronically == null) ? '' : String.valueOf(this.signedElectronically)
			);
			Dom.XmlNode agentCPUNode = outerNode.addChildElement(
				'agentCPU',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			agentCPUNode.addTextNode((this.agentCPU == null) ? '' : this.agentCPU);
		}
	}

	public class ClientInfoType {
		public Long clientGlobalId;
		public String firstName;
		public String lastName;
		public String personalIdentityNumber;
		public BasicTypesService.AccountNumberType SpSA;
		public BasicTypesService.AccountNumberType SpSC;
		public Long salutation;
		// Restriction enumeration:
		public Date birthDate;
		public String birthPlace;
		public String birthState;
		public Long maritalStatus;
		public Long gender;
		public PersonManagementSOAPServiceTypes.ForeignerIdentityType foreignerIdentityDocument;
		public Long profession;
		public PersonManagementSOAPServiceTypes.IdentityCardType identityCard;
		public String citizenship;
		public String dataShareLevel;
		public String personType;
		public PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityData;
		public Boolean isPoliticallyExposed;
		public String prefixTitle;
		public String suffixTitle;
		// Restriction enumeration:
		public Date deathDate;
		public Boolean isCrResident;
		public Long loyaltyProgram;
		public Long incomeSource;
		public Long industry;
		public Boolean cryptoCurrFlag;
		public String cryptoCurrList;
		public String cryptoCurrPlatform;
		public String employerIco;
		public Long monthlyIncomeRange;
		public String documentUid;
		public Long identificationType;
		// Restriction enumeration:
		public Date personalDataUpdateDate;
		public String maidenName;
		// Restriction enumeration:
		public Date dateOfCreation;
		public DateTime dateUpdated;
		public String VATNumber;
		public String registrationNrClientTrade;
		public String attorney;
		public Boolean flagSpecialRltnToBank;
		public Boolean signedElectronically;
		public String agentCPU;
		private transient String[] clientGlobalId_type_info = new List<String>{
			'clientGlobalId',
			s_ns0,
			'ClientGlobalIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] firstName_type_info = new List<String>{
			'firstName',
			s_ns0,
			'FirstNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] lastName_type_info = new List<String>{
			'lastName',
			s_ns0,
			'LastNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] personalIdentityNumber_type_info = new List<String>{
			'personalIdentityNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] SpSA_type_info = new List<String>{
			'SpSA',
			s_ns0,
			'AccountNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] SpSC_type_info = new List<String>{
			'SpSC',
			s_ns0,
			'AccountNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] salutation_type_info = new List<String>{
			'salutation',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] birthDate_type_info = new List<String>{
			'birthDate',
			s_ns0,
			'CommonDateType',
			'1',
			'1',
			'false'
		};
		private transient String[] birthPlace_type_info = new List<String>{
			'birthPlace',
			s_ns0,
			'CityNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] birthState_type_info = new List<String>{
			'birthState',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] maritalStatus_type_info = new List<String>{
			'maritalStatus',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] gender_type_info = new List<String>{
			'gender',
			s_ns0,
			'CodeListItemIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] foreignerIdentityDocument_type_info = new List<String>{
			'foreignerIdentityDocument',
			s_ns0,
			'ForeignerIdentityType',
			'0',
			'1',
			'false'
		};
		private transient String[] profession_type_info = new List<String>{
			'profession',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] identityCard_type_info = new List<String>{
			'identityCard',
			s_ns0,
			'IdentityCardType',
			'0',
			'1',
			'false'
		};
		private transient String[] citizenship_type_info = new List<String>{
			'citizenship',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] dataShareLevel_type_info = new List<String>{
			'dataShareLevel',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personType_type_info = new List<String>{
			'personType',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] legalEntityData_type_info = new List<String>{
			'legalEntityData',
			s_ns0,
			'LegalEntityDataType',
			'0',
			'1',
			'false'
		};
		private transient String[] isPoliticallyExposed_type_info = new List<String>{
			'isPoliticallyExposed',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] prefixTitle_type_info = new List<String>{
			'prefixTitle',
			s_ns0,
			'NamePrefixType',
			'0',
			'1',
			'false'
		};
		private transient String[] suffixTitle_type_info = new List<String>{
			'suffixTitle',
			s_ns0,
			'NameSuffixType',
			'0',
			'1',
			'false'
		};
		private transient String[] deathDate_type_info = new List<String>{
			'deathDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] isCrResident_type_info = new List<String>{
			'isCrResident',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] loyaltyProgram_type_info = new List<String>{
			'loyaltyProgram',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] incomeSource_type_info = new List<String>{
			'incomeSource',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] industry_type_info = new List<String>{
			'industry',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrFlag_type_info = new List<String>{
			'cryptoCurrFlag',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrList_type_info = new List<String>{
			'cryptoCurrList',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] cryptoCurrPlatform_type_info = new List<String>{
			'cryptoCurrPlatform',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] employerIco_type_info = new List<String>{
			'employerIco',
			s_ns0,
			'ICOType',
			'0',
			'1',
			'false'
		};
		private transient String[] monthlyIncomeRange_type_info = new List<String>{
			'monthlyIncomeRange',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] documentUid_type_info = new List<String>{
			'documentUid',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] identificationType_type_info = new List<String>{
			'identificationType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personalDataUpdateDate_type_info = new List<String>{
			'personalDataUpdateDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] maidenName_type_info = new List<String>{
			'maidenName',
			s_ns0,
			'LastNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] dateOfCreation_type_info = new List<String>{
			'dateOfCreation',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] dateUpdated_type_info = new List<String>{
			'dateUpdated',
			s_ns0,
			'CommonDateTimeType',
			'0',
			'1',
			'false'
		};
		private transient String[] VATNumber_type_info = new List<String>{
			'VATNumber',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] registrationNrClientTrade_type_info = new List<String>{
			'registrationNrClientTrade',
			s_ns0,
			'PersonalIdentityNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] attorney_type_info = new List<String>{
			'attorney',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] flagSpecialRltnToBank_type_info = new List<String>{
			'flagSpecialRltnToBank',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] signedElectronically_type_info = new List<String>{
			'signedElectronically',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] agentCPU_type_info = new List<String>{
			'agentCPU',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'clientGlobalId',
			'firstName',
			'lastName',
			'personalIdentityNumber',
			'SpSA',
			'SpSC',
			'salutation',
			'birthDate',
			'birthPlace',
			'birthState',
			'maritalStatus',
			'gender',
			'foreignerIdentityDocument',
			'profession',
			'identityCard',
			'citizenship',
			'dataShareLevel',
			'personType',
			'legalEntityData',
			'isPoliticallyExposed',
			'prefixTitle',
			'suffixTitle',
			'deathDate',
			'isCrResident',
			'loyaltyProgram',
			'incomeSource',
			'industry',
			'cryptoCurrFlag',
			'cryptoCurrList',
			'cryptoCurrPlatform',
			'employerIco',
			'monthlyIncomeRange',
			'documentUid',
			'identificationType',
			'personalDataUpdateDate',
			'maidenName',
			'dateOfCreation',
			'dateUpdated',
			'VATNumber',
			'registrationNrClientTrade',
			'attorney',
			'flagSpecialRltnToBank',
			'signedElectronically',
			'agentCPU'
		};
		public ClientInfoType() {
		}
		public ClientInfoType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode clientGlobalIdNode = responseNode.getChildElement(
				'clientGlobalId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.clientGlobalId = (clientGlobalIdNode == null) ? null : Long.valueOf(clientGlobalIdNode.getText());
			nodesParsed.add(clientGlobalIdNode);
			//System.debug(this.clientGlobalId);
			DOM.XmlNode firstNameNode = responseNode.getChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.firstName = (firstNameNode == null) ? null : firstNameNode.getText();
			nodesParsed.add(firstNameNode);
			//System.debug(this.firstName);
			DOM.XmlNode lastNameNode = responseNode.getChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.lastName = (lastNameNode == null) ? null : lastNameNode.getText();
			nodesParsed.add(lastNameNode);
			//System.debug(this.lastName);
			DOM.XmlNode personalIdentityNumberNode = responseNode.getChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalIdentityNumber = (personalIdentityNumberNode == null)
				? null
				: personalIdentityNumberNode.getText();
			nodesParsed.add(personalIdentityNumberNode);
			//System.debug(this.personalIdentityNumber);
			DOM.XmlNode SpSANode = responseNode.getChildElement(
				'SpSA',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (SpSANode == null) {
				this.SpSA = null;
			} else {
				BasicTypesService.AccountNumberType SpSAObj = new BasicTypesService.AccountNumberType(SpSANode);
				nodesParsed.add(SpSANode);
				this.SpSA = SpSAObj;
			}
			//System.debug(this.SpSA);
			DOM.XmlNode SpSCNode = responseNode.getChildElement(
				'SpSC',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (SpSCNode == null) {
				this.SpSC = null;
			} else {
				BasicTypesService.AccountNumberType SpSCObj = new BasicTypesService.AccountNumberType(SpSCNode);
				nodesParsed.add(SpSCNode);
				this.SpSC = SpSCObj;
			}
			//System.debug(this.SpSC);
			DOM.XmlNode salutationNode = responseNode.getChildElement(
				'salutation',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.salutation = (salutationNode == null) ? null : Long.valueOf(salutationNode.getText());
			nodesParsed.add(salutationNode);
			//System.debug(this.salutation);
			DOM.XmlNode birthDateNode = responseNode.getChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthDate = (birthDateNode == null) ? null : Date.valueOf(birthDateNode.getText());
			nodesParsed.add(birthDateNode);
			//System.debug(this.birthDate);
			DOM.XmlNode birthPlaceNode = responseNode.getChildElement(
				'birthPlace',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthPlace = (birthPlaceNode == null) ? null : birthPlaceNode.getText();
			nodesParsed.add(birthPlaceNode);
			//System.debug(this.birthPlace);
			DOM.XmlNode birthStateNode = responseNode.getChildElement(
				'birthState',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthState = (birthStateNode == null) ? null : birthStateNode.getText();
			nodesParsed.add(birthStateNode);
			//System.debug(this.birthState);
			DOM.XmlNode maritalStatusNode = responseNode.getChildElement(
				'maritalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.maritalStatus = (maritalStatusNode == null) ? null : Long.valueOf(maritalStatusNode.getText());
			nodesParsed.add(maritalStatusNode);
			//System.debug(this.maritalStatus);
			DOM.XmlNode genderNode = responseNode.getChildElement(
				'gender',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.gender = (genderNode == null) ? null : Long.valueOf(genderNode.getText());
			nodesParsed.add(genderNode);
			//System.debug(this.gender);
			DOM.XmlNode foreignerIdentityDocumentNode = responseNode.getChildElement(
				'foreignerIdentityDocument',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (foreignerIdentityDocumentNode == null) {
				this.foreignerIdentityDocument = null;
			} else {
				PersonManagementSOAPServiceTypes.ForeignerIdentityType foreignerIdentityDocumentObj = new PersonManagementSOAPServiceTypes.ForeignerIdentityType(
					foreignerIdentityDocumentNode
				);
				nodesParsed.add(foreignerIdentityDocumentNode);
				this.foreignerIdentityDocument = foreignerIdentityDocumentObj;
			}
			//System.debug(this.foreignerIdentityDocument);
			DOM.XmlNode professionNode = responseNode.getChildElement(
				'profession',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.profession = (professionNode == null) ? null : Long.valueOf(professionNode.getText());
			nodesParsed.add(professionNode);
			//System.debug(this.profession);
			DOM.XmlNode identityCardNode = responseNode.getChildElement(
				'identityCard',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (identityCardNode == null) {
				this.identityCard = null;
			} else {
				PersonManagementSOAPServiceTypes.IdentityCardType identityCardObj = new PersonManagementSOAPServiceTypes.IdentityCardType(
					identityCardNode
				);
				nodesParsed.add(identityCardNode);
				this.identityCard = identityCardObj;
			}
			//System.debug(this.identityCard);
			DOM.XmlNode citizenshipNode = responseNode.getChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.citizenship = (citizenshipNode == null) ? null : citizenshipNode.getText();
			nodesParsed.add(citizenshipNode);
			//System.debug(this.citizenship);
			DOM.XmlNode dataShareLevelNode = responseNode.getChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dataShareLevel = (dataShareLevelNode == null) ? null : dataShareLevelNode.getText();
			nodesParsed.add(dataShareLevelNode);
			//System.debug(this.dataShareLevel);
			DOM.XmlNode personTypeNode = responseNode.getChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personType = (personTypeNode == null) ? null : personTypeNode.getText();
			nodesParsed.add(personTypeNode);
			//System.debug(this.personType);
			DOM.XmlNode legalEntityDataNode = responseNode.getChildElement(
				'legalEntityData',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (legalEntityDataNode == null) {
				this.legalEntityData = null;
			} else {
				PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityDataObj = new PersonManagementSOAPServiceTypes.LegalEntityDataType(
					legalEntityDataNode
				);
				nodesParsed.add(legalEntityDataNode);
				this.legalEntityData = legalEntityDataObj;
			}
			//System.debug(this.legalEntityData);
			DOM.XmlNode isPoliticallyExposedNode = responseNode.getChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.isPoliticallyExposed = (isPoliticallyExposedNode == null)
				? null
				: Boolean.valueOf(isPoliticallyExposedNode.getText());
			nodesParsed.add(isPoliticallyExposedNode);
			//System.debug(this.isPoliticallyExposed);
			DOM.XmlNode prefixTitleNode = responseNode.getChildElement(
				'prefixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.prefixTitle = (prefixTitleNode == null) ? null : prefixTitleNode.getText();
			nodesParsed.add(prefixTitleNode);
			//System.debug(this.prefixTitle);
			DOM.XmlNode suffixTitleNode = responseNode.getChildElement(
				'suffixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.suffixTitle = (suffixTitleNode == null) ? null : suffixTitleNode.getText();
			nodesParsed.add(suffixTitleNode);
			//System.debug(this.suffixTitle);
			DOM.XmlNode deathDateNode = responseNode.getChildElement(
				'deathDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.deathDate = (deathDateNode == null) ? null : Date.valueOf(deathDateNode.getText());
			nodesParsed.add(deathDateNode);
			//System.debug(this.deathDate);
			DOM.XmlNode isCrResidentNode = responseNode.getChildElement(
				'isCrResident',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.isCrResident = (isCrResidentNode == null) ? null : Boolean.valueOf(isCrResidentNode.getText());
			nodesParsed.add(isCrResidentNode);
			//System.debug(this.isCrResident);
			DOM.XmlNode loyaltyProgramNode = responseNode.getChildElement(
				'loyaltyProgram',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.loyaltyProgram = (loyaltyProgramNode == null) ? null : Long.valueOf(loyaltyProgramNode.getText());
			nodesParsed.add(loyaltyProgramNode);
			//System.debug(this.loyaltyProgram);
			DOM.XmlNode incomeSourceNode = responseNode.getChildElement(
				'incomeSource',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.incomeSource = (incomeSourceNode == null) ? null : Long.valueOf(incomeSourceNode.getText());
			nodesParsed.add(incomeSourceNode);
			//System.debug(this.incomeSource);
			DOM.XmlNode industryNode = responseNode.getChildElement(
				'industry',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.industry = (industryNode == null) ? null : Long.valueOf(industryNode.getText());
			nodesParsed.add(industryNode);
			//System.debug(this.industry);
			DOM.XmlNode cryptoCurrFlagNode = responseNode.getChildElement(
				'cryptoCurrFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrFlag = (cryptoCurrFlagNode == null) ? null : Boolean.valueOf(cryptoCurrFlagNode.getText());
			nodesParsed.add(cryptoCurrFlagNode);
			//System.debug(this.cryptoCurrFlag);
			DOM.XmlNode cryptoCurrListNode = responseNode.getChildElement(
				'cryptoCurrList',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrList = (cryptoCurrListNode == null) ? null : cryptoCurrListNode.getText();
			nodesParsed.add(cryptoCurrListNode);
			//System.debug(this.cryptoCurrList);
			DOM.XmlNode cryptoCurrPlatformNode = responseNode.getChildElement(
				'cryptoCurrPlatform',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cryptoCurrPlatform = (cryptoCurrPlatformNode == null) ? null : cryptoCurrPlatformNode.getText();
			nodesParsed.add(cryptoCurrPlatformNode);
			//System.debug(this.cryptoCurrPlatform);
			DOM.XmlNode employerIcoNode = responseNode.getChildElement(
				'employerIco',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.employerIco = (employerIcoNode == null) ? null : employerIcoNode.getText();
			nodesParsed.add(employerIcoNode);
			//System.debug(this.employerIco);
			DOM.XmlNode monthlyIncomeRangeNode = responseNode.getChildElement(
				'monthlyIncomeRange',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.monthlyIncomeRange = (monthlyIncomeRangeNode == null)
				? null
				: Long.valueOf(monthlyIncomeRangeNode.getText());
			nodesParsed.add(monthlyIncomeRangeNode);
			//System.debug(this.monthlyIncomeRange);
			DOM.XmlNode documentUidNode = responseNode.getChildElement(
				'documentUid',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.documentUid = (documentUidNode == null) ? null : documentUidNode.getText();
			nodesParsed.add(documentUidNode);
			//System.debug(this.documentUid);
			DOM.XmlNode identificationTypeNode = responseNode.getChildElement(
				'identificationType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.identificationType = (identificationTypeNode == null)
				? null
				: Long.valueOf(identificationTypeNode.getText());
			nodesParsed.add(identificationTypeNode);
			//System.debug(this.identificationType);
			DOM.XmlNode personalDataUpdateDateNode = responseNode.getChildElement(
				'personalDataUpdateDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalDataUpdateDate = (personalDataUpdateDateNode == null)
				? null
				: Date.valueOf(personalDataUpdateDateNode.getText());
			nodesParsed.add(personalDataUpdateDateNode);
			//System.debug(this.personalDataUpdateDate);
			DOM.XmlNode maidenNameNode = responseNode.getChildElement(
				'maidenName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.maidenName = (maidenNameNode == null) ? null : maidenNameNode.getText();
			nodesParsed.add(maidenNameNode);
			//System.debug(this.maidenName);
			DOM.XmlNode dateOfCreationNode = responseNode.getChildElement(
				'dateOfCreation',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateOfCreation = (dateOfCreationNode == null) ? null : Date.valueOf(dateOfCreationNode.getText());
			nodesParsed.add(dateOfCreationNode);
			//System.debug(this.dateOfCreation);
			DOM.XmlNode dateUpdatedNode = responseNode.getChildElement(
				'dateUpdated',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateUpdated = (dateUpdatedNode == null)
				? null
				: PersonManagementSOAPServiceTypes.parseDateTime(dateUpdatedNode.getText());
			nodesParsed.add(dateUpdatedNode);
			//System.debug(this.dateUpdated);
			DOM.XmlNode VATNumberNode = responseNode.getChildElement(
				'VATNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.VATNumber = (VATNumberNode == null) ? null : VATNumberNode.getText();
			nodesParsed.add(VATNumberNode);
			//System.debug(this.VATNumber);
			DOM.XmlNode registrationNrClientTradeNode = responseNode.getChildElement(
				'registrationNrClientTrade',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.registrationNrClientTrade = (registrationNrClientTradeNode == null)
				? null
				: registrationNrClientTradeNode.getText();
			nodesParsed.add(registrationNrClientTradeNode);
			//System.debug(this.registrationNrClientTrade);
			DOM.XmlNode attorneyNode = responseNode.getChildElement(
				'attorney',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.attorney = (attorneyNode == null) ? null : attorneyNode.getText();
			nodesParsed.add(attorneyNode);
			//System.debug(this.attorney);
			DOM.XmlNode flagSpecialRltnToBankNode = responseNode.getChildElement(
				'flagSpecialRltnToBank',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.flagSpecialRltnToBank = (flagSpecialRltnToBankNode == null)
				? null
				: Boolean.valueOf(flagSpecialRltnToBankNode.getText());
			nodesParsed.add(flagSpecialRltnToBankNode);
			//System.debug(this.flagSpecialRltnToBank);
			DOM.XmlNode signedElectronicallyNode = responseNode.getChildElement(
				'signedElectronically',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.signedElectronically = (signedElectronicallyNode == null)
				? null
				: Boolean.valueOf(signedElectronicallyNode.getText());
			nodesParsed.add(signedElectronicallyNode);
			//System.debug(this.signedElectronically);
			DOM.XmlNode agentCPUNode = responseNode.getChildElement(
				'agentCPU',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.agentCPU = (agentCPUNode == null) ? null : agentCPUNode.getText();
			nodesParsed.add(agentCPUNode);
			//System.debug(this.agentCPU);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode clientGlobalIdNode = outerNode.addChildElement(
				'clientGlobalId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			clientGlobalIdNode.addTextNode((this.clientGlobalId == null) ? '' : String.valueOf(this.clientGlobalId));
			Dom.XmlNode firstNameNode = outerNode.addChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.firstName != null) {
				firstNameNode.addTextNode(this.firstName);
			}
			Dom.XmlNode lastNameNode = outerNode.addChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.lastName != null) {
				lastNameNode.addTextNode(this.lastName);
			}
			Dom.XmlNode personalIdentityNumberNode = outerNode.addChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personalIdentityNumber != null) {
				personalIdentityNumberNode.addTextNode(this.personalIdentityNumber);
			}

			BasicTypesService.AccountNumberType SpSAObj = this.SpSA;
			Dom.XmlNode SpSANode = outerNode.addChildElement(
				'SpSA',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (SpSAObj != null) {
				SpSAObj.populateXmlNode(SpSANode);
			}

			BasicTypesService.AccountNumberType SpSCObj = this.SpSC;
			Dom.XmlNode SpSCNode = outerNode.addChildElement(
				'SpSC',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (SpSCObj != null) {
				SpSCObj.populateXmlNode(SpSCNode);
			}
			Dom.XmlNode salutationNode = outerNode.addChildElement(
				'salutation',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			salutationNode.addTextNode((this.salutation == null) ? '' : String.valueOf(this.salutation));
			Dom.XmlNode birthDateNode = outerNode.addChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.birthDate != null) {
				birthDateNode.addTextNode(String.valueOf(this.birthDate));
			}
			Dom.XmlNode birthPlaceNode = outerNode.addChildElement(
				'birthPlace',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.birthPlace != null) {
				birthPlaceNode.addTextNode(this.birthPlace);
			}
			Dom.XmlNode birthStateNode = outerNode.addChildElement(
				'birthState',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.birthState != null) {
				birthStateNode.addTextNode(this.birthState);
			}
			Dom.XmlNode maritalStatusNode = outerNode.addChildElement(
				'maritalStatus',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			maritalStatusNode.addTextNode((this.maritalStatus == null) ? '' : String.valueOf(this.maritalStatus));
			Dom.XmlNode genderNode = outerNode.addChildElement(
				'gender',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.gender != null) {
				genderNode.addTextNode(String.valueOf(this.gender));
			}

			PersonManagementSOAPServiceTypes.ForeignerIdentityType foreignerIdentityDocumentObj = this.foreignerIdentityDocument;
			Dom.XmlNode foreignerIdentityDocumentNode = outerNode.addChildElement(
				'foreignerIdentityDocument',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (foreignerIdentityDocumentObj != null) {
				foreignerIdentityDocumentObj.populateXmlNode(foreignerIdentityDocumentNode);
			}
			Dom.XmlNode professionNode = outerNode.addChildElement(
				'profession',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			professionNode.addTextNode((this.profession == null) ? '' : String.valueOf(this.profession));

			PersonManagementSOAPServiceTypes.IdentityCardType identityCardObj = this.identityCard;
			Dom.XmlNode identityCardNode = outerNode.addChildElement(
				'identityCard',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (identityCardObj != null) {
				identityCardObj.populateXmlNode(identityCardNode);
			}
			Dom.XmlNode citizenshipNode = outerNode.addChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.citizenship != null) {
				citizenshipNode.addTextNode(this.citizenship);
			}
			Dom.XmlNode dataShareLevelNode = outerNode.addChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dataShareLevelNode.addTextNode((this.dataShareLevel == null) ? '' : this.dataShareLevel);
			Dom.XmlNode personTypeNode = outerNode.addChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personType != null) {
				personTypeNode.addTextNode(this.personType);
			}

			PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityDataObj = this.legalEntityData;
			Dom.XmlNode legalEntityDataNode = outerNode.addChildElement(
				'legalEntityData',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (legalEntityDataObj != null) {
				legalEntityDataObj.populateXmlNode(legalEntityDataNode);
			}
			Dom.XmlNode isPoliticallyExposedNode = outerNode.addChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			isPoliticallyExposedNode.addTextNode(
				(this.isPoliticallyExposed == null) ? '' : String.valueOf(this.isPoliticallyExposed)
			);
			Dom.XmlNode prefixTitleNode = outerNode.addChildElement(
				'prefixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			prefixTitleNode.addTextNode((this.prefixTitle == null) ? '' : this.prefixTitle);
			Dom.XmlNode suffixTitleNode = outerNode.addChildElement(
				'suffixTitle',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			suffixTitleNode.addTextNode((this.suffixTitle == null) ? '' : this.suffixTitle);
			Dom.XmlNode deathDateNode = outerNode.addChildElement(
				'deathDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			deathDateNode.addTextNode((this.deathDate == null) ? '' : String.valueOf(this.deathDate));
			Dom.XmlNode isCrResidentNode = outerNode.addChildElement(
				'isCrResident',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			isCrResidentNode.addTextNode((this.isCrResident == null) ? '' : String.valueOf(this.isCrResident));
			Dom.XmlNode loyaltyProgramNode = outerNode.addChildElement(
				'loyaltyProgram',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			loyaltyProgramNode.addTextNode((this.loyaltyProgram == null) ? '' : String.valueOf(this.loyaltyProgram));
			Dom.XmlNode incomeSourceNode = outerNode.addChildElement(
				'incomeSource',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			incomeSourceNode.addTextNode((this.incomeSource == null) ? '' : String.valueOf(this.incomeSource));
			Dom.XmlNode industryNode = outerNode.addChildElement(
				'industry',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			industryNode.addTextNode((this.industry == null) ? '' : String.valueOf(this.industry));
			Dom.XmlNode cryptoCurrFlagNode = outerNode.addChildElement(
				'cryptoCurrFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrFlagNode.addTextNode((this.cryptoCurrFlag == null) ? '' : String.valueOf(this.cryptoCurrFlag));
			Dom.XmlNode cryptoCurrListNode = outerNode.addChildElement(
				'cryptoCurrList',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrListNode.addTextNode((this.cryptoCurrList == null) ? '' : this.cryptoCurrList);
			Dom.XmlNode cryptoCurrPlatformNode = outerNode.addChildElement(
				'cryptoCurrPlatform',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cryptoCurrPlatformNode.addTextNode((this.cryptoCurrPlatform == null) ? '' : this.cryptoCurrPlatform);
			Dom.XmlNode employerIcoNode = outerNode.addChildElement(
				'employerIco',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			employerIcoNode.addTextNode((this.employerIco == null) ? '' : this.employerIco);
			Dom.XmlNode monthlyIncomeRangeNode = outerNode.addChildElement(
				'monthlyIncomeRange',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			monthlyIncomeRangeNode.addTextNode(
				(this.monthlyIncomeRange == null) ? '' : String.valueOf(this.monthlyIncomeRange)
			);
			Dom.XmlNode documentUidNode = outerNode.addChildElement(
				'documentUid',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			documentUidNode.addTextNode((this.documentUid == null) ? '' : this.documentUid);
			Dom.XmlNode identificationTypeNode = outerNode.addChildElement(
				'identificationType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			identificationTypeNode.addTextNode(
				(this.identificationType == null) ? '' : String.valueOf(this.identificationType)
			);
			Dom.XmlNode personalDataUpdateDateNode = outerNode.addChildElement(
				'personalDataUpdateDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personalDataUpdateDateNode.addTextNode(
				(this.personalDataUpdateDate == null) ? '' : String.valueOf(this.personalDataUpdateDate)
			);
			Dom.XmlNode maidenNameNode = outerNode.addChildElement(
				'maidenName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			maidenNameNode.addTextNode((this.maidenName == null) ? '' : this.maidenName);
			Dom.XmlNode dateOfCreationNode = outerNode.addChildElement(
				'dateOfCreation',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateOfCreationNode.addTextNode((this.dateOfCreation == null) ? '' : String.valueOf(this.dateOfCreation));
			Dom.XmlNode dateUpdatedNode = outerNode.addChildElement(
				'dateUpdated',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateUpdatedNode.addTextNode((this.dateUpdated == null) ? '' : String.valueOf(this.dateUpdated));
			Dom.XmlNode VATNumberNode = outerNode.addChildElement(
				'VATNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			VATNumberNode.addTextNode((this.VATNumber == null) ? '' : this.VATNumber);
			Dom.XmlNode registrationNrClientTradeNode = outerNode.addChildElement(
				'registrationNrClientTrade',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			registrationNrClientTradeNode.addTextNode(
				(this.registrationNrClientTrade == null) ? '' : this.registrationNrClientTrade
			);
			Dom.XmlNode attorneyNode = outerNode.addChildElement(
				'attorney',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			attorneyNode.addTextNode((this.attorney == null) ? '' : this.attorney);
			Dom.XmlNode flagSpecialRltnToBankNode = outerNode.addChildElement(
				'flagSpecialRltnToBank',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			flagSpecialRltnToBankNode.addTextNode(
				(this.flagSpecialRltnToBank == null) ? '' : String.valueOf(this.flagSpecialRltnToBank)
			);
			Dom.XmlNode signedElectronicallyNode = outerNode.addChildElement(
				'signedElectronically',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			signedElectronicallyNode.addTextNode(
				(this.signedElectronically == null) ? '' : String.valueOf(this.signedElectronically)
			);
			Dom.XmlNode agentCPUNode = outerNode.addChildElement(
				'agentCPU',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			agentCPUNode.addTextNode((this.agentCPU == null) ? '' : this.agentCPU);
		}
	}

	public class CoupleDocumentRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'CoupleDocumentRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public CoupleDocumentRequest() {
		}
		public CoupleDocumentRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('coupleDocument', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}

	public class CoupleDocumentRequestBody {
		public Long globalId;
		public String documentUID;
		public String documentType;
		// Restriction enumeration:
		public Date dateOfScan;
		private transient String[] globalId_type_info = new List<String>{
			'globalId',
			s_ns0,
			'ClientGlobalIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] documentUID_type_info = new List<String>{
			'documentUID',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] documentType_type_info = new List<String>{
			'documentType',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] dateOfScan_type_info = new List<String>{
			'dateOfScan',
			s_ns0,
			'CommonDateType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'globalId',
			'documentUID',
			'documentType',
			'dateOfScan'
		};
		public CoupleDocumentRequestBody() {
		}
		public CoupleDocumentRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode globalIdNode = responseNode.getChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.globalId = (globalIdNode == null) ? null : Long.valueOf(globalIdNode.getText());
			nodesParsed.add(globalIdNode);
			//System.debug(this.globalId);
			DOM.XmlNode documentUIDNode = responseNode.getChildElement(
				'documentUID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.documentUID = (documentUIDNode == null) ? null : documentUIDNode.getText();
			nodesParsed.add(documentUIDNode);
			//System.debug(this.documentUID);
			DOM.XmlNode documentTypeNode = responseNode.getChildElement(
				'documentType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.documentType = (documentTypeNode == null) ? null : documentTypeNode.getText();
			nodesParsed.add(documentTypeNode);
			//System.debug(this.documentType);
			DOM.XmlNode dateOfScanNode = responseNode.getChildElement(
				'dateOfScan',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateOfScan = (dateOfScanNode == null) ? null : Date.valueOf(dateOfScanNode.getText());
			nodesParsed.add(dateOfScanNode);
			//System.debug(this.dateOfScan);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode globalIdNode = outerNode.addChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.globalId != null) {
				globalIdNode.addTextNode(String.valueOf(this.globalId));
			}
			Dom.XmlNode documentUIDNode = outerNode.addChildElement(
				'documentUID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.documentUID != null) {
				documentUIDNode.addTextNode(this.documentUID);
			}
			Dom.XmlNode documentTypeNode = outerNode.addChildElement(
				'documentType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.documentType != null) {
				documentTypeNode.addTextNode(this.documentType);
			}
			Dom.XmlNode dateOfScanNode = outerNode.addChildElement(
				'dateOfScan',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.dateOfScan != null) {
				dateOfScanNode.addTextNode(String.valueOf(this.dateOfScan));
			}
		}
	}
	public class CoupleDocumentResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_CoupleDocumentResponse;
		private transient String[] responseHeader_CoupleDocumentResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'CoupleDocumentResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_CoupleDocumentResponse',
			'responseBody'
		};
		public CoupleDocumentResponse() {
		}
		public CoupleDocumentResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('coupleDocumentResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_CoupleDocumentResponseNode = responseNode.getChildElement(
				'responseHeader_CoupleDocumentResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_CoupleDocumentResponseNode == null) {
				this.responseHeader_CoupleDocumentResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_CoupleDocumentResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_CoupleDocumentResponseNode
				);
				nodesParsed.add(responseHeader_CoupleDocumentResponseNode);
				this.responseHeader_CoupleDocumentResponse = responseHeader_CoupleDocumentResponseObj;
			}
			//System.debug(this.responseHeader_CoupleDocumentResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class CoupleDocumentResponseBody {
		public BasicTypesService.OperationSuccessType successful;
		private transient String[] successful_type_info = new List<String>{
			'successful',
			s_ns0,
			'OperationSuccessType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'successful'};
		public CoupleDocumentResponseBody() {
		}
		public CoupleDocumentResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode successfulNode = responseNode.getChildElement(
				'successful',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (successfulNode == null) {
				this.successful = null;
			} else {
				BasicTypesService.OperationSuccessType successfulObj = new BasicTypesService.OperationSuccessType(
					successfulNode
				);
				nodesParsed.add(successfulNode);
				this.successful = successfulObj;
			}
			//System.debug(this.successful);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			BasicTypesService.OperationSuccessType successfulObj = this.successful;
			Dom.XmlNode successfulNode = outerNode.addChildElement(
				'successful',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (successfulObj != null) {
				successfulObj.populateXmlNode(successfulNode);
			}
		}
	}
	public class CreateClientRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.CreateClientRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'CreateClientRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public CreateClientRequest() {
		}
		public CreateClientRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.CreateClientRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('createClient', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.CreateClientRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class CreateClientRequestBody {
		public PersonManagementSOAPServiceTypes.ClientInfoType clientInfo;
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunications;
		private transient String[] clientInfo_type_info = new List<String>{
			'clientInfo',
			s_ns0,
			'ClientInfoType',
			'1',
			'1',
			'false'
		};
		private transient String[] listOfCommunications_type_info = new List<String>{
			'listOfCommunications',
			s_ns0,
			'ListOfCommunicationsType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'clientInfo', 'listOfCommunications'};
		public CreateClientRequestBody() {
		}
		public CreateClientRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode clientInfoNode = responseNode.getChildElement(
				'clientInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (clientInfoNode == null) {
				this.clientInfo = null;
			} else {
				PersonManagementSOAPServiceTypes.ClientInfoType clientInfoObj = new PersonManagementSOAPServiceTypes.ClientInfoType(
					clientInfoNode
				);
				nodesParsed.add(clientInfoNode);
				this.clientInfo = clientInfoObj;
			}
			//System.debug(this.clientInfo);
			DOM.XmlNode listOfCommunicationsNode = responseNode.getChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfCommunicationsNode == null) {
				this.listOfCommunications = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
					listOfCommunicationsNode
				);
				nodesParsed.add(listOfCommunicationsNode);
				this.listOfCommunications = listOfCommunicationsObj;
			}
			//System.debug(this.listOfCommunications);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.ClientInfoType clientInfoObj = this.clientInfo;
			Dom.XmlNode clientInfoNode = outerNode.addChildElement(
				'clientInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (clientInfoObj != null) {
				clientInfoObj.populateXmlNode(clientInfoNode);
			}

			PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = this.listOfCommunications;
			Dom.XmlNode listOfCommunicationsNode = outerNode.addChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfCommunicationsObj != null) {
				listOfCommunicationsObj.populateXmlNode(listOfCommunicationsNode);
			}
		}
	}
	public class CreateClientResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_CreateClientResponse;
		private transient String[] responseHeader_CreateClientResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.CreateClientResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'CreateClientResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_CreateClientResponse',
			'responseBody'
		};
		public CreateClientResponse() {
		}
		public CreateClientResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('createClientResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_CreateClientResponseNode = responseNode.getChildElement(
				'responseHeader_CreateClientResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_CreateClientResponseNode == null) {
				this.responseHeader_CreateClientResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_CreateClientResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_CreateClientResponseNode
				);
				nodesParsed.add(responseHeader_CreateClientResponseNode);
				this.responseHeader_CreateClientResponse = responseHeader_CreateClientResponseObj;
			}
			//System.debug(this.responseHeader_CreateClientResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.CreateClientResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.CreateClientResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class CreateClientResponseBody {
		public Long personNumber;
		public Long globalId;
		public String personId;
		public DateTime dateLastUpdate;
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunications;
		public String riskClass;
		// Restriction enumeration:
		public Date nextAmlReviewDate;
		private transient String[] personNumber_type_info = new List<String>{
			'personNumber',
			s_ns0,
			'PersonNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] globalId_type_info = new List<String>{
			'globalId',
			s_ns0,
			'ClientGlobalIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] personId_type_info = new List<String>{
			'personId',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] dateLastUpdate_type_info = new List<String>{
			'dateLastUpdate',
			s_ns0,
			'CommonDateTimeType',
			'1',
			'1',
			'false'
		};
		private transient String[] listOfCommunications_type_info = new List<String>{
			'listOfCommunications',
			s_ns0,
			'ListOfCommunicationsType',
			'0',
			'1',
			'false'
		};
		private transient String[] riskClass_type_info = new List<String>{
			'riskClass',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] nextAmlReviewDate_type_info = new List<String>{
			'nextAmlReviewDate',
			s_ns0,
			'CommonDateType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'personNumber',
			'globalId',
			'personId',
			'dateLastUpdate',
			'listOfCommunications',
			'riskClass',
			'nextAmlReviewDate'
		};
		public CreateClientResponseBody() {
		}
		public CreateClientResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode personNumberNode = responseNode.getChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personNumber = (personNumberNode == null) ? null : Long.valueOf(personNumberNode.getText());
			nodesParsed.add(personNumberNode);
			//System.debug(this.personNumber);
			DOM.XmlNode globalIdNode = responseNode.getChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.globalId = (globalIdNode == null) ? null : Long.valueOf(globalIdNode.getText());
			nodesParsed.add(globalIdNode);
			//System.debug(this.globalId);
			DOM.XmlNode personIdNode = responseNode.getChildElement(
				'personId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personId = (personIdNode == null) ? null : personIdNode.getText();
			nodesParsed.add(personIdNode);
			//System.debug(this.personId);
			DOM.XmlNode dateLastUpdateNode = responseNode.getChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateLastUpdate = (dateLastUpdateNode == null)
				? null
				: PersonManagementSOAPServiceTypes.parseDateTime(dateLastUpdateNode.getText());
			nodesParsed.add(dateLastUpdateNode);
			//System.debug(this.dateLastUpdate);
			DOM.XmlNode listOfCommunicationsNode = responseNode.getChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfCommunicationsNode == null) {
				this.listOfCommunications = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
					listOfCommunicationsNode
				);
				nodesParsed.add(listOfCommunicationsNode);
				this.listOfCommunications = listOfCommunicationsObj;
			}
			//System.debug(this.listOfCommunications);
			DOM.XmlNode riskClassNode = responseNode.getChildElement(
				'riskClass',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.riskClass = (riskClassNode == null) ? null : riskClassNode.getText();
			nodesParsed.add(riskClassNode);
			//System.debug(this.riskClass);
			DOM.XmlNode nextAmlReviewDateNode = responseNode.getChildElement(
				'nextAmlReviewDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.nextAmlReviewDate = (nextAmlReviewDateNode == null)
				? null
				: Date.valueOf(nextAmlReviewDateNode.getText());
			nodesParsed.add(nextAmlReviewDateNode);
			//System.debug(this.nextAmlReviewDate);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode personNumberNode = outerNode.addChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personNumber != null) {
				personNumberNode.addTextNode(String.valueOf(this.personNumber));
			}
			Dom.XmlNode globalIdNode = outerNode.addChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.globalId != null) {
				globalIdNode.addTextNode(String.valueOf(this.globalId));
			}
			Dom.XmlNode personIdNode = outerNode.addChildElement(
				'personId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personId != null) {
				personIdNode.addTextNode(this.personId);
			}
			Dom.XmlNode dateLastUpdateNode = outerNode.addChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.dateLastUpdate != null) {
				dateLastUpdateNode.addTextNode(String.valueOf(this.dateLastUpdate));
			}

			PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = this.listOfCommunications;
			Dom.XmlNode listOfCommunicationsNode = outerNode.addChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfCommunicationsObj != null) {
				listOfCommunicationsObj.populateXmlNode(listOfCommunicationsNode);
			}
			Dom.XmlNode riskClassNode = outerNode.addChildElement(
				'riskClass',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.riskClass != null) {
				riskClassNode.addTextNode(this.riskClass);
			}
			Dom.XmlNode nextAmlReviewDateNode = outerNode.addChildElement(
				'nextAmlReviewDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.nextAmlReviewDate != null) {
				nextAmlReviewDateNode.addTextNode(String.valueOf(this.nextAmlReviewDate));
			}
		}
	}
	public class CreatePersonRelationRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'CreatePersonRelationRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public CreatePersonRelationRequest() {
		}
		public CreatePersonRelationRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('createPersonRelation', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class CreatePersonRelationRequestBody {
		public PersonManagementSOAPServiceTypes.PersonRelationType personRelation;
		private transient String[] personRelation_type_info = new List<String>{
			'personRelation',
			s_ns0,
			'PersonRelationType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'personRelation'};
		public CreatePersonRelationRequestBody() {
		}
		public CreatePersonRelationRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode personRelationNode = responseNode.getChildElement(
				'personRelation',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (personRelationNode == null) {
				this.personRelation = null;
			} else {
				PersonManagementSOAPServiceTypes.PersonRelationType personRelationObj = new PersonManagementSOAPServiceTypes.PersonRelationType(
					personRelationNode
				);
				nodesParsed.add(personRelationNode);
				this.personRelation = personRelationObj;
			}
			//System.debug(this.personRelation);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.PersonRelationType personRelationObj = this.personRelation;
			Dom.XmlNode personRelationNode = outerNode.addChildElement(
				'personRelation',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (personRelationObj != null) {
				personRelationObj.populateXmlNode(personRelationNode);
			}
		}
	}
	public class CreatePersonRelationResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_CreatePersonRelationResponse;
		private transient String[] responseHeader_CreatePersonRelationResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'CreatePersonRelationResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_CreatePersonRelationResponse',
			'responseBody'
		};
		public CreatePersonRelationResponse() {
		}
		public CreatePersonRelationResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('createPersonRelationResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_CreatePersonRelationResponseNode = responseNode.getChildElement(
				'responseHeader_CreatePersonRelationResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_CreatePersonRelationResponseNode == null) {
				this.responseHeader_CreatePersonRelationResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_CreatePersonRelationResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_CreatePersonRelationResponseNode
				);
				nodesParsed.add(responseHeader_CreatePersonRelationResponseNode);
				this.responseHeader_CreatePersonRelationResponse = responseHeader_CreatePersonRelationResponseObj;
			}
			//System.debug(this.responseHeader_CreatePersonRelationResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class CreatePersonRelationResponseBody {
		public PersonManagementSOAPServiceTypes.CreatePersonRelationResponseInfoType createPersonRelationResponseInfo;
		private transient String[] createPersonRelationResponseInfo_type_info = new List<String>{
			'createPersonRelationResponseInfo',
			s_ns0,
			'CreatePersonRelationResponseInfoType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'createPersonRelationResponseInfo'};
		public CreatePersonRelationResponseBody() {
		}
		public CreatePersonRelationResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode createPersonRelationResponseInfoNode = responseNode.getChildElement(
				'createPersonRelationResponseInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (createPersonRelationResponseInfoNode == null) {
				this.createPersonRelationResponseInfo = null;
			} else {
				PersonManagementSOAPServiceTypes.CreatePersonRelationResponseInfoType createPersonRelationResponseInfoObj = new PersonManagementSOAPServiceTypes.CreatePersonRelationResponseInfoType(
					createPersonRelationResponseInfoNode
				);
				nodesParsed.add(createPersonRelationResponseInfoNode);
				this.createPersonRelationResponseInfo = createPersonRelationResponseInfoObj;
			}
			//System.debug(this.createPersonRelationResponseInfo);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.CreatePersonRelationResponseInfoType createPersonRelationResponseInfoObj = this.createPersonRelationResponseInfo;
			Dom.XmlNode createPersonRelationResponseInfoNode = outerNode.addChildElement(
				'createPersonRelationResponseInfo',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (createPersonRelationResponseInfoObj != null) {
				createPersonRelationResponseInfoObj.populateXmlNode(createPersonRelationResponseInfoNode);
			}
		}
	}
	public class CreatePersonRelationResponseInfoType {
		public String relationId;
		private transient String[] relationId_type_info = new List<String>{
			'relationId',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'relationId'};
		public CreatePersonRelationResponseInfoType() {
		}
		public CreatePersonRelationResponseInfoType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode relationIdNode = responseNode.getChildElement(
				'relationId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.relationId = (relationIdNode == null) ? null : relationIdNode.getText();
			nodesParsed.add(relationIdNode);
			//System.debug(this.relationId);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode relationIdNode = outerNode.addChildElement(
				'relationId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			relationIdNode.addTextNode((this.relationId == null) ? '' : this.relationId);
		}
	}
	public class ForeignerIdentityType {
		// Restriction enumeration:
		public Date dateOfStayFrom;
		// Restriction enumeration:
		public Date dateOfStayUntil;
		public Long residenceStyleCode;
		private transient String[] dateOfStayFrom_type_info = new List<String>{
			'dateOfStayFrom',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] dateOfStayUntil_type_info = new List<String>{
			'dateOfStayUntil',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] residenceStyleCode_type_info = new List<String>{
			'residenceStyleCode',
			s_ns0,
			'CodeListItemIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'dateOfStayFrom',
			'dateOfStayUntil',
			'residenceStyleCode'
		};
		public ForeignerIdentityType() {
		}
		public ForeignerIdentityType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode dateOfStayFromNode = responseNode.getChildElement(
				'dateOfStayFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateOfStayFrom = (dateOfStayFromNode == null) ? null : Date.valueOf(dateOfStayFromNode.getText());
			nodesParsed.add(dateOfStayFromNode);
			//System.debug(this.dateOfStayFrom);
			DOM.XmlNode dateOfStayUntilNode = responseNode.getChildElement(
				'dateOfStayUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateOfStayUntil = (dateOfStayUntilNode == null) ? null : Date.valueOf(dateOfStayUntilNode.getText());
			nodesParsed.add(dateOfStayUntilNode);
			//System.debug(this.dateOfStayUntil);
			DOM.XmlNode residenceStyleCodeNode = responseNode.getChildElement(
				'residenceStyleCode',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.residenceStyleCode = (residenceStyleCodeNode == null)
				? null
				: Long.valueOf(residenceStyleCodeNode.getText());
			nodesParsed.add(residenceStyleCodeNode);
			//System.debug(this.residenceStyleCode);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode dateOfStayFromNode = outerNode.addChildElement(
				'dateOfStayFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateOfStayFromNode.addTextNode((this.dateOfStayFrom == null) ? '' : String.valueOf(this.dateOfStayFrom));
			Dom.XmlNode dateOfStayUntilNode = outerNode.addChildElement(
				'dateOfStayUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateOfStayUntilNode.addTextNode((this.dateOfStayUntil == null) ? '' : String.valueOf(this.dateOfStayUntil));
			Dom.XmlNode residenceStyleCodeNode = outerNode.addChildElement(
				'residenceStyleCode',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.residenceStyleCode != null) {
				residenceStyleCodeNode.addTextNode(String.valueOf(this.residenceStyleCode));
			}
		}
	}
	public class ForeignerIDType {
		public Long cardType;
		// Restriction enumeration:
		public Date dateOfStayFrom;
		// Restriction enumeration:
		public Date dateOfStayUntil;
		public String travelDocumentNumber;
		public Long residenceStyleCode;
		private transient String[] cardType_type_info = new List<String>{
			'cardType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] dateOfStayFrom_type_info = new List<String>{
			'dateOfStayFrom',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] dateOfStayUntil_type_info = new List<String>{
			'dateOfStayUntil',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] travelDocumentNumber_type_info = new List<String>{
			'travelDocumentNumber',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] residenceStyleCode_type_info = new List<String>{
			'residenceStyleCode',
			s_ns0,
			'CodeListItemIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'cardType',
			'dateOfStayFrom',
			'dateOfStayUntil',
			'travelDocumentNumber',
			'residenceStyleCode'
		};
		public ForeignerIDType() {
		}
		public ForeignerIDType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode cardTypeNode = responseNode.getChildElement(
				'cardType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.cardType = (cardTypeNode == null) ? null : Long.valueOf(cardTypeNode.getText());
			nodesParsed.add(cardTypeNode);
			//System.debug(this.cardType);
			DOM.XmlNode dateOfStayFromNode = responseNode.getChildElement(
				'dateOfStayFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateOfStayFrom = (dateOfStayFromNode == null) ? null : Date.valueOf(dateOfStayFromNode.getText());
			nodesParsed.add(dateOfStayFromNode);
			//System.debug(this.dateOfStayFrom);
			DOM.XmlNode dateOfStayUntilNode = responseNode.getChildElement(
				'dateOfStayUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateOfStayUntil = (dateOfStayUntilNode == null) ? null : Date.valueOf(dateOfStayUntilNode.getText());
			nodesParsed.add(dateOfStayUntilNode);
			//System.debug(this.dateOfStayUntil);
			DOM.XmlNode travelDocumentNumberNode = responseNode.getChildElement(
				'travelDocumentNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.travelDocumentNumber = (travelDocumentNumberNode == null) ? null : travelDocumentNumberNode.getText();
			nodesParsed.add(travelDocumentNumberNode);
			//System.debug(this.travelDocumentNumber);
			DOM.XmlNode residenceStyleCodeNode = responseNode.getChildElement(
				'residenceStyleCode',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.residenceStyleCode = (residenceStyleCodeNode == null)
				? null
				: Long.valueOf(residenceStyleCodeNode.getText());
			nodesParsed.add(residenceStyleCodeNode);
			//System.debug(this.residenceStyleCode);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode cardTypeNode = outerNode.addChildElement(
				'cardType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cardTypeNode.addTextNode((this.cardType == null) ? '' : String.valueOf(this.cardType));
			Dom.XmlNode dateOfStayFromNode = outerNode.addChildElement(
				'dateOfStayFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateOfStayFromNode.addTextNode((this.dateOfStayFrom == null) ? '' : String.valueOf(this.dateOfStayFrom));
			Dom.XmlNode dateOfStayUntilNode = outerNode.addChildElement(
				'dateOfStayUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateOfStayUntilNode.addTextNode((this.dateOfStayUntil == null) ? '' : String.valueOf(this.dateOfStayUntil));
			Dom.XmlNode travelDocumentNumberNode = outerNode.addChildElement(
				'travelDocumentNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			travelDocumentNumberNode.addTextNode((this.travelDocumentNumber == null) ? '' : this.travelDocumentNumber);
			Dom.XmlNode residenceStyleCodeNode = outerNode.addChildElement(
				'residenceStyleCode',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.residenceStyleCode != null) {
				residenceStyleCodeNode.addTextNode(String.valueOf(this.residenceStyleCode));
			}
		}
	}
	public class GetReservedGlobalIdRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'GetReservedGlobalIdRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public GetReservedGlobalIdRequest() {
		}
		public GetReservedGlobalIdRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('getReservedGlobalId', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class GetReservedGlobalIdRequestBody {
		public String firstName;
		public String lastName;
		public String personalIdentityNumber;
		private transient String[] firstName_type_info = new List<String>{
			'firstName',
			s_ns0,
			'FirstNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] lastName_type_info = new List<String>{
			'lastName',
			s_ns0,
			'LastNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] personalIdentityNumber_type_info = new List<String>{
			'personalIdentityNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'firstName',
			'lastName',
			'personalIdentityNumber'
		};
		public GetReservedGlobalIdRequestBody() {
		}
		public GetReservedGlobalIdRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode firstNameNode = responseNode.getChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.firstName = (firstNameNode == null) ? null : firstNameNode.getText();
			nodesParsed.add(firstNameNode);
			//System.debug(this.firstName);
			DOM.XmlNode lastNameNode = responseNode.getChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.lastName = (lastNameNode == null) ? null : lastNameNode.getText();
			nodesParsed.add(lastNameNode);
			//System.debug(this.lastName);
			DOM.XmlNode personalIdentityNumberNode = responseNode.getChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalIdentityNumber = (personalIdentityNumberNode == null)
				? null
				: personalIdentityNumberNode.getText();
			nodesParsed.add(personalIdentityNumberNode);
			//System.debug(this.personalIdentityNumber);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode firstNameNode = outerNode.addChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.firstName != null) {
				firstNameNode.addTextNode(this.firstName);
			}
			Dom.XmlNode lastNameNode = outerNode.addChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.lastName != null) {
				lastNameNode.addTextNode(this.lastName);
			}
			Dom.XmlNode personalIdentityNumberNode = outerNode.addChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personalIdentityNumber != null) {
				personalIdentityNumberNode.addTextNode(this.personalIdentityNumber);
			}
		}
	}
	public class GetReservedGlobalIdResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_GetReservedGlobalIdResponse;
		private transient String[] responseHeader_GetReservedGlobalIdResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'GetReservedGlobalIdResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_GetReservedGlobalIdResponse',
			'responseBody'
		};
		public GetReservedGlobalIdResponse() {
		}
		public GetReservedGlobalIdResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('getReservedGlobalIdResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_GetReservedGlobalIdResponseNode = responseNode.getChildElement(
				'responseHeader_GetReservedGlobalIdResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_GetReservedGlobalIdResponseNode == null) {
				this.responseHeader_GetReservedGlobalIdResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_GetReservedGlobalIdResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_GetReservedGlobalIdResponseNode
				);
				nodesParsed.add(responseHeader_GetReservedGlobalIdResponseNode);
				this.responseHeader_GetReservedGlobalIdResponse = responseHeader_GetReservedGlobalIdResponseObj;
			}
			//System.debug(this.responseHeader_GetReservedGlobalIdResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class GetReservedGlobalIdResponseBody {
		public Long globalId;
		private transient String[] globalId_type_info = new List<String>{
			'globalId',
			s_ns0,
			'ClientGlobalIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'globalId'};
		public GetReservedGlobalIdResponseBody() {
		}
		public GetReservedGlobalIdResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode globalIdNode = responseNode.getChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.globalId = (globalIdNode == null) ? null : Long.valueOf(globalIdNode.getText());
			nodesParsed.add(globalIdNode);
			//System.debug(this.globalId);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode globalIdNode = outerNode.addChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.globalId != null) {
				globalIdNode.addTextNode(String.valueOf(this.globalId));
			}
		}
	}
	public class IdentityCardType {
		public String authority;
		public String number_x;
		public String personalNumber;
		public String transactionId;
		public Long type_x;
		// Restriction enumeration:
		public Date validUntil;
		public Long state;
		private transient String[] authority_type_info = new List<String>{
			'authority',
			s_ns0,
			'OrganizationNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] number_x_type_info = new List<String>{
			'number',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personalNumber_type_info = new List<String>{
			'personalNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] transactionId_type_info = new List<String>{
			'transactionId',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] type_x_type_info = new List<String>{
			'type',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] validUntil_type_info = new List<String>{
			'validUntil',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] state_type_info = new List<String>{
			'state',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'authority',
			'number_x',
			'personalNumber',
			'transactionId',
			'type_x',
			'validUntil',
			'state'
		};
		public IdentityCardType() {
		}
		public IdentityCardType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode authorityNode = responseNode.getChildElement(
				'authority',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.authority = (authorityNode == null) ? null : authorityNode.getText();
			nodesParsed.add(authorityNode);
			//System.debug(this.authority);
			DOM.XmlNode number_xNode = responseNode.getChildElement(
				'number',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.number_x = (number_xNode == null) ? null : number_xNode.getText();
			nodesParsed.add(number_xNode);
			//System.debug(this.number_x);
			DOM.XmlNode personalNumberNode = responseNode.getChildElement(
				'personalNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalNumber = (personalNumberNode == null) ? null : personalNumberNode.getText();
			nodesParsed.add(personalNumberNode);
			//System.debug(this.personalNumber);
			DOM.XmlNode transactionIdNode = responseNode.getChildElement(
				'transactionId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.transactionId = (transactionIdNode == null) ? null : transactionIdNode.getText();
			nodesParsed.add(transactionIdNode);
			//System.debug(this.transactionId);
			DOM.XmlNode type_xNode = responseNode.getChildElement(
				'type',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.type_x = (type_xNode == null) ? null : Long.valueOf(type_xNode.getText());
			nodesParsed.add(type_xNode);
			//System.debug(this.type_x);
			DOM.XmlNode validUntilNode = responseNode.getChildElement(
				'validUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validUntil = (validUntilNode == null) ? null : Date.valueOf(validUntilNode.getText());
			nodesParsed.add(validUntilNode);
			//System.debug(this.validUntil);
			DOM.XmlNode stateNode = responseNode.getChildElement(
				'state',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.state = (stateNode == null) ? null : Long.valueOf(stateNode.getText());
			nodesParsed.add(stateNode);
			//System.debug(this.state);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode authorityNode = outerNode.addChildElement(
				'authority',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			authorityNode.addTextNode((this.authority == null) ? '' : this.authority);
			Dom.XmlNode number_xNode = outerNode.addChildElement(
				'number',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			number_xNode.addTextNode((this.number_x == null) ? '' : this.number_x);
			Dom.XmlNode personalNumberNode = outerNode.addChildElement(
				'personalNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personalNumberNode.addTextNode((this.personalNumber == null) ? '' : this.personalNumber);
			Dom.XmlNode transactionIdNode = outerNode.addChildElement(
				'transactionId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			transactionIdNode.addTextNode((this.transactionId == null) ? '' : this.transactionId);
			Dom.XmlNode type_xNode = outerNode.addChildElement(
				'type',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			type_xNode.addTextNode((this.type_x == null) ? '' : String.valueOf(this.type_x));
			Dom.XmlNode validUntilNode = outerNode.addChildElement(
				'validUntil',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validUntilNode.addTextNode((this.validUntil == null) ? '' : String.valueOf(this.validUntil));
			Dom.XmlNode stateNode = outerNode.addChildElement(
				'state',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			stateNode.addTextNode((this.state == null) ? '' : String.valueOf(this.state));
		}
	}
	public class LegalEntityDataType {
		public String companyID;
		public String companyName;
		public Long legalForm;
		// Restriction enumeration:
		public Date dateWritingToOR;
		// Restriction enumeration:
		public Date companyEndDate;
		private transient String[] companyID_type_info = new List<String>{
			'companyID',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] companyName_type_info = new List<String>{
			'companyName',
			s_ns0,
			'CompanyNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] legalForm_type_info = new List<String>{
			'legalForm',
			s_ns0,
			'CodeListItemIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] dateWritingToOR_type_info = new List<String>{
			'dateWritingToOR',
			s_ns0,
			'CommonDateType',
			'1',
			'1',
			'false'
		};
		private transient String[] companyEndDate_type_info = new List<String>{
			'companyEndDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'companyID',
			'companyName',
			'legalForm',
			'dateWritingToOR',
			'companyEndDate'
		};
		public LegalEntityDataType() {
		}
		public LegalEntityDataType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode companyIDNode = responseNode.getChildElement(
				'companyID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.companyID = (companyIDNode == null) ? null : companyIDNode.getText();
			nodesParsed.add(companyIDNode);
			//System.debug(this.companyID);
			DOM.XmlNode companyNameNode = responseNode.getChildElement(
				'companyName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.companyName = (companyNameNode == null) ? null : companyNameNode.getText();
			nodesParsed.add(companyNameNode);
			//System.debug(this.companyName);
			DOM.XmlNode legalFormNode = responseNode.getChildElement(
				'legalForm',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.legalForm = (legalFormNode == null) ? null : Long.valueOf(legalFormNode.getText());
			nodesParsed.add(legalFormNode);
			//System.debug(this.legalForm);
			DOM.XmlNode dateWritingToORNode = responseNode.getChildElement(
				'dateWritingToOR',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateWritingToOR = (dateWritingToORNode == null) ? null : Date.valueOf(dateWritingToORNode.getText());
			nodesParsed.add(dateWritingToORNode);
			//System.debug(this.dateWritingToOR);
			DOM.XmlNode companyEndDateNode = responseNode.getChildElement(
				'companyEndDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.companyEndDate = (companyEndDateNode == null) ? null : Date.valueOf(companyEndDateNode.getText());
			nodesParsed.add(companyEndDateNode);
			//System.debug(this.companyEndDate);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode companyIDNode = outerNode.addChildElement(
				'companyID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.companyID != null) {
				companyIDNode.addTextNode(this.companyID);
			}
			Dom.XmlNode companyNameNode = outerNode.addChildElement(
				'companyName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.companyName != null) {
				companyNameNode.addTextNode(this.companyName);
			}
			Dom.XmlNode legalFormNode = outerNode.addChildElement(
				'legalForm',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.legalForm != null) {
				legalFormNode.addTextNode(String.valueOf(this.legalForm));
			}
			Dom.XmlNode dateWritingToORNode = outerNode.addChildElement(
				'dateWritingToOR',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.dateWritingToOR != null) {
				dateWritingToORNode.addTextNode(String.valueOf(this.dateWritingToOR));
			}
			Dom.XmlNode companyEndDateNode = outerNode.addChildElement(
				'companyEndDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			companyEndDateNode.addTextNode((this.companyEndDate == null) ? '' : String.valueOf(this.companyEndDate));
		}
	}
	public class ListOfCommunicationsItemType {
		public DateTime dateLastUpdate;
		public Long contactType;
		public Long agenda;
		public Long role;
		public Long objectID;
		public Long objectType;
		public Long contactSubType;
		// Restriction enumeration:
		public Date validFrom;
		// Restriction enumeration:
		public Date validTo;
		public PersonManagementSOAPServiceTypes.AddressType address;
		public PersonManagementSOAPServiceTypes.WebEmailType email;
		public PersonManagementSOAPServiceTypes.TelephoneType telephone;
		public Boolean delete_x;
		private transient String[] dateLastUpdate_type_info = new List<String>{
			'dateLastUpdate',
			s_ns0,
			'CommonDateTimeType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactType_type_info = new List<String>{
			'contactType',
			s_ns0,
			'CodeListItemIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] agenda_type_info = new List<String>{
			'agenda',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] role_type_info = new List<String>{
			'role',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] objectID_type_info = new List<String>{
			'objectID',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] objectType_type_info = new List<String>{
			'objectType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactSubType_type_info = new List<String>{
			'contactSubType',
			s_ns0,
			'CodeListItemIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] validFrom_type_info = new List<String>{
			'validFrom',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] validTo_type_info = new List<String>{
			'validTo',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] address_type_info = new List<String>{
			'address',
			s_ns0,
			'AddressType',
			'0',
			'1',
			'false'
		};
		private transient String[] email_type_info = new List<String>{
			'email',
			s_ns0,
			'WebEmailType',
			'0',
			'1',
			'false'
		};
		private transient String[] telephone_type_info = new List<String>{
			'telephone',
			s_ns0,
			'TelephoneType',
			'0',
			'1',
			'false'
		};
		private transient String[] delete_x_type_info = new List<String>{
			'delete',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'dateLastUpdate',
			'contactType',
			'agenda',
			'role',
			'objectID',
			'objectType',
			'contactSubType',
			'validFrom',
			'validTo',
			'address',
			'email',
			'telephone',
			'delete_x'
		};
		public ListOfCommunicationsItemType() {
		}
		public ListOfCommunicationsItemType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode dateLastUpdateNode = responseNode.getChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateLastUpdate = (dateLastUpdateNode == null)
				? null
				: PersonManagementSOAPServiceTypes.parseDateTime(dateLastUpdateNode.getText());
			nodesParsed.add(dateLastUpdateNode);
			//System.debug(this.dateLastUpdate);
			DOM.XmlNode contactTypeNode = responseNode.getChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactType = (contactTypeNode == null) ? null : Long.valueOf(contactTypeNode.getText());
			nodesParsed.add(contactTypeNode);
			//System.debug(this.contactType);
			DOM.XmlNode agendaNode = responseNode.getChildElement(
				'agenda',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.agenda = (agendaNode == null) ? null : Long.valueOf(agendaNode.getText());
			nodesParsed.add(agendaNode);
			//System.debug(this.agenda);
			DOM.XmlNode roleNode = responseNode.getChildElement(
				'role',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.role = (roleNode == null) ? null : Long.valueOf(roleNode.getText());
			nodesParsed.add(roleNode);
			//System.debug(this.role);
			DOM.XmlNode objectIDNode = responseNode.getChildElement(
				'objectID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.objectID = (objectIDNode == null) ? null : Long.valueOf(objectIDNode.getText());
			nodesParsed.add(objectIDNode);
			//System.debug(this.objectID);
			DOM.XmlNode objectTypeNode = responseNode.getChildElement(
				'objectType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.objectType = (objectTypeNode == null) ? null : Long.valueOf(objectTypeNode.getText());
			nodesParsed.add(objectTypeNode);
			//System.debug(this.objectType);
			DOM.XmlNode contactSubTypeNode = responseNode.getChildElement(
				'contactSubType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactSubType = (contactSubTypeNode == null) ? null : Long.valueOf(contactSubTypeNode.getText());
			nodesParsed.add(contactSubTypeNode);
			//System.debug(this.contactSubType);
			DOM.XmlNode validFromNode = responseNode.getChildElement(
				'validFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validFrom = (validFromNode == null) ? null : Date.valueOf(validFromNode.getText());
			nodesParsed.add(validFromNode);
			//System.debug(this.validFrom);
			DOM.XmlNode validToNode = responseNode.getChildElement(
				'validTo',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validTo = (validToNode == null) ? null : Date.valueOf(validToNode.getText());
			nodesParsed.add(validToNode);
			//System.debug(this.validTo);
			DOM.XmlNode addressNode = responseNode.getChildElement(
				'address',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (addressNode == null) {
				this.address = null;
			} else {
				PersonManagementSOAPServiceTypes.AddressType addressObj = new PersonManagementSOAPServiceTypes.AddressType(
					addressNode
				);
				nodesParsed.add(addressNode);
				this.address = addressObj;
			}
			//System.debug(this.address);
			DOM.XmlNode emailNode = responseNode.getChildElement(
				'email',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (emailNode == null) {
				this.email = null;
			} else {
				PersonManagementSOAPServiceTypes.WebEmailType emailObj = new PersonManagementSOAPServiceTypes.WebEmailType(
					emailNode
				);
				nodesParsed.add(emailNode);
				this.email = emailObj;
			}
			//System.debug(this.email);
			DOM.XmlNode telephoneNode = responseNode.getChildElement(
				'telephone',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (telephoneNode == null) {
				this.telephone = null;
			} else {
				PersonManagementSOAPServiceTypes.TelephoneType telephoneObj = new PersonManagementSOAPServiceTypes.TelephoneType(
					telephoneNode
				);
				nodesParsed.add(telephoneNode);
				this.telephone = telephoneObj;
			}
			//System.debug(this.telephone);
			DOM.XmlNode delete_xNode = responseNode.getChildElement(
				'delete',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.delete_x = (delete_xNode == null) ? null : Boolean.valueOf(delete_xNode.getText());
			nodesParsed.add(delete_xNode);
			//System.debug(this.delete_x);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode dateLastUpdateNode = outerNode.addChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateLastUpdateNode.addTextNode((this.dateLastUpdate == null) ? '' : String.valueOf(this.dateLastUpdate));
			Dom.XmlNode contactTypeNode = outerNode.addChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.contactType != null) {
				contactTypeNode.addTextNode(String.valueOf(this.contactType));
			}
			Dom.XmlNode agendaNode = outerNode.addChildElement(
				'agenda',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			agendaNode.addTextNode((this.agenda == null) ? '' : String.valueOf(this.agenda));
			Dom.XmlNode roleNode = outerNode.addChildElement(
				'role',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			roleNode.addTextNode((this.role == null) ? '' : String.valueOf(this.role));
			Dom.XmlNode objectIDNode = outerNode.addChildElement(
				'objectID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			objectIDNode.addTextNode((this.objectID == null) ? '' : String.valueOf(this.objectID));
			Dom.XmlNode objectTypeNode = outerNode.addChildElement(
				'objectType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			objectTypeNode.addTextNode((this.objectType == null) ? '' : String.valueOf(this.objectType));
			Dom.XmlNode contactSubTypeNode = outerNode.addChildElement(
				'contactSubType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.contactSubType != null) {
				contactSubTypeNode.addTextNode(String.valueOf(this.contactSubType));
			}
			Dom.XmlNode validFromNode = outerNode.addChildElement(
				'validFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validFromNode.addTextNode((this.validFrom == null) ? '' : String.valueOf(this.validFrom));
			Dom.XmlNode validToNode = outerNode.addChildElement(
				'validTo',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validToNode.addTextNode((this.validTo == null) ? '' : String.valueOf(this.validTo));

			PersonManagementSOAPServiceTypes.AddressType addressObj = this.address;
			Dom.XmlNode addressNode = outerNode.addChildElement(
				'address',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (addressObj != null) {
				addressObj.populateXmlNode(addressNode);
			}

			PersonManagementSOAPServiceTypes.WebEmailType emailObj = this.email;
			Dom.XmlNode emailNode = outerNode.addChildElement(
				'email',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (emailObj != null) {
				emailObj.populateXmlNode(emailNode);
			}

			PersonManagementSOAPServiceTypes.TelephoneType telephoneObj = this.telephone;
			Dom.XmlNode telephoneNode = outerNode.addChildElement(
				'telephone',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (telephoneObj != null) {
				telephoneObj.populateXmlNode(telephoneNode);
			}
			Dom.XmlNode delete_xNode = outerNode.addChildElement(
				'delete',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			delete_xNode.addTextNode((this.delete_x == null) ? '' : String.valueOf(this.delete_x));
		}
	}
	public class ListOfCommunicationsType {
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType[] listOfCommunicationsItem;
		private transient String[] listOfCommunicationsItem_type_info = new List<String>{
			'listOfCommunicationsItem',
			s_ns0,
			'ListOfCommunicationsItemType',
			'0',
			'-1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'listOfCommunicationsItem'};
		public ListOfCommunicationsType() {
		}
		public ListOfCommunicationsType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			Dom.XmlNode[] listOfCommunicationsItemChildren = responseNode.getChildElements();
			PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType[] listOfCommunicationsItemList = new List<PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType>();
			if (listOfCommunicationsItemChildren == null || listOfCommunicationsItemChildren.size() == 0) {
				this.listOfCommunicationsItem = null;
			} else {
				for (DOM.XmlNode childNode : listOfCommunicationsItemChildren) {
					if (childNode.GetName() == 'listOfCommunicationsItem') {
						PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType Obj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType(
							childNode
						);
						listOfCommunicationsItemList.Add(Obj);
						nodesParsed.add(childNode);
					}
				}
				this.listOfCommunicationsItem = listOfCommunicationsItemList;
			}
			//System.debug(this.listOfCommunicationsItem);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType[] listOfCommunicationsItemObj = this.listOfCommunicationsItem;
			if (listOfCommunicationsItemObj != null) {
				for (
					PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType element : listOfCommunicationsItemObj
				) {
					Dom.XmlNode listOfCommunicationsItemNode = outerNode.addChildElement(
						'listOfCommunicationsItem',
						'http://service.cmss.cz/person/PersonManagementService/v10',
						''
					);
					element.populateXmlNode(listOfCommunicationsItemNode);
				}
			}
		}
	}
	public class ListOfPersonsItemType {
		// Restriction enumeration:
		public Date birthDate;
		public String city;
		public String dataShareLevel;
		public String firstName;
		public String lastName;
		public Long personNumber;
		public String personType;
		public String personalIdentityNumber;
		public String citizenship;
		public Boolean isPoliticallyExposed;
		public String globalId;
		public String accountType;
		private transient String[] birthDate_type_info = new List<String>{
			'birthDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] city_type_info = new List<String>{
			'city',
			s_ns0,
			'CityNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] dataShareLevel_type_info = new List<String>{
			'dataShareLevel',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] firstName_type_info = new List<String>{
			'firstName',
			s_ns0,
			'FirstNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] lastName_type_info = new List<String>{
			'lastName',
			s_ns0,
			'LastNameType',
			'0',
			'1',
			'false'
		};
		private transient String[] personNumber_type_info = new List<String>{
			'personNumber',
			s_ns0,
			'PersonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] personType_type_info = new List<String>{
			'personType',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] personalIdentityNumber_type_info = new List<String>{
			'personalIdentityNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] citizenship_type_info = new List<String>{
			'citizenship',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] isPoliticallyExposed_type_info = new List<String>{
			'isPoliticallyExposed',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] globalId_type_info = new List<String>{
			'globalId',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] accountType_type_info = new List<String>{
			'accountType',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'birthDate',
			'city',
			'dataShareLevel',
			'firstName',
			'lastName',
			'personNumber',
			'personType',
			'personalIdentityNumber',
			'citizenship',
			'isPoliticallyExposed',
			'globalId',
			'accountType'
		};
		public ListOfPersonsItemType() {
		}
		public ListOfPersonsItemType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode birthDateNode = responseNode.getChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.birthDate = (birthDateNode == null) ? null : Date.valueOf(birthDateNode.getText());
			nodesParsed.add(birthDateNode);
			//System.debug(this.birthDate);
			DOM.XmlNode cityNode = responseNode.getChildElement(
				'city',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.city = (cityNode == null) ? null : cityNode.getText();
			nodesParsed.add(cityNode);
			//System.debug(this.city);
			DOM.XmlNode dataShareLevelNode = responseNode.getChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dataShareLevel = (dataShareLevelNode == null) ? null : dataShareLevelNode.getText();
			nodesParsed.add(dataShareLevelNode);
			//System.debug(this.dataShareLevel);
			DOM.XmlNode firstNameNode = responseNode.getChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.firstName = (firstNameNode == null) ? null : firstNameNode.getText();
			nodesParsed.add(firstNameNode);
			//System.debug(this.firstName);
			DOM.XmlNode lastNameNode = responseNode.getChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.lastName = (lastNameNode == null) ? null : lastNameNode.getText();
			nodesParsed.add(lastNameNode);
			//System.debug(this.lastName);
			DOM.XmlNode personNumberNode = responseNode.getChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personNumber = (personNumberNode == null) ? null : Long.valueOf(personNumberNode.getText());
			nodesParsed.add(personNumberNode);
			//System.debug(this.personNumber);
			DOM.XmlNode personTypeNode = responseNode.getChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personType = (personTypeNode == null) ? null : personTypeNode.getText();
			nodesParsed.add(personTypeNode);
			//System.debug(this.personType);
			DOM.XmlNode personalIdentityNumberNode = responseNode.getChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalIdentityNumber = (personalIdentityNumberNode == null)
				? null
				: personalIdentityNumberNode.getText();
			nodesParsed.add(personalIdentityNumberNode);
			//System.debug(this.personalIdentityNumber);
			DOM.XmlNode citizenshipNode = responseNode.getChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.citizenship = (citizenshipNode == null) ? null : citizenshipNode.getText();
			nodesParsed.add(citizenshipNode);
			//System.debug(this.citizenship);
			DOM.XmlNode isPoliticallyExposedNode = responseNode.getChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.isPoliticallyExposed = (isPoliticallyExposedNode == null)
				? null
				: Boolean.valueOf(isPoliticallyExposedNode.getText());
			nodesParsed.add(isPoliticallyExposedNode);
			//System.debug(this.isPoliticallyExposed);
			DOM.XmlNode globalIdNode = responseNode.getChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.globalId = (globalIdNode == null) ? null : globalIdNode.getText();
			nodesParsed.add(globalIdNode);
			//System.debug(this.globalId);
			DOM.XmlNode accountTypeNode = responseNode.getChildElement(
				'accountType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.accountType = (accountTypeNode == null) ? null : accountTypeNode.getText();
			nodesParsed.add(accountTypeNode);
			//System.debug(this.accountType);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode birthDateNode = outerNode.addChildElement(
				'birthDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			birthDateNode.addTextNode((this.birthDate == null) ? '' : String.valueOf(this.birthDate));
			Dom.XmlNode cityNode = outerNode.addChildElement(
				'city',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			cityNode.addTextNode((this.city == null) ? '' : this.city);
			Dom.XmlNode dataShareLevelNode = outerNode.addChildElement(
				'dataShareLevel',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dataShareLevelNode.addTextNode((this.dataShareLevel == null) ? '' : this.dataShareLevel);
			Dom.XmlNode firstNameNode = outerNode.addChildElement(
				'firstName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			firstNameNode.addTextNode((this.firstName == null) ? '' : this.firstName);
			Dom.XmlNode lastNameNode = outerNode.addChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			lastNameNode.addTextNode((this.lastName == null) ? '' : this.lastName);
			Dom.XmlNode personNumberNode = outerNode.addChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personNumberNode.addTextNode((this.personNumber == null) ? '' : String.valueOf(this.personNumber));
			Dom.XmlNode personTypeNode = outerNode.addChildElement(
				'personType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personTypeNode.addTextNode((this.personType == null) ? '' : this.personType);
			Dom.XmlNode personalIdentityNumberNode = outerNode.addChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personalIdentityNumberNode.addTextNode(
				(this.personalIdentityNumber == null) ? '' : this.personalIdentityNumber
			);
			Dom.XmlNode citizenshipNode = outerNode.addChildElement(
				'citizenship',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			citizenshipNode.addTextNode((this.citizenship == null) ? '' : this.citizenship);
			Dom.XmlNode isPoliticallyExposedNode = outerNode.addChildElement(
				'isPoliticallyExposed',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			isPoliticallyExposedNode.addTextNode(
				(this.isPoliticallyExposed == null) ? '' : String.valueOf(this.isPoliticallyExposed)
			);
			Dom.XmlNode globalIdNode = outerNode.addChildElement(
				'globalId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.globalId != null) {
				globalIdNode.addTextNode(this.globalId);
			}
			Dom.XmlNode accountTypeNode = outerNode.addChildElement(
				'accountType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.accountType != null) {
				accountTypeNode.addTextNode(this.accountType);
			}
		}
	}
	public class ListOfPersonsType {
		public PersonManagementSOAPServiceTypes.ListOfPersonsItemType[] listOfPersonsItem;
		private transient String[] listOfPersonsItem_type_info = new List<String>{
			'listOfPersonsItem',
			s_ns0,
			'ListOfPersonsItemType',
			'0',
			'-1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'listOfPersonsItem'};
		public ListOfPersonsType() {
		}
		public ListOfPersonsType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			Dom.XmlNode[] listOfPersonsItemChildren = responseNode.getChildElements();
			PersonManagementSOAPServiceTypes.ListOfPersonsItemType[] listOfPersonsItemList = new List<PersonManagementSOAPServiceTypes.ListOfPersonsItemType>();
			if (listOfPersonsItemChildren == null || listOfPersonsItemChildren.size() == 0) {
				this.listOfPersonsItem = null;
			} else {
				for (DOM.XmlNode childNode : listOfPersonsItemChildren) {
					if (childNode.GetName() == 'listOfPersonsItem') {
						PersonManagementSOAPServiceTypes.ListOfPersonsItemType Obj = new PersonManagementSOAPServiceTypes.ListOfPersonsItemType(
							childNode
						);
						listOfPersonsItemList.Add(Obj);
						nodesParsed.add(childNode);
					}
				}
				this.listOfPersonsItem = listOfPersonsItemList;
			}
			//System.debug(this.listOfPersonsItem);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.ListOfPersonsItemType[] listOfPersonsItemObj = this.listOfPersonsItem;
			if (listOfPersonsItemObj != null) {
				for (PersonManagementSOAPServiceTypes.ListOfPersonsItemType element : listOfPersonsItemObj) {
					Dom.XmlNode listOfPersonsItemNode = outerNode.addChildElement(
						'listOfPersonsItem',
						'http://service.cmss.cz/person/PersonManagementService/v10',
						''
					);
					element.populateXmlNode(listOfPersonsItemNode);
				}
			}
		}
	}

	public class PersonRelationType {
		public Long sourceCustomerId;
		public String sourceContactId;
		public Long destinationCustomerId;
		public String destinationContactId;
		public String relationRole;
		// Restriction enumeration:
		public Date validFrom;
		// Restriction enumeration:
		public Date validTo;
		public Long relationType;
		private transient String[] sourceCustomerId_type_info = new List<String>{
			'sourceCustomerId',
			s_ns0,
			'ClientGlobalIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] sourceContactId_type_info = new List<String>{
			'sourceContactId',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] destinationCustomerId_type_info = new List<String>{
			'destinationCustomerId',
			s_ns0,
			'ClientGlobalIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] destinationContactId_type_info = new List<String>{
			'destinationContactId',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] relationRole_type_info = new List<String>{
			'relationRole',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] validFrom_type_info = new List<String>{
			'validFrom',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] validTo_type_info = new List<String>{
			'validTo',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] relationType_type_info = new List<String>{
			'relationType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'sourceCustomerId',
			'sourceContactId',
			'destinationCustomerId',
			'destinationContactId',
			'relationRole',
			'validFrom',
			'validTo',
			'relationType'
		};
		public PersonRelationType() {
		}
		public PersonRelationType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode sourceCustomerIdNode = responseNode.getChildElement(
				'sourceCustomerId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.sourceCustomerId = (sourceCustomerIdNode == null)
				? null
				: Long.valueOf(sourceCustomerIdNode.getText());
			nodesParsed.add(sourceCustomerIdNode);
			//System.debug(this.sourceCustomerId);
			DOM.XmlNode sourceContactIdNode = responseNode.getChildElement(
				'sourceContactId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.sourceContactId = (sourceContactIdNode == null) ? null : sourceContactIdNode.getText();
			nodesParsed.add(sourceContactIdNode);
			//System.debug(this.sourceContactId);
			DOM.XmlNode destinationCustomerIdNode = responseNode.getChildElement(
				'destinationCustomerId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.destinationCustomerId = (destinationCustomerIdNode == null)
				? null
				: Long.valueOf(destinationCustomerIdNode.getText());
			nodesParsed.add(destinationCustomerIdNode);
			//System.debug(this.destinationCustomerId);
			DOM.XmlNode destinationContactIdNode = responseNode.getChildElement(
				'destinationContactId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.destinationContactId = (destinationContactIdNode == null) ? null : destinationContactIdNode.getText();
			nodesParsed.add(destinationContactIdNode);
			//System.debug(this.destinationContactId);
			DOM.XmlNode relationRoleNode = responseNode.getChildElement(
				'relationRole',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.relationRole = (relationRoleNode == null) ? null : relationRoleNode.getText();
			nodesParsed.add(relationRoleNode);
			//System.debug(this.relationRole);
			DOM.XmlNode validFromNode = responseNode.getChildElement(
				'validFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validFrom = (validFromNode == null) ? null : Date.valueOf(validFromNode.getText());
			nodesParsed.add(validFromNode);
			//System.debug(this.validFrom);
			DOM.XmlNode validToNode = responseNode.getChildElement(
				'validTo',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validTo = (validToNode == null) ? null : Date.valueOf(validToNode.getText());
			nodesParsed.add(validToNode);
			//System.debug(this.validTo);
			DOM.XmlNode relationTypeNode = responseNode.getChildElement(
				'relationType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.relationType = (relationTypeNode == null) ? null : Long.valueOf(relationTypeNode.getText());
			nodesParsed.add(relationTypeNode);
			//System.debug(this.relationType);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode sourceCustomerIdNode = outerNode.addChildElement(
				'sourceCustomerId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			sourceCustomerIdNode.addTextNode(
				(this.sourceCustomerId == null) ? '' : String.valueOf(this.sourceCustomerId)
			);
			Dom.XmlNode sourceContactIdNode = outerNode.addChildElement(
				'sourceContactId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			sourceContactIdNode.addTextNode((this.sourceContactId == null) ? '' : this.sourceContactId);
			Dom.XmlNode destinationCustomerIdNode = outerNode.addChildElement(
				'destinationCustomerId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			destinationCustomerIdNode.addTextNode(
				(this.destinationCustomerId == null) ? '' : String.valueOf(this.destinationCustomerId)
			);
			Dom.XmlNode destinationContactIdNode = outerNode.addChildElement(
				'destinationContactId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			destinationContactIdNode.addTextNode((this.destinationContactId == null) ? '' : this.destinationContactId);
			Dom.XmlNode relationRoleNode = outerNode.addChildElement(
				'relationRole',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			relationRoleNode.addTextNode((this.relationRole == null) ? '' : this.relationRole);
			Dom.XmlNode validFromNode = outerNode.addChildElement(
				'validFrom',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validFromNode.addTextNode((this.validFrom == null) ? '' : String.valueOf(this.validFrom));
			Dom.XmlNode validToNode = outerNode.addChildElement(
				'validTo',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validToNode.addTextNode((this.validTo == null) ? '' : String.valueOf(this.validTo));
			Dom.XmlNode relationTypeNode = outerNode.addChildElement(
				'relationType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			relationTypeNode.addTextNode((this.relationType == null) ? '' : String.valueOf(this.relationType));
		}
	}
	public class SearchCSOBSNonClientRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		private transient String[] requestHeader_SearchCSOBSNonClientRequest_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'SearchCSOBSNonClientRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public SearchCSOBSNonClientRequest() {
		}
		public SearchCSOBSNonClientRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('searchCSOBSNonClient', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement('v01:requestHeader', null, null);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement('v10:requestBody', null, null);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class SearchCSOBSNonClientRequestBody {
		public String personalIdentificationNumber;
		public String lastName;
		private transient String[] personalIdentificationNumber_type_info = new List<String>{
			'personalIdentificationNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] lastName_type_info = new List<String>{
			'lastName',
			s_ns0,
			'LastNameType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'personalIdentificationNumber',
			'lastName'
		};
		public SearchCSOBSNonClientRequestBody() {
		}
		public SearchCSOBSNonClientRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode personalIdentificationNumberNode = responseNode.getChildElement(
				'personalIdentificationNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalIdentificationNumber = (personalIdentificationNumberNode == null)
				? null
				: personalIdentificationNumberNode.getText();
			nodesParsed.add(personalIdentificationNumberNode);
			//System.debug(this.personalIdentificationNumber);
			DOM.XmlNode lastNameNode = responseNode.getChildElement(
				'lastName',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.lastName = (lastNameNode == null) ? null : lastNameNode.getText();
			nodesParsed.add(lastNameNode);
			//System.debug(this.lastName);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode personalIdentificationNumberNode = outerNode.addChildElement(
				'v10:personalIdentificationNumber',
				null,
				null
			);
			if (this.personalIdentificationNumber != null) {
				personalIdentificationNumberNode.addTextNode(this.personalIdentificationNumber);
			}
			Dom.XmlNode lastNameNode = outerNode.addChildElement('v10:lastName', null, null);
			if (this.lastName != null) {
				lastNameNode.addTextNode(this.lastName);
			}
		}
	}
	public class SearchCSOBSNonClientResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_SearchCSOBSNonClientResponse;
		private transient String[] responseHeader_SearchCSOBSNonClientResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'SearchCSOBSNonClientResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_SearchCSOBSNonClientResponse',
			'responseBody'
		};
		public SearchCSOBSNonClientResponse() {
		}
		public SearchCSOBSNonClientResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('searchCSOBSNonClientResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_SearchCSOBSNonClientResponseNode = responseNode.getChildElement(
				'responseHeader_SearchCSOBSNonClientResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_SearchCSOBSNonClientResponseNode == null) {
				this.responseHeader_SearchCSOBSNonClientResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_SearchCSOBSNonClientResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_SearchCSOBSNonClientResponseNode
				);
				nodesParsed.add(responseHeader_SearchCSOBSNonClientResponseNode);
				this.responseHeader_SearchCSOBSNonClientResponse = responseHeader_SearchCSOBSNonClientResponseObj;
			}
			//System.debug(this.responseHeader_SearchCSOBSNonClientResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class SearchCSOBSNonClientResponseBody {
		public String jsonResponse;
		private transient String[] jsonResponse_type_info = new List<String>{
			'jsonResponse',
			s_ns0,
			'AlphanumericStringType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'jsonResponse'};
		public SearchCSOBSNonClientResponseBody() {
		}
		public SearchCSOBSNonClientResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode jsonResponseNode = responseNode.getChildElement(
				'jsonResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.jsonResponse = (jsonResponseNode == null) ? null : jsonResponseNode.getText();
			nodesParsed.add(jsonResponseNode);
			//System.debug(this.jsonResponse);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode jsonResponseNode = outerNode.addChildElement(
				'jsonResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.jsonResponse != null) {
				jsonResponseNode.addTextNode(this.jsonResponse);
			}
		}
	}
	public class SearchPersonByIdNumberRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'SearchPersonByIdNumberRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public SearchPersonByIdNumberRequest() {
		}
		public SearchPersonByIdNumberRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('searchPersonByIdNumber', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class SearchPersonByIdNumberRequestBody {
		public String personalIdentityNumber;
		public String externalId;
		public Long systemId;
		private transient String[] personalIdentityNumber_type_info = new List<String>{
			'personalIdentityNumber',
			s_ns0,
			'PersonalIdentityNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] externalId_type_info = new List<String>{
			'externalId',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] systemId_type_info = new List<String>{
			'systemId',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'personalIdentityNumber',
			'externalId',
			'systemId'
		};
		public SearchPersonByIdNumberRequestBody() {
		}
		public SearchPersonByIdNumberRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode personalIdentityNumberNode = responseNode.getChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personalIdentityNumber = (personalIdentityNumberNode == null)
				? null
				: personalIdentityNumberNode.getText();
			nodesParsed.add(personalIdentityNumberNode);
			//System.debug(this.personalIdentityNumber);
			DOM.XmlNode externalIdNode = responseNode.getChildElement(
				'externalId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.externalId = (externalIdNode == null) ? null : externalIdNode.getText();
			nodesParsed.add(externalIdNode);
			//System.debug(this.externalId);
			DOM.XmlNode systemIdNode = responseNode.getChildElement(
				'systemId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.systemId = (systemIdNode == null) ? null : Long.valueOf(systemIdNode.getText());
			nodesParsed.add(systemIdNode);
			//System.debug(this.systemId);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode personalIdentityNumberNode = outerNode.addChildElement(
				'personalIdentityNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			personalIdentityNumberNode.addTextNode(
				(this.personalIdentityNumber == null) ? '' : this.personalIdentityNumber
			);
			Dom.XmlNode externalIdNode = outerNode.addChildElement(
				'externalId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			externalIdNode.addTextNode((this.externalId == null) ? '' : this.externalId);
			Dom.XmlNode systemIdNode = outerNode.addChildElement(
				'systemId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			systemIdNode.addTextNode((this.systemId == null) ? '' : String.valueOf(this.systemId));
		}
	}
	public class SearchPersonByIdNumberResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_SearchPersonByIdNumberResponse;
		private transient String[] responseHeader_SearchPersonByIdNumberResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'SearchPersonByIdNumberResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_SearchPersonByIdNumberResponse',
			'responseBody'
		};
		public SearchPersonByIdNumberResponse() {
		}
		public SearchPersonByIdNumberResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('searchPersonByIdNumberResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_SearchPersonByIdNumberResponseNode = responseNode.getChildElement(
				'responseHeader_SearchPersonByIdNumberResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_SearchPersonByIdNumberResponseNode == null) {
				this.responseHeader_SearchPersonByIdNumberResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_SearchPersonByIdNumberResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_SearchPersonByIdNumberResponseNode
				);
				nodesParsed.add(responseHeader_SearchPersonByIdNumberResponseNode);
				this.responseHeader_SearchPersonByIdNumberResponse = responseHeader_SearchPersonByIdNumberResponseObj;
			}
			//System.debug(this.responseHeader_SearchPersonByIdNumberResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class SearchPersonByIdNumberResponseBody {
		public PersonManagementSOAPServiceTypes.ListOfPersonsType listOfPersons;
		private transient String[] listOfPersons_type_info = new List<String>{
			'listOfPersons',
			s_ns0,
			'ListOfPersonsType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'listOfPersons'};
		public SearchPersonByIdNumberResponseBody() {
		}
		public SearchPersonByIdNumberResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode listOfPersonsNode = responseNode.getChildElement(
				'listOfPersons',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfPersonsNode == null) {
				this.listOfPersons = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfPersonsType listOfPersonsObj = new PersonManagementSOAPServiceTypes.ListOfPersonsType(
					listOfPersonsNode
				);
				nodesParsed.add(listOfPersonsNode);
				this.listOfPersons = listOfPersonsObj;
			}
			//System.debug(this.listOfPersons);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.ListOfPersonsType listOfPersonsObj = this.listOfPersons;
			Dom.XmlNode listOfPersonsNode = outerNode.addChildElement(
				'listOfPersons',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfPersonsObj != null) {
				listOfPersonsObj.populateXmlNode(listOfPersonsNode);
			}
		}
	}
	public class TelephoneType {
		public DateTime dateLastUpdate;
		public String phone;
		public String note;
		public Long contactFlag;
		public Long contactId;
		public Long telephoneType;
		// Restriction enumeration:
		public Date validFromDate;
		// Restriction enumeration:
		public Date validToDate;
		public String sourceApp;
		public Long dataSource;
		public Long contactType;
		public String priority;
		public Boolean nonConfirm;
		public String communicationMCSBGUID;
		private transient String[] dateLastUpdate_type_info = new List<String>{
			'dateLastUpdate',
			s_ns0,
			'CommonDateTimeType',
			'0',
			'1',
			'false'
		};
		private transient String[] phone_type_info = new List<String>{
			'phone',
			s_ns0,
			'PhoneNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] note_type_info = new List<String>{
			'note',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactFlag_type_info = new List<String>{
			'contactFlag',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactId_type_info = new List<String>{
			'contactId',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] telephoneType_type_info = new List<String>{
			'telephoneType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] validFromDate_type_info = new List<String>{
			'validFromDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] validToDate_type_info = new List<String>{
			'validToDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] sourceApp_type_info = new List<String>{
			'sourceApp',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] dataSource_type_info = new List<String>{
			'dataSource',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactType_type_info = new List<String>{
			'contactType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] priority_type_info = new List<String>{
			'priority',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] nonConfirm_type_info = new List<String>{
			'nonConfirm',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] communicationMCSBGUID_type_info = new List<String>{
			'communicationMCSBGUID',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'dateLastUpdate',
			'phone',
			'note',
			'contactFlag',
			'contactId',
			'telephoneType',
			'validFromDate',
			'validToDate',
			'sourceApp',
			'dataSource',
			'contactType',
			'priority',
			'nonConfirm',
			'communicationMCSBGUID'
		};
		public TelephoneType() {
		}
		public TelephoneType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode dateLastUpdateNode = responseNode.getChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateLastUpdate = (dateLastUpdateNode == null)
				? null
				: PersonManagementSOAPServiceTypes.parseDateTime(dateLastUpdateNode.getText());
			nodesParsed.add(dateLastUpdateNode);
			//System.debug(this.dateLastUpdate);
			DOM.XmlNode phoneNode = responseNode.getChildElement(
				'phone',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.phone = (phoneNode == null) ? null : phoneNode.getText();
			nodesParsed.add(phoneNode);
			//System.debug(this.phone);
			DOM.XmlNode noteNode = responseNode.getChildElement(
				'note',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.note = (noteNode == null) ? null : noteNode.getText();
			nodesParsed.add(noteNode);
			//System.debug(this.note);
			DOM.XmlNode contactFlagNode = responseNode.getChildElement(
				'contactFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactFlag = (contactFlagNode == null) ? null : Long.valueOf(contactFlagNode.getText());
			nodesParsed.add(contactFlagNode);
			//System.debug(this.contactFlag);
			DOM.XmlNode contactIdNode = responseNode.getChildElement(
				'contactId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactId = (contactIdNode == null) ? null : Long.valueOf(contactIdNode.getText());
			nodesParsed.add(contactIdNode);
			//System.debug(this.contactId);
			DOM.XmlNode telephoneTypeNode = responseNode.getChildElement(
				'telephoneType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.telephoneType = (telephoneTypeNode == null) ? null : Long.valueOf(telephoneTypeNode.getText());
			nodesParsed.add(telephoneTypeNode);
			//System.debug(this.telephoneType);
			DOM.XmlNode validFromDateNode = responseNode.getChildElement(
				'validFromDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validFromDate = (validFromDateNode == null) ? null : Date.valueOf(validFromDateNode.getText());
			nodesParsed.add(validFromDateNode);
			//System.debug(this.validFromDate);
			DOM.XmlNode validToDateNode = responseNode.getChildElement(
				'validToDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validToDate = (validToDateNode == null) ? null : Date.valueOf(validToDateNode.getText());
			nodesParsed.add(validToDateNode);
			//System.debug(this.validToDate);
			DOM.XmlNode sourceAppNode = responseNode.getChildElement(
				'sourceApp',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.sourceApp = (sourceAppNode == null) ? null : sourceAppNode.getText();
			nodesParsed.add(sourceAppNode);
			//System.debug(this.sourceApp);
			DOM.XmlNode dataSourceNode = responseNode.getChildElement(
				'dataSource',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dataSource = (dataSourceNode == null) ? null : Long.valueOf(dataSourceNode.getText());
			nodesParsed.add(dataSourceNode);
			//System.debug(this.dataSource);
			DOM.XmlNode contactTypeNode = responseNode.getChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactType = (contactTypeNode == null) ? null : Long.valueOf(contactTypeNode.getText());
			nodesParsed.add(contactTypeNode);
			//System.debug(this.contactType);
			DOM.XmlNode priorityNode = responseNode.getChildElement(
				'priority',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.priority = (priorityNode == null) ? null : priorityNode.getText();
			nodesParsed.add(priorityNode);
			//System.debug(this.priority);
			DOM.XmlNode nonConfirmNode = responseNode.getChildElement(
				'nonConfirm',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.nonConfirm = (nonConfirmNode == null) ? null : Boolean.valueOf(nonConfirmNode.getText());
			nodesParsed.add(nonConfirmNode);
			//System.debug(this.nonConfirm);
			DOM.XmlNode communicationMCSBGUIDNode = responseNode.getChildElement(
				'communicationMCSBGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.communicationMCSBGUID = (communicationMCSBGUIDNode == null)
				? null
				: communicationMCSBGUIDNode.getText();
			nodesParsed.add(communicationMCSBGUIDNode);
			//System.debug(this.communicationMCSBGUID);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode dateLastUpdateNode = outerNode.addChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateLastUpdateNode.addTextNode((this.dateLastUpdate == null) ? '' : String.valueOf(this.dateLastUpdate));
			Dom.XmlNode phoneNode = outerNode.addChildElement(
				'phone',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.phone != null) {
				phoneNode.addTextNode(this.phone);
			}
			Dom.XmlNode noteNode = outerNode.addChildElement(
				'note',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			noteNode.addTextNode((this.note == null) ? '' : this.note);
			Dom.XmlNode contactFlagNode = outerNode.addChildElement(
				'contactFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactFlagNode.addTextNode((this.contactFlag == null) ? '' : String.valueOf(this.contactFlag));
			Dom.XmlNode contactIdNode = outerNode.addChildElement(
				'contactId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactIdNode.addTextNode((this.contactId == null) ? '' : String.valueOf(this.contactId));
			Dom.XmlNode telephoneTypeNode = outerNode.addChildElement(
				'telephoneType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			telephoneTypeNode.addTextNode((this.telephoneType == null) ? '' : String.valueOf(this.telephoneType));
			Dom.XmlNode validFromDateNode = outerNode.addChildElement(
				'validFromDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validFromDateNode.addTextNode((this.validFromDate == null) ? '' : String.valueOf(this.validFromDate));
			Dom.XmlNode validToDateNode = outerNode.addChildElement(
				'validToDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validToDateNode.addTextNode((this.validToDate == null) ? '' : String.valueOf(this.validToDate));
			Dom.XmlNode sourceAppNode = outerNode.addChildElement(
				'sourceApp',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			sourceAppNode.addTextNode((this.sourceApp == null) ? '' : this.sourceApp);
			Dom.XmlNode dataSourceNode = outerNode.addChildElement(
				'dataSource',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dataSourceNode.addTextNode((this.dataSource == null) ? '' : String.valueOf(this.dataSource));
			Dom.XmlNode contactTypeNode = outerNode.addChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactTypeNode.addTextNode((this.contactType == null) ? '' : String.valueOf(this.contactType));
			Dom.XmlNode priorityNode = outerNode.addChildElement(
				'priority',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			priorityNode.addTextNode((this.priority == null) ? '' : this.priority);
			Dom.XmlNode nonConfirmNode = outerNode.addChildElement(
				'nonConfirm',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			nonConfirmNode.addTextNode((this.nonConfirm == null) ? '' : String.valueOf(this.nonConfirm));
			Dom.XmlNode communicationMCSBGUIDNode = outerNode.addChildElement(
				'communicationMCSBGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			communicationMCSBGUIDNode.addTextNode(
				(this.communicationMCSBGUID == null) ? '' : this.communicationMCSBGUID
			);
		}
	}
	public class UpdateClientRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.UpdateClientRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'UpdateClientRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public UpdateClientRequest() {
		}
		public UpdateClientRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.UpdateClientRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('updateClient', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.UpdateClientRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class UpdateClientRequestBody {
		public PersonManagementSOAPServiceTypes.ClientDetailType clientDetail;
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunications;
		public Boolean updateCPE;
		private transient String[] clientDetail_type_info = new List<String>{
			'clientDetail',
			s_ns0,
			'ClientDetailType',
			'1',
			'1',
			'false'
		};
		private transient String[] listOfCommunications_type_info = new List<String>{
			'listOfCommunications',
			s_ns0,
			'ListOfCommunicationsType',
			'0',
			'1',
			'false'
		};
		private transient String[] updateCPE_type_info = new List<String>{
			'updateCPE',
			s_ns0,
			'BooleanFlagType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'clientDetail',
			'listOfCommunications',
			'updateCPE'
		};
		public UpdateClientRequestBody() {
		}
		public UpdateClientRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode clientDetailNode = responseNode.getChildElement(
				'clientDetail',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (clientDetailNode == null) {
				this.clientDetail = null;
			} else {
				PersonManagementSOAPServiceTypes.ClientDetailType clientDetailObj = new PersonManagementSOAPServiceTypes.ClientDetailType(
					clientDetailNode
				);
				nodesParsed.add(clientDetailNode);
				this.clientDetail = clientDetailObj;
			}
			//System.debug(this.clientDetail);
			DOM.XmlNode listOfCommunicationsNode = responseNode.getChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfCommunicationsNode == null) {
				this.listOfCommunications = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
					listOfCommunicationsNode
				);
				nodesParsed.add(listOfCommunicationsNode);
				this.listOfCommunications = listOfCommunicationsObj;
			}
			//System.debug(this.listOfCommunications);
			DOM.XmlNode updateCPENode = responseNode.getChildElement(
				'updateCPE',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.updateCPE = (updateCPENode == null) ? null : Boolean.valueOf(updateCPENode.getText());
			nodesParsed.add(updateCPENode);
			//System.debug(this.updateCPE);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.ClientDetailType clientDetailObj = this.clientDetail;
			Dom.XmlNode clientDetailNode = outerNode.addChildElement(
				'clientDetail',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (clientDetailObj != null) {
				clientDetailObj.populateXmlNode(clientDetailNode);
			}

			PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = this.listOfCommunications;
			Dom.XmlNode listOfCommunicationsNode = outerNode.addChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfCommunicationsObj != null) {
				listOfCommunicationsObj.populateXmlNode(listOfCommunicationsNode);
			}
			Dom.XmlNode updateCPENode = outerNode.addChildElement(
				'updateCPE',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.updateCPE != null) {
				updateCPENode.addTextNode(String.valueOf(this.updateCPE));
			}
		}
	}
	public class UpdateClientResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_UpdateClientResponse;
		private transient String[] responseHeader_UpdateClientResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.UpdateClientResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'UpdateClientResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_UpdateClientResponse',
			'responseBody'
		};
		public UpdateClientResponse() {
		}
		public UpdateClientResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('updateClientResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_UpdateClientResponseNode = responseNode.getChildElement(
				'responseHeader_UpdateClientResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_UpdateClientResponseNode == null) {
				this.responseHeader_UpdateClientResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_UpdateClientResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_UpdateClientResponseNode
				);
				nodesParsed.add(responseHeader_UpdateClientResponseNode);
				this.responseHeader_UpdateClientResponse = responseHeader_UpdateClientResponseObj;
			}
			//System.debug(this.responseHeader_UpdateClientResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.UpdateClientResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.UpdateClientResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class UpdateClientResponseBody {
		public BasicTypesService.OperationSuccessType success;
		public String riskClass;
		// Restriction enumeration:
		public Date nextAmlReviewDate;
		public DateTime dateLastUpdate;
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunications;
		private transient String[] success_type_info = new List<String>{
			'success',
			s_ns0,
			'OperationSuccessType',
			'0',
			'1',
			'false'
		};
		private transient String[] riskClass_type_info = new List<String>{
			'riskClass',
			s_ns0,
			'AlphanumericIdType',
			'1',
			'1',
			'false'
		};
		private transient String[] nextAmlReviewDate_type_info = new List<String>{
			'nextAmlReviewDate',
			s_ns0,
			'CommonDateType',
			'1',
			'1',
			'false'
		};
		private transient String[] dateLastUpdate_type_info = new List<String>{
			'dateLastUpdate',
			s_ns0,
			'CommonDateTimeType',
			'1',
			'1',
			'false'
		};
		private transient String[] listOfCommunications_type_info = new List<String>{
			'listOfCommunications',
			s_ns0,
			'ListOfCommunicationsType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'success',
			'riskClass',
			'nextAmlReviewDate',
			'dateLastUpdate',
			'listOfCommunications'
		};
		public UpdateClientResponseBody() {
		}
		public UpdateClientResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode successNode = responseNode.getChildElement(
				'success',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (successNode == null) {
				this.success = null;
			} else {
				BasicTypesService.OperationSuccessType successObj = new BasicTypesService.OperationSuccessType(
					successNode
				);
				nodesParsed.add(successNode);
				this.success = successObj;
			}
			//System.debug(this.success);
			DOM.XmlNode riskClassNode = responseNode.getChildElement(
				'riskClass',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.riskClass = (riskClassNode == null) ? null : riskClassNode.getText();
			nodesParsed.add(riskClassNode);
			//System.debug(this.riskClass);
			DOM.XmlNode nextAmlReviewDateNode = responseNode.getChildElement(
				'nextAmlReviewDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.nextAmlReviewDate = (nextAmlReviewDateNode == null)
				? null
				: Date.valueOf(nextAmlReviewDateNode.getText());
			nodesParsed.add(nextAmlReviewDateNode);
			//System.debug(this.nextAmlReviewDate);
			DOM.XmlNode dateLastUpdateNode = responseNode.getChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateLastUpdate = (dateLastUpdateNode == null)
				? null
				: PersonManagementSOAPServiceTypes.parseDateTime(dateLastUpdateNode.getText());
			nodesParsed.add(dateLastUpdateNode);
			//System.debug(this.dateLastUpdate);
			DOM.XmlNode listOfCommunicationsNode = responseNode.getChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfCommunicationsNode == null) {
				this.listOfCommunications = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
					listOfCommunicationsNode
				);
				nodesParsed.add(listOfCommunicationsNode);
				this.listOfCommunications = listOfCommunicationsObj;
			}
			//System.debug(this.listOfCommunications);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			BasicTypesService.OperationSuccessType successObj = this.success;
			Dom.XmlNode successNode = outerNode.addChildElement(
				'success',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (successObj != null) {
				successObj.populateXmlNode(successNode);
			}
			Dom.XmlNode riskClassNode = outerNode.addChildElement(
				'riskClass',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.riskClass != null) {
				riskClassNode.addTextNode(this.riskClass);
			}
			Dom.XmlNode nextAmlReviewDateNode = outerNode.addChildElement(
				'nextAmlReviewDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.nextAmlReviewDate != null) {
				nextAmlReviewDateNode.addTextNode(String.valueOf(this.nextAmlReviewDate));
			}
			Dom.XmlNode dateLastUpdateNode = outerNode.addChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.dateLastUpdate != null) {
				dateLastUpdateNode.addTextNode(String.valueOf(this.dateLastUpdate));
			}

			PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = this.listOfCommunications;
			Dom.XmlNode listOfCommunicationsNode = outerNode.addChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfCommunicationsObj != null) {
				listOfCommunicationsObj.populateXmlNode(listOfCommunicationsNode);
			}
		}
	}
	public class UpdateCommunicationsRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'UpdateCommunicationsRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public UpdateCommunicationsRequest() {
		}
		public UpdateCommunicationsRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('updateCommunications', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class UpdateCommunicationsRequestBody {
		public Long personNumber;
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunications;
		private transient String[] personNumber_type_info = new List<String>{
			'personNumber',
			s_ns0,
			'PersonNumberType',
			'1',
			'1',
			'false'
		};
		private transient String[] listOfCommunications_type_info = new List<String>{
			'listOfCommunications',
			s_ns0,
			'ListOfCommunicationsType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'personNumber', 'listOfCommunications'};
		public UpdateCommunicationsRequestBody() {
		}
		public UpdateCommunicationsRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode personNumberNode = responseNode.getChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.personNumber = (personNumberNode == null) ? null : Long.valueOf(personNumberNode.getText());
			nodesParsed.add(personNumberNode);
			//System.debug(this.personNumber);
			DOM.XmlNode listOfCommunicationsNode = responseNode.getChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfCommunicationsNode == null) {
				this.listOfCommunications = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
					listOfCommunicationsNode
				);
				nodesParsed.add(listOfCommunicationsNode);
				this.listOfCommunications = listOfCommunicationsObj;
			}
			//System.debug(this.listOfCommunications);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode personNumberNode = outerNode.addChildElement(
				'personNumber',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.personNumber != null) {
				personNumberNode.addTextNode(String.valueOf(this.personNumber));
			}

			PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = this.listOfCommunications;
			Dom.XmlNode listOfCommunicationsNode = outerNode.addChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfCommunicationsObj != null) {
				listOfCommunicationsObj.populateXmlNode(listOfCommunicationsNode);
			}
		}
	}
	public class UpdateCommunicationsResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_UpdateCommunicationsResponse;
		private transient String[] responseHeader_UpdateCommunicationsResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'UpdateCommunicationsResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_UpdateCommunicationsResponse',
			'responseBody'
		};
		public UpdateCommunicationsResponse() {
		}
		public UpdateCommunicationsResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('updateCommunicationsResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_UpdateCommunicationsResponseNode = responseNode.getChildElement(
				'responseHeader_UpdateCommunicationsResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_UpdateCommunicationsResponseNode == null) {
				this.responseHeader_UpdateCommunicationsResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_UpdateCommunicationsResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_UpdateCommunicationsResponseNode
				);
				nodesParsed.add(responseHeader_UpdateCommunicationsResponseNode);
				this.responseHeader_UpdateCommunicationsResponse = responseHeader_UpdateCommunicationsResponseObj;
			}
			//System.debug(this.responseHeader_UpdateCommunicationsResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class UpdateCommunicationsResponseBody {
		public BasicTypesService.OperationSuccessType success;
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunications;
		private transient String[] success_type_info = new List<String>{
			'success',
			s_ns0,
			'OperationSuccessType',
			'0',
			'1',
			'false'
		};
		private transient String[] listOfCommunications_type_info = new List<String>{
			'listOfCommunications',
			s_ns0,
			'ListOfCommunicationsType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'success', 'listOfCommunications'};
		public UpdateCommunicationsResponseBody() {
		}
		public UpdateCommunicationsResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode successNode = responseNode.getChildElement(
				'success',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (successNode == null) {
				this.success = null;
			} else {
				BasicTypesService.OperationSuccessType successObj = new BasicTypesService.OperationSuccessType(
					successNode
				);
				nodesParsed.add(successNode);
				this.success = successObj;
			}
			//System.debug(this.success);
			DOM.XmlNode listOfCommunicationsNode = responseNode.getChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfCommunicationsNode == null) {
				this.listOfCommunications = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
					listOfCommunicationsNode
				);
				nodesParsed.add(listOfCommunicationsNode);
				this.listOfCommunications = listOfCommunicationsObj;
			}
			//System.debug(this.listOfCommunications);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			BasicTypesService.OperationSuccessType successObj = this.success;
			Dom.XmlNode successNode = outerNode.addChildElement(
				'success',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (successObj != null) {
				successObj.populateXmlNode(successNode);
			}

			PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = this.listOfCommunications;
			Dom.XmlNode listOfCommunicationsNode = outerNode.addChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfCommunicationsObj != null) {
				listOfCommunicationsObj.populateXmlNode(listOfCommunicationsNode);
			}
		}
	}
	public class UpdateCSOBNonClientRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'UpdateCSOBNonClientRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public UpdateCSOBNonClientRequest() {
		}
		public UpdateCSOBNonClientRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('updateCSOBNonClient', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement('v01:requestHeader', null, null);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement('v10:requestBody', null, null);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class UpdateCSOBNonClientRequestBody {
		public String jsonRequest;
		private transient String[] jsonRequest_type_info = new List<String>{
			'jsonRequest',
			s_ns0,
			'AlphanumericStringType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'jsonRequest'};
		public UpdateCSOBNonClientRequestBody() {
		}
		public UpdateCSOBNonClientRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode jsonRequestNode = responseNode.getChildElement(
				'jsonRequest',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.jsonRequest = (jsonRequestNode == null) ? null : jsonRequestNode.getText();
			nodesParsed.add(jsonRequestNode);
			//System.debug(this.jsonRequest);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode jsonRequestNode = outerNode.addChildElement(
				'jsonRequest',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.jsonRequest != null) {
				jsonRequestNode.addTextNode(this.jsonRequest);
			}
		}
	}
	public class UpdateCSOBNonClientResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_UpdateCSOBNonClientResponse;
		private transient String[] responseHeader_UpdateCSOBNonClientResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'UpdateCSOBNonClientResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_UpdateCSOBNonClientResponse',
			'responseBody'
		};
		public UpdateCSOBNonClientResponse() {
		}
		public UpdateCSOBNonClientResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('updateCSOBNonClientResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_UpdateCSOBNonClientResponseNode = responseNode.getChildElement(
				'responseHeader_UpdateCSOBNonClientResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_UpdateCSOBNonClientResponseNode == null) {
				this.responseHeader_UpdateCSOBNonClientResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_UpdateCSOBNonClientResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_UpdateCSOBNonClientResponseNode
				);
				nodesParsed.add(responseHeader_UpdateCSOBNonClientResponseNode);
				this.responseHeader_UpdateCSOBNonClientResponse = responseHeader_UpdateCSOBNonClientResponseObj;
			}
			//System.debug(this.responseHeader_UpdateCSOBNonClientResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class UpdateCSOBNonClientResponseBody {
		public BasicTypesService.OperationSuccessType successful;
		private transient String[] successful_type_info = new List<String>{
			'successful',
			s_ns0,
			'OperationSuccessType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'successful'};
		public UpdateCSOBNonClientResponseBody() {
		}
		public UpdateCSOBNonClientResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode successfulNode = responseNode.getChildElement(
				'successful',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (successfulNode == null) {
				this.successful = null;
			} else {
				BasicTypesService.OperationSuccessType successfulObj = new BasicTypesService.OperationSuccessType(
					successfulNode
				);
				nodesParsed.add(successfulNode);
				this.successful = successfulObj;
			}
			//System.debug(this.successful);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			BasicTypesService.OperationSuccessType successfulObj = this.successful;
			Dom.XmlNode successfulNode = outerNode.addChildElement(
				'successful',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (successfulObj != null) {
				successfulObj.populateXmlNode(successfulNode);
			}
		}
	}
	public class ValidateClientRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.ValidateClientRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'ValidateClientRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public ValidateClientRequest() {
		}
		public ValidateClientRequest(
			CommonMessageService.RequestHeader requestHeader,
			PersonManagementSOAPServiceTypes.ValidateClientRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('validateClient', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			PersonManagementSOAPServiceTypes.ValidateClientRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class ValidateClientRequestBody {
		public PersonManagementSOAPServiceTypes.ClientDetailValidateType clientDetail;
		public PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunications;
		private transient String[] clientDetail_type_info = new List<String>{
			'clientDetail',
			s_ns0,
			'ClientDetailValidateType',
			'1',
			'1',
			'false'
		};
		private transient String[] listOfCommunications_type_info = new List<String>{
			'listOfCommunications',
			s_ns0,
			'ListOfCommunicationsType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'clientDetail', 'listOfCommunications'};
		public ValidateClientRequestBody() {
		}
		public ValidateClientRequestBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode clientDetailNode = responseNode.getChildElement(
				'clientDetail',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (clientDetailNode == null) {
				this.clientDetail = null;
			} else {
				PersonManagementSOAPServiceTypes.ClientDetailValidateType clientDetailObj = new PersonManagementSOAPServiceTypes.ClientDetailValidateType(
					clientDetailNode
				);
				nodesParsed.add(clientDetailNode);
				this.clientDetail = clientDetailObj;
			}
			//System.debug(this.clientDetail);
			DOM.XmlNode listOfCommunicationsNode = responseNode.getChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (listOfCommunicationsNode == null) {
				this.listOfCommunications = null;
			} else {
				PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
					listOfCommunicationsNode
				);
				nodesParsed.add(listOfCommunicationsNode);
				this.listOfCommunications = listOfCommunicationsObj;
			}
			//System.debug(this.listOfCommunications);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			PersonManagementSOAPServiceTypes.ClientDetailValidateType clientDetailObj = this.clientDetail;
			Dom.XmlNode clientDetailNode = outerNode.addChildElement(
				'clientDetail',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (clientDetailObj != null) {
				clientDetailObj.populateXmlNode(clientDetailNode);
			}

			PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsObj = this.listOfCommunications;
			Dom.XmlNode listOfCommunicationsNode = outerNode.addChildElement(
				'listOfCommunications',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (listOfCommunicationsObj != null) {
				listOfCommunicationsObj.populateXmlNode(listOfCommunicationsNode);
			}
		}
	}
	public class ValidateClientResponse {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public CommonMessageService.ResponseHeader responseHeader_ValidateClientResponse;
		private transient String[] responseHeader_ValidateClientResponse_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public PersonManagementSOAPServiceTypes.ValidateClientResponseBody responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'ValidateClientResponseBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'responseHeader',
			'responseHeader_ValidateClientResponse',
			'responseBody'
		};
		public ValidateClientResponse() {
		}
		public ValidateClientResponse(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('validateClientResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeaderNode == null) {
				this.responseHeader = null;
			} else {
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(
					responseHeaderNode
				);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);
			DOM.XmlNode responseHeader_ValidateClientResponseNode = responseNode.getChildElement(
				'responseHeader_ValidateClientResponse',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseHeader_ValidateClientResponseNode == null) {
				this.responseHeader_ValidateClientResponse = null;
			} else {
				CommonMessageService.ResponseHeader responseHeader_ValidateClientResponseObj = new CommonMessageService.ResponseHeader(
					responseHeader_ValidateClientResponseNode
				);
				nodesParsed.add(responseHeader_ValidateClientResponseNode);
				this.responseHeader_ValidateClientResponse = responseHeader_ValidateClientResponseObj;
			}
			//System.debug(this.responseHeader_ValidateClientResponse);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				PersonManagementSOAPServiceTypes.ValidateClientResponseBody responseBodyObj = new PersonManagementSOAPServiceTypes.ValidateClientResponseBody(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
	public class ValidateClientResponseBody {
		public BasicTypesService.OperationSuccessType success;
		private transient String[] success_type_info = new List<String>{
			'success',
			s_ns0,
			'OperationSuccessType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'success'};
		public ValidateClientResponseBody() {
		}
		public ValidateClientResponseBody(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode successNode = responseNode.getChildElement(
				'success',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			if (successNode == null) {
				this.success = null;
			} else {
				BasicTypesService.OperationSuccessType successObj = new BasicTypesService.OperationSuccessType(
					successNode
				);
				nodesParsed.add(successNode);
				this.success = successObj;
			}
			//System.debug(this.success);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			BasicTypesService.OperationSuccessType successObj = this.success;
			Dom.XmlNode successNode = outerNode.addChildElement(
				'success',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (successObj != null) {
				successObj.populateXmlNode(successNode);
			}
		}
	}
	public class WebEmailType {
		public DateTime dateLastUpdate;
		public String value;
		public String note;
		public Long contactFlag;
		public Long contactId;
		public Long contactID_WebEmailType;
		public Long webMailType;
		// Restriction enumeration:
		public Date validFromDate;
		// Restriction enumeration:
		public Date validToDate;
		public String sourceApp;
		public Long dataSource;
		public Long contactType;
		public String priority;
		public Boolean nonConfirm;
		public String communicationMCSBGUID;
		private transient String[] dateLastUpdate_type_info = new List<String>{
			'dateLastUpdate',
			s_ns0,
			'CommonDateTimeType',
			'0',
			'1',
			'false'
		};
		private transient String[] value_type_info = new List<String>{
			'value',
			s_ns0,
			'DescriptionType',
			'1',
			'1',
			'false'
		};
		private transient String[] note_type_info = new List<String>{
			'note',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactFlag_type_info = new List<String>{
			'contactFlag',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactId_type_info = new List<String>{
			'contactId',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactID_WebEmailType_type_info = new List<String>{
			'contactID',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] webMailType_type_info = new List<String>{
			'webMailType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] validFromDate_type_info = new List<String>{
			'validFromDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] validToDate_type_info = new List<String>{
			'validToDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] sourceApp_type_info = new List<String>{
			'sourceApp',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] dataSource_type_info = new List<String>{
			'dataSource',
			s_ns0,
			'CommonNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] contactType_type_info = new List<String>{
			'contactType',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] priority_type_info = new List<String>{
			'priority',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] nonConfirm_type_info = new List<String>{
			'nonConfirm',
			s_ns0,
			'BooleanFlagType',
			'0',
			'1',
			'false'
		};
		private transient String[] communicationMCSBGUID_type_info = new List<String>{
			'communicationMCSBGUID',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'dateLastUpdate',
			'value',
			'note',
			'contactFlag',
			'contactId',
			'contactID_WebEmailType',
			'webMailType',
			'validFromDate',
			'validToDate',
			'sourceApp',
			'dataSource',
			'contactType',
			'priority',
			'nonConfirm',
			'communicationMCSBGUID'
		};
		public WebEmailType() {
		}
		public WebEmailType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode dateLastUpdateNode = responseNode.getChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dateLastUpdate = (dateLastUpdateNode == null)
				? null
				: PersonManagementSOAPServiceTypes.parseDateTime(dateLastUpdateNode.getText());
			nodesParsed.add(dateLastUpdateNode);
			//System.debug(this.dateLastUpdate);
			DOM.XmlNode valueNode = responseNode.getChildElement(
				'value',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.value = (valueNode == null) ? null : valueNode.getText();
			nodesParsed.add(valueNode);
			//System.debug(this.value);
			DOM.XmlNode noteNode = responseNode.getChildElement(
				'note',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.note = (noteNode == null) ? null : noteNode.getText();
			nodesParsed.add(noteNode);
			//System.debug(this.note);
			DOM.XmlNode contactFlagNode = responseNode.getChildElement(
				'contactFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactFlag = (contactFlagNode == null) ? null : Long.valueOf(contactFlagNode.getText());
			nodesParsed.add(contactFlagNode);
			//System.debug(this.contactFlag);
			DOM.XmlNode contactIdNode = responseNode.getChildElement(
				'contactId',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactId = (contactIdNode == null) ? null : Long.valueOf(contactIdNode.getText());
			nodesParsed.add(contactIdNode);
			//System.debug(this.contactId);
			DOM.XmlNode contactID_WebEmailTypeNode = responseNode.getChildElement(
				'contactID_WebEmailType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactID_WebEmailType = (contactID_WebEmailTypeNode == null)
				? null
				: Long.valueOf(contactID_WebEmailTypeNode.getText());
			nodesParsed.add(contactID_WebEmailTypeNode);
			//System.debug(this.contactID_WebEmailType);
			DOM.XmlNode webMailTypeNode = responseNode.getChildElement(
				'webMailType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.webMailType = (webMailTypeNode == null) ? null : Long.valueOf(webMailTypeNode.getText());
			nodesParsed.add(webMailTypeNode);
			//System.debug(this.webMailType);
			DOM.XmlNode validFromDateNode = responseNode.getChildElement(
				'validFromDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validFromDate = (validFromDateNode == null) ? null : Date.valueOf(validFromDateNode.getText());
			nodesParsed.add(validFromDateNode);
			//System.debug(this.validFromDate);
			DOM.XmlNode validToDateNode = responseNode.getChildElement(
				'validToDate',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.validToDate = (validToDateNode == null) ? null : Date.valueOf(validToDateNode.getText());
			nodesParsed.add(validToDateNode);
			//System.debug(this.validToDate);
			DOM.XmlNode sourceAppNode = responseNode.getChildElement(
				'sourceApp',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.sourceApp = (sourceAppNode == null) ? null : sourceAppNode.getText();
			nodesParsed.add(sourceAppNode);
			//System.debug(this.sourceApp);
			DOM.XmlNode dataSourceNode = responseNode.getChildElement(
				'dataSource',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.dataSource = (dataSourceNode == null) ? null : Long.valueOf(dataSourceNode.getText());
			nodesParsed.add(dataSourceNode);
			//System.debug(this.dataSource);
			DOM.XmlNode contactTypeNode = responseNode.getChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.contactType = (contactTypeNode == null) ? null : Long.valueOf(contactTypeNode.getText());
			nodesParsed.add(contactTypeNode);
			//System.debug(this.contactType);
			DOM.XmlNode priorityNode = responseNode.getChildElement(
				'priority',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.priority = (priorityNode == null) ? null : priorityNode.getText();
			nodesParsed.add(priorityNode);
			//System.debug(this.priority);
			DOM.XmlNode nonConfirmNode = responseNode.getChildElement(
				'nonConfirm',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.nonConfirm = (nonConfirmNode == null) ? null : Boolean.valueOf(nonConfirmNode.getText());
			nodesParsed.add(nonConfirmNode);
			//System.debug(this.nonConfirm);
			DOM.XmlNode communicationMCSBGUIDNode = responseNode.getChildElement(
				'communicationMCSBGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10'
			);
			this.communicationMCSBGUID = (communicationMCSBGUIDNode == null)
				? null
				: communicationMCSBGUIDNode.getText();
			nodesParsed.add(communicationMCSBGUIDNode);
			//System.debug(this.communicationMCSBGUID);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode dateLastUpdateNode = outerNode.addChildElement(
				'dateLastUpdate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dateLastUpdateNode.addTextNode((this.dateLastUpdate == null) ? '' : String.valueOf(this.dateLastUpdate));
			Dom.XmlNode valueNode = outerNode.addChildElement(
				'value',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			if (this.value != null) {
				valueNode.addTextNode(this.value);
			}
			Dom.XmlNode noteNode = outerNode.addChildElement(
				'note',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			noteNode.addTextNode((this.note == null) ? '' : this.note);
			Dom.XmlNode contactFlagNode = outerNode.addChildElement(
				'contactFlag',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactFlagNode.addTextNode((this.contactFlag == null) ? '' : String.valueOf(this.contactFlag));
			Dom.XmlNode contactIdNode = outerNode.addChildElement(
				'contactId',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactIdNode.addTextNode((this.contactId == null) ? '' : String.valueOf(this.contactId));
			Dom.XmlNode contactID_WebEmailTypeNode = outerNode.addChildElement(
				'contactID_WebEmailType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactID_WebEmailTypeNode.addTextNode(
				(this.contactID_WebEmailType == null) ? '' : String.valueOf(this.contactID_WebEmailType)
			);
			Dom.XmlNode webMailTypeNode = outerNode.addChildElement(
				'webMailType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			webMailTypeNode.addTextNode((this.webMailType == null) ? '' : String.valueOf(this.webMailType));
			Dom.XmlNode validFromDateNode = outerNode.addChildElement(
				'validFromDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validFromDateNode.addTextNode((this.validFromDate == null) ? '' : String.valueOf(this.validFromDate));
			Dom.XmlNode validToDateNode = outerNode.addChildElement(
				'validToDate',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			validToDateNode.addTextNode((this.validToDate == null) ? '' : String.valueOf(this.validToDate));
			Dom.XmlNode sourceAppNode = outerNode.addChildElement(
				'sourceApp',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			sourceAppNode.addTextNode((this.sourceApp == null) ? '' : this.sourceApp);
			Dom.XmlNode dataSourceNode = outerNode.addChildElement(
				'dataSource',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			dataSourceNode.addTextNode((this.dataSource == null) ? '' : String.valueOf(this.dataSource));
			Dom.XmlNode contactTypeNode = outerNode.addChildElement(
				'contactType',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			contactTypeNode.addTextNode((this.contactType == null) ? '' : String.valueOf(this.contactType));
			Dom.XmlNode priorityNode = outerNode.addChildElement(
				'priority',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			priorityNode.addTextNode((this.priority == null) ? '' : this.priority);
			Dom.XmlNode nonConfirmNode = outerNode.addChildElement(
				'nonConfirm',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			nonConfirmNode.addTextNode((this.nonConfirm == null) ? '' : String.valueOf(this.nonConfirm));
			Dom.XmlNode communicationMCSBGUIDNode = outerNode.addChildElement(
				'communicationMCSBGUID',
				'http://service.cmss.cz/person/PersonManagementService/v10',
				''
			);
			communicationMCSBGUIDNode.addTextNode(
				(this.communicationMCSBGUID == null) ? '' : this.communicationMCSBGUID
			);
		}
	}
}
