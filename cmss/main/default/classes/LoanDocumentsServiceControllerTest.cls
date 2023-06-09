@IsTest
public class LoanDocumentsServiceControllerTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void succsessResponse() {
		Account acc = TestDataFactory.getAccount(new Account());
		insert acc;
		Asset asset1 = new Asset(Name = '1006496201', AccountId = acc.Id);
		insert asset1;

		QueueHttpMock mock = new QueueHttpMock();
		HttpResponse res1 = new HttpResponse();
		res1.setStatus('OK');
		res1.setStatusCode(200);
		res1.setBody(
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:GetLoanDocumentsListResponse xmlns:ns4=\"http://service.cmss.cz/loan/LoanService/v06\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/queue/AQNotificationService/v01/datatypes\"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId>bb06a2a4-d447-1767-913f-8a8d7926a68a</ns2:correlationId><ns2:messageId>bb06a2a4-d447-1767-913f-8a8d7926a68a</ns2:messageId><ns2:physicalSource>https://customer-velocity-8853.cs100.my.salesforce.com</ns2:physicalSource><ns2:sourceSystem>3</ns2:sourceSystem><ns2:targetSystem>ESB</ns2:targetSystem><ns2:timestamp>2022-05-20T18:34:31.055Z</ns2:timestamp><ns2:userId>0051x00000A4jouAAB</ns2:userId></ns2:responseHeader><ns4:responseBody><ns4:listOfDocuments><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>122</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- model dospořování pro určení úrokové sazby (zajistí níže uvedený poradce)</ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882707</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>133</ns4:number><ns4:group>10</ns4:group><ns4:status>5</ns4:status><ns4:text>- prohlášení o osobních údajích podepsané zástavcem/zástavci </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882710</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>223</ns4:number><ns4:group>20</ns4:group><ns4:status>2</ns4:status><ns4:text>- poslední dvě výplatní pásky dlužníka/spoludlužníka 03/2015</ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882732</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>146</ns4:number><ns4:group>30</ns4:group><ns4:status>4</ns4:status><ns4:text>- potvrzení o koupi jednotky bez dluhu </ns4:text><ns4:id>6882764</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>302</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- aktuální list vlastnictví zastavované nemovitosti </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882769</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>312</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- nedostatečné zajištění minimálnícena v rekonstrukci (80% 720.000,-Kč + 500.000,-Kč) nestačí ani na kupní cenu</ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882775</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>313</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- aktuální fotografie zastavované nemovitosti </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882781</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>10</ns4:phase><ns4:number>117</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- reálný plán financování </ns4:text><ns4:incomingDate>2015-05-15</ns4:incomingDate><ns4:id>6882804</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>2</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- Smlouva s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:tillWhenDate>2015-08-15</ns4:tillWhenDate><ns4:id>6882692</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>40</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882695</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>72</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- oznámení o povolení inkasa pro splácení úroků z meziúvěru dle čl. II Smlouvy</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882700</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>73</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- oznámení o povolení inkasa pro dospořování dle čl. II Smlouvy</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882703</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>5</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- smlouva o zřízení zástavního práva k věcem nemovitým s úředně ověřenými podpisy - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882736</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>78</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- list vlastnictví zastavované nemovitosti s vyznačenou poznámkou pro řízení o povolení vkladu zástavního práva dle čl. III. Smlouvy - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882740</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>81</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- na příslušném listu vlastnictví není třetí pracovní den po podání návrhu na vklad zástavního práva dle čl. III. Smlouvy vyznačena jiná poznámka, než poznámka pro toto řízení, nebo poznámka akceptována věřitelem</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882745</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>83</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- návrh na vklad zástavního práva dle čl. III. Smlouvy s vyznačeným číslem jednacím příslušným KÚ - originál nebo kopie potvrzená příslušným KÚ, nebo informace o průběhu řízení s podpisem a razítkem KÚ - originál</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882754</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>86</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- kupní smlouva nebo smlouva o budoucí kupní smlouvě s úředně ověřenými podpisy - originál nebo úředně ověřená kopie</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882801</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>21</ns4:phase><ns4:number>134</ns4:number><ns4:group>50</ns4:group><ns4:status>2</ns4:status><ns4:text>- osobní údaje k žádosti o MÚ/Ú - zástavce/opatrovník - originál k doložené kopii</ns4:text><ns4:incomingDate>2015-06-29</ns4:incomingDate><ns4:id>6882813</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>640</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-05</ns4:incomingDate><ns4:id>6882718</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>640</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-05</ns4:incomingDate><ns4:id>6882722</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>640</ns4:number><ns4:group>10</ns4:group><ns4:status>2</ns4:status><ns4:text>- písemná žádost o čerpání s dispozicí k čerpání s podpisy ověřenými úředně nebo osobami pověřenými věřitelem - originál, pro II. etapu</ns4:text><ns4:incomingDate>2015-10-07</ns4:incomingDate><ns4:id>6882728</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>653</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- ocenění nemovitosti podle požadavku věřitele - provedené firmou nebo osobou požadovanou věřitelem, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-21</ns4:incomingDate><ns4:id>6882786</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>671</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- určení výše čerpání stavebním technikem věřitele - v závislosti na provedeném ocenění, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-21</ns4:incomingDate><ns4:id>6882791</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>696</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- doložení účelového použití částky čerpané v předchozí záloze - originály nebo kopie ve výši 117.353,- Kč</ns4:text><ns4:incomingDate>2015-10-16</ns4:incomingDate><ns4:id>6882806</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>22</ns4:phase><ns4:number>697</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- aktuální fotografie zastavované nemovitosti (interiér a exteriér) dokládající zhodnocení nemovitosti před každým dalším čerpáním, pro II. etapu</ns4:text><ns4:incomingDate>2015-08-10</ns4:incomingDate><ns4:id>6882809</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>30</ns4:phase><ns4:number>1</ns4:number><ns4:group>40</ns4:group><ns4:status>2</ns4:status><ns4:text>- nový list vlastnictví - originál nebo kopii</ns4:text><ns4:incomingDate>2015-08-05</ns4:incomingDate><ns4:tillWhenDate>2016-03-29</ns4:tillWhenDate><ns4:id>6882795</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>30</ns4:phase><ns4:number>4</ns4:number><ns4:group>40</ns4:group><ns4:status>1</ns4:status><ns4:text>- soupisku dokladů s podpisem dlužníka na formuláři věřitele nebo soupisku dokladů včetně účelových faktur a jiných účetních dokladů - originál nebo kopii</ns4:text><ns4:tillWhenDate>2016-07-19</ns4:tillWhenDate><ns4:id>6882798</ns4:id></ns4:documentsItem><ns4:documentsItem><ns4:phase>31</ns4:phase><ns4:number>103</ns4:number><ns4:group>30</ns4:group><ns4:status>2</ns4:status><ns4:text>- nový list vlastnictví se zapsanými věcnými právy v části C nebo vyrozumění XXXX</ns4:text><ns4:incomingDate>2015-07-22</ns4:incomingDate><ns4:tillWhenDate>2015-10-23</ns4:tillWhenDate><ns4:id>6882758</ns4:id></ns4:documentsItem></ns4:listOfDocuments></ns4:responseBody></ns4:GetLoanDocumentsListResponse></soapenv:Body></soapenv:Envelope>'
		);
		mock.addResponse(res1);
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
		HTTPResponse rawResponse = LoanDocumentsServiceController.loanDocumentsRawResponse(asset1.Name);
		Test.stopTest();
		String errorMessage = LoanDocumentsServiceController.loanDocumentsErrorMessage(rawResponse);
		List<UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult> results = LoanDocumentsServiceController.loanDocumentsResult(
			rawResponse
		);
		system.assertEquals(getExpectedResult(), results[0].toString());
		system.assertEquals(errorMessage, null);
	}

	@IsTest
	static void failResponse() {
		Account acc = TestDataFactory.getAccount(new Account());
		insert acc;
		Asset asset1 = new Asset(Name = '12003737010', AccountId = acc.Id);
		insert asset1;

		QueueHttpMock mock = new QueueHttpMock();
		HttpResponse res1 = new HttpResponse();
		res1.setStatus('Internal Server Error');
		res1.setStatusCode(500);
		res1.setBody(
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><soapenv:Fault><faultcode>soapenv:Server</faultcode><faultstring>Zadané číslo úvěrového případu je neplatné</faultstring><detail><ns2:CMSSBusinessLogicFaultInfo xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns4=\"http://service.cmss.cz/loan/LoanService/v06\" xmlns:ns3=\"http://service.cmss.cz/queue/AQNotificationService/v01/datatypes\"><ns2:errorDetail>StarBuild</ns2:errorDetail><ns2:errorNumber>1</ns2:errorNumber><ns2:faultHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId>7779b0be-2b88-4b5f-d653-78e9631dedfc</ns2:correlationId><ns2:messageId>7779b0be-2b88-4b5f-d653-78e9631dedfc</ns2:messageId><ns2:physicalSource>https://customer-velocity-8853.cs100.my.salesforce.com</ns2:physicalSource><ns2:sourceSystem>3</ns2:sourceSystem><ns2:targetSystem>ESB</ns2:targetSystem><ns2:timestamp>2022-05-22T20:25:23.843Z</ns2:timestamp><ns2:userId>0051x00000A4jouAAB</ns2:userId></ns2:faultHeader><ns2:message>Zadané číslo úvěrového případu je neplatné</ns2:message><ns2:system>1</ns2:system></ns2:CMSSBusinessLogicFaultInfo></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>'
		);
		mock.addResponse(res1);
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
		try {
			LoanDocumentsServiceController.loanDocumentsRawResponse(asset1.Name);
			system.assert(false, 'Expected an exception to be thrown');
		} catch (Exception e) {
			system.assert(e.getMessage().contains('Internal Server Error'), 'Incorrect exception thrown');
		}
		Test.stopTest();
	}

	public static String getExpectedResult() {
		UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult ldc = new UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult();
		ldc.phase = '10';
		ldc.number_x = '122';
		ldc.group_x = '10';
		ldc.text = '- model dospořování pro určení úrokové sazby (zajistí níže uvedený poradce)';
		ldc.status = '2';
		ldc.incomingDate = date.newInstance(2015, 5, 15);
		ldc.id = '6882707';

		return ldc.toString();
	}
}
