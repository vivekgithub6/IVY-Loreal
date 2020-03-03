@RestResource(urlMapping='/v1/RetailerMaster/Search')
global class RESTRetailerMasterSearch {
    
    @HttpPost
    global Static RExAPIResponseDomain.ResponseInfo returnHandler() {
        
        RExAPIResponseDomain.ResponseInfo returnResponse = new RExAPIResponseDomain.ResponseInfo ();
        
       // try {
            
            RestRequest req = RestContext.request;
            Blob requestBody = req.requestBody;
            String requestString = requestBody.toString();
            
            system.debug('requestString'+ requestString);
            
            RetailerMasterSearchClass.PostInformation responseBody = (RetailerMasterSearchClass.PostInformation)JSON.deserialize(requestString, RetailerMasterSearchClass.PostInformation.class);
            
            system.debug('responseBody'+ responseBody);
            
            if(responseBody != NULL) {
                
                system.debug('SearchText'+ responseBody.SearchText);
                String SearchText = responseBody.SearchText;
                LIST<String> searchTypeString = new LIST<String>();
                
                searchTypeString = responseBody.SearchType;
                LIST<Account> accountList = new LIST<Account>();
                system.debug('search text'+responseBody.SearchText);
                system.debug('size'+responseBody.SearchType);
                if(responseBody.SearchType.size() >0) {
                    
                    accountList = RetailerMasterSearchService.getAccounts((String)responseBody.SearchText, responseBody.SearchType);
                }
                system.debug('accountList'+ accountList);
                returnResponse = RetailerMasterSearchTranslator.sendAccounts(accountList,null);
                
                system.debug('returnResponse'+ returnResponse);
            } else {
                
            }
        /*} catch(Exception e) {
            
            returnResponse = RetailerMasterSearchTranslator.sendAccounts(NULL, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
        }*/
        
        return returnResponse;
    }
    
}