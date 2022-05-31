//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)

public class LoanServiceDataTypes {
	private static final String s_ns0 = 'http://service.cmss.cz/loan/LoanService/v05/datatypes';
	
	public class ListOfPackagesType {
		public LoanServiceDataTypes.PackagesItemType[] packagesItem;
		private transient String[] packagesItem_type_info = new String[]{'packagesItem',s_ns0,'PackagesItemType','1','-1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'packagesItem'};
		public ListOfPackagesType(){
		}
		public ListOfPackagesType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			Dom.XmlNode[] packagesItemChildren = responseNode.getChildElements();
			LoanServiceDataTypes.PackagesItemType[] packagesItemList = new List<LoanServiceDataTypes.PackagesItemType>();
			if(packagesItemChildren == null || packagesItemChildren.size() == 0){
				this.packagesItem = null;
			} else{
				for(DOM.XmlNode childNode : packagesItemChildren){
					if(childNode.GetName() == 'packagesItem'){
						LoanServiceDataTypes.PackagesItemType Obj = new LoanServiceDataTypes.PackagesItemType(childNode);
						packagesItemList.Add(Obj);
						nodesParsed.add(childNode);
					}
				}
				this.packagesItem = packagesItemList;
			}
			//System.debug(this.packagesItem);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			LoanServiceDataTypes.PackagesItemType[] packagesItemObj = this.packagesItem;
			if(packagesItemObj != null){
				for(LoanServiceDataTypes.PackagesItemType element: packagesItemObj){
					Dom.XmlNode packagesItemNode = outerNode.addChildElement('packagesItem', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
					element.populateXmlNode(packagesItemNode);
				}
			}			
		}
	}
	

	public class LoadPackagesListRequestBodyType {
		public BasicTypesService.AccountNumberType loanIdNumber;
		private transient String[] loanIdNumber_type_info = new String[]{'loanIdNumber',s_ns0,'AccountNumberType','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'loanIdNumber'};
		public LoadPackagesListRequestBodyType(){
		}
		public LoadPackagesListRequestBodyType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode loanIdNumberNode = responseNode.getChildElement('loanIdNumber', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			if(loanIdNumberNode == null){
				this.loanIdNumber = null;
			} else{
				BasicTypesService.AccountNumberType loanIdNumberObj = new BasicTypesService.AccountNumberType(loanIdNumberNode);
				nodesParsed.add(loanIdNumberNode);
				this.loanIdNumber = loanIdNumberObj;
			}
			//System.debug(this.loanIdNumber);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			BasicTypesService.AccountNumberType loanIdNumberObj = this.loanIdNumber;
			Dom.XmlNode loanIdNumberNode = outerNode.addChildElement('dat:loanIdNumber', null, null);
			if(loanIdNumberObj != null){
				loanIdNumberObj.populateXmlNode(loanIdNumberNode);
			}
		}
	}
	
	
	public class LoadPackagesListRequestType {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new String[]{'requestHeader',s_ns0,'RequestHeader','1','1','false'};
		public LoanServiceDataTypes.LoadPackagesListRequestBodyType requestBody;
		private transient String[] requestBody_type_info = new String[]{'requestBody',s_ns0,'LoadPackagesListRequestBodyType','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'requestHeader','requestBody'};
		public LoadPackagesListRequestType(){
		}
		public LoadPackagesListRequestType(CommonMessageService.RequestHeader requestHeader,LoanServiceDataTypes.LoadPackagesListRequestBodyType requestBody){
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			//System.assertEquals('loadPackagesList', outerNode.getName());
			
			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement('v01:requestHeader', null, null);
			if(requestHeaderObj != null){
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}
			
			LoanServiceDataTypes.LoadPackagesListRequestBodyType requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement('dat:requestBody', null, null);
			if(requestBodyObj != null){
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class LoadPackagesListResponseBodyType {
		public LoanServiceDataTypes.ListOfPackagesType listOfPackages;
		private transient String[] listOfPackages_type_info = new String[]{'listOfPackages',s_ns0,'ListOfPackagesType','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'listOfPackages'};
		public LoadPackagesListResponseBodyType(){
		}
		public LoadPackagesListResponseBodyType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode listOfPackagesNode = responseNode.getChildElement('listOfPackages', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			if(listOfPackagesNode == null){
				this.listOfPackages = null;
			} else{
				LoanServiceDataTypes.ListOfPackagesType listOfPackagesObj = new LoanServiceDataTypes.ListOfPackagesType(listOfPackagesNode);
				nodesParsed.add(listOfPackagesNode);
				this.listOfPackages = listOfPackagesObj;
			}
			//System.debug(this.listOfPackages);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			LoanServiceDataTypes.ListOfPackagesType listOfPackagesObj = this.listOfPackages;
			Dom.XmlNode listOfPackagesNode = outerNode.addChildElement('listOfPackages', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
			if(listOfPackagesObj != null){
				listOfPackagesObj.populateXmlNode(listOfPackagesNode);
			}
		}
	}
	
	
	public class LoadPackagesListResponseType {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new String[]{'responseHeader',s_ns0,'ResponseHeader','1','1','false'};
		public CommonMessageService.ResponseHeader responseHeader_LoadPackagesListResponseType;
		private transient String[] responseHeader_LoadPackagesListResponseType_type_info = new String[]{'responseHeader',s_ns0,'ResponseHeader','1','1','false'};
		public LoanServiceDataTypes.LoadPackagesListResponseBodyType responseBody;
		private transient String[] responseBody_type_info = new String[]{'responseBody',s_ns0,'LoadPackagesListResponseBodyType','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'responseHeader','responseHeader_LoadPackagesListResponseType','responseBody'};
		public LoadPackagesListResponseType(){
		}
		public LoadPackagesListResponseType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			//System.assertEquals('loadPackagesListResponse', responseNode.getName());
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement('responseHeader', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			if(responseHeaderNode == null){
				this.responseHeader = null;
			} else{
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(responseHeaderNode);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);			
			DOM.XmlNode responseHeader_LoadPackagesListResponseTypeNode = responseNode.getChildElement('responseHeader_LoadPackagesListResponseType', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			if(responseHeader_LoadPackagesListResponseTypeNode == null){
				this.responseHeader_LoadPackagesListResponseType = null;
			} else{
				CommonMessageService.ResponseHeader responseHeader_LoadPackagesListResponseTypeObj = new CommonMessageService.ResponseHeader(responseHeader_LoadPackagesListResponseTypeNode);
				nodesParsed.add(responseHeader_LoadPackagesListResponseTypeNode);
				this.responseHeader_LoadPackagesListResponseType = responseHeader_LoadPackagesListResponseTypeObj;
			}
			//System.debug(this.responseHeader_LoadPackagesListResponseType);			
			DOM.XmlNode responseBodyNode = responseNode.getChildElement('responseBody', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			if(responseBodyNode == null){
				this.responseBody = null;
			} else{
				LoanServiceDataTypes.LoadPackagesListResponseBodyType responseBodyObj = new LoanServiceDataTypes.LoadPackagesListResponseBodyType(responseBodyNode);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);			
		}
	}
	

	public class PackagesItemType {
		public String packageId;
		// Restriction enumeration: CS_PACKAGE, LOAN_ADVANTAGE, OTHER_LOAN_ACTION, CREDIT_REGRANTING
		public String packageType;
		// Restriction enumeration: 
		public String fee;
		// Restriction enumeration: 
		public String discount;
		// Restriction enumeration: 
		public Date validFrom;
		// Restriction enumeration: 
		public Date validTo;
		private transient String[] packageId_type_info = new String[]{'packageId',s_ns0,'CodeListItemIdType','0','1','false'};
		private transient String[] packageType_type_info = new String[]{'packageType',s_ns0,'PackageType','0','1','false'};
		private transient String[] fee_type_info = new String[]{'fee',s_ns0,'MoneyAmountType','0','1','false'};
		private transient String[] discount_type_info = new String[]{'discount',s_ns0,'MoneyAmountType','0','1','false'};
		private transient String[] validFrom_type_info = new String[]{'validFrom',s_ns0,'CommonDateType','0','1','false'};
		private transient String[] validTo_type_info = new String[]{'validTo',s_ns0,'CommonDateType','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'packageId','packageType','fee','discount','validFrom','validTo'};
		public PackagesItemType(){
		}
		public PackagesItemType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode packageIdNode = responseNode.getChildElement('packageId', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			this.packageId = (packageIdNode == null) ? null : packageIdNode.getText();
			nodesParsed.add(packageIdNode);
			//System.debug(this.packageId);			
			DOM.XmlNode packageTypeNode = responseNode.getChildElement('packageType', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			this.packageType = (packageTypeNode == null) ? null : packageTypeNode.getText();
			nodesParsed.add(packageTypeNode);
			//System.debug(this.packageType);			
			DOM.XmlNode feeNode = responseNode.getChildElement('fee', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			this.fee = (feeNode == null) ? null : feeNode.getText();
			nodesParsed.add(feeNode);
			//System.debug(this.fee);			
			DOM.XmlNode discountNode = responseNode.getChildElement('discount', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			this.discount = (discountNode == null) ? null : discountNode.getText();
			nodesParsed.add(discountNode);
			//System.debug(this.discount);			
			DOM.XmlNode validFromNode = responseNode.getChildElement('validFrom', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			this.validFrom = (validFromNode == null) ? null : Date.valueOf(validFromNode.getText());
			nodesParsed.add(validFromNode);
			//System.debug(this.validFrom);			
			DOM.XmlNode validToNode = responseNode.getChildElement('validTo', 'http://service.cmss.cz/loan/LoanService/v05/datatypes');
			this.validTo = (validToNode == null) ? null : Date.valueOf(validToNode.getText());
			nodesParsed.add(validToNode);
			//System.debug(this.validTo);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode packageIdNode = outerNode.addChildElement('packageId', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
			packageIdNode.addTextNode((this.packageId == null) ? '' : this.packageId);
			Dom.XmlNode packageTypeNode = outerNode.addChildElement('packageType', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
			packageTypeNode.addTextNode((this.packageType == null) ? '' : this.packageType);
			Dom.XmlNode feeNode = outerNode.addChildElement('fee', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
			feeNode.addTextNode((this.fee == null) ? '' : this.fee);
			Dom.XmlNode discountNode = outerNode.addChildElement('discount', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
			discountNode.addTextNode((this.discount == null) ? '' : this.discount);
			Dom.XmlNode validFromNode = outerNode.addChildElement('validFrom', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
			validFromNode.addTextNode((this.validFrom == null) ? '' : String.valueOf(this.validFrom));
			Dom.XmlNode validToNode = outerNode.addChildElement('validTo', 'http://service.cmss.cz/loan/LoanService/v05/datatypes', '');
			validToNode.addTextNode((this.validTo == null) ? '' : String.valueOf(this.validTo));
		}
	}
}