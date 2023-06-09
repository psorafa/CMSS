@IsTest
public class LoanAssetsServicesTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void updateAsset() {
		Account acc = TestDataFactory.getAccount(new Account());
		insert acc;
		Asset asset1 = new Asset(Name = '1200373701', AccountId = acc.Id);
		insert asset1;

		UpdateLoanAssetsFlowController.Request request = new UpdateLoanAssetsFlowController.Request();
		request.assetId = asset1.Id;
		QueueHttpMock mock = new QueueHttpMock();
		HttpResponse res1 = new HttpResponse();
		res1.setStatus('OK');
		res1.setStatusCode(200);
		res1.setBody(
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:GetLoanDetailInfoResponse xmlns:ns4=\"http://service.cmss.cz/loan/LoanDetailInfoService/v05/datatypes\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId>35dd2b14-9bcc-8596-49b5-397909cfdff0</ns2:correlationId><ns2:messageId>35dd2b14-9bcc-8596-49b5-397909cfdff0_resp</ns2:messageId><ns2:physicalSource>SBTESTWEB02.cmss.local</ns2:physicalSource><ns2:sourceSystem>StarBuild</ns2:sourceSystem><ns2:targetSystem>3</ns2:targetSystem><ns2:timestamp>2022-05-24T12:00:28.3595378+02:00</ns2:timestamp><ns2:userId>0051x00000A4jouAAB</ns2:userId></ns2:responseHeader><ns4:responseBody><ns4:loanDetailInfo><ns4:signDate>2019-03-20</ns4:signDate><ns4:receiptDate>2019-04-05</ns4:receiptDate><ns4:approvalDate1>2019-04-05</ns4:approvalDate1><ns4:approvalDate2>2019-04-05</ns4:approvalDate2><ns4:acceptanceDate>2019-04-05</ns4:acceptanceDate><ns4:signDateOwner>2019-04-26</ns4:signDateOwner><ns4:loanUsageCode>3</ns4:loanUsageCode><ns4:realEstateUsageCode>1</ns4:realEstateUsageCode><ns4:loanPlaceCode>3</ns4:loanPlaceCode><ns4:personNumber>7200abc</ns4:personNumber><ns4:decisiveUserId>212</ns4:decisiveUserId><ns4:loanStateCode>6</ns4:loanStateCode><ns4:variableAmount>3300000</ns4:variableAmount><ns4:originalLoanModeCode>2</ns4:originalLoanModeCode><ns4:currentLoanModeCode>2</ns4:currentLoanModeCode><ns4:loanUsage2Code>0</ns4:loanUsage2Code><ns4:loanUsage3Desc></ns4:loanUsage3Desc><ns4:listOfIndemnity><ns4:indemnityDetail><ns4:debtSecurityType>23</ns4:debtSecurityType><ns4:acceptableValue>840541,42</ns4:acceptableValue></ns4:indemnityDetail><ns4:indemnityDetail><ns4:debtSecurityType>37</ns4:debtSecurityType><ns4:acceptableValue>2459458,58</ns4:acceptableValue></ns4:indemnityDetail></ns4:listOfIndemnity><ns4:listOfPayments><ns4:paymentsDetail><ns4:payingSegmentPrefixNumber></ns4:payingSegmentPrefixNumber><ns4:payingSegmentNumber>2107517869</ns4:payingSegmentNumber><ns4:payingSegmentBankCode>2700</ns4:payingSegmentBankCode><ns4:payingSegmentConstaintSymbol>0558</ns4:payingSegmentConstaintSymbol><ns4:payingSegmentVariableSymbol></ns4:payingSegmentVariableSymbol><ns4:payingSegmentSpecificSymbol></ns4:payingSegmentSpecificSymbol><ns4:payingSegmentAV></ns4:payingSegmentAV><ns4:payingSegmentRecipient>AK Mach a Mrázik</ns4:payingSegmentRecipient></ns4:paymentsDetail></ns4:listOfPayments><ns4:listOfAccounts><ns4:accountDetail><ns4:accountIdNumber><basicNumber>1530886</basicNumber><checkNumber>9</checkNumber><endNumber>7</endNumber></ns4:accountIdNumber><ns4:accountType>2</ns4:accountType><ns4:interestRate>2,49</ns4:interestRate></ns4:accountDetail></ns4:listOfAccounts><ns4:aquisitionChannelCode>500</ns4:aquisitionChannelCode><ns4:establishmentTypeCode>8</ns4:establishmentTypeCode><ns4:creditConditions>12/2016</ns4:creditConditions><ns4:lastChangeDate>2019-09-24</ns4:lastChangeDate><ns4:restObligAmount>0,0</ns4:restObligAmount><ns4:requestedAmount>0</ns4:requestedAmount></ns4:loanDetailInfo></ns4:responseBody></ns4:GetLoanDetailInfoResponse></soapenv:Body></soapenv:Envelope>'
		);
		mock.addResponse(res1);
		Test.setMock(HttpCalloutMock.class, mock);
		UpdateLoanAssetsFlowController.LoanDetailInfoResult result = LoanDetailInfoServiceController.loanDetailInfoResult(
			res1
		);
		Test.startTest();
		LoanAssetsServices.updateLoanDetailInfo(result, request);
		Test.stopTest();
		Asset assetAfterUpdate = [
			SELECT
				CreditAmount__c,
				PurposeOfUse__c,
				PurposeOfUse2__c,
				RequestSignDate__c,
				SecondDecissionDate__c,
				Status__c
			FROM Asset
			WHERE Id = :asset1.Id
		];
		system.assertEquals(assetAfterUpdate.CreditAmount__c, 3300000);
		system.assertEquals(assetAfterUpdate.PurposeOfUse__c, '3');
		system.assertEquals(assetAfterUpdate.PurposeOfUse2__c, '0');
		system.assertEquals(assetAfterUpdate.RequestSignDate__c, date.newInstance(2019, 3, 20));
		system.assertEquals(assetAfterUpdate.SecondDecissionDate__c, date.newInstance(2019, 4, 5));
		system.assertEquals(assetAfterUpdate.Status__c, '10006');
	}

	@IsTest
	static void updateLoadPackages() {
		Account acc = TestDataFactory.getAccount(new Account());
		insert acc;
		Asset asset1 = new Asset(Name = '1200373701', AccountId = acc.Id);
		insert asset1;
		LoanSurchargeDiscount__c lsd = new LoanSurchargeDiscount__c(
			Asset__c = asset1.Id,
			SurchargeDiscountId__c = '940'
		);
		insert lsd;
		UpdateLoanAssetsFlowController.Request request = new UpdateLoanAssetsFlowController.Request();
		request.assetId = asset1.Id;
		QueueHttpMock mock = new QueueHttpMock();
		HttpResponse res1 = new HttpResponse();
		res1.setStatus('OK');
		res1.setStatusCode(200);
		res1.setBody(
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:LoadPackagesListResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanService/v05\" xmlns:io8=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io7=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:out=\"http://service.cmss.cz/loan/LoanService/v05/datatypes\" xmlns:io4=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanService/v05/datatypes\" xmlns:io3=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io8:responseHeader><io8:conversationIdName/><io8:conversationIdValue/><io8:correlationId>7e73a1f2-7021-f986-e59f-335e2b8f8b99</io8:correlationId><io8:messageId>7e73a1f2-7021-f986-e59f-335e2b8f8b99_resp</io8:messageId><io8:physicalSource>SBTESTWEB02.cmss.local</io8:physicalSource><io8:sourceSystem>StarBuild</io8:sourceSystem><io8:targetSystem>3</io8:targetSystem><io8:timestamp>2022-05-10T11:41:58.979Z</io8:timestamp><io8:userId>0051j00000AOn9nAAD</io8:userId></io8:responseHeader><out:responseBody><out:listOfPackages><out:packagesItem><out:packageId>951</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-03-22</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>961</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>940</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>-0,4</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem></out:listOfPackages></out:responseBody></out:LoadPackagesListResponse>\r\n</soapenv:Body></soapenv:Envelope>'
		);
		mock.addResponse(res1);
		Test.setMock(HttpCalloutMock.class, mock);
		List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> result = LoanServiceController.loadPackagesResult(
			res1
		);
		lsd.SurchargeDiscountId__c = null;
		lsd.ValidTo__c = null;
		lsd.ValidFrom__c = null;
		lsd.SurchargeDiscountAmount__c = null;
		Test.startTest();
		LoanAssetsServices.updateLoadPackages(result, request);
		Test.stopTest();
		LoanSurchargeDiscount__c lsdAfterUpdate = [
			SELECT SurchargeDiscountId__c, ValidTo__c, ValidFrom__c, SurchargeDiscountAmount__c
			FROM LoanSurchargeDiscount__c
			WHERE Id = :lsd.Id
		];
		system.assertEquals(lsdAfterUpdate.ValidTo__c, null);
		system.assertEquals(lsdAfterUpdate.ValidFrom__c, date.newInstance(2019, 4, 5));
		system.assertEquals(lsdAfterUpdate.SurchargeDiscountAmount__c, -0.4);
	}

	@IsTest
	static void upsertLoanCaseDoc() {
		Account acc = TestDataFactory.getAccount(new Account());
		insert acc;
		Asset asset1 = new Asset(Name = '1006496201', AccountId = acc.Id);
		insert asset1;
		UpdateLoanAssetsFlowController.Request request = new UpdateLoanAssetsFlowController.Request();
		request.assetId = asset1.Id;
		QueueHttpMock mock = new QueueHttpMock();
		HttpResponse res1 = new HttpResponse();
		res1.setStatus('OK');
		res1.setStatusCode(200);
		res1.setBody(
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:GetLoanDocumentsListResponse xmlns:ns4=\"http://service.cmss.cz/loan/LoanService/v06\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/queue/AQNotificationService/v01/datatypes\"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId>bb06a2a4-d447-1767-913f-8a8d7926a68a</ns2:correlationId><ns2:messageId>bb06a2a4-d447-1767-913f-8a8d7926a68a</ns2:messageId><ns2:physicalSource>https://customer-velocity-8853.cs100.my.salesforce.com</ns2:physicalSource><ns2:sourceSystem>3</ns2:sourceSystem><ns2:targetSystem>ESB</ns2:targetSystem><ns2:timestamp>2022-05-20T18:34:31.055Z</ns2:timestamp><ns2:userId>0051x00000A4jouAAB</ns2:userId></ns2:responseHeader><ns4:responseBody><ns4:listOfDocuments><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>122</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- model dospořování pro určení úrokové sazby (zajistí níže uvedený poradce)</ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882707</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>133</ns4:number><ns4:group>10</ns4:group><ns4:status>5</ns4:status><ns4:text>- prohlášení o osobních údajích podepsané zástavcem/zástavci </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882710</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>223</ns4:number><ns4:group>20</ns4:group><ns4:status>2</ns4:status><ns4:text>- poslední dvě výplatní pásky dlužníka/spoludlužníka 03/2015</ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882732</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>146</ns4:number><ns4:group>30</ns4:group><ns4:status>4</ns4:status><ns4:text>- potvrzení o koupi jednotky bez dluhu </ns4:text><ns4:id>6882764</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>302</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- aktuální list vlastnictví zastavované nemovitosti </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882769</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>312</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- nedostatečné zajištění minimálnícena v rekonstrukci (80% 720.000,-Kč + 500.000,-Kč) nestačí ani na kupní cenu</ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882775</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>313</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- aktuální fotografie zastavované nemovitosti </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882781</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>117</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- reálný plán financování </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882804</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>2</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- Smlouva s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:tillWhenDate>2015-08-15</ns4:tillWhenDate><ns4:id>6882692</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>40</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882695</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>72</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- oznámení o povolení inkasa pro splácení úroků z meziúvěru dle čl. II Smlouvy</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882700</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>73</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- oznámení o povolení inkasa pro dospořování dle čl. II Smlouvy</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882703</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>5</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- smlouva o zřízení zástavního práva k věcem nemovitým s úředně ověřenými podpisy - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882736</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>78</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- list vlastnictví zastavované nemovitosti s vyznačenou poznámkou pro řízení o povolení vkladu zástavního práva dle čl. III. Smlouvy - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882740</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>81</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- na příslušném listu vlastnictví není třetí pracovní den po podání návrhu na vklad zástavního práva dle čl. III. Smlouvy vyznačena jiná poznámka, než poznámka pro toto řízení, nebo poznámka akceptována věřitelem</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882745</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>83</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- návrh na vklad zástavního práva dle čl. III. Smlouvy s vyznačeným číslem jednacím příslušným KÚ - originál nebo kopie potvrzená příslušným KÚ, nebo informace o průběhu řízení s podpisem a razítkem KÚ - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882754</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>86</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- kupní smlouva nebo smlouva o budoucí kupní smlouvě s úředně ověřenými podpisy - originál nebo úředně ověřená kopie</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882801</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>134</ns4:number><ns4:group>50</ns4:group><ns4:status>2</ns4:status><ns4:text>- osobní údaje k žádosti o MÚ/Ú - zástavce/opatrovník - originál k doložené kopii</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882813</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>640</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-05</ns4:incomingDate><ns4:id>6882718</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>640</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-05</ns4:incomingDate><ns4:id>6882722</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>640</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál, pro II. etapu</ns4:text><ns4:incomingDate>2015-10-07</ns4:incomingDate><ns4:id>6882728</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>653</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- ocenění nemovitosti podle požadavku věřitele - provedené firmou nebo osobou požadovanou věřitelem, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-21</ns4:incomingDate><ns4:id>6882786</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>671</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- určení výše čerpání stavebním technikem věřitele - v závislosti na provedeném ocenění, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-21</ns4:incomingDate><ns4:id>6882791</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>696</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- doložení účelového použití částky čerpané v předchozí záloze - originály nebo kopie ve výši 117.353,- Kč</ns4:text><ns4:incomingDate>2015-10-16</ns4:incomingDate><ns4:id>6882806</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>697</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- aktuální fotografie zastavované nemovitosti (interiér a exteriér) dokládající zhodnocení nemovitosti před každým dalším čerpáním, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-10</ns4:incomingDate><ns4:id>6882809</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>30</ns4:phase><ns4:number>1</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- nový list vlastnictví - originál nebo kopii</ns4:text><ns4:incomingDate>2015-08-05</ns4:incomingDate><ns4:tillWhenDate>2016-03-29</ns4:tillWhenDate><ns4:id>6882795</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>30</ns4:phase><ns4:number>4</ns4:number><ns4:group>40</ns4:group><ns4:status>1</ns4:status><ns4:text>- soupisku dokladů s podpisem dlužníka na formuláři věřitele nebo soupisku dokladů včetně účelových faktur a jiných účetních dokladů - originál nebo kopii</ns4:text><ns4:tillWhenDate>2016-07-19</ns4:tillWhenDate><ns4:id>6882798</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>31</ns4:phase><ns4:number>103</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- nový list vlastnictví se zapsanými věcnými právy v části C nebo vyrozumění XXXX</ns4:text><ns4:incomingDate>2015-07-22</ns4:incomingDate><ns4:tillWhenDate>2015-10-23</ns4:tillWhenDate><ns4:id>6882758</ns4:id></ns4:documentsItem></ns4:listOfDocuments></ns4:responseBody></ns4:GetLoanDocumentsListResponse></soapenv:Body></soapenv:Envelope>'
		);
		mock.addResponse(res1);
		Test.setMock(HttpCalloutMock.class, mock);
		List<UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult> result = LoanDocumentsServiceController.loanDocumentsResult(
			res1
		);
		Test.startTest();
		LoanAssetsServices.upsertLoanCaseDoc(result, request);
		Test.stopTest();
		List<LoanCaseDoc__c> lcdAfterUpsert = [
			SELECT DueDate__c, ExternalId__c, Group__c, Number__c, Phase__c, ReceiveDate__c, Status__c, Text__c
			FROM LoanCaseDoc__c
			WHERE Asset__c = :asset1.Id
		];
		system.assertEquals(lcdAfterUpsert[0].ExternalId__c, '6882707');
		system.assertEquals(lcdAfterUpsert[0].Group__c, '10');
		system.assertEquals(lcdAfterUpsert[0].Number__c, '122');
		system.assertEquals(lcdAfterUpsert[0].Phase__c, '10');
		system.assertEquals(lcdAfterUpsert[0].Status__c, '2');
		system.assertEquals(
			lcdAfterUpsert[0].Text__c,
			'model dospořování pro určení úrokové sazby (zajistí níže uvedený poradce)'
		);
	}
}
