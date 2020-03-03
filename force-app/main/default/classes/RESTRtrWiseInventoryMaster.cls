@RestResource(UrlMapping='/v1/RtrWiseInventoryMaster/Masters/*')
global with sharing class RESTRtrWiseInventoryMaster{

    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getRtrWiseInventoryMaster() {
        
        RExAPIResponseDomain.ResponseInfo RtrWiseInvMasesponse = new RExAPIResponseDomain.ResponseInfo();
        
        try{
             
             Set<Id> retailIdforuser = new Set<Id>();
             //List<Account> Retailerlist = AccountService.getAllRetailerMaster_List();
             List<Account> Retailerlist = AccountService.getAllRetailerMaster_List_for_Resource();
             List<ivydsd__Suggested_Quantity__c> sugqtylist = SuggestedQuantityService.getAllSuggesqty();
             
             for(Account a : Retailerlist){
                 retailIdforuser.add(a.Id);
             }
             
             RtrWiseInvMasesponse = SuggestedQuantityTranslator.objectToSugQtyInfo(sugqtylist,retailIdforuser,null);
             
        } catch(SecurityUtility.SFDCAccessControlException ex) {
    
            RtrWiseInvMasesponse = SuggestedQuantityTranslator.objectToSugQtyInfo(null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            
        }
        return RtrWiseInvMasesponse;
    }
}