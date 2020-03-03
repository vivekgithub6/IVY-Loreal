@RestResource(urlMapping='/v1/RetailerContact/Masters/*')
global class RESTRetailerContact {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getRetailerContactInfo(){
        RExAPIResponseDomain.ResponseInfo AccountResp = new RExAPIResponseDomain.ResponseInfo();
        
        try{
            Set<Id> accIds = new Set<Id>();
            List<Account> accountList = AccountService.getAllRetailerMaster_List();
            System.debug('accountList::'+accountList);
            for(Account acc : accountList){
                accIds.add(acc.Id);
            }
            List<Partner_Function__c> partners = RetailerContactService.getAllConquests(accIds);
            System.debug('partners::'+partners);
            AccountResp = RetailerContactTranslator.TranslateConquestToJson(partners,null);
            
        }
        catch(Exception ex){
           AccountResp = RetailerContactTranslator.TranslateConquestToJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));	
        }
            
      	return AccountResp; 
        
    }


}