@IsTest
public class LoanServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void coverHttp() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:LoadPackagesListResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanService/v05\" xmlns:io8=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io7=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:out=\"http://service.cmss.cz/loan/LoanService/v05/datatypes\" xmlns:io4=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanService/v05/datatypes\" xmlns:io3=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io8:responseHeader><io8:conversationIdName/><io8:conversationIdValue/><io8:correlationId>7e73a1f2-7021-f986-e59f-335e2b8f8b99</io8:correlationId><io8:messageId>7e73a1f2-7021-f986-e59f-335e2b8f8b99_resp</io8:messageId><io8:physicalSource>SBTESTWEB02.cmss.local</io8:physicalSource><io8:sourceSystem>StarBuild</io8:sourceSystem><io8:targetSystem>3</io8:targetSystem><io8:timestamp>2022-05-10T11:41:58.979Z</io8:timestamp><io8:userId>0051j00000AOn9nAAD</io8:userId></io8:responseHeader><out:responseBody><out:listOfPackages><out:packagesItem><out:packageId>951</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-03-22</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>961</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>940</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>-0,4</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem></out:listOfPackages></out:responseBody></out:LoadPackagesListResponse>\r\n</soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		LoanService testObject = new LoanService();
		Test.startTest();
		testObject.loadPackagesList_Http(null, null);
		Test.stopTest();
	}

	@isTest
	static void coverGeneratedCodeTypes() {
		LoanServiceDataTypes parentObject = new LoanServiceDataTypes();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');

		LoanServiceDataTypes.ListOfPackagesType Obj1 = new LoanServiceDataTypes.ListOfPackagesType();
		Obj1.populateXmlNode(mockNode);
		LoanServiceDataTypes.LoadPackagesListRequestType Obj2 = new LoanServiceDataTypes.LoadPackagesListRequestType();
		Obj2.populateXmlNode(mockNode);
		LoanServiceDataTypes.LoadPackagesListResponseBodyType Obj3 = new LoanServiceDataTypes.LoadPackagesListResponseBodyType();
		Obj3.populateXmlNode(mockNode);
		LoanServiceDataTypes.PackagesItemType Obj5 = new LoanServiceDataTypes.PackagesItemType();
		Obj5.populateXmlNode(mockNode);
	}
}
