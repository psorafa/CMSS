global with sharing class SF_OpportunitySOAPService {

	webService static OpportunityResponseType createOpportunity(OpportunityRequestType request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			OpportunityResponseType response = (OpportunityResponseType) SOAPResponseFactory.constructResponse(OpportunityResponseType.class, request.requestHeader);
			Id result = OpportunityService.createOpportunity(request.requestBody);
			response.responseBody = new OpportunityResponseBody(result);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			OpportunityResponseType response = (OpportunityResponseType) SOAPResponseFactory.constructFaultResponse(OpportunityResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static OpportunityResponseType updateOpportunity(OpportunityRequestType request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			OpportunityResponseType response = (OpportunityResponseType) SOAPResponseFactory.constructResponse(OpportunityResponseType.class, request.requestHeader);
			OpportunityService.updateOpportunity(request.requestBody);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			OpportunityResponseType response = (OpportunityResponseType) SOAPResponseFactory.constructFaultResponse(OpportunityResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	global class OpportunityRequestType {
		webService SOAPCommonTypes.CommonHeader requestHeader;
		webService OpportunityType requestBody;
	}

	global class OpportunityType {
		webService String id;
		webService String customerGlobalId;
		webService String description;
		webService String subject;
		webService String stateReason;
		webService String result;
		webService String author;
		webService String statusManagerCPU;
		webService Datetime validFrom;
		webService Datetime validTo;
		webService String category;
		webService String contractNumber;
		webService Date delegatedDate;
	}

	global class OpportunityResponseType {
		webService SOAPCommonTypes.CommonHeader responseHeader;
		webService Boolean isFault;
		webService SOAPCommonTypes.Fault fault;
		webService OpportunityResponseBody responseBody;
	}

	global class OpportunityResponseBody {
		webService Id opportunityId;

		OpportunityResponseBody(Id opportunityId) {
			this.opportunityId = opportunityId;
		}
	}

}