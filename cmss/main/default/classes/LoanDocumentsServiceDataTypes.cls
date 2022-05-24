public class LoanDocumentsServiceDataTypes {
private static final String s_ns0 = 'http://service.cmss.cz/loan/LoanService/v06';
    public class DocumentsItemType {
		public String phase;
		public String number_x;
		public String group_x;
		public String status;
		public String text;
		// Restriction enumeration: 
		public Date incomingDate;
		// Restriction enumeration: 
		public Date tillWhenDate;
		public String id;
		private transient String[] phase_type_info = new String[]{'phase',s_ns0,'CodeListItemIdType','0','1','false'};
		private transient String[] number_x_type_info = new String[]{'number',s_ns0,'CodeListItemIdType','0','1','false'};
		private transient String[] group_x_type_info = new String[]{'group',s_ns0,'CodeListItemIdType','0','1','false'};
		private transient String[] status_type_info = new String[]{'status',s_ns0,'CodeListItemIdType','0','1','false'};
		private transient String[] text_type_info = new String[]{'text',s_ns0,'DescriptionType','0','1','false'};
		private transient String[] incomingDate_type_info = new String[]{'incomingDate',s_ns0,'CommonDateType','0','1','false'};
		private transient String[] tillWhenDate_type_info = new String[]{'tillWhenDate',s_ns0,'CommonDateType','0','1','false'};
		private transient String[] id_type_info = new String[]{'id',s_ns0,'CommonNumberType','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'phase','number_x','group_x','status','text','incomingDate','tillWhenDate','id'};
		public DocumentsItemType(){
		}
		public DocumentsItemType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode phaseNode = responseNode.getChildElement('phase', 'http://service.cmss.cz/loan/LoanService/v06');
			this.phase = (phaseNode == null) ? null : phaseNode.getText();
			nodesParsed.add(phaseNode);
			//System.debug(this.phase);			
			DOM.XmlNode number_xNode = responseNode.getChildElement('number', 'http://service.cmss.cz/loan/LoanService/v06');
			this.number_x = (number_xNode == null) ? null : number_xNode.getText();
			nodesParsed.add(number_xNode);
			//System.debug(this.number_x);			
			DOM.XmlNode group_xNode = responseNode.getChildElement('group', 'http://service.cmss.cz/loan/LoanService/v06');
			this.group_x = (group_xNode == null) ? null : group_xNode.getText();
			nodesParsed.add(group_xNode);
			//System.debug(this.group_x);			
			DOM.XmlNode statusNode = responseNode.getChildElement('status', 'http://service.cmss.cz/loan/LoanService/v06');
			this.status = (statusNode == null) ? null : statusNode.getText();
			nodesParsed.add(statusNode);
			//System.debug(this.status);			
			DOM.XmlNode textNode = responseNode.getChildElement('text', 'http://service.cmss.cz/loan/LoanService/v06');
			this.text = (textNode == null) ? null : textNode.getText();
			nodesParsed.add(textNode);
			//System.debug(this.text);			
			DOM.XmlNode incomingDateNode = responseNode.getChildElement('incomingDate', 'http://service.cmss.cz/loan/LoanService/v06');
			this.incomingDate = (incomingDateNode == null) ? null : Date.valueOf(incomingDateNode.getText());
			nodesParsed.add(incomingDateNode);
			//System.debug(this.incomingDate);			
			DOM.XmlNode tillWhenDateNode = responseNode.getChildElement('tillWhenDate', 'http://service.cmss.cz/loan/LoanService/v06');
			this.tillWhenDate = (tillWhenDateNode == null) ? null : Date.valueOf(tillWhenDateNode.getText());
			nodesParsed.add(tillWhenDateNode);
			//System.debug(this.tillWhenDate);			
			DOM.XmlNode idNode = responseNode.getChildElement('id', 'http://service.cmss.cz/loan/LoanService/v06');
			this.id = (idNode == null) ? null : idNode.getText();
			nodesParsed.add(idNode);
			//System.debug(this.id);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode phaseNode = outerNode.addChildElement('phase', 'http://service.cmss.cz/loan/LoanService/v06', '');
			phaseNode.addTextNode((this.phase == null) ? '' : this.phase);
			Dom.XmlNode number_xNode = outerNode.addChildElement('number', 'http://service.cmss.cz/loan/LoanService/v06', '');
			number_xNode.addTextNode((this.number_x == null) ? '' : this.number_x);
			Dom.XmlNode group_xNode = outerNode.addChildElement('group', 'http://service.cmss.cz/loan/LoanService/v06', '');
			group_xNode.addTextNode((this.group_x == null) ? '' : this.group_x);
			Dom.XmlNode statusNode = outerNode.addChildElement('status', 'http://service.cmss.cz/loan/LoanService/v06', '');
			statusNode.addTextNode((this.status == null) ? '' : this.status);
			Dom.XmlNode textNode = outerNode.addChildElement('text', 'http://service.cmss.cz/loan/LoanService/v06', '');
			textNode.addTextNode((this.text == null) ? '' : this.text);
			Dom.XmlNode incomingDateNode = outerNode.addChildElement('incomingDate', 'http://service.cmss.cz/loan/LoanService/v06', '');
			incomingDateNode.addTextNode((this.incomingDate == null) ? '' : String.valueOf(this.incomingDate));
			Dom.XmlNode tillWhenDateNode = outerNode.addChildElement('tillWhenDate', 'http://service.cmss.cz/loan/LoanService/v06', '');
			tillWhenDateNode.addTextNode((this.tillWhenDate == null) ? '' : String.valueOf(this.tillWhenDate));
			Dom.XmlNode idNode = outerNode.addChildElement('id', 'http://service.cmss.cz/loan/LoanService/v06', '');
			idNode.addTextNode((this.id == null) ? '' : this.id);
		}
	}
	public class GetLoanDocumentsListRequestBodyType {
		public BasicTypesService.AccountNumberType loanIdNumber;
		public Long phase;
		public Long status;
		private transient String[] loanIdNumber_type_info = new String[]{'loanIdNumber',s_ns0,'AccountNumberType','1','1','false'};
		private transient String[] phase_type_info = new String[]{'phase',s_ns0,'CodeListItemIdType','0','1','false'};
		private transient String[] status_type_info = new String[]{'status',s_ns0,'CodeListItemIdType','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'loanIdNumber','phase','status'};
		public GetLoanDocumentsListRequestBodyType(){
		}
		public GetLoanDocumentsListRequestBodyType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode loanIdNumberNode = responseNode.getChildElement('loanIdNumber', 'http://service.cmss.cz/loan/LoanService/v06');
			if(loanIdNumberNode == null){
				this.loanIdNumber = null;
			} else{
				BasicTypesService.AccountNumberType loanIdNumberObj = new BasicTypesService.AccountNumberType(loanIdNumberNode);
				nodesParsed.add(loanIdNumberNode);
				this.loanIdNumber = loanIdNumberObj;
			}
			//System.debug(this.loanIdNumber);			
			DOM.XmlNode phaseNode = responseNode.getChildElement('phase', 'http://service.cmss.cz/loan/LoanService/v06');
			this.phase = (phaseNode == null) ? null : Long.valueOf(phaseNode.getText());
			nodesParsed.add(phaseNode);
			//System.debug(this.phase);			
			DOM.XmlNode statusNode = responseNode.getChildElement('status', 'http://service.cmss.cz/loan/LoanService/v06');
			this.status = (statusNode == null) ? null : Long.valueOf(statusNode.getText());
			nodesParsed.add(statusNode);
			//System.debug(this.status);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			BasicTypesService.AccountNumberType loanIdNumberObj = this.loanIdNumber;
			Dom.XmlNode loanIdNumberNode = outerNode.addChildElement('v06:loanIdNumber', null, null);
			if(loanIdNumberObj != null){
				loanIdNumberObj.populateXmlNode(loanIdNumberNode);
			}
		}
	}
	

	public class GetLoanDocumentsListRequestType {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new String[]{'requestHeader',s_ns0,'RequestHeader','1','1','false'};
		public LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestBodyType requestBody;
		private transient String[] requestBody_type_info = new String[]{'requestBody',s_ns0,'GetLoanDocumentsListRequestBodyType','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'requestHeader','requestBody'};
		public GetLoanDocumentsListRequestType(){
		}
		public GetLoanDocumentsListRequestType(CommonMessageService.RequestHeader requestHeader,LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestBodyType requestBody){
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			//System.assertEquals('getLoanDocumentsList', outerNode.getName());
			
			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement('v01:requestHeader',null , null);
			if(requestHeaderObj != null){
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			
			LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestBodyType requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement('v06:requestBody', null, null);
			if(requestBodyObj != null){
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}
	public class GetLoanDocumentsListResponseBodyType {
		public LoanDocumentsServiceDataTypes.ListOfDocumentsType listOfDocuments;
		private transient String[] listOfDocuments_type_info = new String[]{'listOfDocuments',s_ns0,'ListOfDocumentsType','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'listOfDocuments'};
		public GetLoanDocumentsListResponseBodyType(){
		}
		public GetLoanDocumentsListResponseBodyType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode listOfDocumentsNode = responseNode.getChildElement('listOfDocuments', 'http://service.cmss.cz/loan/LoanService/v06');
			if(listOfDocumentsNode == null){
				this.listOfDocuments = null;
			} else{
				LoanDocumentsServiceDataTypes.ListOfDocumentsType listOfDocumentsObj = new LoanDocumentsServiceDataTypes.ListOfDocumentsType(listOfDocumentsNode);
				nodesParsed.add(listOfDocumentsNode);
				this.listOfDocuments = listOfDocumentsObj;
			}
			//System.debug(this.listOfDocuments);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			LoanDocumentsServiceDataTypes.ListOfDocumentsType listOfDocumentsObj = this.listOfDocuments;
			Dom.XmlNode listOfDocumentsNode = outerNode.addChildElement('listOfDocuments', 'http://service.cmss.cz/loan/LoanService/v06', '');
			if(listOfDocumentsObj != null){
				listOfDocumentsObj.populateXmlNode(listOfDocumentsNode);
			}
		}
	}
	

	public class GetLoanDocumentsListResponseType {
		public CommonMessageService.ResponseHeader responseHeader;
		private transient String[] responseHeader_type_info = new String[]{'responseHeader',s_ns0,'ResponseHeader','1','1','false'};
		public LoanDocumentsServiceDataTypes.GetLoanDocumentsListResponseBodyType responseBody;
		private transient String[] responseBody_type_info = new String[]{'responseBody',s_ns0,'GetLoanDocumentsListResponseBodyType','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'responseHeader','responseBody'};
		public GetLoanDocumentsListResponseType(){
		}
		public GetLoanDocumentsListResponseType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			system.debug('responseNode' + responseNode);
			DOM.XmlNode responseHeaderNode = responseNode.getChildElement('responseHeader', 'http://service.cmss.cz/loan/LoanService/v06');
			if(responseHeaderNode == null){
				this.responseHeader = null;
			} else{
				CommonMessageService.ResponseHeader responseHeaderObj = new CommonMessageService.ResponseHeader(responseHeaderNode);
				nodesParsed.add(responseHeaderNode);
				this.responseHeader = responseHeaderObj;
			}
			//System.debug(this.responseHeader);			
			DOM.XmlNode responseBodyNode = responseNode.getChildElement('responseBody', 'http://service.cmss.cz/loan/LoanService/v06');
			if(responseBodyNode == null){
				this.responseBody = null;
			} else{
				LoanDocumentsServiceDataTypes.GetLoanDocumentsListResponseBodyType responseBodyObj = new LoanDocumentsServiceDataTypes.GetLoanDocumentsListResponseBodyType(responseBodyNode);
				nodesParsed.add(responseBodyNode);
				this.responseBody = responseBodyObj;
			}
			//System.debug(this.responseBody);			
		}
	}
    public class ListOfDocumentsType {
		public LoanDocumentsServiceDataTypes.DocumentsItemType[] documentsItem;
		private transient String[] documentsItem_type_info = new String[]{'documentsItem',s_ns0,'DocumentsItemType','1','-1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'documentsItem'};
		public ListOfDocumentsType(){
		}
		public ListOfDocumentsType(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			Dom.XmlNode[] documentsItemChildren = responseNode.getChildElements();
			LoanDocumentsServiceDataTypes.DocumentsItemType[] documentsItemList = new List<LoanDocumentsServiceDataTypes.DocumentsItemType>();
			if(documentsItemChildren == null || documentsItemChildren.size() == 0){
				this.documentsItem = null;
			} else{
				for(DOM.XmlNode childNode : documentsItemChildren){
					if(childNode.GetName() == 'documentsItem'){
						LoanDocumentsServiceDataTypes.DocumentsItemType Obj = new LoanDocumentsServiceDataTypes.DocumentsItemType(childNode);
						documentsItemList.Add(Obj);
						nodesParsed.add(childNode);
					}
				}
				this.documentsItem = documentsItemList;
			}
			//System.debug(this.documentsItem);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			
			LoanDocumentsServiceDataTypes.DocumentsItemType[] documentsItemObj = this.documentsItem;
			if(documentsItemObj != null){
				for(LoanDocumentsServiceDataTypes.DocumentsItemType element: documentsItemObj){
					Dom.XmlNode documentsItemNode = outerNode.addChildElement('documentsItem', 'http://service.cmss.cz/loan/LoanService/v06', '');
					element.populateXmlNode(documentsItemNode);
				}
			}			
		}
	}
}