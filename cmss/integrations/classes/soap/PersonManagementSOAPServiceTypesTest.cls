@IsTest
private class PersonManagementSOAPServiceTypesTest {
	@IsTest
	static void coverTypesWithEmptyConstructorTest() {
		PersonManagementSOAPServiceTypes parentObject = new PersonManagementSOAPServiceTypes();
		new CommonMessageService.CMSSBusinessLogicFaultInfo();
		new CommonMessageService.CMSSFaultInfo();
		new CommonMessageService.CMSSSecurityFaultInfo();
		new CommonMessageService.CMSSServiceFaultInfo();
		new CommonMessageService.FaultHeader();
		new CommonMessageService.Header();
		new CommonMessageService.RequestHeader();
		new CommonMessageService.RequestMessage();
		new CommonMessageService.ResponseHeader();
		new CommonMessageService.ResponseMessage();
		new BasicTypesService.AccountNumberType();
		new BasicTypesService.OperationSuccessType();
		new PersonManagementSOAPServiceTypes.AddressType();
		new PersonManagementSOAPServiceTypes.ClientDetailType();
		new PersonManagementSOAPServiceTypes.ClientDetailValidateType();
		new PersonManagementSOAPServiceTypes.ClientInfoType();
		new PersonManagementSOAPServiceTypes.CoupleDocumentRequest();
		new PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody();
		new PersonManagementSOAPServiceTypes.CoupleDocumentResponse();
		new PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody();
		new PersonManagementSOAPServiceTypes.CreateClientRequest();
		new PersonManagementSOAPServiceTypes.CreateClientRequestBody();
		new PersonManagementSOAPServiceTypes.CreateClientResponse();
		new PersonManagementSOAPServiceTypes.CreateClientResponseBody();
		new PersonManagementSOAPServiceTypes.CreatePersonRelationRequest();
		new PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody();
		new PersonManagementSOAPServiceTypes.CreatePersonRelationResponse();
		new PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody();
		new PersonManagementSOAPServiceTypes.CreatePersonRelationResponseInfoType();
		new PersonManagementSOAPServiceTypes.ForeignerIdentityType();
		new PersonManagementSOAPServiceTypes.ForeignerIDType();
		new PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequest();
		new PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody();
		new PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponse();
		new PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody();
		new PersonManagementSOAPServiceTypes.IdentityCardType();
		new PersonManagementSOAPServiceTypes.LegalEntityDataType();
		new PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType();
		new PersonManagementSOAPServiceTypes.ListOfCommunicationsType();
		new PersonManagementSOAPServiceTypes.ListOfPersonsItemType();
		new PersonManagementSOAPServiceTypes.ListOfPersonsType();
		new PersonManagementSOAPServiceTypes.PersonRelationType();
		new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequest();
		new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody();
		new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponse();
		new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody();
		new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequest();
		new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody();
		new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponse();
		new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody();
		new PersonManagementSOAPServiceTypes.TelephoneType();
		new PersonManagementSOAPServiceTypes.UpdateClientRequest();
		new PersonManagementSOAPServiceTypes.UpdateClientRequestBody();
		new PersonManagementSOAPServiceTypes.UpdateClientResponse();
		new PersonManagementSOAPServiceTypes.UpdateClientResponseBody();
		new PersonManagementSOAPServiceTypes.UpdateCommunicationsRequest();
		new PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody();
		new PersonManagementSOAPServiceTypes.UpdateCommunicationsResponse();
		new PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody();
		new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequest();
		new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody();
		new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponse();
		new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody();
		new PersonManagementSOAPServiceTypes.ValidateClientRequest();
		new PersonManagementSOAPServiceTypes.ValidateClientRequestBody();
		new PersonManagementSOAPServiceTypes.ValidateClientResponse();
		new PersonManagementSOAPServiceTypes.ValidateClientResponseBody();
		new PersonManagementSOAPServiceTypes.WebEmailType();
	}

	@IsTest
	static void coverTypesTest() {
		DateTime dt = PersonManagementSOAPServiceTypes.parseDateTime('21-01-01');

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', '', null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		PersonManagementSOAPServiceTypes parentObject = new PersonManagementSOAPServiceTypes();
		new CommonMessageService.CMSSBusinessLogicFaultInfo();
		new CommonMessageService.CMSSFaultInfo();
		new CommonMessageService.CMSSSecurityFaultInfo();
		new CommonMessageService.CMSSServiceFaultInfo();
		new CommonMessageService.FaultHeader();
		new CommonMessageService.Header();
		new CommonMessageService.RequestHeader();
		new CommonMessageService.RequestMessage();
		new CommonMessageService.ResponseHeader();
		new CommonMessageService.ResponseMessage();
		new BasicTypesService.AccountNumberType();
		new BasicTypesService.OperationSuccessType();

		Dom.Document doc = new Dom.Document();
		DOM.XmlNode root = doc.createRootElement('AddressType', '', '');
		PersonManagementSOAPServiceTypes.AddressType address = new PersonManagementSOAPServiceTypes.AddressType(root);
		address.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ClientDetailType', '', '');
		PersonManagementSOAPServiceTypes.ClientDetailType clientDetail = new PersonManagementSOAPServiceTypes.ClientDetailType(
			root
		);
		clientDetail.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ClientDetailValidateType', '', '');
		PersonManagementSOAPServiceTypes.ClientDetailValidateType clientDetailValidate = new PersonManagementSOAPServiceTypes.ClientDetailValidateType(
			root
		);
		clientDetailValidate.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ClientInfoType', '', '');
		PersonManagementSOAPServiceTypes.ClientInfoType clientInfos = new PersonManagementSOAPServiceTypes.ClientInfoType(
			root
		);
		clientInfos.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('CoupleDocumentRequestBody', '', '');
		PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody coupleDocumentRequestBody = new PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody(
			root
		);
		coupleDocumentRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('CoupleDocumentResponse', '', '');
		PersonManagementSOAPServiceTypes.CoupleDocumentResponse coupleDocumentResponse = new PersonManagementSOAPServiceTypes.CoupleDocumentResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('CoupleDocumentResponseBody', '', '');
		PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody coupleDocumentResponseBody = new PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody(
			root
		);
		coupleDocumentResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('CreateClientRequestBody', '', '');
		PersonManagementSOAPServiceTypes.CreateClientRequestBody createClientRequestBody = new PersonManagementSOAPServiceTypes.CreateClientRequestBody(
			root
		);
		createClientRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('CreateClientResponse', '', '');
		PersonManagementSOAPServiceTypes.CreateClientResponse createClientResponse = new PersonManagementSOAPServiceTypes.CreateClientResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('CreateClientResponseBody', '', '');
		PersonManagementSOAPServiceTypes.CreateClientResponseBody createClientResponseBody = new PersonManagementSOAPServiceTypes.CreateClientResponseBody(
			root
		);
		createClientResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('CreatePersonRelationRequestBody', '', '');
		PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody createPersonRelationRequestBody = new PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody(
			root
		);
		createPersonRelationRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('CreatePersonRelationResponse', '', '');
		PersonManagementSOAPServiceTypes.CreatePersonRelationResponse createPersonRelationResponse = new PersonManagementSOAPServiceTypes.CreatePersonRelationResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('CreatePersonRelationResponseBody', '', '');
		PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody createPersonRelationResponseBody = new PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody(
			root
		);
		createPersonRelationResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('CreatePersonRelationResponseInfoType', '', '');
		PersonManagementSOAPServiceTypes.CreatePersonRelationResponseInfoType createPersonRelationResponseInfoType = new PersonManagementSOAPServiceTypes.CreatePersonRelationResponseInfoType(
			root
		);
		createPersonRelationResponseInfoType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ForeignerIdentityType', '', '');
		PersonManagementSOAPServiceTypes.ForeignerIdentityType foreignerIdentityType = new PersonManagementSOAPServiceTypes.ForeignerIdentityType(
			root
		);
		foreignerIdentityType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ForeignerIDType', '', '');
		PersonManagementSOAPServiceTypes.ForeignerIDType foreignerIDType = new PersonManagementSOAPServiceTypes.ForeignerIDType(
			root
		);
		foreignerIDType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('GetReservedGlobalIdRequestBody', '', '');
		PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody getReservedGlobalIdRequestBody = new PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody(
			root
		);
		getReservedGlobalIdRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('GetReservedGlobalIdResponse', '', '');
		PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponse getReservedGlobalIdResponse = new PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('GetReservedGlobalIdResponseBody', '', '');
		PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody getReservedGlobalIdResponseBody = new PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody(
			root
		);
		getReservedGlobalIdResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('IdentityCardType', '', '');
		PersonManagementSOAPServiceTypes.IdentityCardType identityCardType = new PersonManagementSOAPServiceTypes.IdentityCardType(
			root
		);
		identityCardType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('LegalEntityDataType', '', '');
		PersonManagementSOAPServiceTypes.LegalEntityDataType legalEntityDataTyp = new PersonManagementSOAPServiceTypes.LegalEntityDataType(
			root
		);
		legalEntityDataTyp.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ListOfCommunicationsItemType', '', '');
		PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType listOfCommunicationsItemType = new PersonManagementSOAPServiceTypes.ListOfCommunicationsItemType(
			root
		);
		listOfCommunicationsItemType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ListOfCommunicationsType', '', '');
		PersonManagementSOAPServiceTypes.ListOfCommunicationsType listOfCommunicationsType = new PersonManagementSOAPServiceTypes.ListOfCommunicationsType(
			root
		);
		listOfCommunicationsType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ListOfPersonsItemType', '', '');
		PersonManagementSOAPServiceTypes.ListOfPersonsItemType listOfPersonsItemType = new PersonManagementSOAPServiceTypes.ListOfPersonsItemType(
			root
		);
		listOfPersonsItemType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ListOfPersonsType', '', '');
		PersonManagementSOAPServiceTypes.ListOfPersonsType listOfPersonsType = new PersonManagementSOAPServiceTypes.ListOfPersonsType(
			root
		);
		listOfPersonsType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('PersonRelationType', '', '');
		PersonManagementSOAPServiceTypes.PersonRelationType personRelationType = new PersonManagementSOAPServiceTypes.PersonRelationType(
			root
		);
		personRelationType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('SearchCSOBSNonClientRequestBody', '', '');
		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody searchCSOBSNonClientRequestBody = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody(
			root
		);
		searchCSOBSNonClientRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('SearchCSOBSNonClientResponse', '', '');
		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponse searchCSOBSNonClientResponse = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('SearchCSOBSNonClientResponseBody', '', '');
		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody searchCSOBSNonClientResponseBody = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody(
			root
		);
		searchCSOBSNonClientResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('SearchPersonByIdNumberRequestBody', '', '');
		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody searchPersonByIdNumberRequestBody = new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody(
			root
		);
		searchPersonByIdNumberRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('SearchPersonByIdNumberResponse', '', '');
		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponse searchPersonByIdNumberResponse = new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('SearchPersonByIdNumberResponseBody', '', '');
		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody searchPersonByIdNumberResponseBody = new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody(
			root
		);
		searchPersonByIdNumberResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('TelephoneType', '', '');
		PersonManagementSOAPServiceTypes.TelephoneType telephoneType = new PersonManagementSOAPServiceTypes.TelephoneType(
			root
		);
		telephoneType.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateClientRequestBody', '', '');
		PersonManagementSOAPServiceTypes.UpdateClientRequestBody updateClientRequestBody = new PersonManagementSOAPServiceTypes.UpdateClientRequestBody(
			root
		);
		updateClientRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateClientResponse', '', '');
		PersonManagementSOAPServiceTypes.UpdateClientResponse updateClientResponse = new PersonManagementSOAPServiceTypes.UpdateClientResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateClientResponseBody', '', '');
		PersonManagementSOAPServiceTypes.UpdateClientResponseBody updateClientResponseBody = new PersonManagementSOAPServiceTypes.UpdateClientResponseBody(
			root
		);
		updateClientResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateCommunicationsRequestBody', '', '');
		PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody updateCommunicationsRequestBody = new PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody(
			root
		);
		updateCommunicationsRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateCommunicationsResponse', '', '');
		PersonManagementSOAPServiceTypes.UpdateCommunicationsResponse updateCommunicationsResponse = new PersonManagementSOAPServiceTypes.UpdateCommunicationsResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateCommunicationsResponseBody', '', '');
		PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody updateCommunicationsResponseBody = new PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody(
			root
		);
		updateCommunicationsResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateCSOBNonClientRequestBody', '', '');
		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody updateCSOBNonClientRequestBody = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody(
			root
		);
		updateCSOBNonClientRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateCSOBNonClientResponse', '', '');
		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponse updateCSOBNonClientResponse = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('UpdateCSOBNonClientResponseBody', '', '');
		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody updateCSOBNonClientResponseBody = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody(
			root
		);
		updateCSOBNonClientResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ValidateClientRequestBody', '', '');
		PersonManagementSOAPServiceTypes.ValidateClientRequestBody validateClientRequestBody = new PersonManagementSOAPServiceTypes.ValidateClientRequestBody(
			root
		);
		validateClientRequestBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('ValidateClientResponse', '', '');
		PersonManagementSOAPServiceTypes.ValidateClientResponse validateClientResponse = new PersonManagementSOAPServiceTypes.ValidateClientResponse(
			root
		);
		doc = new Dom.Document();
		root = doc.createRootElement('ValidateClientResponseBody', '', '');
		PersonManagementSOAPServiceTypes.ValidateClientResponseBody validateClientResponseBody = new PersonManagementSOAPServiceTypes.ValidateClientResponseBody(
			root
		);
		validateClientResponseBody.populateXmlNode(root);
		doc = new Dom.Document();
		root = doc.createRootElement('WebEmailType', '', '');
		PersonManagementSOAPServiceTypes.WebEmailType webEmailType = new PersonManagementSOAPServiceTypes.WebEmailType(
			root
		);
		webEmailType.populateXmlNode(root);
	}
}
