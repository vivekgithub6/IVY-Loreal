@RestResource(UrlMapping='/v1/RetailerContacts/Masters/')
global with sharing class RestRetailerContacts {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getRetailerAdressInfo(){
        RExAPIResponseDomain.ResponseInfo AccountResp = new RExAPIResponseDomain.ResponseInfo();
        
        try{
             Id sellerId = ResourceService.getLoginSellerId();
            Set<Id> accIds = new Set<Id>();
              List<Account> accList= new List<Account>();
            accList=AccountService.getAllRetailerMaster_List_for_Resource();
             for(Account acc: accList){
                accIds.add(acc.Id);
            }
            system.debug('accIds'+accIds);
            List<Contact> ContactList = RetailerContactService.getAllContacts(accIds);
            system.debug('ContactList'+ContactList);
              AccountResp = RetailerContactTranslator.TranslateContactsToJson(ContactList,null);
            
        }
        catch(Exception ex){
           AccountResp = RetailerContactTranslator.TranslateContactsToJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));  
        }
            
        return AccountResp; 
        
    }

}