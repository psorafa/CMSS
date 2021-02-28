global with sharing class SF_ActivityManagementSOAPService {

	webService static ActivityManagementResponseType createActivity(ActivityRequestType request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
            ActivityManagementResponseType response = 
                (ActivityManagementResponseType) SOAPResponseFactory.constructResponse(
                    ActivityManagementResponseType.class, 
                    request.requestHeader
            );
			Id result = TaskService.createTask(request.requestBody);
			response.responseBody = new ActivityManagementResponseBody(result);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			ActivityManagementResponseType response = (ActivityManagementResponseType) SOAPResponseFactory.constructFaultResponse(ActivityManagementResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static ActivityManagementResponseType updateActivity(ActivityRequestType request) {
        Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			ActivityManagementResponseType response = 
                (ActivityManagementResponseType) SOAPResponseFactory.constructResponse(
                    ActivityManagementResponseType.class, 
                    request.requestHeader
            );
			TaskService.updateTask(request.requestBody);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			ActivityManagementResponseType response = (ActivityManagementResponseType) SOAPResponseFactory.constructFaultResponse(ActivityManagementResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
    }
    
    global class ActivityRequestType {
		webService SOAPCommonTypes.CommonHeader requestHeader;
		webService ActivityType requestBody;
	}

	global class ActivityType {
        webService String id;
		webService String personNumber;
		webService String type;
		webService String describe;
		webService String direction;
		webService String oz;
		webService String phoneNumber;
		webService Date dueDate;
		webService String stateCode;
		webService String statusCode;
		webService String name;
		webService Date validTo;
		webService String result;
		webService String statusManagerCPU;
		webService String modifyByOzCPU;
		webService String authorCPU;
		webService String whatId;
		webService String email;
		webService Boolean isVisibleForNEL;
		webService String opportunityId;
		webService String location;
		webService Datetime plannedToDate;
		webService String webLink;
		webService String letterCity;
		webService String letterHouseNr;
		webService String letterPostcode;
		webService String letterStreet;
		webService Boolean isKZMessage;
		webService Boolean isRead;
		webService String clientGlobalId;
		webService Date validFrom;
	}

    global class ActivityManagementResponseType {
		webService SOAPCommonTypes.CommonHeader responseHeader;
		webService Boolean isFault;
		webService SOAPCommonTypes.Fault fault;
		webService ActivityManagementResponseBody responseBody;
	}

	global class ActivityManagementResponseBody {
		webService Id activityId;

		ActivityManagementResponseBody(Id activityId) {
			this.activityId = activityId;
		}
	}
}