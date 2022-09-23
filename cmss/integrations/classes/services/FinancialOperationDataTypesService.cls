public without sharing class FinancialOperationDataTypesService {
	private static final String s_ns0 = 'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes';
	public static DateTime parseDateTime(String nodeText) {
		String iso8601 = nodeText;
		JSONParser parser = JSON.createParser('{"t":"' + iso8601 + '"}');
		parser.nextToken();
		parser.nextValue();
		DateTime dt = parser.getDateTimeValue();
		//System.debug('dt: ' + dt);
		return dt;
	}
	public class ContractFinancialOperationInfoListType {
		public FinancialOperationDataTypesService.ContractFinancialOperationInfoType[] contractFinancialOperationInfo;
		private transient String[] contractFinancialOperationInfo_type_info = new List<String>{
			'contractFinancialOperationInfo',
			s_ns0,
			'ContractFinancialOperationInfoType',
			'0',
			'-1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'contractFinancialOperationInfo'};
		public ContractFinancialOperationInfoListType() {
		}
		public ContractFinancialOperationInfoListType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			Dom.XmlNode[] contractFinancialOperationInfoChildren = responseNode.getChildElements();
			FinancialOperationDataTypesService.ContractFinancialOperationInfoType[] contractFinancialOperationInfoList = new List<FinancialOperationDataTypesService.ContractFinancialOperationInfoType>();
			if (contractFinancialOperationInfoChildren == null || contractFinancialOperationInfoChildren.size() == 0) {
				this.contractFinancialOperationInfo = null;
			} else {
				for (DOM.XmlNode childNode : contractFinancialOperationInfoChildren) {
					if (childNode.GetName() == 'contractFinancialOperationInfo') {
						FinancialOperationDataTypesService.ContractFinancialOperationInfoType Obj = new FinancialOperationDataTypesService.ContractFinancialOperationInfoType(
							childNode
						);
						contractFinancialOperationInfoList.Add(Obj);
						nodesParsed.add(childNode);
					}
				}
				this.contractFinancialOperationInfo = contractFinancialOperationInfoList;
			}
			//System.debug(this.contractFinancialOperationInfo);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			FinancialOperationDataTypesService.ContractFinancialOperationInfoType[] contractFinancialOperationInfoObj = this.contractFinancialOperationInfo;
			if (contractFinancialOperationInfoObj != null) {
				for (
					FinancialOperationDataTypesService.ContractFinancialOperationInfoType element : contractFinancialOperationInfoObj
				) {
					Dom.XmlNode contractFinancialOperationInfoNode = outerNode.addChildElement(
						'contractFinancialOperationInfo',
						'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
						''
					);
					element.populateXmlNode(contractFinancialOperationInfoNode);
				}
			}
		}
	}
	public class ContractFinancialOperationInfoRequestType {
		public BasicTypesService.AccountNumberType contractIdNumber;
		// Restriction enumeration:
		public Date dateFrom;
		// Restriction enumeration:
		public Date dateTo;
		private transient String[] contractIdNumber_type_info = new List<String>{
			'contractIdNumber',
			s_ns0,
			'AccountNumberType',
			'0',
			'1',
			'false'
		};
		private transient String[] dateFrom_type_info = new List<String>{
			'dateFrom',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] dateTo_type_info = new List<String>{
			'dateTo',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'contractIdNumber', 'dateFrom', 'dateTo'};
		public ContractFinancialOperationInfoRequestType() {
		}
		public ContractFinancialOperationInfoRequestType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>(); //tady odmazano:
			DOM.XmlNode contractIdNumberNode = responseNode.getChildElement(
				'contractIdNumber',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			if (contractIdNumberNode == null) {
				this.contractIdNumber = null;
			} else {
				BasicTypesService.AccountNumberType contractIdNumberObj = new BasicTypesService.AccountNumberType(
					contractIdNumberNode
				);
				nodesParsed.add(contractIdNumberNode);
				this.contractIdNumber = contractIdNumberObj;
			}
			//System.debug(this.contractIdNumber);
			DOM.XmlNode dateFromNode = responseNode.getChildElement(
				'dateFrom',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.dateFrom = (dateFromNode == null) ? null : Date.valueOf(dateFromNode.getText());
			nodesParsed.add(dateFromNode);
			//System.debug(this.dateFrom);
			DOM.XmlNode dateToNode = responseNode.getChildElement(
				'dateTo',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.dateTo = (dateToNode == null) ? null : Date.valueOf(dateToNode.getText());
			nodesParsed.add(dateToNode);
			//System.debug(this.dateTo);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			BasicTypesService.AccountNumberType contractIdNumberObj = this.contractIdNumber; //tady odmazano: http://service.cmss.cz/account/FinancialOperationService/v05/datatypes
			Dom.XmlNode contractIdNumberNode = outerNode.addChildElement('dat:contractIdNumber', null, null);
			if (contractIdNumberObj != null) {
				contractIdNumberObj.populateXmlNode(contractIdNumberNode);
			}
			Dom.XmlNode dateFromNode = outerNode.addChildElement('dat:dateFrom', null, null); //odmazano
			dateFromNode.addTextNode((this.dateFrom == null) ? '' : String.valueOf(this.dateFrom));
			Dom.XmlNode dateToNode = outerNode.addChildElement('dat:dateTo', null, null); //odmazano
			dateToNode.addTextNode((this.dateTo == null) ? '' : String.valueOf(this.dateTo));
		}
	}
	public class ContractFinancialOperationInfoType {
		// Restriction enumeration:
		public Date valueDate;
		public Long bookingCode;
		public String senderReceiverName;
		public String senderReceiverAccountPrefix;
		public String senderReceiverAccountNumber;
		public String senderReceiverBankIdNumber;
		// Restriction enumeration:
		public String amount;
		public String variableSymbol;
		public String constantSymbol;
		public String specificSymbol;
		public String avField;
		// Restriction enumeration:
		public Date bookingDate;
		public String IBAN;
		public DateTime transactionDateTime;
		public String transactionDescription;
		private transient String[] valueDate_type_info = new List<String>{
			'valueDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] bookingCode_type_info = new List<String>{
			'bookingCode',
			s_ns0,
			'CodeListItemIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] senderReceiverName_type_info = new List<String>{
			'senderReceiverName',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] senderReceiverAccountPrefix_type_info = new List<String>{
			'senderReceiverAccountPrefix',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] senderReceiverAccountNumber_type_info = new List<String>{
			'senderReceiverAccountNumber',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] senderReceiverBankIdNumber_type_info = new List<String>{
			'senderReceiverBankIdNumber',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] amount_type_info = new List<String>{
			'amount',
			s_ns0,
			'MoneyAmountType',
			'0',
			'1',
			'false'
		};
		private transient String[] variableSymbol_type_info = new List<String>{
			'variableSymbol',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] constantSymbol_type_info = new List<String>{
			'constantSymbol',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] specificSymbol_type_info = new List<String>{
			'specificSymbol',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] avField_type_info = new List<String>{
			'avField',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] bookingDate_type_info = new List<String>{
			'bookingDate',
			s_ns0,
			'CommonDateType',
			'0',
			'1',
			'false'
		};
		private transient String[] IBAN_type_info = new List<String>{
			'IBAN',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] transactionDateTime_type_info = new List<String>{
			'transactionDateTime',
			s_ns0,
			'CommonDateTimeType',
			'0',
			'1',
			'false'
		};
		private transient String[] transactionDescription_type_info = new List<String>{
			'transactionDescription',
			s_ns0,
			'DescriptionType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{
			'valueDate',
			'bookingCode',
			'senderReceiverName',
			'senderReceiverAccountPrefix',
			'senderReceiverAccountNumber',
			'senderReceiverBankIdNumber',
			'amount',
			'variableSymbol',
			'constantSymbol',
			'specificSymbol',
			'avField',
			'bookingDate',
			'IBAN',
			'transactionDateTime',
			'transactionDescription'
		};
		public ContractFinancialOperationInfoType() {
		}
		public ContractFinancialOperationInfoType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode valueDateNode = responseNode.getChildElement(
				'valueDate',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.valueDate = (valueDateNode == null) ? null : Date.valueOf(valueDateNode.getText());
			nodesParsed.add(valueDateNode);
			//System.debug(this.valueDate);
			DOM.XmlNode bookingCodeNode = responseNode.getChildElement(
				'bookingCode',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.bookingCode = (bookingCodeNode == null) ? null : Long.valueOf(bookingCodeNode.getText());
			nodesParsed.add(bookingCodeNode);
			//System.debug(this.bookingCode);
			DOM.XmlNode senderReceiverNameNode = responseNode.getChildElement(
				'senderReceiverName',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.senderReceiverName = (senderReceiverNameNode == null) ? null : senderReceiverNameNode.getText();
			nodesParsed.add(senderReceiverNameNode);
			//System.debug(this.senderReceiverName);
			DOM.XmlNode senderReceiverAccountPrefixNode = responseNode.getChildElement(
				'senderReceiverAccountPrefix',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.senderReceiverAccountPrefix = (senderReceiverAccountPrefixNode == null)
				? null
				: senderReceiverAccountPrefixNode.getText();
			nodesParsed.add(senderReceiverAccountPrefixNode);
			//System.debug(this.senderReceiverAccountPrefix);
			DOM.XmlNode senderReceiverAccountNumberNode = responseNode.getChildElement(
				'senderReceiverAccountNumber',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.senderReceiverAccountNumber = (senderReceiverAccountNumberNode == null)
				? null
				: senderReceiverAccountNumberNode.getText();
			nodesParsed.add(senderReceiverAccountNumberNode);
			//System.debug(this.senderReceiverAccountNumber);
			DOM.XmlNode senderReceiverBankIdNumberNode = responseNode.getChildElement(
				'senderReceiverBankIdNumber',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.senderReceiverBankIdNumber = (senderReceiverBankIdNumberNode == null)
				? null
				: senderReceiverBankIdNumberNode.getText();
			nodesParsed.add(senderReceiverBankIdNumberNode);
			//System.debug(this.senderReceiverBankIdNumber);
			DOM.XmlNode amountNode = responseNode.getChildElement(
				'amount',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.amount = (amountNode == null) ? null : amountNode.getText();
			nodesParsed.add(amountNode);
			//System.debug(this.amount);
			DOM.XmlNode variableSymbolNode = responseNode.getChildElement(
				'variableSymbol',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.variableSymbol = (variableSymbolNode == null) ? null : variableSymbolNode.getText();
			nodesParsed.add(variableSymbolNode);
			//System.debug(this.variableSymbol);
			DOM.XmlNode constantSymbolNode = responseNode.getChildElement(
				'constantSymbol',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.constantSymbol = (constantSymbolNode == null) ? null : constantSymbolNode.getText();
			nodesParsed.add(constantSymbolNode);
			//System.debug(this.constantSymbol);
			DOM.XmlNode specificSymbolNode = responseNode.getChildElement(
				'specificSymbol',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.specificSymbol = (specificSymbolNode == null) ? null : specificSymbolNode.getText();
			nodesParsed.add(specificSymbolNode);
			//System.debug(this.specificSymbol);
			DOM.XmlNode avFieldNode = responseNode.getChildElement(
				'avField',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.avField = (avFieldNode == null) ? null : avFieldNode.getText();
			nodesParsed.add(avFieldNode);
			//System.debug(this.avField);
			DOM.XmlNode bookingDateNode = responseNode.getChildElement(
				'bookingDate',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.bookingDate = (bookingDateNode == null) ? null : Date.valueOf(bookingDateNode.getText());
			nodesParsed.add(bookingDateNode);
			//System.debug(this.bookingDate);
			DOM.XmlNode IBANNode = responseNode.getChildElement(
				'IBAN',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.IBAN = (IBANNode == null) ? null : IBANNode.getText();
			nodesParsed.add(IBANNode);
			//System.debug(this.IBAN);
			DOM.XmlNode transactionDateTimeNode = responseNode.getChildElement(
				'transactionDateTime',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.transactionDateTime = (transactionDateTimeNode == null)
				? null
				: FinancialOperationDataTypesService.parseDateTime(transactionDateTimeNode.getText());
			nodesParsed.add(transactionDateTimeNode);
			//System.debug(this.transactionDateTime);
			DOM.XmlNode transactionDescriptionNode = responseNode.getChildElement(
				'transactionDescription',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			this.transactionDescription = (transactionDescriptionNode == null)
				? null
				: transactionDescriptionNode.getText();
			nodesParsed.add(transactionDescriptionNode);
			//System.debug(this.transactionDescription);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode valueDateNode = outerNode.addChildElement(
				'valueDate',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			valueDateNode.addTextNode((this.valueDate == null) ? '' : String.valueOf(this.valueDate));
			Dom.XmlNode bookingCodeNode = outerNode.addChildElement(
				'bookingCode',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			bookingCodeNode.addTextNode((this.bookingCode == null) ? '' : String.valueOf(this.bookingCode));
			Dom.XmlNode senderReceiverNameNode = outerNode.addChildElement(
				'senderReceiverName',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			senderReceiverNameNode.addTextNode((this.senderReceiverName == null) ? '' : this.senderReceiverName);
			Dom.XmlNode senderReceiverAccountPrefixNode = outerNode.addChildElement(
				'senderReceiverAccountPrefix',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			senderReceiverAccountPrefixNode.addTextNode(
				(this.senderReceiverAccountPrefix == null) ? '' : this.senderReceiverAccountPrefix
			);
			Dom.XmlNode senderReceiverAccountNumberNode = outerNode.addChildElement(
				'senderReceiverAccountNumber',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			senderReceiverAccountNumberNode.addTextNode(
				(this.senderReceiverAccountNumber == null) ? '' : this.senderReceiverAccountNumber
			);
			Dom.XmlNode senderReceiverBankIdNumberNode = outerNode.addChildElement(
				'senderReceiverBankIdNumber',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			senderReceiverBankIdNumberNode.addTextNode(
				(this.senderReceiverBankIdNumber == null) ? '' : this.senderReceiverBankIdNumber
			);
			Dom.XmlNode amountNode = outerNode.addChildElement(
				'amount',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			amountNode.addTextNode((this.amount == null) ? '' : this.amount);
			Dom.XmlNode variableSymbolNode = outerNode.addChildElement(
				'variableSymbol',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			variableSymbolNode.addTextNode((this.variableSymbol == null) ? '' : this.variableSymbol);
			Dom.XmlNode constantSymbolNode = outerNode.addChildElement(
				'constantSymbol',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			constantSymbolNode.addTextNode((this.constantSymbol == null) ? '' : this.constantSymbol);
			Dom.XmlNode specificSymbolNode = outerNode.addChildElement(
				'specificSymbol',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			specificSymbolNode.addTextNode((this.specificSymbol == null) ? '' : this.specificSymbol);
			Dom.XmlNode avFieldNode = outerNode.addChildElement(
				'avField',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			avFieldNode.addTextNode((this.avField == null) ? '' : this.avField);
			Dom.XmlNode bookingDateNode = outerNode.addChildElement(
				'bookingDate',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			bookingDateNode.addTextNode((this.bookingDate == null) ? '' : String.valueOf(this.bookingDate));
			Dom.XmlNode IBANNode = outerNode.addChildElement(
				'IBAN',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			IBANNode.addTextNode((this.IBAN == null) ? '' : this.IBAN);
			Dom.XmlNode transactionDateTimeNode = outerNode.addChildElement(
				'transactionDateTime',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			transactionDateTimeNode.addTextNode(
				(this.transactionDateTime == null) ? '' : String.valueOf(this.transactionDateTime)
			);
			Dom.XmlNode transactionDescriptionNode = outerNode.addChildElement(
				'transactionDescription',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			transactionDescriptionNode.addTextNode(
				(this.transactionDescription == null) ? '' : this.transactionDescription
			);
		}
	}
	public class GetFinancialOperationInfoRequestBodyType {
		public FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType contractFinancialOperationInfoRequest;
		private transient String[] contractFinancialOperationInfoRequest_type_info = new List<String>{
			'contractFinancialOperationInfoRequest',
			s_ns0,
			'ContractFinancialOperationInfoRequestType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'contractFinancialOperationInfoRequest'};
		public GetFinancialOperationInfoRequestBodyType() {
		}
		public GetFinancialOperationInfoRequestBodyType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode contractFinancialOperationInfoRequestNode = responseNode.getChildElement(
				'contractFinancialOperationInfoRequest',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			if (contractFinancialOperationInfoRequestNode == null) {
				this.contractFinancialOperationInfoRequest = null;
			} else {
				FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType contractFinancialOperationInfoRequestObj = new FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType(
					contractFinancialOperationInfoRequestNode
				);
				nodesParsed.add(contractFinancialOperationInfoRequestNode);
				this.contractFinancialOperationInfoRequest = contractFinancialOperationInfoRequestObj;
			}
			//System.debug(this.contractFinancialOperationInfoRequest);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType contractFinancialOperationInfoRequestObj = this.contractFinancialOperationInfoRequest;
			Dom.XmlNode contractFinancialOperationInfoRequestNode = outerNode.addChildElement(
				'dat:contractFinancialOperationInfoRequest',
				null,
				null
			);
			if (contractFinancialOperationInfoRequestObj != null) {
				contractFinancialOperationInfoRequestObj.populateXmlNode(contractFinancialOperationInfoRequestNode);
			}
		}
	}

	//Extends http://service.cmss.cz/common/CommonMessage/v01:RequestMessage
	//Failed to find base class: http://service.cmss.cz/common/CommonMessage/v01:RequestMessage - Unable to create ApexClass for complexTypeQualifiedName: http://service.cmss.cz/common/CommonMessage/v01:RequestMessage
	//Corresponding complexType was null.
	//Název parametru: complexType
	public class GetFinancialOperationInfoRequestType {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'GetFinancialOperationInfoRequestBodyType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'requestHeader', 'requestBody'};
		public GetFinancialOperationInfoRequestType() {
		}
		public GetFinancialOperationInfoRequestType(
			CommonMessageService.RequestHeader requestHeader,
			FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			//System.assertEquals('getFinancialOperationInfo', outerNode.getName());

			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/common/CommonMessage/v01',
				'v01'
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				'dat'
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class GetFinancialOperationInfoResponseBodyType {
		public FinancialOperationDataTypesService.ContractFinancialOperationInfoListType contractFinancialOperationInfoList;
		private transient String[] contractFinancialOperationInfoList_type_info = new List<String>{
			'contractFinancialOperationInfoList',
			s_ns0,
			'ContractFinancialOperationInfoListType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		private transient String[] field_order_type_info = new List<String>{'contractFinancialOperationInfoList'};
		public GetFinancialOperationInfoResponseBodyType() {
		}
		public GetFinancialOperationInfoResponseBodyType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode contractFinancialOperationInfoListNode = responseNode.getChildElement(
				'contractFinancialOperationInfoList',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			if (contractFinancialOperationInfoListNode == null) {
				this.contractFinancialOperationInfoList = null;
			} else {
				FinancialOperationDataTypesService.ContractFinancialOperationInfoListType contractFinancialOperationInfoListObj = new FinancialOperationDataTypesService.ContractFinancialOperationInfoListType(
					contractFinancialOperationInfoListNode
				);
				nodesParsed.add(contractFinancialOperationInfoListNode);
				this.contractFinancialOperationInfoList = contractFinancialOperationInfoListObj;
			}
			//System.debug(this.contractFinancialOperationInfoList);
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			FinancialOperationDataTypesService.ContractFinancialOperationInfoListType contractFinancialOperationInfoListObj = this.contractFinancialOperationInfoList;
			Dom.XmlNode contractFinancialOperationInfoListNode = outerNode.addChildElement(
				'contractFinancialOperationInfoList',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				''
			);
			if (contractFinancialOperationInfoListObj != null) {
				contractFinancialOperationInfoListObj.populateXmlNode(contractFinancialOperationInfoListNode);
			}
		}
	}

	//Extends http://service.cmss.cz/common/CommonMessage/v01:ResponseMessage
	//Failed to find base class: http://service.cmss.cz/common/CommonMessage/v01:ResponseMessage - Unable to create ApexClass for complexTypeQualifiedName: http://service.cmss.cz/common/CommonMessage/v01:ResponseMessage
	//Corresponding complexType was null.
	//Název parametru: complexType
	public class GetFinancialOperationInfoResponseType {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new List<String>{
			'responseHeader',
			s_ns0,
			'ResponseHeader',
			'1',
			'1',
			'false'
		};
		public FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType responseBody;
		private transient String[] responseBody_type_info = new List<String>{
			'responseBody',
			s_ns0,
			'GetFinancialOperationInfoResponseBodyType',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{s_ns0, 'true', 'false'};
		public GetFinancialOperationInfoResponseType() {
		}
		public GetFinancialOperationInfoResponseType(DOM.XmlNode responseNode) {
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('getFinancialOperationInfoResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement(
				'responseHeader',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
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

			//System.debug(this.responseHeader_GetFinancialOperationInfoResponseType);
			DOM.XmlNode responseBodyNode = responseNode.getChildElement(
				'responseBody',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);
			if (responseBodyNode == null) {
				this.responseBody = null;
			} else {
				FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType responseBodyObj = new FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType(
					responseBodyNode
				);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);
		}
	}
}